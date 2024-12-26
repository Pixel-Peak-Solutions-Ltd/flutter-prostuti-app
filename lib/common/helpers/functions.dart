class HelperFunc {
  static bool isUserSubscribed(
      String subscriptionStartDate, String subscriptionEndDate) {
    final DateTime now = DateTime.now();
    final DateTime startDate = DateTime.parse(subscriptionStartDate);
    final DateTime endDate = DateTime.parse(subscriptionEndDate);

    // Check if the current date is within the subscription period
    return now.isAfter(startDate) && now.isBefore(endDate);
  }
}
