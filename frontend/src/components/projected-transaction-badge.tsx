import { useTranslation } from 'react-i18next'

/** Canonical badge for a virtual transaction projection. */
export function ProjectedTransactionBadge() {
  const { t } = useTranslation()

  return (
    <span className="inline-flex items-center rounded-full border border-indigo-200 bg-indigo-50 px-1 py-0.5 text-[9px] font-semibold uppercase tracking-wide text-indigo-700 shrink-0 dark:border-indigo-900 dark:bg-indigo-950/40 dark:text-indigo-300">
      {t('transactions.projected')}
    </span>
  )
}
