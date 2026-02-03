part of 'auth_bloc.dart';

/// Possible authentication status
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// Authentication state
class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  /// Initial state when app starts
  factory AuthState.initial() => const AuthState(status: AuthStatus.initial);

  /// Loading state during authentication operations
  factory AuthState.loading() => const AuthState(status: AuthStatus.loading);

  /// Authenticated state with user data
  factory AuthState.authenticated(User user) => AuthState(
        status: AuthStatus.authenticated,
        user: user,
      );

  /// Unauthenticated state
  factory AuthState.unauthenticated() =>
      const AuthState(status: AuthStatus.unauthenticated);

  /// Error state with message
  factory AuthState.error(String message) => AuthState(
        status: AuthStatus.error,
        errorMessage: message,
      );

  /// Check if currently loading
  bool get isLoading => status == AuthStatus.loading;

  /// Check if authenticated
  bool get isAuthenticated => status == AuthStatus.authenticated;

  /// Check if has error
  bool get hasError => status == AuthStatus.error;

  /// Copy with method for state updates
  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}
