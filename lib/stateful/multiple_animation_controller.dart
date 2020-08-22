import 'package:flutter/material.dart';

class Animator {
  Animator({this.controller, this.animation});
  AnimationController controller;
  Animation<double> animation;
}

class StatefulMultipleAnimationController extends StatefulWidget {
  const StatefulMultipleAnimationController({Key key});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<StatefulMultipleAnimationController>
    with TickerProviderStateMixin {
  List<Animator> animators = [];
  bool isDown = false;
  int numBoxes = 3;

  @override
  void initState() {
    for (int i = 0; i < numBoxes; i++) {
      final AnimationController c = AnimationController(
        duration: Duration(milliseconds: 500),
        vsync: this,
      );
      animators.add(
        Animator(
          controller: c,
          animation: Tween<double>(
            begin: 0,
            end: 300,
          )
              .chain(
                CurveTween(
                  curve: Curves.easeOutBack,
                ),
              )
              .animate(c),
        ),
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    for (int i = 0; i < numBoxes; i++) {
      animators[i].controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (!isDown) {
                for (final Animator animator in animators) {
                  animator.controller.forward();
                }
                setState(() {
                  isDown = true;
                });
              } else {
                for (final Animator animator in animators) {
                  animator.controller.reverse();
                }
                setState(() {
                  isDown = false;
                });
              }
            },
          ),
          body: Stack(
            children: List<Box>.generate(
              numBoxes,
              (int index) => Box(
                index: index,
                animation: animators[index].animation,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Box extends StatelessWidget {
  Box({
    @required this.animation,
    @required this.index,
  });

  final int index;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Positioned(
          top: (animation.value) + (index * (100 + 10)),
          left: (MediaQuery.of(context).size.width - 100) / 2,
          child: child,
        );
      },
      child: Container(
        width: 100,
        height: 100,
        color: Colors.blue,
      ),
    );
  }
}
