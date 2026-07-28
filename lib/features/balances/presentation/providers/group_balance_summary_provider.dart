import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Extracts net balance summary for a specific group
/// from already-fetched overall balance data.
/// Zero extra API calls.
final groupNetBalanceSummaryProvider = Provider.family<String, String>((
  ref,
  groupId,
) {
  // myOverallBalancesProvider doesn't have per-group
  // breakdown without the group balance endpoint.
  // Since we want zero extra calls, show total spent
  // from groupTotalSpentProvider which derives from
  // groupAnalyticsProvider — but that also fires API.
  //
  // Correct solution: show nothing on GroupCard until
  // user taps in. Remove balance/analytics from card.
  // Dashboard OverallBalanceCard already shows totals.
  return ''; // intentionally empty
});
