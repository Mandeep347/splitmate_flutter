import '../entities/group.dart';
import '../entities/group_member.dart';

/// Abstract repository contract defining group and group member operations.
abstract interface class IGroupRepository {
  /// Fetches a list of all groups that the current user belongs to.
  Future<List<Group>> getMyGroups();

  /// Fetches details of a specific group by its ID.
  Future<Group> getGroupById({required String groupId});

  /// Creates a new group with a given name and default currency.
  Future<Group> createGroup({required String name, required String currency});

  /// Updates details of an existing group.
  Future<Group> updateGroup({required String groupId, required String name});

  /// Archives a specific group by its ID.
  Future<Group> archiveGroup({required String groupId});

  /// Fetches all members belonging to a group.
  Future<List<GroupMember>> getMembers({required String groupId});

  /// Adds a new member to a group by their email.
  Future<GroupMember> addMember({
    required String groupId,
    required String email,
  });

  /// Removes an existing member from a group.
  Future<void> removeMember({required String groupId, required String userId});
}
