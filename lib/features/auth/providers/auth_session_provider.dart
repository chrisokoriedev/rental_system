import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/shared_preferences_provider.dart';
import '../models/auth_profile_model.dart';

class AuthProfileNotifier extends Notifier<AuthProfileModel?> {
  static const _profileKey = 'auth.profile';

  @override
  AuthProfileModel? build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final rawProfile = prefs.getString(_profileKey);
    if (rawProfile == null || rawProfile.isEmpty) {
      return null;
    }

    try {
      return AuthProfileModel.fromEncodedJson(rawProfile);
    } catch (_) {
      return null;
    }
  }

  Future<void> upsertProfile({
    required String email,
    String? fullName,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final normalizedName = fullName?.trim();
    final resolvedName = normalizedName != null && normalizedName.isNotEmpty
        ? normalizedName
        : state?.fullName ?? _displayNameFromEmail(normalizedEmail);

    state = AuthProfileModel(
      fullName: resolvedName,
      email: normalizedEmail,
    );

    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_profileKey, state!.toEncodedJson());
  }

  String _displayNameFromEmail(String email) {
    final localPart = email.split('@').first;
    final spaced = localPart.replaceAll(RegExp(r'[._-]+'), ' ').trim();
    final words = spaced
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .map(
          (word) => '${word.substring(0, 1).toUpperCase()}${word.substring(1)}',
        )
        .toList();

    return words.isEmpty ? 'Guest User' : words.join(' ');
  }
}

final authProfileProvider =
    NotifierProvider<AuthProfileNotifier, AuthProfileModel?>(
      AuthProfileNotifier.new,
    );

class AuthSessionNotifier extends Notifier<bool> {
  static const _loggedInKey = 'auth.logged_in';

  @override
  bool build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getBool(_loggedInKey) ?? false;
  }

  Future<void> signIn({
    required String email,
    String? fullName,
  }) async {
    await ref
        .read(authProfileProvider.notifier)
        .upsertProfile(email: email, fullName: fullName);
    state = true;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_loggedInKey, true);
  }

  Future<void> signInWithGoogle() async {
    await signIn(
      email: 'guest.google@rental.app',
      fullName: 'Google Guest',
    );
  }

  Future<void> signUp({
    required String fullName,
    required String email,
  }) async {
    await signIn(email: email, fullName: fullName);
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
