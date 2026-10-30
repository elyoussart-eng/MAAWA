// Tabular (civil) Hijri calendar. It can differ by a day from moon sighting,
// so the user can shift it with an adjustment setting.

class HDate {
  final int y, m, d;
  const HDate(this.y, this.m, this.d);
}

int jdnOf(DateTime date) =>
    DateTime.utc(date.year, date.month, date.day).difference(DateTime.utc(1970, 1, 1)).inDays + 2440588;

DateTime dateOfJdn(int jdn) => DateTime.utc(1970, 1, 1).add(Duration(days: jdn - 2440588));

HDate hijriFromJdn(int jd) {
  var l = jd - 1948440 + 10632;
  final n = (l - 1) ~/ 10631;
  l = l - 10631 * n + 354;
  final j = ((10985 - l) ~/ 5316) * ((50 * l) ~/ 17719) + (l ~/ 5670) * ((43 * l) ~/ 15238);
  l = l - ((30 - j) ~/ 15) * ((17719 * j) ~/ 50) - (j ~/ 16) * ((15238 * j) ~/ 43) + 29;
  final m = (24 * l) ~/ 709;
  final d = l - (709 * m) ~/ 24;
  final y = 30 * n + j - 30;
  return HDate(y, m, d);
}

int jdnFromHijri(int y, int m, int d) =>
    (11 * y + 3) ~/ 30 + 354 * y + 30 * m - (m - 1) ~/ 2 + d + 1948440 - 385;

HDate hijriOf(DateTime date, int adjust) => hijriFromJdn(jdnOf(date) + adjust);

int monthLength(int y, int m) {
  final ny = m == 12 ? y + 1 : y;
  final nm = m == 12 ? 1 : m + 1;
  return jdnFromHijri(ny, nm, 1) - jdnFromHijri(y, m, 1);
}

/// Islamic occasions as (month, day); indices match the 'events' list in l10n.
const List<List<int>> kEvents = [
  [1, 1], // New Year
  [1, 10], // Ashura
  [9, 1], // Ramadan
  [10, 1], // Eid al-Fitr
  [12, 9], // Arafah
  [12, 10], // Eid al-Adha
];

class UpcomingEvent {
  final int index;
  final int daysLeft;
  final DateTime date;
  UpcomingEvent(this.index, this.daysLeft, this.date);
}

List<UpcomingEvent> upcomingEvents(DateTime today, int adjust) {
  final tj = jdnOf(today) + adjust;
  final h = hijriFromJdn(tj);
  final out = <UpcomingEvent>[];
  for (var i = 0; i < kEvents.length; i++) {
    final e = kEvents[i];
    var j = jdnFromHijri(h.y, e[0], e[1]);
    if (j < tj) j = jdnFromHijri(h.y + 1, e[0], e[1]);
    out.add(UpcomingEvent(i, j - tj, dateOfJdn(j - adjust)));
  }
  out.sort((a, b) => a.daysLeft.compareTo(b.daysLeft));
  return out;
}
