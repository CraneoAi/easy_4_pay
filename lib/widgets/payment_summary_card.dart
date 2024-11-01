// lib/widgets/payment_summary_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentSummaryCard extends StatelessWidget {
  final double totalAmount;
  final int totalPayments;
  final int upcomingPayments;

  const PaymentSummaryCard({
    super.key,
    required this.totalAmount,
    required this.totalPayments,
    required this.upcomingPayments,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumen de Pagos',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SummaryItem(
                  title: 'Total',
                  value: NumberFormat.currency(
                    symbol: '\$',
                    decimalDigits: 2,
                  ).format(totalAmount),
                  icon: Icons.account_balance_wallet,
                ),
                _SummaryItem(
                  title: 'Pagos',
                  value: totalPayments.toString(),
                  icon: Icons.payment,
                ),
                _SummaryItem(
                  title: 'Próximos',
                  value: upcomingPayments.toString(),
                  icon: Icons.upcoming,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _SummaryItem({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Theme.of(context).primaryColor),
        const SizedBox(height: 8),
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}