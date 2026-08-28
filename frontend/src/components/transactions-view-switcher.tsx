import { CalendarClock, CalendarDays, List } from 'lucide-react'
import { Button } from '@/components/ui/button'

export type TransactionsViewMode = 'list' | 'calendar' | 'day'

export type TransactionsViewSwitcherProps = {
  value: TransactionsViewMode
  onChange: (value: TransactionsViewMode) => void
  listLabel: string
  calendarLabel: string
  // Optional: the dashboard's transactions section only offers List/Calendar
  // (it has no per-day drill-down), so the Day segment only renders when a
  // caller passes a label for it — the Transactions page itself always does.
  dayLabel?: string
}

/**
 * Segmented List/Calendar(/Day) switch, shared by the transactions page
 * header and the dashboard's transactions section so both read as the same
 * control.
 * @example `<TransactionsViewSwitcher value={view} onChange={setView} listLabel="List" calendarLabel="Calendar" dayLabel="Day" />`
 */
export function TransactionsViewSwitcher({ value, onChange, listLabel, calendarLabel, dayLabel }: TransactionsViewSwitcherProps) {
  return (
    <div className="inline-flex rounded-full border border-border bg-card p-0.5">
      <Button
        variant={value === 'list' ? 'secondary' : 'ghost'}
        size="sm"
        className="h-8 gap-1.5 px-2.5"
        aria-pressed={value === 'list'}
        onClick={() => onChange('list')}
      >
        <List size={14} />
        {listLabel}
      </Button>
      <Button
        variant={value === 'calendar' ? 'secondary' : 'ghost'}
        size="sm"
        className="h-8 gap-1.5 px-2.5"
        aria-pressed={value === 'calendar'}
        onClick={() => onChange('calendar')}
      >
        <CalendarDays size={14} />
        {calendarLabel}
      </Button>
      {dayLabel && (
        <Button
          variant={value === 'day' ? 'secondary' : 'ghost'}
          size="sm"
          className="h-8 gap-1.5 px-2.5"
          aria-pressed={value === 'day'}
          onClick={() => onChange('day')}
        >
          <CalendarClock size={14} />
          {dayLabel}
        </Button>
      )}
    </div>
  )
}
