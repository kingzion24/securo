import { useEffect, useState } from 'react'
import { useTranslation } from 'react-i18next'
import type { AxiosError } from 'axios'
import { useAuth } from '@/contexts/auth-context'
import { auth as authApi } from '@/lib/api'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { ShellLogo } from '@/components/shell-logo'
import { Lock, Fingerprint, LogOut } from 'lucide-react'
import {
  isPasskeySupported,
  passkeyFailure,
  startPasskeyAuthentication,
} from '@/lib/webauthn'
import type { PasskeyFailure } from '@/lib/webauthn'

const PASSKEY_FAILURE_KEYS: Record<PasskeyFailure, string> = {
  cancelled: 'auth.passkeyCancelled',
  domain: 'auth.passkeyDomainError',
  mismatch: 'auth.passkeyDomainMismatch',
  ip: 'auth.passkeyIpAddress',
  insecure: 'auth.passkeyInsecureContext',
  unsupported: 'auth.passkeyUnsupported',
  duplicate: 'auth.passkeyLoginError',
  unknown: 'auth.passkeyLoginError',
}

/**
 * Blocking re-authentication overlay shown after the configured idle
 * timeout (see `useIdleLock`). Rendered as a sibling over the existing
 * app tree — nothing underneath unmounts, so whatever the user was doing
 * is exactly where they left it once unlocked.
 *
 * Deliberately a re-verification, not a fresh login: on success it either
 * refreshes the session token (password/2FA path, via the same endpoints
 * login.tsx uses) or swaps in a new one (passkey path) — either way the
 * signed-in user never changes, this only proves it's still them.
 */
export function LockScreen({ onUnlock, localAuthEnabled }: { onUnlock: () => void; localAuthEnabled: boolean }) {
  const { t } = useTranslation()
  const { user, login, verify2fa, loginWithToken, logout } = useAuth()
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [isLoading, setIsLoading] = useState(false)
  const [isPasskeyLoading, setIsPasskeyLoading] = useState(false)
  const [hasPasskeys, setHasPasskeys] = useState(false)

  const [requires2fa, setRequires2fa] = useState(false)
  const [tempToken, setTempToken] = useState('')
  const [available2faMethods, setAvailable2faMethods] = useState<Array<'totp' | 'passkey'>>(['totp'])
  const [selected2faMethod, setSelected2faMethod] = useState<'totp' | 'passkey'>('totp')
  const [totpCode, setTotpCode] = useState('')

  const passkeySupported = isPasskeySupported()

  useEffect(() => {
    authApi.listPasskeys().then((list) => setHasPasskeys(list.length > 0)).catch(() => setHasPasskeys(false))
  }, [])

  const handlePasswordSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!user) return
    setError('')
    setIsLoading(true)
    try {
      const result = await login(user.email, password)
      if (result.requires_2fa) {
        const methods: Array<'totp' | 'passkey'> = result.available_methods?.length ? result.available_methods : ['totp']
        setRequires2fa(true)
        setTempToken(result.temp_token ?? '')
        setAvailable2faMethods(methods)
        setSelected2faMethod(methods.includes('passkey') ? 'passkey' : methods[0])
      } else {
        onUnlock()
      }
    } catch (err) {
      const axiosErr = err as AxiosError
      if (axiosErr?.response?.status === 429) {
        setError(t('auth.tooManyAttempts'))
      } else {
        setError(t('auth.invalidCredentials'))
      }
    } finally {
      setIsLoading(false)
    }
  }

  const handlePasskeyUnlock = async () => {
    if (!user) return
    setError('')
    setIsPasskeyLoading(true)
    try {
      const options = await authApi.passkeyAuthenticationOptions(user.email)
      const credential = await startPasskeyAuthentication(options.options)
      const result = await authApi.verifyPasskeyAuthentication(options.challenge_id, credential)
      loginWithToken(result.access_token)
      onUnlock()
    } catch (err) {
      const axiosErr = err as AxiosError
      if (axiosErr?.response?.status === 429) {
        setError(t('auth.tooManyAttempts'))
      } else {
        setError(t(PASSKEY_FAILURE_KEYS[passkeyFailure(err)]))
      }
    } finally {
      setIsPasskeyLoading(false)
    }
  }

  const handleVerifyTotp = async (e: React.FormEvent) => {
    e.preventDefault()
    setError('')
    setIsLoading(true)
    try {
      await verify2fa(tempToken, totpCode)
      onUnlock()
    } catch (err) {
      const axiosErr = err as AxiosError
      if (axiosErr?.response?.status === 401) {
        setError(t('auth.invalidCredentials'))
        setRequires2fa(false)
        setTempToken('')
        setTotpCode('')
      } else {
        setError(t('auth.invalid2faCode'))
      }
    } finally {
      setIsLoading(false)
    }
  }

  const handlePasskeySecondFactor = async () => {
    setError('')
    setIsPasskeyLoading(true)
    try {
      const options = await authApi.passkeySecondFactorOptions(tempToken)
      const credential = await startPasskeyAuthentication(options.options)
      const result = await authApi.verifyPasskeySecondFactor(tempToken, options.challenge_id, credential)
      loginWithToken(result.access_token)
      onUnlock()
    } catch (err) {
      const axiosErr = err as AxiosError
      const domErr = err as { name?: string }
      if (domErr?.name === 'NotAllowedError') {
        setError(t('auth.passkeyCancelled'))
      } else if (axiosErr?.response?.status === 401) {
        setError(t('auth.invalidCredentials'))
        setRequires2fa(false)
        setTempToken('')
      } else {
        setError(t('auth.passkeyLoginError'))
      }
    } finally {
      setIsPasskeyLoading(false)
    }
  }

  if (!user) return null

  return (
    <div className="fixed inset-0 z-[100] flex items-center justify-center bg-background/80 backdrop-blur-md p-4">
      <div className="w-full max-w-sm bg-card border border-border rounded-2xl shadow-xl p-6 space-y-5">
        <div className="flex flex-col items-center text-center gap-3">
          <ShellLogo size={36} />
          <div className="w-12 h-12 rounded-full bg-primary/10 flex items-center justify-center">
            <Lock size={20} className="text-primary" />
          </div>
          <div>
            <p className="text-sm font-semibold text-foreground">{t('lock.title')}</p>
            <p className="text-xs text-muted-foreground mt-0.5">{user.email}</p>
          </div>
        </div>

        {requires2fa ? (
          <div className="space-y-3">
            {available2faMethods.length > 1 && (
              <div className="grid grid-cols-2 gap-2">
                {available2faMethods.includes('passkey') && (
                  <Button
                    type="button"
                    variant={selected2faMethod === 'passkey' ? 'default' : 'outline'}
                    onClick={() => setSelected2faMethod('passkey')}
                  >
                    {t('auth.passkeyMethod')}
                  </Button>
                )}
                {available2faMethods.includes('totp') && (
                  <Button
                    type="button"
                    variant={selected2faMethod === 'totp' ? 'default' : 'outline'}
                    onClick={() => setSelected2faMethod('totp')}
                  >
                    {t('auth.totpMethod')}
                  </Button>
                )}
              </div>
            )}
            {selected2faMethod === 'totp' ? (
              <form onSubmit={handleVerifyTotp} className="space-y-3">
                <div className="space-y-2">
                  <Label>{t('auth.twoFactor')}</Label>
                  <Input
                    type="text"
                    inputMode="numeric"
                    autoComplete="one-time-code"
                    value={totpCode}
                    onChange={(e) => setTotpCode(e.target.value.replace(/\D/g, '').slice(0, 6))}
                    placeholder="000000"
                    className="text-center text-lg tracking-[0.3em] font-mono"
                    maxLength={6}
                    required
                    autoFocus
                  />
                </div>
                {error && <p className="text-xs text-rose-500">{error}</p>}
                <Button type="submit" className="w-full" disabled={isLoading || totpCode.length !== 6}>
                  {isLoading ? t('common.loading') : t('auth.verify')}
                </Button>
              </form>
            ) : (
              <div className="space-y-3">
                <p className="text-sm text-muted-foreground text-center">
                  {t('auth.passkeySecondFactorPrompt')}
                </p>
                {error && <p className="text-xs text-rose-500 text-center">{error}</p>}
                <Button
                  type="button"
                  className="w-full gap-2"
                  onClick={handlePasskeySecondFactor}
                  disabled={isPasskeyLoading}
                >
                  <Fingerprint size={15} />
                  {isPasskeyLoading ? t('common.loading') : t('auth.usePasskeySecondFactor')}
                </Button>
              </div>
            )}
          </div>
        ) : (
          <div className="space-y-3">
            {localAuthEnabled && (
              <form onSubmit={handlePasswordSubmit} className="space-y-3">
                <div className="space-y-2">
                  <Label>{t('auth.password')}</Label>
                  <Input
                    type="password"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    autoFocus
                    required
                  />
                </div>
                {error && <p className="text-xs text-rose-500">{error}</p>}
                <Button type="submit" className="w-full" disabled={isLoading || !password}>
                  {isLoading ? t('common.loading') : t('lock.unlock')}
                </Button>
              </form>
            )}
            {passkeySupported && hasPasskeys && (
              <Button
                type="button"
                variant={localAuthEnabled ? 'outline' : 'default'}
                className="w-full gap-2"
                onClick={handlePasskeyUnlock}
                disabled={isPasskeyLoading}
              >
                <Fingerprint size={15} />
                {isPasskeyLoading ? t('common.loading') : t('lock.usePasskey')}
              </Button>
            )}
            {!localAuthEnabled && !(passkeySupported && hasPasskeys) && error === '' && (
              <p className="text-xs text-muted-foreground text-center">{t('lock.noMethodAvailable')}</p>
            )}
          </div>
        )}

        <button
          type="button"
          onClick={logout}
          className="w-full flex items-center justify-center gap-1.5 text-xs text-muted-foreground hover:text-rose-500 transition-colors pt-1"
        >
          <LogOut size={12} />
          {t('lock.logOutInstead')}
        </button>
      </div>
    </div>
  )
}
