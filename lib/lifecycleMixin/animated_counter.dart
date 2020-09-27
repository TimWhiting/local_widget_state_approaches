import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'common.dart';
import 'framework.dart';

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
        title: Text('Lifecycle mixin animated counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedLifecycleBuilder(builder: (context, lifeCycle) {
              final counter1Value = lifeCycle.useFirstCounter();
              return (context, lifecycle) =>
                  Text('${lifecycle.get(counter1Value)}');
            }),
            RaisedButton(
              onPressed: () => firstCounter.value += 100,
              child: Text('+'),
            ),
            AnimatedLifecycleBuilder(builder: (context, lifeCycle) {
              final counter2Value = lifeCycle.useSecondCounter();
              return (context, lifecycle) =>
                  Text('${lifecycle.get(counter2Value)}');
            }),
            RaisedButton(
              onPressed: () => secondCounter.value += 100,
              child: Text('+'),
            ),
            const Text('total:'),
            // The total must take into account the animation of both counters
            AnimatedLifecycleBuilder(builder: (context, lifeCycle) {
              final counter1Value = lifeCycle.useFirstCounter();
              final counter2Value = lifeCycle.useSecondCounter();
              return (context, lifecycle) => Text(
                  '${lifecycle.get(counter1Value) + lifecycle.get(counter2Value)}');
            }),
          ],
        ),
      ),
    );
  }
}

extension AnimatedLifeBuilderHelpers on AnimatedLifecycleBuilderState {
  StateRef<int> useFirstCounter() => Helpers(this).useFirstCounter(this);

  StateRef<int> useSecondCounter() => Helpers(this).useSecondCounter(this);
}

extension Helpers on LifeMixin {
  StateRef<int> useFirstCounter(TickerProvider ticker) {
    final animation = createFirstCounter(ticker);
    return useAnimInt(animation, 'firstAnimValue');
  }

  StateRef<int> useSecondCounter(TickerProvider ticker) {
    final animation = createSecondCounter(ticker);
    return useAnimInt(animation, 'secondAnimValue');
  }

  StateRef<Animation<int>> createFirstCounter(TickerProvider ticker) {
    return createAnimInt(
      ticker,
      initListenable(firstCounter, 'firstCounter'),
      'firstCounterAnimation',
      duration: const Duration(seconds: 5),
      curve: Curves.easeOut,
    );
  }

  StateRef<Animation<int>> createSecondCounter(TickerProvider ticker) {
    return createAnimInt(
      ticker,
      initListenable(secondCounter, 'secondCounter'),
      'secondCounterAnimation',
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
    );
  }
}
