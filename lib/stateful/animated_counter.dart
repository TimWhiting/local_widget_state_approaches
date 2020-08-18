import 'package:flutter/material.dart';

final firstCounter = ValueNotifier(0);
final secondCounter = ValueNotifier(0);

class StatefulAnimatedCounter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stateful animated counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder<int>(
              valueListenable: firstCounter,
              builder: (context, value, child) {
                return TweenAnimationBuilder<int>(
                  duration: const Duration(seconds: 5),
                  curve: Curves.easeOut,
                  tween: IntTween(end: value),
                  builder: (context, value, child) {
                    return Text('$value');
                  },
                );
              },
            ),
            RaisedButton(
              onPressed: () => firstCounter.value += 100,
              child: Text('+'),
            ),
            // Both counters have voluntarily a different Curve and duration
            ValueListenableBuilder<int>(
              valueListenable: secondCounter,
              builder: (context, value, child) {
                return TweenAnimationBuilder<int>(
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeInOut,
                  tween: IntTween(end: value),
                  builder: (context, value, child) {
                    return Text('$value');
                  },
                );
              },
            ),
            RaisedButton(
              onPressed: () => secondCounter.value += 100,
              child: Text('+'),
            ),
            const Text('total:'),
            // The total must take into account the animation of both counters
            ValueListenableBuilder<int>(
              valueListenable: firstCounter,
              builder: (context, value, child) {
                return TweenAnimationBuilder<int>(
                  duration: const Duration(seconds: 5),
                  curve: Curves.easeOut,
                  tween: IntTween(end: value),
                  builder: (context, value, child) {
                    return ValueListenableBuilder<int>(
                      valueListenable: secondCounter,
                      builder: (context, value2, child) {
                        return TweenAnimationBuilder<int>(
                          duration: const Duration(seconds: 2),
                          curve: Curves.easeInOut,
                          tween: IntTween(end: value2),
                          builder: (context, value2, child) {
                            return Text('${value + value2}');
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
