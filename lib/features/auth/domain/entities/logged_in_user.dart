/// Pure domain entity representing the authenticated user.
class LoggedInUser {
  /// Unique identifier of the user.
  final String id;

  /// Full display name of the user.
  final String name;

  /// Email address of the user.
  final String email;

  /// User's preferred currency (e.g., USD, EUR).
  final String preferredCurrency;

  /// Whether the user's email has been verified.
  final bool isEmailVerified;

  /// Creates a new [LoggedInUser] instance.
  const LoggedInUser({
    required this.id,
    required this.name,
    required this.email,
    required this.preferredCurrency,
    required this.isEmailVerified,
  });

  /// Computes the user's initials from their name.
  /// Matches first letters of the first and last name (e.g. "John Doe" -> "JD").
  String get initials {
    if (name.isEmpty) return '';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[parts.length - 1].substring(0, 1))
        .toUpperCase();
  }
}
