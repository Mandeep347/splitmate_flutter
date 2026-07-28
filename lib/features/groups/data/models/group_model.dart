import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:splito_flutter/core/utils/date_utils.dart';
import '../../domain/entities/group.dart';
import 'group_member_model.dart';

part 'group_model.freezed.dart';
part 'group_model.g.dart';

/// Data model representing a group with JSON serialization support.
@freezed
class GroupModel with _$GroupModel {
  /// Constructor for [GroupModel].
  const factory GroupModel({
    required String id,
    required String name,
    @JsonKey(name: 'default_currency') required String defaultCurrency,
    required String status,
    @JsonKey(name: 'created_by') required String createdBy,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'members_count') required int membersCount,
    @Default([]) List<GroupMemberModel> members,
  }) = _GroupModel;

  const GroupModel._();

  /// Creates a [GroupModel] from a JSON map.
  factory GroupModel.fromJson(Map<String, dynamic> json) =>
      _$GroupModelFromJson(json);

  /// Converts this model into a domain [Group] entity.
  Group toEntity() {
    return Group(
      id: id,
      name: name,
      defaultCurrency: defaultCurrency,
      status: status,
      createdBy: createdBy,
      createdAt: AppDateUtils.parseApiDate(createdAt),
      membersCount: membersCount,
      members: members.map((m) => m.toEntity()).toList(),
    );
  }
}
