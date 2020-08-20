import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'common.dart';

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
