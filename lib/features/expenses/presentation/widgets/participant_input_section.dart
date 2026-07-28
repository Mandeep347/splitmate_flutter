import 'package:flutter/material.dart';
import 'package:splito_flutter/features/expenses/domain/entities/expense_split_input.dart';
import 'package:splito_flutter/features/expenses/domain/entities/split_type.dart';
import 'package:splito_flutter/features/groups/domain/entities/group_member.dart';
import 'package:splito_flutter/shared/widgets/member_avatar.dart';

/// Dynamic input widget section to specify the expense division among group members.
class ParticipantInputSection extends StatefulWidget {
  /// The list of members in the group.
  final List<GroupMember> members;

  /// The active split strategy.
  final SplitType splitType;

  /// The currency code or symbol for exact splits.
  final String currency;

  /// Callback triggered when any split input changes, returning the structured input payload.
  final ValueChanged<ExpenseSplitInput?> onSplitInputChanged;

  /// Creates a const [ParticipantInputSection] instance.
  const ParticipantInputSection({
    super.key,
    required this.members,
    required this.splitType,
    this.currency = 'INR',
    required this.onSplitInputChanged,
  });

  @override
  State<ParticipantInputSection> createState() =>
      _ParticipantInputSectionState();
}

class _ParticipantInputSectionState extends State<ParticipantInputSection> {
  Set<String> _selectedEqualIds = {};
  Map<String, TextEditingController> _exactControllers = {};
  Map<String, TextEditingController> _percentControllers = {};
  Map<String, TextEditingController> _shareControllers = {};

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    // Trigger initial notification after widget build to configure parent default states
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyParentOfCurrentInput();
    });
  }

  @override
  void didUpdateWidget(ParticipantInputSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.splitType != widget.splitType ||
        oldWidget.members.length != widget.members.length) {
      _initializeControllers();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _notifyParentOfCurrentInput();
        }
      });
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _initializeControllers() {
    _disposeControllers();

    if (widget.splitType == SplitType.equal) {
      _selectedEqualIds = widget.members.map((m) => m.userId).toSet();
    } else if (widget.splitType == SplitType.exact) {
      _exactControllers = {
        for (final m in widget.members) m.userId: TextEditingController(),
      };
    } else if (widget.splitType == SplitType.percentage) {
      _percentControllers = {
        for (final m in widget.members) m.userId: TextEditingController(),
      };
    } else if (widget.splitType == SplitType.share) {
      _shareControllers = {
        for (final m in widget.members)
          m.userId: TextEditingController(text: '1'),
      };
    }
  }

  void _disposeControllers() {
    for (final controller in _exactControllers.values) {
      controller.dispose();
    }
    _exactControllers.clear();

    for (final controller in _percentControllers.values) {
      controller.dispose();
    }
    _percentControllers.clear();

    for (final controller in _shareControllers.values) {
      controller.dispose();
    }
    _shareControllers.clear();
  }

  void _notifyParentOfCurrentInput() {
    ExpenseSplitInput? input;

    try {
      if (widget.splitType == SplitType.equal) {
        if (_selectedEqualIds.isNotEmpty) {
          input = EqualSplitInput(
            participants: _selectedEqualIds
                .map((id) => EqualParticipantInput(userId: id))
                .toList(),
          );
        }
      } else if (widget.splitType == SplitType.exact) {
        final list = <ExactParticipantInput>[];
        for (final m in widget.members) {
          final text = _exactControllers[m.userId]?.text ?? '';
          if (text.isNotEmpty) {
            final val = double.tryParse(text);
            if (val != null && val > 0) {
              list.add(
                ExactParticipantInput(userId: m.userId, owedAmount: val),
              );
            }
          }
        }
        if (list.isNotEmpty) {
          input = ExactSplitInput(participants: list);
        }
      } else if (widget.splitType == SplitType.percentage) {
        final list = <PercentageParticipantInput>[];
        for (final m in widget.members) {
          final text = _percentControllers[m.userId]?.text ?? '';
          if (text.isNotEmpty) {
            final val = double.tryParse(text);
            if (val != null && val > 0) {
              list.add(
                PercentageParticipantInput(userId: m.userId, percentage: val),
              );
            }
          }
        }
        if (list.isNotEmpty) {
          input = PercentageSplitInput(participants: list);
        }
      } else if (widget.splitType == SplitType.share) {
        final list = <ShareParticipantInput>[];
        for (final m in widget.members) {
          final text = _shareControllers[m.userId]?.text ?? '';
          if (text.isNotEmpty) {
            final val = int.tryParse(text);
            if (val != null && val > 0) {
              list.add(ShareParticipantInput(userId: m.userId, shares: val));
            }
          }
        }
        if (list.isNotEmpty) {
          input = ShareSplitInput(participants: list);
        }
      }
    } catch (_) {
      input = null;
    }

    widget.onSplitInputChanged(input);
  }

  String _getCurrencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'INR':
        return '₹';
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      default:
        return currency;
    }
  }

  Widget _buildRightControl(String userId) {
    switch (widget.splitType) {
      case SplitType.equal:
        final isChecked = _selectedEqualIds.contains(userId);
        return Checkbox(
          value: isChecked,
          onChanged: (val) {
            setState(() {
              if (val == true) {
                _selectedEqualIds.add(userId);
              } else {
                _selectedEqualIds.remove(userId);
              }
            });
            _notifyParentOfCurrentInput();
          },
        );
      case SplitType.exact:
        return SizedBox(
          width: 100,
          child: TextField(
            controller: _exactControllers[userId],
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: '0.00',
              suffixText: ' ${_getCurrencySymbol(widget.currency)}',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              isDense: true,
            ),
            onChanged: (_) => _notifyParentOfCurrentInput(),
          ),
        );
      case SplitType.percentage:
        return SizedBox(
          width: 80,
          child: TextField(
            controller: _percentControllers[userId],
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              hintText: '0',
              suffixText: ' %',
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              isDense: true,
            ),
            onChanged: (_) => _notifyParentOfCurrentInput(),
          ),
        );
      case SplitType.share:
        return SizedBox(
          width: 100,
          child: TextField(
            controller: _shareControllers[userId],
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: '1',
              suffixText: ' shares',
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              isDense: true,
            ),
            onChanged: (_) => _notifyParentOfCurrentInput(),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.members.map((member) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              MemberAvatar(name: member.name, radius: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  member.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildRightControl(member.userId),
            ],
          ),
        );
      }).toList(),
    );
  }
}
