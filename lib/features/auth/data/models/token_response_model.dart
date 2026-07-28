import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:splito_flutter/features/auth/domain/entities/auth_tokens.dart';

part 'token_response_model.freezed.dart';
part 'token_response_model.g.dart';

/// Data model representing the backend response containing authentication tokens.
@freezed
class TokenResponseModel with _$TokenResponseModel {
  const TokenResponseModel._();

  /// Creates a new [TokenResponseModel] instance.
  const factory TokenResponseModel({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'token_type') required String tokenType,
  }) = _TokenResponseModel;

  /// De-serializes JSON map data into a [TokenResponseModel] instance.
  factory TokenResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseModelFromJson(json);

  /// Converts this data model into a pure domain [AuthTokens] entity.
  AuthTokens toEntity() {
    return AuthTokens(accessToken: accessToken, refreshToken: refreshToken);
  }
}
