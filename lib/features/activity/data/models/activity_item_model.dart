import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/activity_item.dart';

part 'activity_item_model.freezed.dart';
part 'activity_item_model.g.dart';

/// Data model representing a group activity item received from the API.
@freezed
class ActivityItemModel with _$ActivityItemModel {
  /// Creates a new [ActivityItemModel] instance.
  const factory ActivityItemModel({
    required String type,
    required String actor,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _ActivityItemModel;

  const ActivityItemModel._();

  /// Creates a new [ActivityItemModel] instance from a JSON map.
  factory ActivityItemModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityItemModelFromJson(json);

  /// Converts this data model into a domain [ActivityItem] entity.
  ActivityItem toEntity({required String groupId, required int index}) {
    return ActivityItem(
      id: index.toString(),
      groupId: groupId,
      type: type,
      actorName: actor,
      actorUserId: '',
      description: _deriveDescription(type, actor),
      entityId: null,
      entityType: _deriveEntityType(type),
      createdAt: DateTime.parse(createdAt),
    );
  }

  static String _deriveDescription(String type, String actor) {
    switch (type) {
      case 'EXPENSE_CREATED':
        return '$actor added an expense';
      case 'EXPENSE_REVERSED':
        return '$actor reversed an expense';
      case 'SETTLEMENT_RECORDED':
        return '$actor recorded a payment';
      case 'MEMBER_ADDED':
        return '$actor joined the group';
      case 'MEMBER_REMOVED':
        return '$actor left the group';
      case 'GROUP_UPDATED':
        return '$actor updated the group';
      default:
        return '$actor performed an action';
    }
  }

  static String? _deriveEntityType(String type) {
    if (type.startsWith('EXPENSE_')) {
      return 'expense';
    } else if (type.startsWith('SETTLEMENT_')) {
      return 'settlement';
    } else if (type.startsWith('MEMBER_')) {
      return 'member';
    }
    return null;
  }
}
