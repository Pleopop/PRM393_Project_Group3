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
        // ── Header tháng ──
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 32),

            Text(
              monthTitle,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: _textMain,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(width: 32),
          ],
        ),

        // ── DOW header ──
        Row(
          children: _dow
              .map(
                (d) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      d,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _textSub,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),

        // ── Grid tuần – Expanded để fill hết chiều cao còn lại ──
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // phân bổ đều
            children: weekRows.map((week) => _WeekRow(week: week)).toList(),
          ),
        ),

        const Divider(color: _border, height: 16, thickness: 1),

        // ── Stat chips ──
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
    return SizedBox(
      height: 36, // chiều cao cố định mỗi row — đủ cho circle 30 + dot
      child: Row(
        children: week.asMap().entries.map((entry) {
          final di = entry.key;
          final day = entry.value;

          if (day == null) return const Expanded(child: SizedBox.shrink());

          final prevStreak = di > 0 && (week[di - 1]?.hasStudy ?? false);
          final nextStreak = di < 6 && (week[di + 1]?.hasStudy ?? false);

          BorderRadius? pillRadius;
          Color? pillColor;
          if (day.hasStudy) {
            pillColor = _p1.withOpacity(0.08);
            pillRadius = BorderRadius.horizontal(
              left: Radius.circular(prevStreak ? 0 : 999),
              right: Radius.circular(nextStreak ? 0 : 999),
            );
          }

          return Expanded(
            child: ClipRect(
              // ← ngăn mọi overflow tràn ra ngoài cell
              child: Container(
                decoration: pillColor != null
                    ? BoxDecoration(color: pillColor, borderRadius: pillRadius)
                    : null,
                alignment: Alignment.center,
                child: _DayCell(day: day),
              ),
            ),
          );
        }).toList(),
      ),
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
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [_p1, _p2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(color: _p1.withOpacity(0.4), blurRadius: 8),
              ],
            ),
            child: Center(
              child: Text(
                '$num',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Dot thay cho triangle — không bao giờ overflow
          const SizedBox(height: 2),
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(color: _p1, shape: BoxShape.circle),
          ),
        ],
      );
    }

    if (day.hasStudy) {
      return Text(
        '$num',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: DashboardColors.primary,
        ),
      );
    }

    return Text(
      '$num',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 13,
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
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _p1,
            ),
          ),
          Text(label, style: const TextStyle(fontSize: 12, color: _textSub)),
        ],
      ),
    );
  }
}
