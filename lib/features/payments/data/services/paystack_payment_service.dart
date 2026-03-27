import 'package:flutter/material.dart';
import 'package:flutter_paystack_plus/flutter_paystack_plus.dart';

/// Model for payment transaction details
class PaymentTransaction {
  final String reference;
  final String email;
  final int amountInKobo; 
  final String? currency;

  PaymentTransaction({
    required this.reference,
    required this.email,
    required this.amountInKobo,
    this.currency = 'NGN',
  });

  Map<String, dynamic> toJson() => {
    'reference': reference,
    'email': email,
    'amount': amountInKobo,
    'currency': currency ?? 'NGN',
  };
}

/// Model for payment response
class PaystackPaymentResponse {
  final bool success;
  final String message;
  final String? reference;

  PaystackPaymentResponse({
    required this.success,
    required this.message,
    this.reference,
  });
}

/// Service to handle Paystack payment integration
class PaystackPaymentService {
  late String _paystackPublicKey;
  final String _callbackUrl = 'https://example.com/callback';

  /// Initialize Paystack with a public key only.
  Future<void> initialize(String publicKey) async {
    _paystackPublicKey = publicKey;
  }

  /// Charge card and process payment with Paystack
  Future<PaystackPaymentResponse> chargeCard({
    required PaymentTransaction transaction,
    required BuildContext context,
  }) async {
    try {
      bool paymentSuccess = false;

      await FlutterPaystackPlus.openPaystackPopup(
        context: context,
        customerEmail: transaction.email,
        amount: transaction.amountInKobo.toString(),
        reference: transaction.reference,
        // The plugin API uses the parameter name `secretKey`.
        // For client apps, pass only your Paystack public key here.
        secretKey: _paystackPublicKey,
        callBackUrl: _callbackUrl,
        currency: transaction.currency ?? 'NGN',
        onSuccess: () {
          paymentSuccess = true;
        },
        onClosed: () {
          paymentSuccess = false;
        },
      );

      if (paymentSuccess) {
        return PaystackPaymentResponse(
          success: true,
          message: 'Payment successful',
          reference: transaction.reference,
        );
      } else {
        return PaystackPaymentResponse(
          success: false,
          message: 'Payment cancelled',
        );
      }
    } catch (e) {
      return PaystackPaymentResponse(
        success: false,
        message: 'Payment error: ${e.toString()}',
      );
    }
  }
}


