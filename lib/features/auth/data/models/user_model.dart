import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:splito_flutter/features/auth/domain/entities/logged_in_user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Data model representing backend user details responses.
@freezed
class UserModel with _$UserModel {
  const UserModel._();

  /// Creates a new [UserModel] instance.
  const factory UserModel({
    required String id,
    required String name,
    required String email,
    @JsonKey(name: 'preferred_currency') required String preferredCurrency,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'is_email_verified', defaultValue: false)
    required bool isEmailVerified,
  }) = _UserModel;

  /// De-serializes JSON map data into a [UserModel] instance.
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Converts this data model into a pure domain [LoggedInUser] entity.
  LoggedInUser toEntity() {
    return LoggedInUser(
      id: id,
      name: name,
      email: email,
      preferredCurrency: preferredCurrency,
      isEmailVerified: isEmailVerified,
    );
  }
}
