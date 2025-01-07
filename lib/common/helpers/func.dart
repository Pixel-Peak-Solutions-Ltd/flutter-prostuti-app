class Func {
  static Map<String, dynamic> timeConverterMinToHour(int minute) {
    int hours = minute ~/ 60;
    int minutes = minute % 60;
    print("{hour : $hours,minute:$minutes }");
    return {
      "hour": hours == 0 ? "" : hours,
      "minute": minutes == 0 ? "" : minutes
    };
  }

  static int timeConverterSecToMin(int sec) {
    int minutes = sec % 60;
    print("minute:$minutes");
    return minutes;
  }

  static bool canAccessContent(
      String unlockDateTimeString, int durationMinutes) {
    // Parse the provided date string
    final DateTime? unlockDateTime = DateTime.tryParse(unlockDateTimeString);

    if (unlockDateTime == null) {
      throw ArgumentError(
          "Invalid date format. Ensure it's in a valid ISO 8601 format.");
    }

    // Get the current date and time
    final DateTime currentDateTime = DateTime.now();

    // Calculate the end of the unlock period (duration minutes added)
    final DateTime unlockEndDateTime =
        unlockDateTime.add(Duration(minutes: durationMinutes));

    // Calculate the end of the access period (30 minutes after unlock)
    final DateTime accessEndDateTime =
        unlockDateTime.add(const Duration(minutes: 30));

    // Check if the current time is within the unlock period and the 30-minute access window
    return currentDateTime.isAfter(unlockDateTime) &&
        currentDateTime.isBefore(accessEndDateTime) &&
        currentDateTime.isBefore(unlockEndDateTime);
  }
}
