import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'framework.dart';

extension CommonHelpers on LifeMixin {
  StateRef<int, SW> useAnimInt<SW extends StatefulWidget>(
      StateRef<Animation<int>, SW> animation) {
    final animationValue = init(get(animation).value);
    animation.watch((newAnimation) {
      newAnimation.addListener(() {
        set(animationValue, get(animation).value);
      });
    });
    return animationValue;
  }

  StateRef<Animation<int>, SW> createAnimInt<SW extends StatefulWidget>(
    TickerProvider ticker,
    StateRef<int, SW> value, {
    Duration duration,
    Curve curve,
  }) {
    final animationController =
        createAnimationController(ticker, duration: duration);

    final animation = init<Animation<int>>(
      AlwaysStoppedAnimation(get(value)),
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
          TickerProvider ticker,
          {Duration duration}) {
    final animationController =
        init(AnimationController(duration: duration, vsync: ticker));
    animationController.onDispose((controller) => controller.dispose());
    return animationController;
  }

  StateRef<T, SW> initListenable<T, SW extends StatefulWidget>(
      ValueListenable<T> vl) {
    final state = init(vl.value);
    vl.addListener(() {
      set(state, vl.value);
    });
    return state;
  }
}
