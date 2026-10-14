import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/helpers.dart';
import '../../data/models/bill.dart';
import 'providers/bill_providers.dart';
import '../../core/services/notification_service.dart';

class AddEditBillScreen extends ConsumerStatefulWidget {
  final Bill? bill;
  const AddEditBillScreen({super.key, this.bill});

  @override
  ConsumerState<AddEditBillScreen> createState() => _AddEditBillScreenState();
}

class _AddEditBillScreenState extends ConsumerState<AddEditBillScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _amount;
  late final TextEditingController _notes;
  late String _currency;
  int? _categoryId;
  late DateTime _dueDate;
  late Recurrence _recurrence;
  late int _reminderDays;

  bool get _isEdit => widget.bill != null;

  @override
  void initState() {
    super.initState();
    final b = widget.bill;
    _title = TextEditingController(text: b?.title ?? '');
    _amount = TextEditingController(text: b == null ? '' : b.amount.toString());
    _notes = TextEditingController(text: b?.notes ?? '');
    _currency = b?.currency ?? 'LKR';
    _categoryId = b?.categoryId;
    _dueDate = b?.dueDate ?? dateOnly(DateTime.now());
    _recurrence = b?.recurrence ?? Recurrence.monthly;
    _reminderDays = b?.reminderDays ?? 3;
    if (b == null) _loadDefaultCurrency();
  }

  Future<void> _loadDefaultCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    final c = prefs.getString(AppConstants.prefDefaultCurrency);
    if (c != null && mounted) setState(() => _currency = c);
  }

  @override
  void dispose() {
    _title.dispose();
    _amount.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _dueDate = dateOnly(picked));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_isEdit) await NotificationService.instance.requestPermission();

    final amount = double.parse(_amount.text.replaceAll(',', '').trim());
    final notes = _notes.text.trim();

    final bill = Bill(
      id: widget.bill?.id,
      title: _title.text.trim(),
      amount: amount,
      currency: _currency,
      categoryId: _categoryId!,
      dueDate: _dueDate,
      recurrence: _recurrence,
      reminderDays: _reminderDays,
      notes: notes.isEmpty ? null : notes,
      anchorDay: (_isEdit && _dueDate == widget.bill!.dueDate)
          ? widget.bill!.anchorDay
          : null,
    );

    final notifier = ref.read(billsProvider.notifier);
    if (_isEdit) {
      await notifier.updateBill(bill);
    } else {
      await notifier.addBill(bill);
    }
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit bill' : 'Add bill')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _title,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Bill name'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter a name' : null,
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _amount,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Amount'),
                    validator: (v) {
                      final n =
                          double.tryParse((v ?? '').replaceAll(',', '').trim());
                      if (n == null || n <= 0) return 'Enter a valid amount';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    key: ValueKey(_currency),
                    initialValue: _currency,
                    decoration: const InputDecoration(labelText: 'Currency'),
                    items: AppConstants.currencies
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => _currency = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              initialValue: _categoryId,
              decoration: const InputDecoration(labelText: 'Category'),
              items: categories
                  .map((c) => DropdownMenuItem(
                        value: c.id,
                        child: Row(
                          children: [
                            Icon(categoryIcon(c.icon),
                                color: Color(c.color), size: 20),
                            const SizedBox(width: 10),
                            Text(c.nameEn),
                          ],
                        ),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _categoryId = v),
              validator: (v) => v == null ? 'Select a category' : null,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Due date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(formatDate(_dueDate)),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Repeat'),
            const SizedBox(height: 8),
            SegmentedButton<Recurrence>(
              segments: const [
                ButtonSegment(value: Recurrence.none, label: Text('One-time')),
                ButtonSegment(value: Recurrence.monthly, label: Text('Monthly')),
                ButtonSegment(value: Recurrence.yearly, label: Text('Yearly')),
              ],
              selected: {_recurrence},
              onSelectionChanged: (s) => setState(() => _recurrence = s.first),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              initialValue: _reminderDays,
              decoration: const InputDecoration(labelText: 'Remind me'),
              items: const [
                DropdownMenuItem(value: 0, child: Text('On the due date')),
                DropdownMenuItem(value: 1, child: Text('1 day before')),
                DropdownMenuItem(value: 3, child: Text('3 days before')),
                DropdownMenuItem(value: 7, child: Text('7 days before')),
              ],
              onChanged: (v) => setState(() => _reminderDays = v!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notes,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: _save,
                child: Text(_isEdit ? 'Save changes' : 'Add bill'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}