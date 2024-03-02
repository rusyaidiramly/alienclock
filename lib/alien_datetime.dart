class AlienDateTime {
  final int year;
  final int month;
  final int day;
  final int hour;
  final int minute;
  final int second;

  static const int alienToEarthSecondsRatio = 2;
  static const int secondsPerMinute = 90;
  static const int minutesPerHour = 90;
  static const int hoursPerDay = 36;
  static const List<int> daysInMonth = [
    44,
    42,
    48,
    40,
    48,
    44,
    40,
    44,
    42,
    40,
    40,
    42,
    44,
    48,
    42,
    40,
    44,
    38
  ];

  AlienDateTime(
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.second,
  );

  factory AlienDateTime.fromSecondsSinceEpoch(int seconds) {
    var remainingSeconds = seconds * alienToEarthSecondsRatio;

    int alienYear = 1;
    while (remainingSeconds >=
        daysInMonth[(alienYear - 1) % daysInMonth.length] *
            hoursPerDay *
            minutesPerHour *
            secondsPerMinute) {
      remainingSeconds -= daysInMonth[(alienYear - 1) % daysInMonth.length] *
          hoursPerDay *
          minutesPerHour *
          secondsPerMinute;
      alienYear++;
    }

    int alienMonth = 1;
    while (remainingSeconds >=
        daysInMonth[alienMonth - 1] *
            hoursPerDay *
            minutesPerHour *
            secondsPerMinute) {
      remainingSeconds -= daysInMonth[alienMonth - 1] *
          hoursPerDay *
          minutesPerHour *
          secondsPerMinute;
      alienMonth++;
    }

    int alienDay =
        remainingSeconds ~/ (hoursPerDay * minutesPerHour * secondsPerMinute) +
            1;
    remainingSeconds %= hoursPerDay * minutesPerHour * secondsPerMinute;

    int alienHour = remainingSeconds ~/ (minutesPerHour * secondsPerMinute);
    remainingSeconds %= minutesPerHour * secondsPerMinute;

    int alienMinute = remainingSeconds ~/ secondsPerMinute;
    remainingSeconds %= secondsPerMinute;

    int alienSecond = remainingSeconds;

    return AlienDateTime(
      alienYear,
      alienMonth,
      alienDay,
      alienHour,
      alienMinute,
      alienSecond,
    );
  }
}
