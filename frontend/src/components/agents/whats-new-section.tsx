import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { useTranslation } from 'react-i18next'
import { Sparkles, ExternalLink, X } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { agents } from '@/lib/api'
import { useDisplayLocale } from '@/hooks/use-display-locale'

// Surfaces items the market-scraper found for the first time this cycle
// (see backend/scraper/findings.py) — a passive read here, not a push
// notification, since this deployment has no notification channel wired
// up. Dismissing just marks the row read; it never touches the scraper's
// own dedup table, so re-scraping the same URL never resurfaces it anyway.
export function WhatsNewSection({ agentId }: { agentId: string }) {
  const { t } = useTranslation()
  const qc = useQueryClient()
  const locale = useDisplayLocale()

  const { data, isLoading } = useQuery({
    queryKey: ['agent-findings', agentId],
    queryFn: () => agents.findings.list(agentId),
  })

  const dismiss = useMutation({
    mutationFn: (findingId: string) => agents.findings.dismiss(agentId, findingId),
    onSuccess: () => qc.invalidateQueries({ queryKey: ['agent-findings', agentId] }),
  })

  const items = data?.items ?? []
  if (isLoading || items.length === 0) return null

  return (
    <div className="rounded-lg border bg-muted/30 divide-y mb-4">
      <div className="flex items-center gap-2 px-3 py-2">
        <Sparkles className="h-4 w-4 text-primary shrink-0" />
        <h3 className="text-sm font-semibold">{t('agents.whatsNew.title')}</h3>
        <span className="text-xs text-muted-foreground">{t('agents.whatsNew.count', { count: items.length })}</span>
      </div>
      {items.map((f) => (
        <div key={f.id} className="flex items-center gap-3 px-3 py-2.5">
          <div className="min-w-0 flex-1">
            <a
              href={f.url}
              target="_blank"
              rel="noreferrer noopener"
              className="text-sm hover:text-primary hover:underline inline-flex items-center gap-1"
            >
              <span className="truncate">{f.title}</span>
              <ExternalLink className="h-3 w-3 shrink-0 text-muted-foreground" />
            </a>
            <div className="text-xs text-muted-foreground mt-0.5">
              {f.source_key} · {new Date(f.discovered_at).toLocaleDateString(locale, { day: 'numeric', month: 'short' })}
            </div>
          </div>
          <Button
            size="icon"
            variant="ghost"
            title={t('agents.whatsNew.dismiss')}
            onClick={() => dismiss.mutate(f.id)}
            disabled={dismiss.isPending}
          >
            <X className="h-4 w-4" />
          </Button>
        </div>
      ))}
    </div>
  )
}
