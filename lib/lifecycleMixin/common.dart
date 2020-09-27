import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'framework.dart';

extension CommonHelpers on LifeMixin {
  StateRef<int> useAnimInt(StateRef<Animation<int>> animation, String key) {
    final animationValue = init(get(animation).value, key + 'value');
    watch<Animation<int>>(animation, (newAnimation) {
      print('here');
      newAnimation.addListener(() {
        set(animationValue, get(animation).value);
      });
    });
    return animationValue;
  }

  StateRef<Animation<int>> createAnimInt(
    TickerProvider ticker,
    StateRef<int> value,
    String key, {
    Duration duration,
    Curve curve,
  }) {
    final animationController = createAnimationController(
        ticker, key + '_animationController',
        duration: duration);

    final animation = init(
      AlwaysStoppedAnimation(get(value)),
      key + '_animation',
    );

    onDidUpdateWidget(animation, (animation, _) {
      final newAnimation = get(animationController).drive(
        IntTween(begin: animation.value, end: get(value)).chain(
          CurveTween(curve: curve),
        ),
      );
      get(animationController).forward(from: 0);
      return newAnimation;
    });

    watch(value, (_) {
      final newAnimation = get(animationController).drive(
        IntTween(begin: get(animation).value, end: get(value)).chain(
          CurveTween(curve: curve),
        ),
      );
      get(animationController).forward(from: 0);
      set(animation, newAnimation);
    });

    return animation;
  }

  StateRef<AnimationController> createAnimationController(
      TickerProvider ticker, String key,
      {Duration duration}) {
    final animationController =
        init(AnimationController(duration: duration, vsync: ticker), key);
    onDispose<AnimationController>(
        animationController, (controller) => controller.dispose());
    return animationController;
  }

  StateRef<T> initListenable<T>(ValueListenable<T> vl, String key) {
    final state = init(vl.value, key);
    vl.addListener(() {
      set(state, vl.value);
    });
    return state;
  }
}
