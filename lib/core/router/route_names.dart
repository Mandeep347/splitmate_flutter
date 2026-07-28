/// Defines route names and paths constants to avoid hardcoding strings.
abstract class AppRoutes {
  // Splash Route
  static const String splashName = 'splash';
  static const String splashPath = '/';

  // Auth Routes
  static const String loginName = 'login';
  static const String loginPath = '/login';

  static const String registerName = 'register';
  static const String registerPath = '/register';

  static const String verifyEmailPendingName = 'verifyEmailPending';
  static const String verifyEmailPendingPath = '/verify-email-pending';

  static const String verifyEmailName = 'verifyEmail';
  static const String verifyEmailPath = '/verify-email';

  static const String forgotPasswordName = 'forgotPassword';
  static const String forgotPasswordPath = '/forgot-password';

  static const String resetPasswordName = 'resetPassword';
  static const String resetPasswordPath = '/reset-password';

  // Legal Routes
  static const String privacyPolicyName = 'privacyPolicy';
  static const String privacyPolicyPath = '/privacy-policy';
  static const String termsOfServiceName = 'termsOfService';
  static const String termsOfServicePath = '/terms-of-service';

  // Groups Tab Routes (Nested inside StatefulShellRoute)
  static const String dashboardName = 'dashboard';
  static const String dashboardPath = '/dashboard';

  static const String groupsName = 'groups';
  static const String groupsPath = '/groups';

  static const String groupDetailsName = 'groupDetails';
  static const String groupDetailsPath = 'details/:groupId'; // Nested sub-route

  static const String createExpenseName = 'createExpense';
  static const String createExpensePath = 'expenses/new';

  static const String expenseListName = 'expenseList';
  static const String expenseListPath = 'expenses';

  static const String expenseDetailName = 'expenseDetail';
  static const String expenseDetailPath = 'expenses/:expenseId';

  static const String groupBalancesPath = 'balances';
  static const String groupBalancesName = 'groupBalances';
  static const String settlementListPath = 'settlements';
  static const String settlementListName = 'settlementList';
  static const String createSettlementPath = 'settlements/new';
  static const String createSettlementName = 'createSettlement';

  static const String groupMembersName = 'groupMembers';
  static const String groupMembersPath = 'details/:groupId/members';

  static const String activityFeedPath = 'activity';
  static const String activityFeedName = 'activityFeed';

  static const String notificationsPath = '/notifications';
  static const String notificationsName = 'notifications';

  static const String settingsPath = '/settings';
  static const String settingsName = 'settings';

  static const String groupAnalyticsPath = 'analytics';
  static const String groupAnalyticsName = 'groupAnalytics';

  // Global Navigation Branch Routes
  static const String globalActivityName = 'globalActivity';
  static const String globalActivityPath = '/activity';

  static const String globalExpensesName = 'globalExpenses';
  static const String globalExpensesPath = '/expenses';

  static const String globalStatisticsName = 'globalStatistics';
  static const String globalStatisticsPath = '/statistics';

  // Profile Tab Routes (Nested inside StatefulShellRoute)
  static const String profileName = 'profile';
  static const String profilePath = '/profile';

  // Offline Sync Status Route
  static const String syncStatusName = 'syncStatus';
  static const String syncStatusPath = '/sync-status';

  // Download / Marketing Page (public — no auth required)
  static const String downloadName = 'download';
  static const String downloadPath = '/download';
}
