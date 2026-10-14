enum Recurrence { none, monthly, yearly }

class Bill {
  final int? id;
  final String title;
  final double amount;
  final String currency;
  final int categoryId;
  final DateTime dueDate;
  final Recurrence recurrence;
  final int reminderDays;
  final String? notes;
  final bool isActive;
  final int anchorDay; // original day of month, used for month-end handling

  Bill({
    this.id,
    required this.title,
    required this.amount,
    required this.currency,
    required this.categoryId,
    required this.dueDate,
    this.recurrence = Recurrence.none,
    this.reminderDays = 3,
    this.notes,
    this.isActive = true,
    int? anchorDay,
  }) : anchorDay = anchorDay ?? dueDate.day;

  factory Bill.fromMap(Map<String, dynamic> m) => Bill(
        id: m['id'] as int?,
        title: m['title'] as String,
        amount: (m['amount'] as num).toDouble(),
        currency: m['currency'] as String,
        categoryId: m['category_id'] as int,
        dueDate: DateTime.parse(m['due_date'] as String),
        recurrence: Recurrence.values.byName(m['recurrence'] as String),
        reminderDays: m['reminder_days'] as int,
        notes: m['notes'] as String?,
        isActive: (m['is_active'] as int) == 1,
        anchorDay: m['anchor_day'] as int,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'amount': amount,
        'currency': currency,
        'category_id': categoryId,
        'due_date': dueDate.toIso8601String(),
        'recurrence': recurrence.name,
        'reminder_days': reminderDays,
        'notes': notes,
        'is_active': isActive ? 1 : 0,
        'anchor_day': anchorDay,
      };
}