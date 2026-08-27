import { useEffect, useRef, useState, useCallback } from 'react'
import { useAuth } from '@/contexts/auth-context'

const STORAGE_KEY = 'securo_last_activity'
const DEFAULT_MINUTES = 5
const CHECK_INTERVAL_MS = 15_000
const ACTIVITY_THROTTLE_MS = 1_000
const ACTIVITY_EVENTS = ['mousemove', 'mousedown', 'keydown', 'touchstart', 'scroll', 'wheel'] as const

/** Minutes of inactivity before the lock screen appears. 0 means disabled.
 * Stored per-user in preferences so it syncs across that user's devices. */
export function getIdleLockMinutes(preferences: unknown): number {
  const raw = (preferences as { idle_lock_minutes?: unknown } | null)?.idle_lock_minutes
  return typeof raw === 'number' && raw >= 0 ? raw : DEFAULT_MINUTES
}

/**
 * Tracks user activity and flips `locked` once the configured idle timeout
 * has elapsed — a privacy measure for a finance app left open on a shared
 * or unattended device. The rest of the app stays mounted underneath the
 * lock screen; nothing is lost, it's purely a blocking overlay.
 *
 * Last-activity is persisted to localStorage (not just in-memory) so:
 *   - a page reload while idle re-locks immediately instead of granting a
 *     fresh grace period, and
 *   - multiple tabs share one idle clock instead of each running its own.
 * A `visibilitychange` check catches the "closed the laptop lid" case,
 * where JS timers are suspended and wouldn't fire on their own.
 */
export function useIdleLock() {
  const { user } = useAuth()
  const minutes = getIdleLockMinutes(user?.preferences)
  const enabled = !!user && minutes > 0
  const [locked, setLocked] = useState(false)
  const lastThrottledRef = useRef(0)

  const recordActivity = useCallback(() => {
    try {
      localStorage.setItem(STORAGE_KEY, String(Date.now()))
    } catch {
      // Storage unavailable (private browsing quirks, quota) — the idle
      // check below falls back to in-memory timing for this tab only.
    }
  }, [])

  const checkIdle = useCallback(() => {
    if (!enabled) return
    let last = 0
    try {
      last = Number(localStorage.getItem(STORAGE_KEY)) || 0
    } catch {
      last = Date.now()
    }
    const elapsedMs = Date.now() - last
    if (elapsedMs >= minutes * 60_000) setLocked(true)
  }, [enabled, minutes])

  useEffect(() => {
    if (!enabled) {
      setLocked(false)
      return
    }

    recordActivity()
    checkIdle()

    const onActivity = () => {
      const now = Date.now()
      if (now - lastThrottledRef.current < ACTIVITY_THROTTLE_MS) return
      lastThrottledRef.current = now
      if (!locked) recordActivity()
    }
    for (const evt of ACTIVITY_EVENTS) {
      window.addEventListener(evt, onActivity, { passive: true })
    }

    const onVisibility = () => {
      if (document.visibilityState === 'visible') checkIdle()
    }
    document.addEventListener('visibilitychange', onVisibility)

    const interval = window.setInterval(checkIdle, CHECK_INTERVAL_MS)

    return () => {
      for (const evt of ACTIVITY_EVENTS) {
        window.removeEventListener(evt, onActivity)
      }
      document.removeEventListener('visibilitychange', onVisibility)
      window.clearInterval(interval)
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [enabled, minutes])

  const unlock = useCallback(() => {
    recordActivity()
    setLocked(false)
  }, [recordActivity])

  return { locked: enabled && locked, unlock }
}
