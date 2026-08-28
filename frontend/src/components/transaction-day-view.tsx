import { useMemo, useState } from 'react'
import { useTranslation } from 'react-i18next'
import { format, addDays } from 'date-fns'
import { ChevronLeft, ChevronRight } from 'lucide-react'
import type { Account, TransactionCalendarResponse } from '@/types'
import { Popover, PopoverTrigger, PopoverContent } from '@/components/ui/popover'
import { Calendar as DatePickerCalendar } from '@/components/ui/calendar'
import { Skeleton } from '@/components/ui/skeleton'
import { CalendarItemRow } from '@/components/transaction-calendar-view'
import { formatCurrency } from '@/lib/format'
import { resolveDateFnsLocale } from '@/lib/date-fns-locale'
import { cn } from '@/lib/utils'

function isoDate(d: Date) {
  return format(d, 'yyyy-MM-dd')
}

function shiftDay(iso: string, delta: number) {
  return isoDate(addDays(new Date(`${iso}T00:00:00`), delta))
}

// Simple ‹ label › stepper shared by the date and account rows — same shape,
// different content, so both read as one control family.
function StepperRow({
  onPrev,
  onNext,
  prevDisabled,
  nextDisabled,
  prevLabel,
  nextLabel,
  children,
}: {
  onPrev: () => void
  onNext: () => void
  prevDisabled?: boolean
  nextDisabled?: boolean
  prevLabel: string
  nextLabel: string
  children: React.ReactNode
}) {
  return (
    <div className="flex items-center justify-between gap-3 bg-card rounded-xl border border-border shadow-sm px-3 py-2.5">
      <button
        type="button"
        onClick={onPrev}
        disabled={prevDisabled}
        aria-label={prevLabel}
        className="shrink-0 rounded-lg p-1.5 text-muted-foreground transition-colors hover:bg-muted/60 hover:text-foreground disabled:opacity-30 disabled:pointer-events-none"
      >
        <ChevronLeft size={18} />
      </button>
      <div className="min-w-0 flex-1 text-center">{children}</div>
      <button
        type="button"
        onClick={onNext}
        disabled={nextDisabled}
        aria-label={nextLabel}
        className="shrink-0 rounded-lg p-1.5 text-muted-foreground transition-colors hover:bg-muted/60 hover:text-foreground disabled:opacity-30 disabled:pointer-events-none"
      >
        <ChevronRight size={18} />
      </button>
    </div>
  )
}

export function TransactionDayView({
  date,
  onDateChange,
  accountId,
  onAccountIdChange,
  accounts,
  calendar,
  isLoading,
  locale,
  dateLocale,
  mask,
  userCurrency,
  onOpenTransaction,
}: {
  date: string
  onDateChange: (value: string) => void
  accountId: string
  onAccountIdChange: (value: string) => void
  accounts: Account[]
  calendar?: TransactionCalendarResponse
  isLoading: boolean
  locale: string
  dateLocale: string
  mask: (value: string) => string
  userCurrency: string
  onOpenTransaction: (id: string) => void
}) {
  const { t, i18n } = useTranslation()
  const [pickerOpen, setPickerOpen] = useState(false)
  const dateFnsLocale = resolveDateFnsLocale(i18n.resolvedLanguage ?? i18n.language)

  const accountById = useMemo(() => {
    const map = new Map<string, Account>()
    for (const account of accounts) map.set(account.id, account)
    return map
  }, [accounts])

  // 'all' is one of the cycle positions, same as the spec calls for.
  const cycle = useMemo(() => ['all', ...accounts.map((a) => a.id)], [accounts])
  const cycleIndex = Math.max(0, cycle.indexOf(accountId))
  const goAccount = (delta: number) => {
    if (cycle.length <= 1) return
    const next = (cycleIndex + delta + cycle.length) % cycle.length
    onAccountIdChange(cycle[next])
  }

  const jsDate = new Date(`${date}T00:00:00`)
  const day = calendar?.days.find((d) => d.date === date)
  // Expenses only — income/opening-balance rows (e.g. "Saldo inicial") stay
  // out of the list. The summary line below still nets/balances against the
  // full picture; this list is specifically "what did I spend".
  const items = (day?.items ?? []).filter((item) => item.kind === 'actual' && item.type === 'debit')

  const accountLabel = accountId === 'all'
    ? t('transactions.dayAllAccounts')
    : (accountById.get(accountId)?.name ?? t('transactions.summaryUnknownAccount'))

  const isAll = accountId === 'all'
  const summaryValue = isAll ? (day?.actual_expense ?? 0) : (day?.ending_balance ?? 0)
  const summaryLabel = isAll
    ? t('transactions.dayTotalExpenses')
    : t('transactions.dayEndingBalance', { account: accountLabel })
  const currency = calendar?.currency ?? userCurrency

  return (
    <div className="mb-4 space-y-3">
      <StepperRow
        onPrev={() => onDateChange(shiftDay(date, -1))}
        onNext={() => onDateChange(shiftDay(date, 1))}
        prevLabel={t('transactions.dayPrevious')}
        nextLabel={t('transactions.dayNext')}
      >
        <Popover open={pickerOpen} onOpenChange={setPickerOpen}>
          <PopoverTrigger asChild>
            <button type="button" className="mx-auto flex flex-col items-center rounded-lg px-2 py-0.5 transition-colors hover:bg-muted/60">
              <span className="text-lg font-bold tabular-nums text-foreground">{format(jsDate, 'dd/MM/yyyy')}</span>
              <span className="text-xs capitalize text-muted-foreground">
                {jsDate.toLocaleDateString(dateLocale, { weekday: 'long' })}
              </span>
            </button>
          </PopoverTrigger>
          <PopoverContent className="w-auto p-0" align="center">
            <DatePickerCalendar
              mode="single"
              locale={dateFnsLocale}
              selected={jsDate}
              defaultMonth={jsDate}
              onSelect={(selected) => {
                if (selected) {
                  onDateChange(isoDate(selected))
                  setPickerOpen(false)
                }
              }}
            />
          </PopoverContent>
        </Popover>
      </StepperRow>

      <StepperRow
        onPrev={() => goAccount(-1)}
        onNext={() => goAccount(1)}
        prevDisabled={cycle.length <= 1}
        nextDisabled={cycle.length <= 1}
        prevLabel={t('transactions.dayPreviousAccount')}
        nextLabel={t('transactions.dayNextAccount')}
      >
        <span className="truncate text-sm font-semibold text-foreground">{accountLabel}</span>
      </StepperRow>

      <div className="bg-card rounded-xl border border-border shadow-sm overflow-hidden">
        {isLoading ? (
          <div className="space-y-3 p-4">
            {Array.from({ length: 4 }).map((_, i) => (
              <Skeleton key={i} className="h-12 w-full" />
            ))}
          </div>
        ) : items.length === 0 ? (
          <p className="px-4 py-10 text-center text-sm text-muted-foreground">{t('transactions.dayNoItems')}</p>
        ) : (
          <div className="divide-y divide-border">
            {items.map((item) => (
              <CalendarItemRow
                key={`${item.kind}-${item.id ?? item.recurring_id}-${item.date}`}
                item={item}
                account={item.account_id ? accountById.get(item.account_id) : undefined}
                locale={locale}
                userCurrency={userCurrency}
                mask={mask}
                onOpenTransaction={onOpenTransaction}
              />
            ))}
          </div>
        )}

        {!isLoading && (
          <div className="flex items-center justify-between gap-3 border-t border-border bg-muted/30 px-4 py-3">
            <span className="text-xs font-semibold uppercase tracking-wide text-muted-foreground">{summaryLabel}</span>
            <span
              className={cn(
                'text-base font-bold tabular-nums',
                // "All" mode is always a spend total (red). A specific
                // account's end-of-day balance keeps sign-based coloring.
                isAll || summaryValue < 0 ? 'text-rose-600 dark:text-rose-400' : 'text-emerald-600 dark:text-emerald-400',
              )}
            >
              {mask(formatCurrency(summaryValue, currency, locale))}
            </span>
          </div>
        )}
      </div>
    </div>
  )
}
