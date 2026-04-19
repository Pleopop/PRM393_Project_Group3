part of '../right_col.dart';

class _TimeOfDayCard extends StatefulWidget {
  const _TimeOfDayCard();

  @override
  State<_TimeOfDayCard> createState() => _TimeOfDayCardState();
}

class _TimeOfDayCardState extends State<_TimeOfDayCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late List<Animation<double>> _sectorAnims;
  int? _hovered;

  static const _gap = 3.0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _sectorAnims = List.generate(_segmentColors.length, (i) {
      final start = (i * 0.18).clamp(0.0, 1.0);
      final end = (start + 0.55).clamp(0.0, 1.0);
      return CurvedAnimation(
        parent: _ctrl,
        curve: Interval(start, end, curve: Curves.elasticOut),
      );
    });

    Future.delayed(const Duration(milliseconds: 660), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = _segmentHours.fold(0, (a, b) => a + b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phân bổ theo Buổi',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: _textMain,
          ),
        ),
        Text(
          '4 tuần gần nhất · ${total}h',
          style: const TextStyle(fontSize: 10, color: _textSub),
        ),
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) => CustomPaint(
            size: const Size(double.infinity, 160),
            painter: _DonutPainter(
              hours: _segmentHours,
              colors: _segmentColors,
              names: _segmentNames,
              sectorAnims: _sectorAnims.map((a) => a.value).toList(),
              hovered: _hovered,
              gap: _gap,
            ),
          ),
        ),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<int> hours;
  final List<Color> colors;
  final List<String> names;
  final List<double> sectorAnims;
  final int? hovered;
  final double gap;

  const _DonutPainter({
    required this.hours,
    required this.colors,
    required this.names,
    required this.sectorAnims,
    required this.hovered,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final R = math.min(cx, cy) * 0.72;
    final r = R * 0.48;

    final total = hours.fold(0, (a, b) => a + b);
    double startAngle = -math.pi / 2;
    final gapRad = gap * math.pi / 180;

    for (int i = 0; i < hours.length; i++) {
      final fraction = hours[i] / total;
      final sweep = fraction * math.pi * 2;
      final anim = sectorAnims[i];
      final isHov = hovered == i;
      final scale = anim * (isHov ? 1.09 : 1.0);

      final paint = Paint()
        ..color = colors[i].withOpacity(hovered == null ? 1.0 : isHov ? 1.0 : 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = (R - r) * scale
        ..strokeCap = StrokeCap.butt;

      final midR = (R + r) / 2 * scale;
      final sa = startAngle + gapRad / 2;
      final sw = sweep * anim - gapRad;

      if (sw > 0) {
        canvas.drawArc(
          Rect.fromCircle(center: Offset(cx, cy), radius: midR),
          sa,
          sw,
          false,
          paint,
        );
      }

      if (anim > 0.5) {
        final pct = (hours[i] / total * 100).round();
        if (pct >= 8) {
          final midAngle = startAngle + sweep / 2;
          final lblR = (R * 0.76) * scale;
          final lx = cx + math.cos(midAngle) * lblR;
          final ly = cy + math.sin(midAngle) * lblR;

          final tp = TextPainter(
            text: TextSpan(
              text: '$pct%',
              style: TextStyle(
                color: Colors.white.withOpacity(anim),
                fontSize: pct >= 35 ? 11 : 9,
                fontWeight: FontWeight.w800,
              ),
            ),
            textDirection: TextDirection.ltr,
          )..layout();
          tp.paint(canvas, Offset(lx - tp.width / 2, ly - tp.height / 2));
        }
      }

      if (anim > 0.3) {
        final midAngle = startAngle + sweep / 2;
        final cosA = math.cos(midAngle);
        final sinA = math.sin(midAngle);
        final dotR = R * scale + 2;
        final dx = cx + cosA * dotR;
        final dy = cy + sinA * dotR;
        final mx = dx + cosA * 12;
        final my = dy + sinA * 12;
        final isRight = cosA > 0;
        final ex = isRight ? mx + 14 : mx - 14;

        canvas.drawCircle(
          Offset(dx, dy),
          2.2,
          Paint()..color = colors[i].withOpacity(anim),
        );

        final lp = Paint()
          ..color = colors[i].withOpacity(0.7 * anim)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;
        canvas.drawLine(Offset(dx, dy), Offset(mx, my), lp);
        canvas.drawLine(Offset(mx, my), Offset(ex, my), lp);

        final swX = isRight ? ex + 3 : ex - 10;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(swX, my - 3.5, 7, 7),
            const Radius.circular(2),
          ),
          Paint()..color = colors[i].withOpacity(0.9 * anim),
        );

        final nameX = isRight ? ex + 12.0 : ex - 12.0;
        final nameTp = TextPainter(
          text: TextSpan(
            text: names[i],
            style: TextStyle(
              color: _p1.withOpacity(anim),
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
          textDirection: TextDirection.ltr,
          textAlign: isRight ? TextAlign.left : TextAlign.right,
        )..layout();
        nameTp.paint(
          canvas,
          Offset(
            isRight ? nameX : nameX - nameTp.width,
            my - nameTp.height / 2,
          ),
        );
      }

      startAngle += sweep;
    }

    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()..color = _surface,
    );
    canvas.drawCircle(
      Offset(cx, cy),
      r * 0.5,
      Paint()..color = Colors.white.withOpacity(0.7),
    );
  }

  @override
  bool shouldRepaint(_DonutPainter old) =>
      old.sectorAnims != sectorAnims || old.hovered != hovered;
}
