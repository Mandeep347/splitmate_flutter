import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Application wide constants loaded from environment settings.
class AppConstants {
  const AppConstants._();

  /// The base URL of the FastAPI backend.
  static String get baseUrl => dotenv.get('API_BASE_URL', fallback: 'https://splitmate-hosting.onrender.com/api/v1');

  /// Connection timeout in milliseconds.
  static int get connectTimeoutMs => int.parse(dotenv.get('CONNECT_TIMEOUT_MS', fallback: '15000'));

  /// Receive timeout in milliseconds.
  static int get receiveTimeoutMs => int.parse(dotenv.get('RECEIVE_TIMEOUT_MS', fallback: '15000'));
}

/// Constants defining backend REST API endpoint paths.
class ApiEndpoints {
  const ApiEndpoints._();

  /// Endpoint to request login and acquire JWT tokens.
  static const String login = '/auth/login';

  /// Endpoint to register a new user profile.
  static const String register = '/auth/register';

  /// Endpoint to refresh a expired authentication access token.
  static const String refresh = '/auth/refresh';

  /// Endpoint to verify user email address.
  static const String verifyEmail = '/auth/verify-email';

  /// Endpoint to resend user email verification.
  static const String resendVerification = '/auth/resend-verification';

  /// Endpoint to trigger forgot password flow.
  static const String forgotPassword = '/auth/forgot-password';

  /// Endpoint to reset password using code/token.
  static const String resetPassword = '/auth/reset-password';

  /// Endpoint to get or update the current user profile.
  static const String usersMe = '/users/me';

  // Added User, Groups, Members, Expenses, Balances, and Settlements endpoints for future Phase 3 features
  // User
  static const String myBalances = '/users/me/balances';

  // Groups
  static const String groups = '/groups';
  static String groupById(String id) => '/groups/$id';
  static String archiveGroup(String id) => '/groups/$id/archive';

  // Group Members
  static String groupMembers(String groupId) =>
      '/groups/$groupId/members';
  static String groupMemberById(String groupId, String userId) =>
      '/groups/$groupId/members/$userId';

  // Expenses
  static String groupExpenses(String groupId) =>
      '/groups/$groupId/expenses';
  static String expenseById(String id) => '/expenses/$id';
  static String reverseExpense(String id) => '/expenses/$id/reverse';

  // Balances
  static String groupBalances(String groupId) =>
      '/groups/$groupId/balances';
  static String simplifiedBalances(String groupId) =>
      '/groups/$groupId/balances/simplified';

  // Settlements
  static String groupSettlements(String groupId) =>
      '/groups/$groupId/settlements';

  static String groupActivities(String groupId) =>
      '/groups/$groupId/activities';

  static const String notifications = '/notifications';

  static String markNotificationRead(String id) =>
      '/notifications/$id/read';

  static const String markAllNotificationsRead =
      '/notifications/read-all';
}
