import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final firstCounter = ValueNotifier(0);
final secondCounter = ValueNotifier(0);

class HookAnimatedCounter extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hook animated counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HookBuilder(
              builder: (context) {
                final value = useFirstCounter();
                return Text('$value');
              },
            ),
            RaisedButton(
              onPressed: () => firstCounter.value += 100,
              child: Text('+'),
            ),
            HookBuilder(
              builder: (context) {
                final value = useSecondCounter();
                return Text('$value');
              },
            ),
            RaisedButton(
              onPressed: () => secondCounter.value += 100,
              child: Text('+'),
            ),
            const Text('total:'),
            // The total must take into account the animation of both counters
            HookBuilder(
              builder: (context) {
                final value = useFirstCounter();
                final value2 = useSecondCounter();
                return Text('${value + value2}');
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Both animations voluntarily have a different Duration/Curve
int useFirstCounter() {
  return useAnimatedInt(
    useValueListenable(firstCounter),
    duration: const Duration(seconds: 5),
    curve: Curves.easeOut,
  );
}

int useSecondCounter() {
  return useAnimatedInt(
    useValueListenable(secondCounter),
    duration: const Duration(seconds: 2),
    curve: Curves.easeInOut,
  );
}

int useAnimatedInt(
  int value, {
  @required Duration duration,
  Curve curve = Curves.linear,
}) {
  final controller = useAnimationController(duration: duration);
  return useAnimation(use(_AnimatedIntHook(value, curve, controller)));
}

class _AnimatedIntHook extends Hook<Animation<int>> {
  _AnimatedIntHook(this.value, this.curve, this.controller);

  final int value;
  final Curve curve;
  final AnimationController controller;

  @override
  _AnimatedIntState createState() {
    return _AnimatedIntState();
  }
}

class _AnimatedIntState extends HookState<Animation<int>, _AnimatedIntHook> {
  Animation<int> animation;

  @override
  void initHook() {
    animation = AlwaysStoppedAnimation(hook.value);
  }

  @override
  void didUpdateHook(_AnimatedIntHook oldHook) {
    if (oldHook.value != hook.value) {
      final tween = IntTween(begin: animation.value, end: hook.value);
      animation = hook.controller.drive(
        tween.chain(CurveTween(curve: hook.curve)),
      );
      hook.controller.forward(from: 0);
    }
  }

  @override
  Animation<int> build(BuildContext context) => animation;
}
