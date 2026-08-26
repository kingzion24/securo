/**
 * Pure logic behind <NumberInput>: locale-aware live comma-formatting for a
 * text input, with correct cursor-position preservation while typing.
 *
 * Kept separate from the component (and unit-tested) because the
 * cursor-position math is exactly the kind of thing that looks right in a
 * quick manual check and breaks on the next edge case.
 */

/** The clean value is always plain JS-number-string format ("-1234.5"),
 * regardless of display locale — this is what callers' existing
 * parseFloat()-based logic expects, unchanged. */
export type CleanValue = string

let separatorCache = new Map<string, { decimal: string; group: string }>()

export function getLocaleSeparators(locale: string): { decimal: string; group: string } {
  const cached = separatorCache.get(locale)
  if (cached) return cached
  let decimal = '.'
  let group = ','
  try {
    const parts = new Intl.NumberFormat(locale).formatToParts(1234.5)
    decimal = parts.find((p) => p.type === 'decimal')?.value ?? decimal
    group = parts.find((p) => p.type === 'group')?.value ?? group
  } catch {
    // Unknown locale — fall back to en-US separators.
  }
  const result = { decimal, group }
  separatorCache.set(locale, result)
  return result
}

/** Whatever the user has typed/pasted (possibly with grouping characters,
 * a locale decimal separator, stray characters from a paste) -> clean
 * standard-format numeric string. Never throws; unparseable input reduces
 * to whatever digits/sign/decimal it can salvage. */
export function parseToClean(raw: string, locale: string, allowDecimals: boolean): CleanValue {
  const { decimal, group } = getLocaleSeparators(locale)
  const negative = raw.trim().startsWith('-')

  let s = group ? raw.split(group).join('') : raw
  if (!allowDecimals) {
    // Truncate at the decimal separator entirely, rather than stripping it
    // and letting the fractional digits collapse into the integer part.
    const decIdx = s.indexOf(decimal)
    if (decIdx !== -1) s = s.slice(0, decIdx)
  } else if (decimal !== '.') {
    const decIdx = s.indexOf(decimal)
    if (decIdx !== -1) {
      s = s.slice(0, decIdx) + '.' + s.slice(decIdx + decimal.length).split(decimal).join('')
    }
  }

  s = allowDecimals ? s.replace(/[^0-9.]/g, '') : s.replace(/[^0-9]/g, '')

  if (allowDecimals) {
    const firstDot = s.indexOf('.')
    if (firstDot !== -1) {
      s = s.slice(0, firstDot + 1) + s.slice(firstDot + 1).replace(/\./g, '')
    }
  }

  return (negative ? '-' : '') + s
}

/** Clean standard-format numeric string -> locale-formatted display string,
 * grouping only the integer part and re-attaching any (possibly
 * in-progress, e.g. trailing ".") decimal portion verbatim so mid-typing
 * states never get mangled or rounded away. */
export function formatForDisplay(clean: CleanValue, locale: string): string {
  if (clean === '' || clean === '-') return clean

  const negative = clean.startsWith('-')
  const unsigned = negative ? clean.slice(1) : clean
  const dotIdx = unsigned.indexOf('.')
  const intPart = dotIdx === -1 ? unsigned : unsigned.slice(0, dotIdx)
  const decPart = dotIdx === -1 ? null : unsigned.slice(dotIdx + 1)

  const { decimal, group } = getLocaleSeparators(locale)
  const intDigits = intPart.replace(/^0+(?=\d)/, '') || '0'

  let groupedInt: string
  try {
    // BigInt (not Number) so arbitrarily long integer parts group correctly
    // without floating-point precision loss.
    groupedInt = new Intl.NumberFormat(locale, { useGrouping: true, maximumFractionDigits: 0 }).format(
      BigInt(intDigits),
    )
  } catch {
    groupedInt = intDigits
  }

  let result = (negative ? '-' : '') + groupedInt
  if (decPart !== null) {
    result += decimal + decPart
  }
  return result
}

/** Count of "significant" characters (digits, minus sign, decimal
 * separator) in `str` up to (not including) `index`. Group separators
 * don't count — they're what makes the cursor otherwise drift. */
function significantCharsBefore(str: string, index: number, decimalChar: string, groupChar: string): number {
  let count = 0
  for (let i = 0; i < index && i < str.length; i++) {
    if (str[i] !== groupChar || groupChar === decimalChar) count++
  }
  return count
}

/** Inverse: the index in `str` right after the Nth significant character.
 * Clamps to the string's end if it has fewer significant characters. */
function indexAfterSignificantCount(str: string, count: number, groupChar: string): number {
  if (count <= 0) return 0
  let seen = 0
  for (let i = 0; i < str.length; i++) {
    if (str[i] !== groupChar) {
      seen++
      if (seen === count) return i + 1
    }
  }
  return str.length
}

/** Given the raw (post-edit, still-old-formatting) input value and where
 * the cursor landed in it, plus the freshly reformatted display value,
 * return where the cursor should land in the new string so it stays next
 * to the same digit the user was just next to. */
export function mapCursorPosition(
  rawValueBeforeReformat: string,
  cursorInRaw: number,
  newDisplay: string,
  locale: string,
): number {
  const { decimal, group } = getLocaleSeparators(locale)
  const sigCount = significantCharsBefore(rawValueBeforeReformat, cursorInRaw, decimal, group)
  return indexAfterSignificantCount(newDisplay, sigCount, group)
}

/** Blur-time cleanup: drop a trailing decimal point / lone sign with no
 * digits, so "1000." -> "1000" and "-" -> "". */
export function normalizeOnBlur(clean: CleanValue): CleanValue {
  if (clean === '-' || clean === '.' || clean === '-.') return ''
  return clean.replace(/\.$/, '')
}
