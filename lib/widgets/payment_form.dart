import 'package:flutter/material.dart';
import '../models/scheduled_payment.dart';
import '../database/database_helper.dart';

class PaymentForm extends StatefulWidget {
  final ScheduledPayment? payment;

  const PaymentForm({super.key, this.payment});

  @override
  _PaymentFormState createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  late TextEditingController _amountController;
  late DateTime _selectedDate;
  late String _selectedInterval;
  late PaymentCategory _selectedCategory;
  late PaymentFrequency _selectedFrequency;
  final List<String> _intervals = ['Mensual', 'Quincenal', 'Semanal'];

  @override
  void initState() {
    super.initState();
    final payment = widget.payment;
    _descriptionController = TextEditingController(text: payment?.description ?? '');
    _amountController = TextEditingController(text: payment?.amount.toString() ?? '');
    _selectedDate = payment?.nextDate ?? DateTime.now();
    _selectedInterval = payment?.interval ?? _intervals.first;
    _selectedCategory = payment?.category ?? PaymentCategory.other;
    _selectedFrequency = payment?.frequency ?? PaymentFrequency.monthly;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese una descripción';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Monto',
                border: OutlineInputBorder(),
                prefixText: '\$',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un monto';
                }
                if (double.tryParse(value) == null) {
                  return 'Por favor ingrese un número válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedInterval,
              decoration: const InputDecoration(
                labelText: 'Intervalo',
                border: OutlineInputBorder(),
              ),
              items: _intervals.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedInterval = value);
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<PaymentCategory>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Categoría',
                border: OutlineInputBorder(),
              ),
              items: PaymentCategory.values.map((category) {
                return DropdownMenuItem<PaymentCategory>(
                  value: category,
                  child: Row(
                    children: [
                      Icon(category.icon),
                      const SizedBox(width: 8),
                      Text(category.name),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCategory = value);
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<PaymentFrequency>(
              value: _selectedFrequency,
              decoration: const InputDecoration(
                labelText: 'Frecuencia',
                border: OutlineInputBorder(),
              ),
              items: PaymentFrequency.values.map((frequency) {
                return DropdownMenuItem<PaymentFrequency>(
                  value: frequency,
                  child: Text(frequency.name),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedFrequency = value);
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _savePayment,
              child: Text(widget.payment == null ? 'Agregar' : 'Actualizar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _savePayment() async {
    if (_formKey.currentState!.validate()) {
      final payment = ScheduledPayment(
        id: widget.payment?.id,
        description: _descriptionController.text,
        amount: double.parse(_amountController.text),
        nextDate: _selectedDate,
        interval: _selectedInterval,
        frequency: _selectedFrequency,
        category: _selectedCategory,
        isActive: true,
      );

      if (widget.payment == null) {
        await DatabaseHelper.instance.insertPayment(payment);
      } else {
        await DatabaseHelper.instance.updatePayment(payment);
      }

      if (mounted) {
        Navigator.pop(context, payment);
      }
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
