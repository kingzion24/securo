import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { useTranslation } from 'react-i18next'
import { Bell, X } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { Popover, PopoverContent, PopoverTrigger } from '@/components/ui/popover'
import { agents } from '@/lib/api'
import { useDisplayLocale } from '@/hooks/use-display-locale'
import { cn } from '@/lib/utils'

// Proactive, agent-generated suggestions (e.g. the daily market-opportunity
// scan — see backend/app/agents/tasks/market_opportunity.py) surfaced here
// as an in-app list. There's no push/email channel wired up in this
// deployment, so "notification" means "shows up next time you open this
// bell" rather than something that reaches you outside the app.
export function NotificationsBell({ triggerSize = 18 }: { triggerSize?: number }) {
  const { t } = useTranslation()
  const qc = useQueryClient()
  const locale = useDisplayLocale()

  const { data } = useQuery({
    queryKey: ['agent-notifications'],
    queryFn: () => agents.notifications.list(),
    refetchInterval: 5 * 60 * 1000,
  })

  const dismiss = useMutation({
    mutationFn: (notificationId: string) => agents.notifications.dismiss(notificationId),
    onSuccess: () => qc.invalidateQueries({ queryKey: ['agent-notifications'] }),
  })

  const items = data?.items ?? []

  return (
    <Popover>
      <PopoverTrigger asChild>
        <button
          className="relative text-sidebar-muted hover:text-sidebar-foreground transition-colors p-1 rounded-md hover:bg-sidebar-accent"
          title={t('agents.notifications.title')}
          aria-label={t('agents.notifications.title')}
        >
          <Bell size={triggerSize} />
          {items.length > 0 && (
            <span className="absolute top-0.5 right-0.5 h-2 w-2 rounded-full bg-emerald-500" />
          )}
        </button>
      </PopoverTrigger>
      <PopoverContent align="end" className="w-80 p-0 overflow-hidden">
        <div className={cn('divide-y', items.length === 0 && 'divide-y-0')}>
          <div className="flex items-center gap-2 px-3 py-2">
            <Bell className="h-4 w-4 text-primary shrink-0" />
            <h3 className="text-sm font-semibold">{t('agents.notifications.title')}</h3>
            {items.length > 0 && (
              <span className="text-xs text-muted-foreground">{t('agents.notifications.count', { count: items.length })}</span>
            )}
          </div>
          {items.length === 0 && (
            <div className="px-3 pb-3 text-xs text-muted-foreground">{t('agents.notifications.empty')}</div>
          )}
          {items.map((n) => (
            <div key={n.id} className="flex items-start gap-3 px-3 py-2.5">
              <div className="min-w-0 flex-1">
                {n.source_url ? (
                  <a
                    href={n.source_url}
                    target="_blank"
                    rel="noreferrer noopener"
                    className="text-sm font-medium hover:text-primary hover:underline"
                  >
                    {n.title}
                  </a>
                ) : (
                  <div className="text-sm font-medium">{n.title}</div>
                )}
                <p className="text-xs text-muted-foreground mt-0.5">{n.body}</p>
                <div className="text-[11px] text-muted-foreground mt-1">
                  {new Date(n.created_at).toLocaleDateString(locale, { day: 'numeric', month: 'short' })}
                </div>
              </div>
              <Button
                size="icon"
                variant="ghost"
                className="shrink-0"
                title={t('agents.notifications.dismiss')}
                onClick={() => dismiss.mutate(n.id)}
                disabled={dismiss.isPending}
              >
                <X className="h-4 w-4" />
              </Button>
            </div>
          ))}
        </div>
      </PopoverContent>
    </Popover>
  )
}
