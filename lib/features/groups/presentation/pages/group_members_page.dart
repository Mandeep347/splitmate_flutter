import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/core/theme/theme_extensions.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:splito_flutter/features/groups/domain/entities/group_member.dart';
import 'package:splito_flutter/features/groups/presentation/providers/group_providers.dart';
import 'package:splito_flutter/features/groups/presentation/widgets/add_member_sheet.dart';
import 'package:splito_flutter/shared/widgets/async_value_widget.dart';
import 'package:splito_flutter/shared/widgets/confirmation_dialog.dart';
import 'package:splito_flutter/shared/widgets/member_avatar.dart';
import 'package:splito_flutter/shared/widgets/shimmer_wrapper.dart';
import 'package:splito_flutter/shared/widgets/skeletons/member_tile_skeleton.dart';

/// Screen displaying the full list of members in a group.
class GroupMembersPage extends ConsumerWidget {
  /// The unique identifier of the group.
  final String groupId;

  /// The user ID of the creator of the group.
  final String groupCreatedBy;

  /// Creates a const [GroupMembersPage] instance.
  const GroupMembersPage({
    super.key,
    required this.groupId,
    required this.groupCreatedBy,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final membersAsync = ref.watch(groupMembersProvider(groupId));
    final currentUser = ref.watch(currentUserProvider);
    final isCreator = currentUser?.id == groupCreatedBy;

    // Listen to remove member state changes to show success/error SnackBar
    ref.listen<AsyncValue<void>>(removeMemberProvider, (previous, next) {
      if (next is AsyncData<void> && previous is AsyncLoading<void>) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Member removed!')),
        );
      } else if (next is AsyncError<void> && previous is AsyncLoading<void>) {
        final errorMessage =
            next.error is Failure ? (next.error as Failure).message : 'Failed to remove member.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () async => await AddMemberSheet.show(context, groupId),
          ),
        ],
      ),
      body: AsyncValueWidget<List<GroupMember>>(
        value: membersAsync,
        loading: () => ShimmerWrapper(
          isLoading: true,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(vertical: ext.spaceMD),
            itemCount: 3,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) => const MemberTileSkeleton(),
          ),
        ),
        data: (members) {
          if (members.isEmpty) {
            return const Center(
              child: Text('No members found.'),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.symmetric(vertical: ext.spaceMD),
            itemCount: members.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final member = members[index];
              final isSelf = currentUser?.id == member.userId;
              final showRemove = isCreator && !isSelf;

              return ListTile(
                leading: MemberAvatar(name: member.name),
                title: Text(
                  member.name,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  member.email,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (member.isAdmin) ...[
                      Chip(
                        label: const Text('ADMIN'),
                        backgroundColor: theme.colorScheme.primaryContainer,
                        labelStyle: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                      SizedBox(width: ext.spaceSM),
                    ],
                    if (showRemove)
                      IconButton(
                        icon: const Icon(Icons.person_remove_outlined),
                        color: theme.colorScheme.error,
                        onPressed: () async {
                          final confirm = await ConfirmationDialog.show(
                            context,
                            title: 'Remove Member',
                            message: 'Remove ${member.name} from this group?',
                            isDestructive: true,
                          );
                          if (confirm == true) {
                            await ref.read(removeMemberProvider.notifier).remove(
                                  groupId: groupId,
                                  userId: member.userId,
                                );
                          }
                        },
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
