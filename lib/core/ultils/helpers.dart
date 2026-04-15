int getISOWeek(DateTime date) {
  int dayOfYear = int.parse(date.toString().substring(5, 7)) * 30 + date.day;
  return ((dayOfYear - date.weekday + 10) / 7).floor(); 
}

String getInitials(String name) {
  List<String> parts = name.split(' ').where((e) => e.isNotEmpty).toList();
  if (parts.isEmpty) return '';
  if (parts.length == 1) return parts[0][0].toUpperCase();
  return (parts[0][0] + parts[1][0]).toUpperCase();
}