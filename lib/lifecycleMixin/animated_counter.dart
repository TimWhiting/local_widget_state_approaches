import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_widget_state_approaches/lifecycleMixin/common.dart';

import 'common.dart';

final firstCounter = ValueNotifier(0);
final secondCounter = ValueNotifier(0);

class LifeAnimatedCounter extends StatefulWidget {
  @override
  _LifeAnimatedCounterState createState() => _LifeAnimatedCounterState();
}

class _LifeAnimatedCounterState extends State<LifeAnimatedCounter>
    with TickerProviderStateMixin, LifeMixin {
  StateRef<int> counter1;
  StateRef<int> counter2;

  @override
  void initState() {
    super.initState();
    counter1 = useFirstCounter(this);
    counter2 = useSecondCounter(this);
  }

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
            Text('${get(counter1)}'),
            RaisedButton(
              onPressed: () => firstCounter.value += 100,
              child: Text('+'),
            ),
            Text('${get(counter2)}'),
            RaisedButton(
              onPressed: () => secondCounter.value += 100,
              child: Text('+'),
            ),
            const Text('total:'),
            // The total must take into account the animation of both counters
            Text('${get(counter1) + get(counter2)}'),
          ],
        ),
      ),
    );
  }
}

extension Helpers on LifeMixin {
  StateRef<int> useFirstCounter(TickerProvider ticker) {
    return useAnimInt(
      ticker,
      initListenable(firstCounter, 'firstCounter'),
      'firstCounterAnimation',
      duration: const Duration(seconds: 5),
      curve: Curves.easeOut,
    );
  }

  StateRef<int> useSecondCounter(TickerProvider ticker) {
    return useAnimInt(
      ticker,
      initListenable(secondCounter, 'secondCounter'),
      'secondCounterAnimation',
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
    );
  }

  StateRef<int> useAnimInt(TickerProvider ticker, StateRef<int> vl, String key,
      {Duration duration, Curve curve}) {
    final animation =
        createAnimInt(ticker, vl, duration, curve, key + 'animation');
    final animationValue = init(get(animation).value, key + 'value');
    get(animation).addListener(() {
      set(animationValue, get(animation).value);
      print('here');
    });
    return animationValue;
  }

  StateRef<Animation<int>> createAnimInt(TickerProvider ticker,
      StateRef<int> value, Duration duration, Curve curve, String key) {
    final animationController = createAnimationController(
        ticker, key + '_animationController',
        duration: duration);

    final animation = init(
      AlwaysStoppedAnimation(get(value)),
      key + '_animation',
      update: (animation, _) {
        final newAnimation = get(animationController).drive(
          IntTween(begin: animation.value, end: get(value)).chain(
            CurveTween(curve: curve),
          ),
        );
        get(animationController).forward(from: 0);
        return newAnimation;
      },
      rebuildOnChange: {value},
      rebuild: (a) {
        final oldValue = a as StateRef<int>;
        final newAnimation = get(animationController).drive(
          IntTween(begin: get(oldValue), end: get(value)).chain(
            CurveTween(curve: curve),
          ),
        );
        get(animationController).forward(from: 0);
        return newAnimation;
      },
    );
    return animation;
  }

  StateRef<AnimationController> createAnimationController(
      TickerProvider ticker, String key,
      {Duration duration}) {
    return init(AnimationController(duration: duration, vsync: ticker), key);
  }

  StateRef<T> initListenable<T>(ValueListenable<T> vl, String key) {
    final state = init(vl.value, key);
    vl.addListener(() {
      set(state, vl.value);
      print('here');
    });
    return state;
  }
}
