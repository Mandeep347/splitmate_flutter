/// Represents the different types of expense splitting methods.
enum SplitType {
  /// Splitting equally among all participants.
  equal,

  /// Splitting by exact amounts for each participant.
  exact,

  /// Splitting by percentages for each participant.
  percentage,

  /// Splitting by shares/ratio for each participant.
  share;

  /// Returns the uppercase string representation the backend API expects.
  String get apiValue {
    switch (this) {
      case SplitType.equal:
        return 'EQUAL';
      case SplitType.exact:
        return 'EXACT';
      case SplitType.percentage:
        return 'PERCENTAGE';
      case SplitType.share:
        return 'SHARE';
    }
  }

  /// Parses the backend string representation back to the [SplitType] enum.
  /// Throws [ArgumentError] on an unknown api value.
  static SplitType fromApiValue(String value) {
    switch (value.toUpperCase()) {
      case 'EQUAL':
        return SplitType.equal;
      case 'EXACT':
        return SplitType.exact;
      case 'PERCENTAGE':
        return SplitType.percentage;
      case 'SHARE':
        return SplitType.share;
      default:
        throw ArgumentError('Unknown API value for SplitType: $value');
    }
  }

  /// Returns a user-friendly label for displaying in the UI.
  String get displayLabel {
    switch (this) {
      case SplitType.equal:
        return 'Equal';
      case SplitType.exact:
        return 'Exact';
      case SplitType.percentage:
        return 'Percentage';
      case SplitType.share:
        return 'By Shares';
    }
  }
}
