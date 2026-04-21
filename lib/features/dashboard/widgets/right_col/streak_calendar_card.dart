part of '../right_col.dart';

class _StreakCalendarCard extends StatelessWidget {
  final StreakCalendarModel calendar;
  const _StreakCalendarCard({required this.calendar});

  static const _dow = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

  @override
  Widget build(BuildContext context) {
    final days = calendar.days;
    final weekRows = _chunkWeeks(days);
    final monthTitle = _monthRangeLabel(days);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left_rounded, size: 16, color: _textSub),
              onPressed: () {},
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            ),
            Text(
              monthTitle,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: _textMain,
                letterSpacing: 1.0,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right_rounded, size: 16, color: _textSub),
              onPressed: () {},
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: _dow
              .map(
                (d) => Expanded(
                  child: Text(
                    d,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: _textSub,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: Column(
            children: weekRows
                .map((week) => Expanded(child: _WeekRow(week: week)))
                .toList(),
          ),
        ),
        const Divider(color: _border, height: 16, thickness: 1),
        Row(
          children: [
            _StatChip(value: '${calendar.currentStreak}', label: 'Streak'),
            _StatChip(value: '${calendar.longestStreak}', label: 'Kỷ lục'),
            _StatChip(value: '${calendar.studyDays}', label: 'Ngày học'),
          ],
        ),
      ],
    );
  }
}

class _WeekRow extends StatelessWidget {
  final List<StreakDayModel?> week;
  const _WeekRow({required this.week});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: week.asMap().entries.map((entry) {
        final di = entry.key;
        final day = entry.value;
        if (day == null) {
          return const Expanded(child: SizedBox.shrink());
        }

        final prevStreak = di > 0 && (week[di - 1]?.hasStudy ?? false);
        final nextStreak = di < 6 && (week[di + 1]?.hasStudy ?? false);

        BorderRadius? pillRadius;
        Color? pillColor;
        if (day.hasStudy) {
          pillColor = _p1.withOpacity(0.10);
          pillRadius = BorderRadius.horizontal(
            left: Radius.circular(prevStreak ? 0 : 999),
            right: Radius.circular(nextStreak ? 0 : 999),
          );
        }

        return Expanded(
          child: Container(
            decoration: pillColor != null
                ? BoxDecoration(color: pillColor, borderRadius: pillRadius)
                : null,
            alignment: Alignment.center,
            child: _DayCell(day: day),
          ),
        );
      }).toList(),
    );
  }
}

class _DayCell extends StatelessWidget {
  final StreakDayModel day;
  const _DayCell({required this.day});

  @override
  Widget build(BuildContext context) {
    final num = day.date.day;

    if (day.isToday) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [_p1, _p2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [BoxShadow(color: _p1.withOpacity(0.4), blurRadius: 8)],
            ),
            child: Center(
              child: Text(
                '$num',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          CustomPaint(
            size: const Size(8, 5),
            painter: _TrianglePainter(color: _p1),
          ),
        ],
      );
    }

    if (day.hasStudy) {
      return Text(
        '$num',
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: _p1,
        ),
      );
    }

    return Text(
      '$num',
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: _textSub.withOpacity(0.55),
      ),
    );
  }
}

List<List<StreakDayModel?>> _chunkWeeks(List<StreakDayModel> days) {
  final rows = <List<StreakDayModel?>>[];
  for (var i = 0; i < days.length; i += 7) {
    final week = days.skip(i).take(7).cast<StreakDayModel?>().toList();
    while (week.length < 7) {
      week.add(null);
    }
    rows.add(week);
  }
  if (rows.isEmpty) {
    rows.add(List<StreakDayModel?>.filled(7, null));
  }
  return rows;
}

String _monthRangeLabel(List<StreakDayModel> days) {
  if (days.isEmpty) return 'THÁNG';
  final first = days.first.date;
  final last = days.last.date;
  if (first.month == last.month) {
    return 'THG ${first.month} / ${first.year}';
  }
  return 'THG ${first.month} - ${last.month} / ${last.year}';
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  const _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_TrianglePainter old) => old.color != color;
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  const _StatChip({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _p1,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 9, color: _textSub),
          ),
        ],
      ),
    );
  }
}
