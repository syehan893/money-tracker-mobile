import 'package:equatable/equatable.dart';

/// User entity representing the authenticated user
class User extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String? avatarUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.fullName,
    this.avatarUrl,
    this.createdAt,
    this.updatedAt,
  });

  /// Create an empty user for initial states
  factory User.empty() => const User(
        id: '',
        email: '',
        fullName: '',
      );

  /// Check if user is empty/not authenticated
  bool get isEmpty => id.isEmpty;
  bool get isNotEmpty => id.isNotEmpty;

  @override
  List<Object?> get props => [id, email, fullName, avatarUrl, createdAt, updatedAt];
}
