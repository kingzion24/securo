import { describe, it, expect } from 'vitest'
import {
  getLocaleSeparators,
  parseToClean,
  formatForDisplay,
  mapCursorPosition,
  normalizeOnBlur,
} from './number-input-utils'

describe('getLocaleSeparators', () => {
  it('en-US uses comma group, dot decimal', () => {
    expect(getLocaleSeparators('en-US')).toEqual({ decimal: '.', group: ',' })
  })
  it('pt-BR uses dot group, comma decimal', () => {
    expect(getLocaleSeparators('pt-BR')).toEqual({ decimal: ',', group: '.' })
  })
  it('falls back gracefully for an unknown locale tag', () => {
    expect(getLocaleSeparators('not-a-real-locale')).toEqual({ decimal: '.', group: ',' })
  })
})

describe('parseToClean', () => {
  it('strips en-US grouping commas', () => {
    expect(parseToClean('1,234,567', 'en-US', true)).toBe('1234567')
  })
  it('keeps a single dot decimal for en-US', () => {
    expect(parseToClean('1,234.56', 'en-US', true)).toBe('1234.56')
  })
  it('converts pt-BR comma-decimal and dot-grouping to standard form', () => {
    expect(parseToClean('1.234,56', 'pt-BR', true)).toBe('1234.56')
  })
  it('preserves a leading minus sign', () => {
    expect(parseToClean('-1,234.56', 'en-US', true)).toBe('-1234.56')
  })
  it('drops decimals entirely when allowDecimals is false', () => {
    expect(parseToClean('1,234.56', 'en-US', false)).toBe('1234')
  })
  it('collapses multiple stray dots to just the first', () => {
    expect(parseToClean('12.34.56', 'en-US', true)).toBe('12.3456')
  })
  it('handles empty input', () => {
    expect(parseToClean('', 'en-US', true)).toBe('')
  })
  it('handles an in-progress trailing decimal point', () => {
    expect(parseToClean('1000.', 'en-US', true)).toBe('1000.')
  })
})

describe('formatForDisplay', () => {
  it('groups a plain integer for en-US', () => {
    expect(formatForDisplay('1000', 'en-US')).toBe('1,000')
  })
  it('groups a large integer correctly', () => {
    expect(formatForDisplay('1234567', 'en-US')).toBe('1,234,567')
  })
  it('leaves small numbers ungrouped', () => {
    expect(formatForDisplay('42', 'en-US')).toBe('42')
  })
  it('preserves an in-progress trailing decimal point without rounding it away', () => {
    expect(formatForDisplay('1000.', 'en-US')).toBe('1,000.')
  })
  it('preserves in-progress trailing zeros after the decimal', () => {
    expect(formatForDisplay('1000.50', 'en-US')).toBe('1,000.50')
  })
  it('uses pt-BR separators (dot group, comma decimal)', () => {
    expect(formatForDisplay('1234.5', 'pt-BR')).toBe('1.234,5')
  })
  it('handles negative numbers', () => {
    expect(formatForDisplay('-1000', 'en-US')).toBe('-1,000')
  })
  it('handles a bare "0"', () => {
    expect(formatForDisplay('0', 'en-US')).toBe('0')
  })
  it('handles empty and lone-minus as-is (mid-typing states)', () => {
    expect(formatForDisplay('', 'en-US')).toBe('')
    expect(formatForDisplay('-', 'en-US')).toBe('-')
  })
  it('strips leading zeros but keeps a single zero', () => {
    expect(formatForDisplay('007', 'en-US')).toBe('7')
    expect(formatForDisplay('000', 'en-US')).toBe('0')
  })
  it('round-trips through parseToClean for a typical amount', () => {
    const display = formatForDisplay('1234567.89', 'en-US')
    expect(parseToClean(display, 'en-US', true)).toBe('1234567.89')
  })
})

describe('mapCursorPosition', () => {
  it('keeps the cursor at the end when typing appends a digit at the end', () => {
    // "100" -> user types "0" at the end -> raw "1000", cursor at 4
    const pos = mapCursorPosition('1000', 4, '1,000', 'en-US')
    expect(pos).toBe(5) // after "1,000"
  })
  it('keeps the cursor immediately after the digit just typed in the middle', () => {
    // Display was "1,000"; user positions cursor between "1" and "," (index 1)
    // and types "2", making the raw (pre-reformat) value "12,000" with
    // cursor at index 2 (right after the "2").
    const pos = mapCursorPosition('12,000', 2, '12,000', 'en-US')
    expect(pos).toBe(2)
  })
  it('does not count a newly-inserted grouping comma as part of the offset', () => {
    // "999" + typing "9" before the end -> raw "9999", cursor at 4 (end).
    // Reformatted "9,999" should put the cursor at the end (5), not before
    // the inserted comma.
    const pos = mapCursorPosition('9999', 4, '9,999', 'en-US')
    expect(pos).toBe(5)
  })
  it('lands after the decimal point when the cursor was right after it', () => {
    const pos = mapCursorPosition('1000.', 5, '1,000.', 'en-US')
    expect(pos).toBe(6)
  })
  it('clamps to the end if the new string has fewer significant characters', () => {
    const pos = mapCursorPosition('1000', 4, '0', 'en-US')
    expect(pos).toBe(1)
  })
})

describe('normalizeOnBlur', () => {
  it('drops a trailing decimal point', () => {
    expect(normalizeOnBlur('1000.')).toBe('1000')
  })
  it('clears a lone minus sign', () => {
    expect(normalizeOnBlur('-')).toBe('')
  })
  it('clears a lone decimal point', () => {
    expect(normalizeOnBlur('.')).toBe('')
  })
  it('leaves a complete value untouched', () => {
    expect(normalizeOnBlur('1000.50')).toBe('1000.50')
  })
})
