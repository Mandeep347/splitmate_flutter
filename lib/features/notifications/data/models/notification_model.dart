import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:splito_flutter/core/utils/date_utils.dart';
import '../../domain/entities/app_notification.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

/// Data model representing an in-app notification received from the API.
@freezed
class NotificationModel with _$NotificationModel {
  /// Creates a new [NotificationModel] instance.
  const factory NotificationModel({
    required String id,
    required String type,
    String? title,
    String? message,
    @JsonKey(name: 'is_read') required bool isRead,
    Map<String, dynamic>? metadata,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _NotificationModel;

  const NotificationModel._();

  /// Creates a new [NotificationModel] instance from a JSON map.
  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  /// Converts this data model into a domain [AppNotification] entity.
  AppNotification toEntity() {
    return AppNotification(
      id: id,
      type: type,
      title: title,
      message: message,
      isRead: isRead,
      metadata: metadata,
      createdAt: AppDateUtils.parseApiDate(createdAt),
    );
  }
}
