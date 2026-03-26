import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/shared_preferences_provider.dart';

class AuthSessionNotifier extends Notifier<bool> {
  static const _loggedInKey = 'auth.logged_in';

  @override
  bool build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getBool(_loggedInKey) ?? false;
  }

  Future<void> signIn() async {
    state = true;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_loggedInKey, true);
  }

  Future<void> signOut() async {
    state = false;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_loggedInKey, false);
  }
}

final authSessionProvider = NotifierProvider<AuthSessionNotifier, bool>(
  AuthSessionNotifier.new,
);
