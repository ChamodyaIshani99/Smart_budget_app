class Payment {
  final int? id;
  final int billId;
  final double amountPaid;
  final String currency;
  final DateTime paidDate;
  final DateTime dueDateCovered;

  const Payment({
    this.id,
    required this.billId,
    required this.amountPaid,
    required this.currency,
    required this.paidDate,
    required this.dueDateCovered,
  });

  factory Payment.fromMap(Map<String, dynamic> m) => Payment(
        id: m['id'] as int?,
        billId: m['bill_id'] as int,
        amountPaid: (m['amount_paid'] as num).toDouble(),
        currency: m['currency'] as String,
        paidDate: DateTime.parse(m['paid_date'] as String),
        dueDateCovered: DateTime.parse(m['due_date_covered'] as String),
      );
}