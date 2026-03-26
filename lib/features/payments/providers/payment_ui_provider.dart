import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PaymentMethod { paystack, flutterwave, stripe }

final selectedPaymentMethodProvider =
    StateProvider<PaymentMethod>((ref) => PaymentMethod.paystack);
