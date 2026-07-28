import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:splito_flutter/core/utils/date_utils.dart';
import '../../domain/entities/group_member.dart';

part 'group_member_model.freezed.dart';
part 'group_member_model.g.dart';

/// Data model representing a group member with JSON serialization support.
@freezed
class GroupMemberModel with _$GroupMemberModel {
  /// Constructor for [GroupMemberModel].
  const factory GroupMemberModel({
    @JsonKey(name: 'user_id') required String userId,
    required String name,
    required String email,
    required String role,
    required String status,
    @JsonKey(name: 'joined_at') required String joinedAt,
  }) = _GroupMemberModel;

  const GroupMemberModel._();

  /// Creates a [GroupMemberModel] from a JSON map.
  factory GroupMemberModel.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberModelFromJson(json);

  /// Converts this model into a domain [GroupMember] entity.
  GroupMember toEntity() {
    return GroupMember(
      userId: userId,
      name: name,
      email: email,
      role: role,
      status: status,
      joinedAt: AppDateUtils.parseApiDate(joinedAt),
    );
  }
}
