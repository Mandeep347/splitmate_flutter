import 'split_type.dart';

/// Input details of a participant for an equal split.
class EqualParticipantInput {
  /// The unique identifier of the user participant.
  final String userId;

  /// Creates a new [EqualParticipantInput] instance.
  const EqualParticipantInput({required this.userId});
}

/// Input details of a participant for an exact split.
class ExactParticipantInput {
  /// The unique identifier of the user participant.
  final String userId;

  /// The exact amount owed by this participant.
  final double owedAmount;

  /// Creates a new [ExactParticipantInput] instance.
  const ExactParticipantInput({required this.userId, required this.owedAmount});
}

/// Input details of a participant for a percentage split.
class PercentageParticipantInput {
  /// The unique identifier of the user participant.
  final String userId;

  /// The percentage split for this participant.
  final double percentage;

  /// Creates a new [PercentageParticipantInput] instance.
  const PercentageParticipantInput({
    required this.userId,
    required this.percentage,
  });
}

/// Input details of a participant for a share split.
class ShareParticipantInput {
  /// The unique identifier of the user participant.
  final String userId;

  /// The number of shares owned by this participant.
  final int shares;

  /// Creates a new [ShareParticipantInput] instance.
  const ShareParticipantInput({required this.userId, required this.shares});
}

/// Sealed base class representing input shapes for splitting an expense.
sealed class ExpenseSplitInput {
  /// Creates a new [ExpenseSplitInput] instance.
  const ExpenseSplitInput();

  /// Gets the [SplitType] corresponding to this input strategy.
  SplitType get splitType;
}

/// Input strategy for splitting an expense equally.
final class EqualSplitInput extends ExpenseSplitInput {
  /// The list of participants included in the equal split.
  final List<EqualParticipantInput> participants;

  /// Creates a new [EqualSplitInput] instance.
  const EqualSplitInput({required this.participants});

  @override
  SplitType get splitType => SplitType.equal;
}

/// Input strategy for splitting an expense by exact amounts.
final class ExactSplitInput extends ExpenseSplitInput {
  /// The list of participants with exact amounts.
  final List<ExactParticipantInput> participants;

  /// Creates a new [ExactSplitInput] instance.
  const ExactSplitInput({required this.participants});

  @override
  SplitType get splitType => SplitType.exact;
}

/// Input strategy for splitting an expense by percentages.
final class PercentageSplitInput extends ExpenseSplitInput {
  /// The list of participants with percentages.
  final List<PercentageParticipantInput> participants;

  /// Creates a new [PercentageSplitInput] instance.
  const PercentageSplitInput({required this.participants});

  @override
  SplitType get splitType => SplitType.percentage;
}

/// Input strategy for splitting an expense by shares/ratio.
final class ShareSplitInput extends ExpenseSplitInput {
  /// The list of participants with shares.
  final List<ShareParticipantInput> participants;

  /// Creates a new [ShareSplitInput] instance.
  const ShareSplitInput({required this.participants});

  @override
  SplitType get splitType => SplitType.share;
}
