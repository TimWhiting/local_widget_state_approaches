import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

Color _useBackgroundColor(Duration duration) {
  final colorState = useState(Colors.green[100]);

  useEffect(() {
    int color = 100;
    final timer = Timer.periodic(duration, (Timer timer) {
      color += 100;
      if (color > 900) color = 100;
      colorState.value = Colors.green[color];
    });

    return timer.cancel;
  }, [duration]);

  return colorState.value;
}

class HookAnimation extends HookWidget {
  @override
  Widget build(BuildContext context) {
    // Supports hot-reload. Changing the duration will be applied live
    final color = _useBackgroundColor(const Duration(milliseconds: 900));

    return Example(
      color: color,
      active: true,
    );
  }
}

class Example extends HookWidget {
  const Example({
    Key key,
    this.color,
    this.active,
  })  : assert(color != null),
        assert(active != null),
        super(key: key);

  final Color color;
  final bool active;

  @override
  Widget build(BuildContext context) {
    // TODO: change to `useRestorableDuration(Duration(...), 'duration');
    final duration = useState(const Duration(seconds: 5));
    // The hook internally handles the duration change by default
    final controller = useAnimationController(duration: duration.value);

    // Both handles `active` being toggle and forcing the `controller` to
    // refresh the animation when `duration` changes
    useEffect(() {
      if (active) {
        controller.repeat();
      } else if (controller.isAnimating) {
        controller.stop();
      }
      return;
    }, [active, duration.value]);

    return Container(
      color: color,
      padding: const EdgeInsets.all(30.0),
      // Caches the ExpensiveWidget such that it is built only once, even if
      // color/active/duration changes.
      child: useMemoized(() {
        return ExpensiveWidget(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              const ExpensiveWidget(child: const FlutterLogo()),
              FlatButton(
                color: Colors.blue,
                child: _AnimatedText(animation: controller),
                onPressed: () {
                  duration.value =
                      Duration(seconds: duration.value.inSeconds > 1 ? 1 : 5);
                },
              ),
            ],
          ),
        );
      }, const []),
    );
  }
}

/// Could be a [HookBuilder] too
class _AnimatedText extends HookWidget {
  const _AnimatedText({Key key, this.animation}) : super(key: key);

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final value = useAnimation(animation);

    final screenHeight = MediaQuery.of(context).size.height;
    final textHeight =
        useMemoized(() => math.sqrt(screenHeight), [screenHeight]);

    return Text(
      'Change Duration',
      style: TextStyle(fontSize: 10.0 + value * textHeight),
    );
  }
}

/* ************ COPIED FROM /lib/stateful/animation.dart ************** */

class ExpensiveWidget extends StatelessWidget {
  const ExpensiveWidget({Key key, this.child}) : super(key: key);

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
            ) +
            Border.all(
              color: Colors.teal[700],
              width: 8.0 + random.nextDouble() - 0.5,
            ) +
            Border.all(
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
              ) +
              Border.all(
                color: Colors.teal[700],
                width: 8.0 + random.nextDouble() - 0.5,
              ) +
              Border.all(
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
                ) +
                Border.all(
                  color: Colors.teal[700],
                  width: 8.0 + random.nextDouble() - 0.5,
                ) +
                Border.all(
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
                  ) +
                  Border.all(
                    color: Colors.teal[700],
                    width: 8.0 + random.nextDouble() - 0.5,
                  ) +
                  Border.all(
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
                    ) +
                    Border.all(
                      color: Colors.teal[700],
                      width: 8.0 + random.nextDouble() - 0.5,
                    ) +
                    Border.all(
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
    if (oldValue.inMicroseconds != value.inMicroseconds) notifyListeners();
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
