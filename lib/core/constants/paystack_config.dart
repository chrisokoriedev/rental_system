/// Paystack configuration constants
/// This mock app must only use a Paystack PUBLIC key on device.
class PaystackConfig {
  static const String publicKey = String.fromEnvironment(
    'PAYSTACK_PUBLIC_KEY',
    defaultValue: 'pk_test_replace_me',
  );

  /// Callback URL — set this in your Paystack dashboard under Settings > API Keys & Webhooks
  static const String callbackUrl = 'https://example.com/callback';
}

