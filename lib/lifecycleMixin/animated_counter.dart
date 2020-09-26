import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:local_widget_state_approaches/lifecycleMixin/common.dart';

import '../hooks/common.dart';

final firstCounter = ValueNotifier(0);
final secondCounter = ValueNotifier(0);

class LifeAnimatedCounter extends StatefulWidget {
  @override
  _LifeAnimatedCounterState createState() => _LifeAnimatedCounterState();
}

class _LifeAnimatedCounterState extends State<LifeAnimatedCounter>
    with LifeMixin {
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

extension Helpers on LifeMixin {
  StateRef<int> useFirstCounter() {}
  StateRef<int> useAnimInt(
      StateRef<int> driver, Duration duration, Curve curve, String key) {
    final state = useAnimController();
  }

  StateRef<AnimationController> controller(String key) {
    final state = init(AnimationController, AnimationController(), key: key);
  }

  StateRef<T> useListenable<T, L extends Listenable>(L<T> vl, String key) {
    final state = init(T, vl.value, key: key);
    vl.addListener(() {
      set(state, vl.value);
    });
    return state;
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
