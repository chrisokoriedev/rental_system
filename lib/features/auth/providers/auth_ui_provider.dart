import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthUiState {
  const AuthUiState({this.isLoading = false, this.error});

  final bool isLoading;
  final String? error;

  AuthUiState copyWith({bool? isLoading, String? error}) {
    return AuthUiState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthUiNotifier extends Notifier<AuthUiState> {
  @override
  AuthUiState build() => const AuthUiState();
}

final authUiProvider = NotifierProvider<AuthUiNotifier, AuthUiState>(
  AuthUiNotifier.new,
);
