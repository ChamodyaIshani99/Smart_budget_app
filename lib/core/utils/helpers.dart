import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../l10n/app_localizations.dart';

String formatMoney(double amount, String currency) {
  final f = NumberFormat.currency(
    name: currency,
    symbol: '$currency ',
    decimalDigits: 2,
  );
  return f.format(amount);
}

String formatDate(DateTime date) => DateFormat.yMMMd().format(date);

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

IconData categoryIcon(String key) {
  switch (key) {
    case 'bolt':
      return Icons.bolt;
    case 'water':
      return Icons.water_drop;
    case 'bank':
      return Icons.account_balance;
    case 'home':
      return Icons.home;
    case 'wifi':
      return Icons.wifi;
    case 'food':
      return Icons.restaurant;
    case 'bus':
      return Icons.directions_bus;
    default:
      return Icons.more_horiz;
  }
}

/// Whole days from today until [due]. Negative if overdue.
/// Uses UTC dates so daylight-saving changes can't produce off-by-one errors.
int daysUntil(DateTime due) {
  final now = DateTime.now();
  return DateTime.utc(due.year, due.month, due.day)
      .difference(DateTime.utc(now.year, now.month, now.day))
      .inDays;
}

String dueStatusText(AppLocalizations l10n, DateTime due) {
  final days = daysUntil(due);
  if (days < 0) return l10n.overdueByDays(-days);
  if (days == 0) return l10n.dueToday;
  if (days == 1) return l10n.dueTomorrow;
  return l10n.dueInDays(days);
}