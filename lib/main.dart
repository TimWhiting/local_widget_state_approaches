import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:local_widget_state_approaches/hooks/animated_counter.dart';
import 'package:local_widget_state_approaches/hooks/animation.dart';
import 'package:local_widget_state_approaches/stateful/animated_counter.dart';

import 'hooks/counter.dart' show CounterHooks;
// import 'lateProperty/counter.dart' show LatePropertyCounter; // empty
import 'stateful/counter.dart' show StatefulCounter;

import 'stateful/animation.dart' show StatefulAnimation;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

enum Approach { hooks, stateful, lateProperty }

enum Examples { counter, animation, animatedCouter }

class HomePage extends HookWidget {
  Widget pageFor({Approach approach, Examples example}) {
    switch (example) {
      case Examples.counter:
        switch (approach) {
          case Approach.hooks:
            return CounterHooks('Hook Counter');
          case Approach.stateful:
            return StatefulCounter(title: 'Stateful Counter');
          case Approach.lateProperty:
            return Text('unavailable'); // LatePropertyCounter(title: 'Late Property Counter');
        }
        break;
      case Examples.animatedCouter:
        switch (approach) {
          case Approach.hooks:
            return HookAnimatedCounter();
          case Approach.stateful:
            return StatefulAnimatedCounter();
          case Approach.lateProperty:
            return Text('unavailable'); // LatePropertyCounter(title: 'Late Property Counter');
        }
        break;
      case Examples.animation:
        switch (approach) {
          case Approach.hooks:
            return HookAnimation();
          case Approach.stateful:
            return StatefulAnimation();
          case Approach.lateProperty:
            return Text('unavailable'); // LatePropertyCounter(title: 'Late Property Counter');
        }
        break;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final approach = useState(Approach.hooks);
    final example = useState(Examples.counter);
    return Row(
      children: [
        NavigationRail(
          destinations: [
            ...Examples.values.map(
              (a) => NavigationRailDestination(
                  icon: Container(), label: Text(a.toString().split('.')[1])),
            ),
          ],
          selectedIndex: Examples.values.indexOf(example.value),
          onDestinationSelected: (i) => example.value = Examples.values[i],
          labelType: NavigationRailLabelType.all,
        ),
        NavigationRail(
          destinations: [
            ...Approach.values.map(
              (a) => NavigationRailDestination(
                  icon: Container(), label: Text(a.toString().split('.')[1])),
            ),
          ],
          selectedIndex: Approach.values.indexOf(approach.value),
          onDestinationSelected: (i) => approach.value = Approach.values[i],
          labelType: NavigationRailLabelType.all,
        ),
        Expanded(child: pageFor(approach: approach.value, example: example.value)),
      ],
    );
  }
}
