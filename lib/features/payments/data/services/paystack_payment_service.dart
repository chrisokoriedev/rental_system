import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_paystack_plus/flutter_paystack_plus.dart';
import 'package:http/http.dart' as http;

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
  final String? verifyUrl;

  PaystackPaymentResponse({
    required this.success,
    required this.message,
    this.reference,
    this.verifyUrl,
  });
}

/// Service to handle Paystack payment integration
class PaystackPaymentService {
  late String _secretKey;
  final String _apiEndpoint = 'https://api.paystack.co';
  final String _callbackUrl = 'https://example.com/callback';

  /// Initialize Paystack with secret key
  Future<void> initialize(String secretKey) async {
    _secretKey = secretKey;
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
        secretKey: _secretKey,
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
          verifyUrl:
              '$_apiEndpoint/transaction/verify/${transaction.reference}',
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

  /// Verify transaction with Paystack backend
  Future<PaystackPaymentResponse> verifyPayment({
    required String reference,
    required String secretKey,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$_apiEndpoint/transaction/verify/$reference'),
        headers: {
          'Authorization': 'Bearer $secretKey',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PaystackPaymentResponse(
          success: data['status'] == true,
          message: data['message'] ?? 'Payment verified',
          reference: reference,
          verifyUrl: '$_apiEndpoint/transaction/verify/$reference',
        );
      }

      return PaystackPaymentResponse(
        success: false,
        message: 'Verification failed',
      );
    } catch (e) {
      return PaystackPaymentResponse(
        success: false,
        message: 'Verification error: ${e.toString()}',
      );
    }
  }

  /// Get secret key
  String get secretKey => _secretKey;

  /// Get API endpoint
  String get apiEndpoint => _apiEndpoint;
}


