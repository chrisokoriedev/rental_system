/// Paystack configuration constants
/// Replace with your actual Paystack public key from https://dashboard.paystack.co/
class PaystackConfig {
  /// Your Paystack public key (test or live)
  /// Get this from: https://dashboard.paystack.co/#/settings/developer
  static const String publicKey = 'pk_test_79cea0725615fdee14403e304abac2525c376630';

  /// Paystack API endpoint
  static const String apiEndpoint = 'https://api.paystack.co';

  /// Initialize Paystack with your public key
  /// Call this in main.dart before running the app
  static void initialize() {
    // Paystack.initialize(publicKey: publicKey);
  }
}

