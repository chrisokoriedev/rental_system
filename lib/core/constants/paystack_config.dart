/// Paystack configuration constants
/// Replace with your actual Paystack public key from https://dashboard.paystack.co/
class PaystackConfig {
  static const String publicKey = 'pk_test_79cea0725615fdee14403e304abac2525c376630';

  /// ⚠️ SECRET KEY — For test only. Move to a backend server before going live.
  static const String secretKey = 'sk_test_a2dccaaa0b33c31f62ef29f8eb6f745a16089366';

  static const String apiEndpoint = 'https://api.paystack.co';

  /// Callback URL — set this in your Paystack dashboard under Settings > API Keys & Webhooks
  static const String callbackUrl = 'https://example.com/callback';
}

