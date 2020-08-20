import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:local_widget_state_approaches/hooks/common.dart';

class HookMultipleAnimationController extends HookWidget {
  const HookMultipleAnimationController({Key key});

  @override
  Widget build(BuildContext context) {
    final isDown = useState(false);
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => isDown.value = !isDown.value,
          ),
          body: Stack(
            children: List<Box>.generate(
              3,
              (int index) => Box(
                index: index,
                isDown: isDown.value,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Box extends HookWidget {
  const Box({
    Key key,
    this.index,
    this.isDown,
  }) : super(key: key);

  final bool isDown;
  final int index;

  @override
  Widget build(BuildContext context) {
    final target = isDown ? 300.0 : .0;

    final position = useAnimatedDouble(
      target + (index * (100 + 10)),
      duration: const Duration(milliseconds: 500),
      curve: isDown ? Curves.easeOutBack : Curves.easeOutBack.flipped,
    );

    final child = useMemoized(() {
      return Container(
        width: 100,
        height: 100,
        color: Colors.blue,
      );
    });

    return Positioned(
      top: position,
      left: (MediaQuery.of(context).size.width - 100) / 2,
      child: child,
    );
  }
}
