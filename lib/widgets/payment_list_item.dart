// lib/widgets/payment_list_item.dart
import 'package:flutter/material.dart';
import '../models/scheduled_payment.dart';
import 'package:intl/intl.dart';

class PaymentListItem extends StatelessWidget {
  final ScheduledPayment payment;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const PaymentListItem({
    super.key,
    required this.payment,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(payment.id.toString()),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Icon(
              payment.category.icon,
              color: Theme.of(context).primaryColor,
            ),
          ),
          title: Text(
            payment.description,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Próximo pago: ${DateFormat('dd/MM/yyyy').format(payment.nextDate)}\n'
            '${payment.interval}',
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '\$${payment.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: onEdit,
                color: Colors.grey,
              ),
            ],
          ),
          isThreeLine: true,
        ),
      ),
    );
  }
}