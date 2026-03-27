import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_system/features/payments/data/services/paystack_payment_service.dart';
import '../../../core/constants/paystack_config.dart';

/// Provider for Paystack payment service singleton
final paystackServiceProvider = Provider<PaystackPaymentService>((ref) {
  final service = PaystackPaymentService();
  service.initialize(PaystackConfig.publicKey);
  return service;
});

/// State for payment processing
class PaymentState {
  final bool isProcessing;
  final String? errorMessage;
  final String? successMessage;
  final String? transactionReference;

  PaymentState({
    this.isProcessing = false,
    this.errorMessage,
    this.successMessage,
    this.transactionReference,
  });

  PaymentState copyWith({
    bool? isProcessing,
    String? errorMessage,
    String? successMessage,
    String? transactionReference,
  }) {
    return PaymentState(
      isProcessing: isProcessing ?? this.isProcessing,
      errorMessage: errorMessage,
      successMessage: successMessage,
      transactionReference: transactionReference ?? this.transactionReference,
    );
  }
}

/// Notifier for payment processing
class PaymentNotifier extends StateNotifier<PaymentState> {
  final PaystackPaymentService _paymentService;

  PaymentNotifier(this._paymentService) : super(PaymentState());

  /// Process payment with Paystack
  Future<bool> processPayment({
    required String email,
    required int amountInKobo,
    required String reference,
    required BuildContext context,
  }) async {
    state = state.copyWith(isProcessing: true, errorMessage: null);

    try {
      final transaction = PaymentTransaction(
        reference: reference,
        email: email,
        amountInKobo: amountInKobo,
      );

      final response = await _paymentService.chargeCard(
        transaction: transaction,
        context: context,
      );

      if (response.success) {
        state = state.copyWith(
          isProcessing: false,
          successMessage: response.message,
          transactionReference: response.reference,
        );
        return true;
      } else {
        state = state.copyWith(
          isProcessing: false,
          errorMessage: response.message,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        errorMessage: 'Payment processing failed: ${e.toString()}',
      );
      return false;
    }
  }

  /// Clear payment messages
  void clearMessages() {
    state = PaymentState();
  }
}

/// Provider for payment state management
final paymentProvider = StateNotifierProvider<PaymentNotifier, PaymentState>(
  (ref) {
    final service = ref.watch(paystackServiceProvider);
    return PaymentNotifier(service);
  },
);
