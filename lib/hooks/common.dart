import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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

// TODO factorize the common code between useAnimatedInt * double
double useAnimatedDouble(
  double value, {
  @required Duration duration,
  Curve curve = Curves.linear,
}) {
  final controller = useAnimationController(duration: duration);
  return useAnimation(use(_AnimatedDoubleHook(value, curve, controller)));
}

class _AnimatedDoubleHook extends Hook<Animation<double>> {
  _AnimatedDoubleHook(this.value, this.curve, this.controller);

  final double value;
  final Curve curve;
  final AnimationController controller;

  @override
  _AnimatedDoubleState createState() {
    return _AnimatedDoubleState();
  }
}

class _AnimatedDoubleState
    extends HookState<Animation<double>, _AnimatedDoubleHook> {
  Animation<double> animation;

  @override
  void initHook() {
    animation = AlwaysStoppedAnimation(hook.value);
  }

  @override
  void didUpdateHook(_AnimatedDoubleHook oldHook) {
    if (oldHook.value != hook.value) {
      final tween = Tween(begin: animation.value, end: hook.value);
      animation = hook.controller.drive(
        tween.chain(CurveTween(curve: hook.curve)),
      );
      hook.controller.forward(from: 0);
    }
  }

  @override
  Animation<double> build(BuildContext context) => animation;
}
