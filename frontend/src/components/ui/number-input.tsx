import * as React from "react"
import { cn } from "@/lib/utils"
import { useDisplayLocale } from "@/hooks/use-display-locale"
import {
  formatForDisplay,
  parseToClean,
  mapCursorPosition,
  normalizeOnBlur,
} from "@/lib/number-input-utils"

type ControlledProps = {
  /** Clean, standard-format numeric string ("1234.5", "-10", ""). Same
   * shape every existing `<Input type="number">` call site already used,
   * so this is a drop-in replacement — swap the component, keep the rest. */
  value: string
  /** Receives the same clean numeric string shape — existing
   * `parseFloat(value)` call sites need no changes. */
  onChange: (value: string) => void
  defaultValue?: never
}

type UncontrolledProps = {
  value?: never
  onChange?: never
  /** For FormData-submitted forms (`new FormData(e.currentTarget)`,
   * `formData.get(name)`). A hidden input mirrors the clean value under
   * `name` — the visible text input carries no `name` itself — so the
   * submitted value is always the clean numeric string, never the
   * comma-formatted display text. */
  defaultValue?: string
}

type NumberInputProps = Omit<
  React.ComponentProps<"input">,
  "type" | "value" | "onChange" | "defaultValue"
> & {
  /** Set false for integer-only fields (days, counts). Default true. */
  allowDecimals?: boolean
} & (ControlledProps | UncontrolledProps)

/**
 * Drop-in replacement for `<Input type="number">` that live-formats with
 * locale-aware thousands separators while typing (issue: native number
 * inputs never group digits, so "1000" never becomes "1,000").
 *
 * Renders a text input (native number inputs reject the grouping
 * character outright) with `inputMode="decimal"` so mobile keyboards stay
 * numeric. Works both controlled (`value`/`onChange`, same shape as the
 * `Input` it replaces) and uncontrolled (`name`/`defaultValue`, for
 * FormData-submitted forms — see `UncontrolledProps` above for why a
 * hidden mirror input is needed there). Cursor position is preserved
 * across each reformat — see `number-input-utils.ts` for the algorithm.
 */
function NumberInput({
  value: controlledValue,
  onChange: controlledOnChange,
  defaultValue,
  allowDecimals = true,
  className,
  onBlur,
  name,
  min,
  max,
  ...props
}: NumberInputProps) {
  const locale = useDisplayLocale()
  const inputRef = React.useRef<HTMLInputElement>(null)
  const pendingCursor = React.useRef<number | null>(null)
  const isControlled = controlledValue !== undefined

  const [internalValue, setInternalValue] = React.useState(defaultValue ?? "")
  const value = isControlled ? controlledValue : internalValue
  const setValue = isControlled ? controlledOnChange! : setInternalValue

  const display = formatForDisplay(value, locale)

  React.useLayoutEffect(() => {
    if (pendingCursor.current !== null && inputRef.current) {
      inputRef.current.setSelectionRange(pendingCursor.current, pendingCursor.current)
      pendingCursor.current = null
    }
  }, [display])

  return (
    <>
      {!isControlled && name && <input type="hidden" name={name} value={value} />}
      <input
        ref={inputRef}
        type="text"
        inputMode={allowDecimals ? "decimal" : "numeric"}
        data-slot="input"
        name={isControlled ? name : undefined}
        value={display}
        onChange={(e) => {
          const raw = e.target.value
          const cursorInRaw = e.target.selectionStart ?? raw.length
          const clean = parseToClean(raw, locale, allowDecimals)
          const newDisplay = formatForDisplay(clean, locale)
          pendingCursor.current = mapCursorPosition(raw, cursorInRaw, newDisplay, locale)
          setValue(clean)
        }}
        onBlur={(e) => {
          // A plain `type="text"` input ignores the min/max HTML attributes
          // (the browser only enforces those for type="number"), so we
          // reproduce that clamping ourselves rather than silently losing
          // it for the fields that relied on it (day-of-month 1-31, a
          // minimum transfer amount, etc.).
          let normalized = normalizeOnBlur(value)
          const asNum = normalized === "" || normalized === "-" ? null : Number(normalized)
          if (asNum !== null && Number.isFinite(asNum)) {
            const lo = min !== undefined ? Number(min) : null
            const hi = max !== undefined ? Number(max) : null
            if (lo !== null && asNum < lo) normalized = String(lo)
            else if (hi !== null && asNum > hi) normalized = String(hi)
          }
          if (normalized !== value) setValue(normalized)
          onBlur?.(e)
        }}
        className={cn(
          "file:text-foreground placeholder:text-muted-foreground selection:bg-primary selection:text-primary-foreground dark:bg-input/30 border-input h-9 w-full min-w-0 rounded-md border bg-card px-3 py-1 text-base shadow-xs transition-[color,box-shadow] outline-none file:inline-flex file:h-7 file:border-0 file:bg-transparent file:text-sm file:font-medium disabled:pointer-events-none disabled:cursor-not-allowed disabled:opacity-50 md:text-sm",
          "focus-visible:border-ring focus-visible:ring-ring/30 focus-visible:ring-[2px]",
          "aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive",
          className
        )}
        {...props}
      />
    </>
  )
}

export { NumberInput }
