import 'package:flutter/material.dart';

/// Icon and colour per account type, ported from
/// `frontend/src/components/account-icon.tsx` so an account looks the same
/// whether it's opened on the phone or the browser.
class AccountTypeStyle {
  const AccountTypeStyle({
    required this.icon,
    required this.foreground,
    required this.background,
    required this.label,
  });

  final IconData icon;
  final Color foreground;
  final Color background;
  final String label;
}

const _typeStyles = <String, AccountTypeStyle>{
  'checking': AccountTypeStyle(
    icon: Icons.account_balance_outlined,
    foreground: Color(0xFF4F46E5),
    background: Color(0xFFE0E7FF),
    label: 'Checking',
  ),
  'savings': AccountTypeStyle(
    icon: Icons.savings_outlined,
    foreground: Color(0xFF059669),
    background: Color(0xFFD1FAE5),
    label: 'Savings',
  ),
  'credit_card': AccountTypeStyle(
    icon: Icons.credit_card,
    foreground: Color(0xFF7C3AED),
    background: Color(0xFFEDE9FE),
    label: 'Credit card',
  ),
  'investment': AccountTypeStyle(
    icon: Icons.trending_up,
    foreground: Color(0xFFD97706),
    background: Color(0xFFFEF3C7),
    label: 'Investment',
  ),
  'wallet': AccountTypeStyle(
    icon: Icons.account_balance_wallet_outlined,
    foreground: Color(0xFFE11D48),
    background: Color(0xFFFFE4E6),
    label: 'Wallet',
  ),
};

AccountTypeStyle accountTypeStyle(String type) =>
    _typeStyles[type] ?? _typeStyles['checking']!;
