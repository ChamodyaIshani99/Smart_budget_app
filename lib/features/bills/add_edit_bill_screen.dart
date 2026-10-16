import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/localization/l10n_ext.dart';
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
      appBar: AppBar(
        title: Text(_isEdit ? context.l10n.editBill : context.l10n.addBill),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _title,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: context.l10n.billName),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? context.l10n.enterName : null,
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
                    decoration: InputDecoration(labelText: context.l10n.amount),
                    validator: (v) {
                      final n =
                          double.tryParse((v ?? '').replaceAll(',', '').trim());
                      if (n == null || n <= 0) {
                        return context.l10n.enterValidAmount;
                      }
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
                    decoration:
                        InputDecoration(labelText: context.l10n.currency),
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
              decoration: InputDecoration(labelText: context.l10n.category),
              items: categories
                  .map((c) => DropdownMenuItem(
                        value: c.id,
                        child: Row(
                          children: [
                            Icon(categoryIcon(c.icon),
                                color: Color(c.color), size: 20),
                            const SizedBox(width: 10),
                            Text(c.nameFor(context.langCode)),
                          ],
                        ),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _categoryId = v),
              validator: (v) =>
                  v == null ? context.l10n.selectCategory : null,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: context.l10n.dueDate,
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                child: Text(formatDate(_dueDate)),
              ),
            ),
            const SizedBox(height: 16),
            Text(context.l10n.repeat),
            const SizedBox(height: 8),
            SegmentedButton<Recurrence>(
              segments: [
                ButtonSegment(
                    value: Recurrence.none, label: Text(context.l10n.oneTime)),
                ButtonSegment(
                    value: Recurrence.monthly,
                    label: Text(context.l10n.monthly)),
                ButtonSegment(
                    value: Recurrence.yearly, label: Text(context.l10n.yearly)),
              ],
              selected: {_recurrence},
              onSelectionChanged: (s) => setState(() => _recurrence = s.first),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              initialValue: _reminderDays,
              decoration: InputDecoration(labelText: context.l10n.remindMe),
              items: [
                DropdownMenuItem(
                    value: 0, child: Text(context.l10n.onTheDueDate)),
                DropdownMenuItem(
                    value: 1, child: Text(context.l10n.daysBefore(1))),
                DropdownMenuItem(
                    value: 3, child: Text(context.l10n.daysBefore(3))),
                DropdownMenuItem(
                    value: 7, child: Text(context.l10n.daysBefore(7))),
              ],
              onChanged: (v) => setState(() => _reminderDays = v!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notes,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: context.l10n.notesOptional,
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: _save,
                child: Text(
                    _isEdit ? context.l10n.saveChanges : context.l10n.addBill),
              ),
            ),
          ],
        ),
      ),
    );
  }
}