import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:local_widget_state_approaches/lifecycleMixin/framework.dart';


class LifeCounter extends StatefulWidget {
  LifeCounter(this.title);
  final String title;
  @override
  _LifeCounterState createState() => _LifeCounterState();
}

class _LifeCounterState extends State<LifeCounter> with LifeMixin {
  StateRef<int, LifeCounter> counter;
  @override
  void initState() {
    super.initState();
    counter = init(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Read the current value from the counter
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '${get(counter)}',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // When the button is pressed, update the value of the counter! This
        // will trigger a rebuild, displaying the latest value in the Text
        // Widget above!
        onPressed: () => set(counter, get(counter) + 1),
        child: const Icon(Icons.add),
      ),
    );
  }
}
