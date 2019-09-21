import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

List<Particle> particles;

class Explode extends StatefulWidget {
  final int particleCount;
  final Size size;
  final List<Color> colors;
  final Function onFinish;
  final Widget widget;
  static GlobalKey<_ExplodeState> getKey() {
    return GlobalKey<_ExplodeState>();
  }

  final Duration duration;

  const Explode(
      {Key key,
      this.colors,
        this.onFinish,
      @required this.size,
      this.widget,
      this.duration = const Duration(seconds: 1, milliseconds: 300),
      this.particleCount = 100})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExplodeState();
}

class _ExplodeState extends State<Explode> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  Animation<double> animationTwo;
  var image;
  Math.Random random = new Math.Random();
  List<Color> colors = [];

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(() {
        setState(() {});
      });
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.linear));
    check();
  }

  void explode()async {
    print("explode called");
      controller.reset();
      controller.forward();
      await Future.delayed(widget.duration);
      widget.onFinish();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  void check() async {
    colors = widget.colors;
    particles = new List<Particle>.generate(widget.particleCount, (i) {
      return Particle(
          left: random.nextInt(widget.size.width.toInt() - 10).toDouble(),
          top: random.nextInt(widget.size.height.toInt() - 10).toDouble(),
          color: colors[i % colors.length],
          sizeFactor: random.nextInt(1000).toDouble() / 1000,
          spread: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return InkWell(
        child:
//        controller.value < 0.4
//            ? Transform(
//                transform: Matrix4.translation(getTranslation()),
//                child: widget)
//            :
        CustomPaint(
                foregroundPainter: ParticlesPainter(animation.value),
                size: widget.size,
                child: Container(
                  width: widget.size.width,
                  height: widget.size.height,
                ),
              ));
  }
}

class ParticlesPainter extends CustomPainter {
  final double span;
  ParticlesPainter(this.span);

  @override
  void paint(Canvas canvas, Size size) {
    particles.forEach((particle) {
      particle.advance(span, span > 0.4, size.height);
      Paint paint = Paint()
        ..color = particle.color.withOpacity(
            Math.min(Math.max((0.4 * (1 - span) + 1 - span), 0), 1))
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(particle.left, particle.top),
          particle.sizeFactor * 10 * span, paint);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

class Particle {
  double left;
  double top;
  double initialLeft;
  double initialTop;
  double sizeFactor;
  Color color;
  ExplodeType type;
  final bool spread;
  int direction;
  double topMax;
  double leftMax;
  double bottomMax;
  double x;

  Particle({this.left, this.top, this.color, this.sizeFactor, this.spread}) {
    direction = new Math.Random().nextBool() ? 1 : -1;
    initialLeft = left;
    initialTop = top;
    x = new Math.Random().nextInt(1000) / 1000.0;
    leftMax = direction == 1 ? (left + 100 * x) : left - 100 * x;
    topMax = top - 100;
    bottomMax = initialTop + 100;
  }

  advance(double span, bool stage, double height) {
    if (spread) {
      left = initialLeft * (1 - span) + leftMax * span;
      top = initialTop +
          20 * span +
          60 * Math.sin(Math.pi / 2 + 2 * span * Math.pi);
    } else {
      top = initialTop * (1 - span) + height * span;
    }
  }
}

enum ExplodeType { Spread, Drop }
