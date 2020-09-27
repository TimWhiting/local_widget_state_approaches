import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'framework.dart';

extension CommonHelpers on LifeMixin {
  StateRef<int, SW> useAnimInt<SW extends StatefulWidget>(
      StateRef<Animation<int>, SW> animation, String key) {
    final animationValue = init(get(animation).value, key + 'value');
    animation.watch((newAnimation) {
      newAnimation.addListener(() {
        set(animationValue, get(animation).value);
      });
    });
    return animationValue;
  }

  StateRef<Animation<int>, SW> createAnimInt<SW extends StatefulWidget>(
    TickerProvider ticker,
    StateRef<int, SW> value,
    String key, {
    Duration duration,
    Curve curve,
  }) {
    final animationController = createAnimationController(
        ticker, key + '_animationController',
        duration: duration);

    final animation = init<Animation<int>>(
      AlwaysStoppedAnimation(get(value)),
      key + '_animation',
    );

    animation.onDidUpdateWidget((animation, _) {
      final newAnimation = get(animationController).drive(
        IntTween(begin: animation.value, end: get(value)).chain(
          CurveTween(curve: curve),
        ),
      );
      get(animationController).forward(from: 0);
      return newAnimation;
    });

    value.watch((_) {
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

  StateRef<AnimationController, SW>
      createAnimationController<SW extends StatefulWidget>(
          TickerProvider ticker, String key,
          {Duration duration}) {
    final animationController =
        init(AnimationController(duration: duration, vsync: ticker), key);
    animationController.onDispose((controller) => controller.dispose());
    return animationController;
  }

  StateRef<T, SW> initListenable<T, SW extends StatefulWidget>(
      ValueListenable<T> vl, String key) {
    final state = init(vl.value, key);
    vl.addListener(() {
      set(state, vl.value);
    });
    return state;
  }
}
