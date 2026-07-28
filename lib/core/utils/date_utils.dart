class AppDateUtils {
  const AppDateUtils._();

  /// Parses a date string from the API and ensures it is converted to the device's local timezone.
  /// FastAPI returns UTC strings like "2024-01-01T12:00:00" without a 'Z' offset.
  /// If parsed natively by Dart, it will assume it is already in local time.
  /// This method appends 'Z' if missing to force UTC parsing, then converts to local.
  static DateTime parseApiDate(String dateStr) {
    if (dateStr.isEmpty) {
      return DateTime.now();
    }
    String parseStr = dateStr;
    if (!dateStr.endsWith('Z') && !dateStr.contains('+') && !dateStr.contains(RegExp(r'-[0-9]{2}:[0-9]{2}'))) {
      parseStr = '${dateStr}Z';
    }
    return DateTime.parse(parseStr).toLocal();
  }
}
