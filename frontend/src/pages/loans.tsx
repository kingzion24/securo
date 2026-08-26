import { useEffect, useState } from 'react'
import { useTranslation } from 'react-i18next'
import { useDisplayLocale } from '@/hooks/use-display-locale'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { loans as loansApi, payees as payeesApi, transactions as transactionsApi } from '@/lib/api'
import { toast } from 'sonner'
import { Button } from '@/components/ui/button'
import { DatePickerInput } from '@/components/ui/date-picker-input'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
} from '@/components/ui/dialog'
import type { Loan, Transaction } from '@/types'
import {
  Pencil, Trash2, Plus, HandCoins, ArrowDownLeft, ArrowUpRight,
  ChevronDown, ChevronUp, CheckCircle2, Archive, ArchiveRestore,
} from 'lucide-react'
import { PageHeader } from '@/components/page-header'
import { usePrivacyMode } from '@/hooks/use-privacy-mode'
import { useAuth } from '@/contexts/auth-context'
import { useWorkspace } from '@/contexts/workspace-context'
import { formatCurrency } from '@/lib/format'

const SELECT_CLASS = 'w-full border border-border rounded-lg px-3 py-2 text-sm bg-card text-foreground focus:outline-none focus:ring-2 focus:ring-primary'

function SectionCard({ children }: { children: React.ReactNode }) {
  return (
    <div className="bg-card rounded-xl border border-border shadow-sm overflow-hidden">
      {children}
    </div>
  )
}
function SectionHeader({ title, action }: { title: string; action?: React.ReactNode }) {
  return (
    <div className="px-4 sm:px-5 py-4 border-b border-border flex flex-wrap items-center justify-between gap-2">
      <p className="text-sm font-semibold text-foreground">{title}</p>
      {action}
    </div>
  )
}

function StatusBadge({ status, t }: { status: string; t: (key: string) => string }) {
  const config: Record<string, { bg: string; text: string; key: string }> = {
    open: { bg: 'bg-emerald-100 dark:bg-emerald-500/20', text: 'text-emerald-700 dark:text-emerald-400', key: 'loans.statusOpen' },
    settled: { bg: 'bg-blue-100 dark:bg-blue-500/20', text: 'text-blue-700 dark:text-blue-400', key: 'loans.statusSettled' },
    archived: { bg: 'bg-muted', text: 'text-muted-foreground', key: 'loans.statusArchived' },
  }
  const c = config[status] ?? config.open
  return (
    <span className={`inline-flex items-center px-2 py-0.5 rounded-full text-[10px] font-bold ${c.bg} ${c.text}`}>
      {t(c.key)}
    </span>
  )
}

function DirectionBadge({ direction, t }: { direction: string; t: (key: string) => string }) {
  const owedToMe = direction === 'they_owe_me'
  return (
    <span className={`inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-[10px] font-bold ${
      owedToMe
        ? 'bg-emerald-100 dark:bg-emerald-500/20 text-emerald-700 dark:text-emerald-400'
        : 'bg-amber-100 dark:bg-amber-500/20 text-amber-700 dark:text-amber-400'
    }`}>
      {owedToMe ? <ArrowDownLeft size={11} /> : <ArrowUpRight size={11} />}
      {owedToMe ? t('loans.directionTheyOweMe') : t('loans.directionIOweThem')}
    </span>
  )
}

/** Amount + date + optional note, either typed manually or copied from an
 * existing transaction picked via debounced search — both first-class,
 * mirroring how group settlements link (or don't) to a real transaction. */
function RepaymentForm({
  loanId,
  currency,
  onDone,
}: {
  loanId: string
  currency: string
  onDone: () => void
}) {
  const { t } = useTranslation()
  const queryClient = useQueryClient()
  const [mode, setMode] = useState<'manual' | 'existing'>('manual')
  const [amount, setAmount] = useState('')
  const [date, setDate] = useState(new Date().toISOString().slice(0, 10))
  const [note, setNote] = useState('')
  const [pickedTx, setPickedTx] = useState<Transaction | null>(null)
  const [txSearch, setTxSearch] = useState('')
  const [txQuery, setTxQuery] = useState('')

  useEffect(() => {
    const id = setTimeout(() => setTxQuery(txSearch), 300)
    return () => clearTimeout(id)
  }, [txSearch])

  const { data: txOptions } = useQuery({
    queryKey: ['loan-repayment-tx-options', txQuery],
    queryFn: () => transactionsApi.list({ q: txQuery || undefined, limit: 20 }),
    enabled: mode === 'existing',
  })

  const mutation = useMutation({
    mutationFn: () =>
      loansApi.addRepayment(loanId, {
        amount: parseFloat(amount),
        date,
        note: note || undefined,
        transaction_id: mode === 'existing' ? pickedTx?.id : undefined,
      }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['loans'] })
      queryClient.invalidateQueries({ queryKey: ['loans-summary'] })
      toast.success(t('loans.repaymentAdded'))
      onDone()
    },
    onError: () => toast.error(t('common.error')),
  })

  const canSubmit = mode === 'manual' ? amount && parseFloat(amount) > 0 : !!pickedTx

  return (
    <div className="space-y-3 bg-muted/30 rounded-lg p-3 mt-2">
      <div className="space-y-2">
        <Label className="text-xs">{t('loans.repaymentSource')}</Label>
        <select
          className={SELECT_CLASS}
          value={mode}
          onChange={(e) => {
            setMode(e.target.value as 'manual' | 'existing')
            setPickedTx(null)
          }}
        >
          <option value="manual">{t('loans.repaymentManual')}</option>
          <option value="existing">{t('loans.repaymentLinkTransaction')}</option>
        </select>
      </div>

      {mode === 'manual' ? (
        <div className="grid grid-cols-2 gap-3">
          <div className="space-y-1">
            <Label className="text-xs">{t('loans.amount')}</Label>
            <Input type="number" step="0.01" value={amount} onChange={(e) => setAmount(e.target.value)} />
          </div>
          <div className="space-y-1">
            <Label className="text-xs">{t('loans.date')}</Label>
            <DatePickerInput value={date} onChange={setDate} className="w-full justify-start" />
          </div>
        </div>
      ) : (
        <div className="space-y-1.5">
          <Input
            type="text"
            value={txSearch}
            onChange={(e) => setTxSearch(e.target.value)}
            placeholder={t('loans.searchTransaction')}
          />
          <div className="max-h-40 overflow-y-auto rounded-md border border-border divide-y divide-border">
            {(txOptions?.items ?? []).length === 0 ? (
              <p className="text-xs text-muted-foreground px-3 py-4 text-center">{t('loans.noTransactions')}</p>
            ) : (
              (txOptions?.items ?? []).map((tx) => {
                const picked = pickedTx?.id === tx.id
                return (
                  <button
                    key={tx.id}
                    type="button"
                    onClick={() => {
                      setPickedTx(tx)
                      setAmount(Math.abs(Number(tx.amount)).toFixed(2))
                      setDate(tx.date)
                    }}
                    className={`w-full text-left px-3 py-2 text-xs flex items-center justify-between gap-3 ${
                      picked ? 'bg-primary/10' : 'hover:bg-muted/50'
                    }`}
                  >
                    <span className="min-w-0 truncate">
                      <span className="text-muted-foreground">{tx.date}</span> · {tx.description}
                    </span>
                    <span className="shrink-0 tabular-nums text-muted-foreground">
                      {tx.amount} {tx.currency}
                    </span>
                  </button>
                )
              })
            )}
          </div>
        </div>
      )}

      <div className="space-y-1">
        <Label className="text-xs">{t('loans.note')}</Label>
        <Input value={note} onChange={(e) => setNote(e.target.value)} placeholder={t('loans.notePlaceholder')} />
      </div>

      <div className="flex justify-end gap-2">
        <Button type="button" variant="outline" size="sm" onClick={onDone}>
          {t('common.cancel')}
        </Button>
        <Button
          type="button"
          size="sm"
          disabled={!canSubmit || mutation.isPending}
          onClick={() => mutation.mutate()}
        >
          {mutation.isPending ? t('common.loading') : t('loans.addRepayment')}
        </Button>
      </div>
      <p className="text-[10px] text-muted-foreground">{currency}</p>
    </div>
  )
}

export default function LoansPage() {
  const { t } = useTranslation()
  const { mask } = usePrivacyMode()
  const { user } = useAuth()
  const { canWrite } = useWorkspace()
  const userCurrency = user?.preferences?.currency_display ?? 'USD'
  const locale = useDisplayLocale()
  const queryClient = useQueryClient()

  const [dialogOpen, setDialogOpen] = useState(false)
  const [editing, setEditing] = useState<Loan | null>(null)
  const [directionFilter, setDirectionFilter] = useState<string>('')
  const [statusFilter, setStatusFilter] = useState<string>('open')
  const [deletingLoan, setDeletingLoan] = useState<Loan | null>(null)
  const [expandedId, setExpandedId] = useState<string | null>(null)
  const [addingRepaymentFor, setAddingRepaymentFor] = useState<string | null>(null)

  const { data: loansList } = useQuery({
    queryKey: ['loans', directionFilter, statusFilter],
    queryFn: () => loansApi.list(directionFilter || undefined, statusFilter || undefined),
  })

  const { data: summary } = useQuery({
    queryKey: ['loans-summary'],
    queryFn: () => loansApi.summary(),
  })

  const { data: payeesList } = useQuery({
    queryKey: ['payees'],
    queryFn: () => payeesApi.list(),
  })

  const createMutation = useMutation({
    mutationFn: (data: Partial<Loan>) => loansApi.create(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['loans'] })
      queryClient.invalidateQueries({ queryKey: ['loans-summary'] })
      setDialogOpen(false)
      toast.success(t('loans.created'))
    },
    onError: () => toast.error(t('common.error')),
  })

  const updateMutation = useMutation({
    mutationFn: ({ id, ...data }: Partial<Loan> & { id: string }) => loansApi.update(id, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['loans'] })
      queryClient.invalidateQueries({ queryKey: ['loans-summary'] })
      setDialogOpen(false)
      setEditing(null)
      toast.success(t('loans.updated'))
    },
    onError: () => toast.error(t('common.error')),
  })

  const deleteMutation = useMutation({
    mutationFn: (id: string) => loansApi.delete(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['loans'] })
      queryClient.invalidateQueries({ queryKey: ['loans-summary'] })
      setDeletingLoan(null)
      toast.success(t('loans.deleted'))
    },
    onError: () => toast.error(t('common.error')),
  })

  const statusMutation = useMutation({
    mutationFn: ({ id, status }: { id: string; status: string }) => loansApi.update(id, { status } as Partial<Loan>),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['loans'] })
      queryClient.invalidateQueries({ queryKey: ['loans-summary'] })
      toast.success(t('loans.updated'))
    },
  })

  const deleteRepaymentMutation = useMutation({
    mutationFn: ({ loanId, repaymentId }: { loanId: string; repaymentId: string }) =>
      loansApi.deleteRepayment(loanId, repaymentId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['loans'] })
      queryClient.invalidateQueries({ queryKey: ['loans-summary'] })
      toast.success(t('loans.repaymentDeleted'))
    },
    onError: () => toast.error(t('common.error')),
  })

  const openCreateDialog = () => {
    setEditing(null)
    setDialogOpen(true)
  }

  const openEditDialog = (loan: Loan) => {
    setEditing(loan)
    setDialogOpen(true)
  }

  return (
    <div>
      <PageHeader section={t('loans.title')} title={t('loans.title')} />

      {/* Summary */}
      {summary && (summary.open_count > 0) && (
        <div className="grid grid-cols-2 gap-3 mb-4">
          <div className="bg-card rounded-xl border border-border px-4 py-3">
            <p className="text-xs text-muted-foreground mb-1">{t('loans.totalOwedToMe')}</p>
            <p className="text-lg font-bold text-emerald-600 dark:text-emerald-400 tabular-nums">
              {mask(formatCurrency(summary.total_owed_to_me, summary.currency, locale))}
            </p>
          </div>
          <div className="bg-card rounded-xl border border-border px-4 py-3">
            <p className="text-xs text-muted-foreground mb-1">{t('loans.totalIOwe')}</p>
            <p className="text-lg font-bold text-amber-600 dark:text-amber-400 tabular-nums">
              {mask(formatCurrency(summary.total_i_owe, summary.currency, locale))}
            </p>
          </div>
        </div>
      )}

      {/* Filters */}
      <div className="flex flex-wrap items-center gap-2 mb-4">
        {['', 'they_owe_me', 'i_owe_them'].map((d) => (
          <button
            key={d || 'all'}
            onClick={() => setDirectionFilter(d)}
            className={`px-3 py-1.5 rounded-lg text-xs font-medium transition-colors ${
              directionFilter === d ? 'bg-primary text-primary-foreground' : 'bg-muted text-muted-foreground hover:text-foreground'
            }`}
          >
            {d === '' ? t('transactions.all') : d === 'they_owe_me' ? t('loans.directionTheyOweMe') : t('loans.directionIOweThem')}
          </button>
        ))}
        <span className="w-px h-4 bg-border mx-1" />
        {['open', 'settled', 'archived', ''].map((s) => (
          <button
            key={s || 'allStatus'}
            onClick={() => setStatusFilter(s)}
            className={`px-3 py-1.5 rounded-lg text-xs font-medium transition-colors ${
              statusFilter === s ? 'bg-primary text-primary-foreground' : 'bg-muted text-muted-foreground hover:text-foreground'
            }`}
          >
            {s ? t(`loans.status${s.charAt(0).toUpperCase() + s.slice(1)}`) : t('transactions.all')}
          </button>
        ))}
      </div>

      <SectionCard>
        <SectionHeader
          title={t('loans.title')}
          action={
            canWrite ? (
              <Button size="sm" className="gap-1.5 h-8" onClick={openCreateDialog}>
                <Plus size={13} /> {t('loans.add')}
              </Button>
            ) : undefined
          }
        />
        {loansList && loansList.length > 0 ? (
          <div className="divide-y divide-border">
            {loansList.map((loan) => {
              const progressColor = loan.percentage >= 100
                ? 'bg-emerald-500'
                : loan.percentage >= 60
                  ? 'bg-blue-500'
                  : loan.percentage >= 30
                    ? 'bg-amber-400'
                    : 'bg-muted-foreground/30'
              const expanded = expandedId === loan.id
              const addingRepayment = addingRepaymentFor === loan.id

              return (
                <div key={loan.id} className="px-4 sm:px-5 py-4 hover:bg-muted/50 transition-colors">
                  <div className="flex items-start gap-4">
                    <div
                      className="w-10 h-10 rounded-xl flex items-center justify-center shrink-0 text-white bg-primary"
                    >
                      <HandCoins size={18} />
                    </div>

                    <div className="flex-1 min-w-0">
                      <div className="flex items-center gap-2 mb-1 flex-wrap">
                        <span className="text-sm font-semibold text-foreground truncate">{loan.person_name}</span>
                        <DirectionBadge direction={loan.direction} t={t} />
                        <StatusBadge status={loan.status} t={t} />
                      </div>

                      <div className="flex items-center gap-3 mb-1.5">
                        <div className="flex-1 h-2 bg-muted/60 rounded-full overflow-hidden">
                          <div
                            className={`h-full rounded-full transition-all ${progressColor}`}
                            style={{ width: `${Math.min(loan.percentage, 100)}%` }}
                          />
                        </div>
                        <span className="text-xs font-bold tabular-nums text-foreground shrink-0">
                          {loan.percentage.toFixed(0)}%
                        </span>
                      </div>

                      <div className="flex flex-wrap items-center gap-x-4 gap-y-1 text-xs text-muted-foreground">
                        <span className="tabular-nums font-medium">
                          {mask(formatCurrency(loan.repaid_amount, loan.currency, locale))}
                          {' / '}
                          {mask(formatCurrency(loan.principal_amount, loan.currency, locale))}
                        </span>
                        <span>{t('loans.remaining')}: {mask(formatCurrency(loan.remaining_amount, loan.currency, locale))}</span>
                        <span>{loan.date}</span>
                        {loan.note && <span className="truncate">{loan.note}</span>}
                      </div>

                      <button
                        className="mt-2 text-xs text-primary hover:text-primary/80 transition-colors flex items-center gap-1"
                        onClick={() => setExpandedId(expanded ? null : loan.id)}
                      >
                        {expanded ? <ChevronUp size={12} /> : <ChevronDown size={12} />}
                        {t('loans.repayments', { count: loan.repayments.length })}
                      </button>

                      {expanded && (
                        <div className="mt-2 space-y-1.5">
                          {loan.repayments.length === 0 && (
                            <p className="text-xs text-muted-foreground">{t('loans.noRepaymentsYet')}</p>
                          )}
                          {loan.repayments.map((r) => (
                            <div key={r.id} className="flex items-center justify-between gap-3 text-xs bg-muted/30 rounded-md px-2.5 py-1.5">
                              <span className="min-w-0 truncate">
                                <span className="text-muted-foreground">{r.date}</span>{' '}
                                {mask(formatCurrency(r.amount, loan.currency, locale))}
                                {r.note && <span className="text-muted-foreground"> — {r.note}</span>}
                                {r.transaction_id && (
                                  <span className="text-muted-foreground"> ({t('loans.linkedTransaction')})</span>
                                )}
                              </span>
                              {canWrite && (
                                <button
                                  className="shrink-0 text-muted-foreground hover:text-rose-500 transition-colors"
                                  onClick={() => deleteRepaymentMutation.mutate({ loanId: loan.id, repaymentId: r.id })}
                                >
                                  <Trash2 size={12} />
                                </button>
                              )}
                            </div>
                          ))}

                          {canWrite && loan.status === 'open' && (
                            addingRepayment ? (
                              <RepaymentForm
                                loanId={loan.id}
                                currency={loan.currency}
                                onDone={() => setAddingRepaymentFor(null)}
                              />
                            ) : (
                              <button
                                className="text-xs text-primary hover:text-primary/80 transition-colors flex items-center gap-1 mt-1"
                                onClick={() => setAddingRepaymentFor(loan.id)}
                              >
                                <Plus size={12} /> {t('loans.addRepayment')}
                              </button>
                            )
                          )}
                        </div>
                      )}
                    </div>

                    {canWrite && (
                      <div className="flex items-center gap-1 shrink-0">
                        {loan.status === 'open' && (
                          <button
                            className="p-1.5 rounded-md text-muted-foreground hover:text-blue-500 hover:bg-blue-50 dark:hover:bg-blue-500/10 transition-colors"
                            onClick={() => statusMutation.mutate({ id: loan.id, status: 'settled' })}
                            title={t('loans.markSettled')}
                          >
                            <CheckCircle2 size={13} />
                          </button>
                        )}
                        {loan.status !== 'archived' && (
                          <button
                            className="p-1.5 rounded-md text-muted-foreground hover:text-muted-foreground/80 hover:bg-muted transition-colors"
                            onClick={() => statusMutation.mutate({ id: loan.id, status: 'archived' })}
                            title={t('loans.archive')}
                          >
                            <Archive size={13} />
                          </button>
                        )}
                        {loan.status !== 'open' && (
                          <button
                            className="p-1.5 rounded-md text-muted-foreground hover:text-emerald-500 hover:bg-emerald-50 dark:hover:bg-emerald-500/10 transition-colors"
                            onClick={() => statusMutation.mutate({ id: loan.id, status: 'open' })}
                            title={t('loans.reopen')}
                          >
                            <ArchiveRestore size={13} />
                          </button>
                        )}
                        <button
                          className="p-1.5 rounded-md text-muted-foreground hover:text-primary hover:bg-primary/5 transition-colors"
                          onClick={() => openEditDialog(loan)}
                          title={t('common.edit')}
                        >
                          <Pencil size={13} />
                        </button>
                        <button
                          className="p-1.5 rounded-md text-muted-foreground hover:text-rose-500 hover:bg-rose-50 dark:hover:bg-rose-500/10 transition-colors"
                          onClick={() => setDeletingLoan(loan)}
                          title={t('common.delete')}
                        >
                          <Trash2 size={13} />
                        </button>
                      </div>
                    )}
                  </div>
                </div>
              )
            })}
          </div>
        ) : (
          <p className="text-sm text-muted-foreground text-center py-10">{t('loans.empty')}</p>
        )}
      </SectionCard>

      {/* Create/Edit Dialog */}
      <Dialog open={dialogOpen} onOpenChange={() => { setDialogOpen(false); setEditing(null) }}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>{editing ? t('loans.edit') : t('loans.add')}</DialogTitle>
          </DialogHeader>
          <form
            key={editing?.id ?? 'new'}
            onSubmit={(e) => {
              e.preventDefault()
              const formData = new FormData(e.currentTarget)
              const payload: Record<string, unknown> = {
                person_name: formData.get('person_name') as string,
                payee_id: (formData.get('payee_id') as string) || null,
                direction: formData.get('direction') as string,
                principal_amount: parseFloat(formData.get('principal_amount') as string),
                currency: (formData.get('currency') as string) || userCurrency,
                date: formData.get('date') as string,
                note: (formData.get('note') as string) || null,
              }

              if (editing) {
                updateMutation.mutate({ id: editing.id, ...payload } as Partial<Loan> & { id: string })
              } else {
                createMutation.mutate(payload as Partial<Loan>)
              }
            }}
            className="space-y-4"
          >
            <div className="space-y-2">
              <Label>{t('loans.person')}</Label>
              <Input name="person_name" defaultValue={editing?.person_name ?? ''} required />
            </div>

            <div className="space-y-2">
              <Label>{t('loans.linkPayee')}</Label>
              <select name="payee_id" defaultValue={editing?.payee_id ?? ''} className={SELECT_CLASS}>
                <option value="">{t('loans.noPayeeLink')}</option>
                {payeesList?.map((p) => (
                  <option key={p.id} value={p.id}>{p.name}</option>
                ))}
              </select>
            </div>

            <div className="space-y-2">
              <Label>{t('loans.direction')}</Label>
              <select name="direction" defaultValue={editing?.direction ?? 'they_owe_me'} className={SELECT_CLASS}>
                <option value="they_owe_me">{t('loans.directionTheyOweMe')}</option>
                <option value="i_owe_them">{t('loans.directionIOweThem')}</option>
              </select>
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label>{t('loans.principalAmount')}</Label>
                <Input
                  name="principal_amount"
                  type="number"
                  step="0.01"
                  defaultValue={editing?.principal_amount?.toString() ?? ''}
                  required
                />
              </div>
              <div className="space-y-2">
                <Label>{t('loans.currency')}</Label>
                <Input name="currency" defaultValue={editing?.currency ?? userCurrency} maxLength={3} className="uppercase" />
              </div>
            </div>

            <div className="space-y-2">
              <Label>{t('loans.date')}</Label>
              <Input name="date" type="date" defaultValue={editing?.date ?? new Date().toISOString().slice(0, 10)} required />
            </div>

            <div className="space-y-2">
              <Label>{t('loans.note')}</Label>
              <Input name="note" defaultValue={editing?.note ?? ''} placeholder={t('loans.notePlaceholder')} />
            </div>

            <DialogFooter>
              <Button type="button" variant="outline" onClick={() => { setDialogOpen(false); setEditing(null) }}>
                {t('common.cancel')}
              </Button>
              <Button type="submit" disabled={createMutation.isPending || updateMutation.isPending}>
                {t('common.save')}
              </Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>

      {/* Confirm delete dialog */}
      <Dialog open={!!deletingLoan} onOpenChange={() => setDeletingLoan(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>{t('loans.confirmDeleteTitle')}</DialogTitle>
          </DialogHeader>
          <p className="text-sm text-muted-foreground">
            {t('loans.confirmDeleteDesc', { name: deletingLoan?.person_name })}
          </p>
          <DialogFooter>
            <Button variant="outline" onClick={() => setDeletingLoan(null)}>
              {t('common.cancel')}
            </Button>
            <Button
              variant="destructive"
              onClick={() => deletingLoan && deleteMutation.mutate(deletingLoan.id)}
              disabled={deleteMutation.isPending}
            >
              {deleteMutation.isPending ? t('common.loading') : t('common.delete')}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  )
}
