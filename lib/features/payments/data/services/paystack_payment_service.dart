import 'dart:convert';
import 'package:http/http.dart' as http;

/// Model for payment transaction details
class PaymentTransaction {
  final String reference;
  final String email;
  final int amountInKobo; // Amount in kobo (1/100 of naira)
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
  late String _publicKey;
  final String _apiEndpoint = 'https://api.paystack.co';

  /// Initialize Paystack with public key
  Future<void> initialize(String publicKey) async {
    _publicKey = publicKey;
  }

  /// Create Paystack payment authorization endpoint URL
  String getPaymentAuthorizationUrl(PaymentTransaction transaction) {
    final params = {
      'key': _publicKey,
      'email': transaction.email,
      'amount': transaction.amountInKobo.toString(),
      'reference': transaction.reference,
      'currency': transaction.currency ?? 'NGN',
    };

    final queryString = params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return 'https://checkout.paystack.com/?$queryString';
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

  /// Charge card and process payment (for direct implementation)
  Future<PaystackPaymentResponse> chargeCard({
    required PaymentTransaction transaction,
  }) async {
    try {
      // In a real implementation, this would use the Paystack SDK
      // For now, return a mock response
      return PaystackPaymentResponse(
        success: true,
        message: 'Payment processed',
        reference: transaction.reference,
        verifyUrl:
            '$_apiEndpoint/transaction/verify/${transaction.reference}',
      );
    } catch (e) {
      return PaystackPaymentResponse(
        success: false,
        message: 'Payment error: ${e.toString()}',
      );
    }
  }

  /// Get public key
  String get publicKey => _publicKey;

  /// Get API endpoint
  String get apiEndpoint => _apiEndpoint;
}
