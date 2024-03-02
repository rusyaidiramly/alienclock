class AlienDateTime {
  final int year;
  final int month;
  final int day;
  final int hour;
  final int minute;
  final int second;

  static const AlienDateTime unixEpoch = AlienDateTime(2804, 18, 31, 2, 2, 88);
  static const int alienToEarthMilliSecondsRatio = 500;
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

  static int get daysPerYear => daysInMonth.reduce((v, e) => v + e);
  static int get secondsPerYear => daysPerYear * secondsPerDay;
  static int get secondsPerDay =>
      hoursPerDay * minutesPerHour * secondsPerMinute;

  const AlienDateTime(
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.second,
  );

  factory AlienDateTime.fromMillisecondsSinceEpoch(int milliseconds) {
    int unixMonthDays = unixEpoch.day - 1;
    for (int i = 0; i < unixEpoch.month - 1; i++) {
      unixMonthDays += daysInMonth[i];
    }

    int unixSeconds = (unixEpoch.year - 1) * secondsPerYear +
        unixMonthDays * secondsPerDay +
        unixEpoch.hour * minutesPerHour * secondsPerMinute +
        unixEpoch.minute * secondsPerMinute +
        unixEpoch.second;

    int remainingSeconds =
        milliseconds ~/ alienToEarthMilliSecondsRatio + unixSeconds;

    int alienYear = remainingSeconds ~/ secondsPerYear + 1;
    remainingSeconds %= secondsPerYear;

    int alienMonth = 1;
    while (remainingSeconds >= daysInMonth[alienMonth - 1] * secondsPerDay) {
      remainingSeconds -= daysInMonth[alienMonth - 1] * secondsPerDay;
      alienMonth++;
    }

    int alienDay = remainingSeconds ~/ secondsPerDay + 1;
    remainingSeconds %= secondsPerDay;

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

  factory AlienDateTime.fromDateTime(DateTime dateTime) {
    return AlienDateTime.fromMillisecondsSinceEpoch(
        dateTime.millisecondsSinceEpoch);
  }
}
