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
    // print('Main Build');
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
              return (context, lifecycle) {
                // print('Counter 1 Build');
                return Text('${lifecycle.get(counter1Value)}');
              };
            }),
            RaisedButton(
              onPressed: () => firstCounter.value += 100,
              child: Text('+'),
            ),
            AnimatedLifecycleBuilder(builder: (context, lifeCycle) {
              final counter2Value = lifeCycle.useSecondCounter();
              return (context, lifecycle) {
                // print('Counter 2 Build');
                return Text('${lifecycle.get(counter2Value)}');
              };
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
              return (context, lifecycle) {
                // print('Counter 1+2 Build');
                return Text(
                    '${lifecycle.get(counter1Value) + lifecycle.get(counter2Value)}');
              };
            }),
          ],
        ),
      ),
    );
  }
}

extension AnimatedLifeBuilderHelpers on AnimatedLifecycleBuilderState {
  StateRef<int, SW> useFirstCounter<SW extends StatefulWidget>() =>
      Helpers(this).useFirstCounter(this);

  StateRef<int, SW> useSecondCounter<SW extends StatefulWidget>() =>
      Helpers(this).useSecondCounter(this);
}

extension Helpers on LifeMixin {
  StateRef<int, SW> useFirstCounter<SW extends StatefulWidget>(
      TickerProvider ticker) {
    final animation = createFirstCounter(ticker);
    return useAnimInt(animation);
  }

  StateRef<int, SW> useSecondCounter<SW extends StatefulWidget>(
      TickerProvider ticker) {
    final animation = createSecondCounter(ticker);
    return useAnimInt(animation);
  }

  StateRef<Animation<int>, SW> createFirstCounter<SW extends StatefulWidget>(
      TickerProvider ticker) {
    return createAnimInt(
      ticker,
      initListenable(firstCounter),
      duration: const Duration(seconds: 5),
      curve: Curves.easeOut,
    );
  }

  StateRef<Animation<int>, SW> createSecondCounter<SW extends StatefulWidget>(
      TickerProvider ticker) {
    return createAnimInt(
      ticker,
      initListenable(secondCounter),
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
    );
  }
}
