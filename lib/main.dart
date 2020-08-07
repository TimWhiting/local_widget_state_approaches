import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:local_widget_state_approaches/hooks/counter.dart';
import 'package:local_widget_state_approaches/stateful/counter.dart';

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

class HomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final approach = useState(Approach.Hooks);
    final example = useState(Examples.Counter);
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
        Expanded(child: example.value.pageFor(approach.value)),
      ],
    );
  }
}

enum Approach { Hooks, Stateful, LateProperty }

enum Examples { Counter, SomethingElse }

extension on Examples {
  Widget pageFor(Approach approach) {
    switch (this) {
      case Examples.Counter:
        switch (approach) {
          case Approach.Hooks:
            return CounterHooks('Hook Counter');
          case Approach.Stateful:
            return StatefulCounter(title: 'Stateful Counter');
          default:
            return StatefulCounter(title: 'Stateful Counter');
        }
    }
    return CounterHooks('Hook Counter Default');
  }
}
