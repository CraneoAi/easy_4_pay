import 'package:flutter/material.dart';

// Enums para categorías y frecuencias de pago
enum PaymentCategory {
  bills,
  rent,
  services,
  subscription,
  loan,
  other,
}

enum PaymentFrequency {
  daily,
  weekly,
  biweekly,
  monthly,
  bimonthly,
  quarterly,
  yearly,
}

// Extensión para obtener strings legibles de los enums
extension PaymentCategoryExtension on PaymentCategory {
  String get name {
    switch (this) {
      case PaymentCategory.bills:
        return 'Facturas';
      case PaymentCategory.rent:
        return 'Alquiler';
      case PaymentCategory.services:
        return 'Servicios';
      case PaymentCategory.subscription:
        return 'Suscripción';
      case PaymentCategory.loan:
        return 'Préstamo';
      case PaymentCategory.other:
        return 'Otro';
    }
  }

  IconData get icon {
    switch (this) {
      case PaymentCategory.bills:
        return Icons.receipt_long;
      case PaymentCategory.rent:
        return Icons.home;
      case PaymentCategory.services:
        return Icons.build;
      case PaymentCategory.subscription:
        return Icons.subscriptions;
      case PaymentCategory.loan:
        return Icons.account_balance;
      case PaymentCategory.other:
        return Icons.more_horiz;
    }
  }
}

extension PaymentFrequencyExtension on PaymentFrequency {
  String get name {
    switch (this) {
      case PaymentFrequency.daily:
        return 'Diario';
      case PaymentFrequency.weekly:
        return 'Semanal';
      case PaymentFrequency.biweekly:
        return 'Quincenal';
      case PaymentFrequency.monthly:
        return 'Mensual';
      case PaymentFrequency.bimonthly:
        return 'Bimestral';
      case PaymentFrequency.quarterly:
        return 'Trimestral';
      case PaymentFrequency.yearly:
        return 'Anual';
    }
  }

  int get daysInterval {
    switch (this) {
      case PaymentFrequency.daily:
        return 1;
      case PaymentFrequency.weekly:
        return 7;
      case PaymentFrequency.biweekly:
        return 15;
      case PaymentFrequency.monthly:
        return 30;
      case PaymentFrequency.bimonthly:
        return 60;
      case PaymentFrequency.quarterly:
        return 90;
      case PaymentFrequency.yearly:
        return 365;
    }
  }
}

class ScheduledPayment {
  final int? id;
  final String description;
  final double amount;
  final DateTime nextDate;
  final String interval;
  final PaymentFrequency frequency;
  final PaymentCategory category;
  final bool isActive;
  final String? notes;
  final DateTime createdAt;
  final DateTime? lastPaidDate;

  ScheduledPayment({
    this.id,
    required this.description,
    required this.amount,
    required this.nextDate,
    required this.interval,
    required this.frequency,
    required this.category,
    this.isActive = true,
    this.notes,
    DateTime? createdAt,
    this.lastPaidDate,
  }) : createdAt = createdAt ?? DateTime.now();

  // Constructor de fábrica para crear una instancia desde un Map (base de datos)
  factory ScheduledPayment.fromMap(Map<String, dynamic> map) {
    return ScheduledPayment(
      id: map['id'],
      description: map['description'],
      amount: map['amount'],
      nextDate: DateTime.parse(map['next_date']),
      interval: map['interval'],
      frequency: PaymentFrequency.values[map['frequency']],
      category: PaymentCategory.values[map['category']],
      isActive: map['is_active'] == 1,
      notes: map['notes'],
      createdAt: DateTime.parse(map['created_at']),
      lastPaidDate: map['last_paid_date'] != null
          ? DateTime.parse(map['last_paid_date'])
          : null,
    );
  }

  // Método para convertir la instancia a un Map (para guardar en base de datos)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'next_date': nextDate.toIso8601String(),
      'interval': interval,
      'frequency': frequency.index,
      'category': category.index,
      'is_active': isActive ? 1 : 0,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'last_paid_date': lastPaidDate?.toIso8601String(),
    };
  }

  // Método para crear una copia del objeto con campos actualizados
  ScheduledPayment copyWith({
    int? id,
    String? description,
    double? amount,
    DateTime? nextDate,
    String? interval,
    PaymentFrequency? frequency,
    PaymentCategory? category,
    bool? isActive,
    String? notes,
    DateTime? createdAt,
    DateTime? lastPaidDate,
  }) {
    return ScheduledPayment(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      nextDate: nextDate ?? this.nextDate,
      interval: interval ?? this.interval,
      frequency: frequency ?? this.frequency,
      category: category ?? this.category,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      lastPaidDate: lastPaidDate ?? this.lastPaidDate,
    );
  }

  // Método para calcular la siguiente fecha de pago
  DateTime calculateNextPaymentDate() {
    if (lastPaidDate == null) return nextDate;
    return lastPaidDate!.add(Duration(days: frequency.daysInterval));
  }

  // Método para verificar si el pago está próximo (en los próximos 7 días)
  bool get isUpcoming {
    final now = DateTime.now();
    final difference = nextDate.difference(now).inDays;
    return difference <= 7 && difference >= 0;
  }

  // Método para verificar si el pago está vencido
  bool get isOverdue {
    return DateTime.now().isAfter(nextDate);
  }
}
