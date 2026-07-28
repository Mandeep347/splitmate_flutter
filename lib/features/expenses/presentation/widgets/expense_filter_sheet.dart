import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:splito_flutter/core/theme/theme_extensions.dart';
import 'package:splito_flutter/features/analytics/presentation/providers/analytics_providers.dart';
import 'package:splito_flutter/features/expenses/domain/entities/split_type.dart';
import 'package:splito_flutter/features/groups/domain/entities/group_member.dart';
import 'package:splito_flutter/shared/widgets/primary_button.dart';

/// Bottom sheet allowing users to filter group expenses.
class ExpenseFilterSheet extends ConsumerStatefulWidget {
  /// The unique identifier of the group.
  final String groupId;

  /// The list of members belonging to this group.
  final List<GroupMember> members;

  /// Creates a const [ExpenseFilterSheet] instance.
  const ExpenseFilterSheet({
    super.key,
    required this.groupId,
    required this.members,
  });

  /// Displays the modal bottom filter sheet helper.
  static Future<void> show(
    BuildContext context,
    String groupId,
    List<GroupMember> members,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) =>
          ExpenseFilterSheet(groupId: groupId, members: members),
    );
  }

  @override
  ConsumerState<ExpenseFilterSheet> createState() => _ExpenseFilterSheetState();
}

class _ExpenseFilterSheetState extends ConsumerState<ExpenseFilterSheet> {
  DateTime? _fromDate;
  DateTime? _toDate;
  String? _selectedPayerId;
  SplitType? _selectedSplitType;

  @override
  void initState() {
    super.initState();
    final filters = ref.read(expenseSearchFiltersProvider(widget.groupId));
    _fromDate = filters.fromDate;
    _toDate = filters.toDate;
    _selectedPayerId = filters.paidByUserId;
    _selectedSplitType = filters.splitType;
  }

  void _applyFilters() {
    final notifier = ref.read(expenseSearchProvider(widget.groupId).notifier);
    final current = ref.read(expenseSearchFiltersProvider(widget.groupId));

    if (_fromDate != current.fromDate || _toDate != current.toDate) {
      notifier.updateDateRange(_fromDate, _toDate);
    }
    if (_selectedPayerId != current.paidByUserId) {
      notifier.updatePaidBy(_selectedPayerId);
    }
    if (_selectedSplitType != current.splitType) {
      notifier.updateSplitType(_selectedSplitType);
    }
    Navigator.pop(context);
  }

  void _clearFilters() {
    ref.read(expenseSearchProvider(widget.groupId).notifier).clearFilters();
    Navigator.pop(context);
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    return Padding(
      padding: EdgeInsets.only(top: ext.spaceLG, bottom: ext.spaceSM),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Expenses'),
        leading: TextButton(
          onPressed: _clearFilters,
          child: const Text('Clear'),
        ),
        actions: [
          TextButton(onPressed: _applyFilters, child: const Text('Apply')),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(ext.spaceMD),
        children: [
          _buildSectionHeader(context, 'Date Range'),
          Row(
            children: [
              _DatePickerTile(
                label: 'From',
                date: _fromDate,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _fromDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      _fromDate = picked;
                    });
                  }
                },
              ),
              SizedBox(width: ext.spaceSM),
              _DatePickerTile(
                label: 'To',
                date: _toDate,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _toDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      _toDate = picked;
                    });
                  }
                },
              ),
            ],
          ),
          _buildSectionHeader(context, 'Paid By'),
          Wrap(
            spacing: ext.spaceXS,
            runSpacing: ext.spaceXS,
            children: widget.members.map((member) {
              final isSelected = _selectedPayerId == member.userId;
              return FilterChip(
                label: Text(member.name.split(' ').first),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedPayerId = selected ? member.userId : null;
                  });
                },
              );
            }).toList(),
          ),
          _buildSectionHeader(context, 'Split Type'),
          Wrap(
            spacing: ext.spaceXS,
            runSpacing: ext.spaceXS,
            children: SplitType.values.map((splitType) {
              final isSelected = _selectedSplitType == splitType;
              return FilterChip(
                label: Text(splitType.displayLabel),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedSplitType = selected ? splitType : null;
                  });
                },
              );
            }).toList(),
          ),
          SizedBox(height: ext.spaceXL),
          PrimaryButton(label: 'Apply Filters', onPressed: _applyFilters),
        ],
      ),
    );
  }
}

class _DatePickerTile extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  const _DatePickerTile({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(ext.spaceSM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                date != null ? DateFormat('d MMM yyyy').format(date!) : 'Any',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
