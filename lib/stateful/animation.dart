import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../common.dart';

class StatefulAnimation extends StatefulWidget {
  StatefulAnimation({
    Key key,
    this.period = const Duration(milliseconds: 900),
  }): super(key: key);

  final Duration period;

  @override
  _StatefulAnimationState createState() => _StatefulAnimationState();
}

class _StatefulAnimationState extends State<StatefulAnimation> with ShowAnimationsMixin {
  ValueNotifier<Color> _colorListenable;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _colorListenable = ValueNotifier<Color>(Colors.green[100]);
  }

  int _color = 100;

  void _ticker(Timer timer) {
    _color += 100;
    if (_color > 900)
      _color = 100;
    _colorListenable.value = Colors.green[_color];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (TickerMode.of(context) && showAnimations) {
      _timer ??= Timer.periodic(widget.period, _ticker);
    } else {
      _timer?.cancel();
      _timer = null;
    }
  }

  @override
  void didUpdateWidget(StatefulAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.period != oldWidget.period) {
      if (TickerMode.of(context) && showAnimations) {
        _timer.cancel();
        _timer = Timer.periodic(widget.period, _ticker);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _colorListenable.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Example(
      restorationId: 'animation',
      color: _colorListenable,
      active: true,
    );
  }
}

class Example extends StatefulWidget {
  Example({
    Key key,
    @required this.restorationId,
    this.color,
    this.active,
  }): assert(restorationId != null),
      assert(color != null),
      assert(active != null),
      super(key: key);

  final String restorationId;

  final ValueListenable<Color> color;

  final bool active;

  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> with TickerProviderStateMixin, RestorationMixin, ShowAnimationsMixin {
  RestorableDuration _duration = RestorableDuration(const Duration(seconds: 5));
  AnimationController _animation;
  Color _color;

  @override
  void initState() {
    super.initState();
    widget.color.addListener(_colorChange);
    _color = widget.color.value;
  }

  bool _firstTime = true;

  @override
  void restoreState(RestorationBucket oldBucket) {
    registerForRestoration(_duration, 'duration');
    if (_firstTime)
      _animation = AnimationController(vsync: this);
    _animation.duration = _duration.value;
    if (_firstTime)
      _setupAnimation();
    _firstTime = false;
  }

  @override
  String get restorationId => widget.restorationId;

  @override
  void didUpdateWidget(Example oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.color.removeListener(_colorChange);
    widget.color.addListener(_colorChange);
    if (widget.active != oldWidget.active)
      _setupAnimation();
  }

  double _height;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _height = _expensiveComputation(MediaQuery.of(context).size.height);
    _setupAnimation();
  }

  void _setupAnimation() {
    bool shouldAnimate = widget.active && showAnimations;
    if (shouldAnimate && !_animation.isAnimating) {
      _animation.repeat();
    } else if (!shouldAnimate && _animation.isAnimating) {
      _animation.stop();
    }
  }

  double _expensiveComputation(double input) {
    return math.sqrt(input);
  }

  @override
  void dispose() {
    _animation.dispose();
    widget.color.removeListener(_colorChange);
    super.dispose();
  }

  void _updateDuration(Duration newDuration) {
    _duration.value = newDuration;
    _animation.duration = _duration.value;
    if (_animation.isAnimating)
      _animation.repeat();
  }

  void _colorChange() {
    setState(() {
      _color = widget.color.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _color,
      padding: EdgeInsets.all(30.0),
      child: ExpensiveWidget( // ideally this would not even rebuild when _color changes
        child: ValueListenableBuilder(
          valueListenable: _animation,
          child: const ExpensiveWidget(child: const FlutterLogo()),
          builder: (BuildContext context, double value, Widget child) {
            return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                child,
                FlatButton(
                  color: Colors.blue,
                  child: Text('Change Duration', style: TextStyle(fontSize: 10.0 + value * _height)),
                  onPressed: () {
                    _updateDuration(Duration(seconds: _duration.value.inSeconds > 1 ? 1 : 5));
                  },
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}

class ExpensiveWidget extends StatelessWidget {
  const ExpensiveWidget({ Key key, this.child }) : super(key: key);

  final Widget child;

  static math.Random random = math.Random();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: Colors.orange,
        shape: Border.all(
            color: Colors.teal[500],
            width: 8.0 + random.nextDouble() - 0.5,
          ) + Border.all(
            color: Colors.teal[700],
            width: 8.0 + random.nextDouble() - 0.5,
          ) + Border.all(
            color: Colors.teal[900],
            width: 8.0 + random.nextDouble() - 0.5,
          ),
      ),
      child: Container(
        decoration: ShapeDecoration(
          color: Colors.teal,
          shape: Border.all(
              color: Colors.teal[500],
              width: 8.0 + random.nextDouble() - 0.5,
            ) + Border.all(
              color: Colors.teal[700],
              width: 8.0 + random.nextDouble() - 0.5,
            ) + Border.all(
              color: Colors.teal[900],
              width: 8.0 + random.nextDouble() - 0.5,
            ),
        ),
        child: Container(
          decoration: ShapeDecoration(
            color: Colors.yellow,
            shape: Border.all(
                color: Colors.teal[500],
                width: 8.0 + random.nextDouble() - 0.5,
              ) + Border.all(
                color: Colors.teal[700],
                width: 8.0 + random.nextDouble() - 0.5,
              ) + Border.all(
                color: Colors.teal[900],
                width: 8.0 + random.nextDouble() - 0.5,
              ),
          ),
          child: Container(
            decoration: ShapeDecoration(
              color: Colors.lime,
              shape: Border.all(
                  color: Colors.teal[500],
                  width: 8.0 + random.nextDouble() - 0.5,
                ) + Border.all(
                  color: Colors.teal[700],
                  width: 8.0 + random.nextDouble() - 0.5,
                ) + Border.all(
                  color: Colors.teal[900],
                  width: 8.0 + random.nextDouble() - 0.5,
                ),
            ),
            child: Container(
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: Border.all(
                    color: Colors.teal[500],
                    width: 8.0 + random.nextDouble() - 0.5,
                  ) + Border.all(
                    color: Colors.teal[700],
                    width: 8.0 + random.nextDouble() - 0.5,
                  ) + Border.all(
                    color: Colors.teal[900],
                    width: 8.0 + random.nextDouble() - 0.5,
                  ),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class RestorableDuration extends RestorableValue<Duration> {
  RestorableDuration(this._default);

  final Duration _default;

  @override
  Duration createDefaultValue() => _default;

  @override
  void didUpdateValue(Duration oldValue) {
    if (oldValue.inMicroseconds != value.inMicroseconds)
      notifyListeners();
  }

  @override
  Duration fromPrimitives(Object data) {
    return Duration(microseconds: data as int);
  }

  @override
  Object toPrimitives() {
    return value.inMicroseconds;
  }

  @override
  bool get enabled => true;
}
