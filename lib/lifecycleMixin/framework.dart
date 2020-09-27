import 'package:flutter/widgets.dart';

class StateRef<T, SW extends StatefulWidget> {
  final int id;
  Function(T) _onDispose;
  T Function(T, SW) _onUpdate;
  T Function(T) _onChange;
  List<void Function(T)> _watchers = [];
  StateRef(this.id);
}

extension StateRefX<T, SW extends StatefulWidget> on StateRef<T, SW> {
  void watch(void Function(T) watch) {
    _watchers.add(watch);
  }

  void onDidUpdateWidget(T Function(T oldValue, SW oldWidget) update) {
    _onUpdate = update;
  }

  void onDidChangeDependencies(T Function(T old) change) {
    _onChange = change;
  }

  void onDispose(Function(T) dispose) {
    _onDispose = dispose;
  }
}

mixin LifeMixin<SW extends StatefulWidget> on State<SW> {
  Map<StateRef<Object, SW>, Object> _lifeStateEntries = {};
  static int _lastAssignedID = -1;

  T get<T, SW2 extends StatefulWidget>(StateRef<T, SW2> ref) =>
      _lifeStateEntries[ref] as T;
  set<T>(StateRef<T, SW> ref, T value) {
    if (value != _lifeStateEntries[ref]) {
      _lifeStateEntries[ref] = value;
      setState(() {});
      for (final watcher in ref._watchers) {
        watcher?.call(value);
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  StateRef<T, SW> init<T>(T something) {
    final ref = StateRef<T, SW>(_lastAssignedID++);
    this._lifeStateEntries[ref] = something;
    return ref;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final ref in _lifeStateEntries.keys) {
      if (ref?._onChange != null) {
        set(ref, ref._onChange(_lifeStateEntries[ref]));
      }
    }
  }

  @override
  void didUpdateWidget(covariant SW oldWidget) {
    super.didUpdateWidget(oldWidget);
    for (final ref in _lifeStateEntries.keys) {
      if (ref?._onUpdate != null) {
        set(ref, ref._onUpdate(_lifeStateEntries[ref], oldWidget));
      }
    }
  }

  @override
  void dispose() {
    for (final entry in _lifeStateEntries.entries) {
      if (entry.key?._onDispose != null) {
        final disposer = entry.key._onDispose;
        disposer(entry.value);
      }
    }
    _lifeStateEntries = {};
    super.dispose();
  }
}
typedef BuildFunction = Widget Function(BuildContext, LifeMixin);
typedef LifeCycleFunction = BuildFunction Function(BuildContext, LifeMixin);

class LifecycleBuilder extends StatefulWidget {
  final LifeCycleFunction builder;

  const LifecycleBuilder({Key key, this.builder}) : super(key: key);
  @override
  _LifecycleBuilderState createState() => _LifecycleBuilderState();
}

class _LifecycleBuilderState extends State<LifecycleBuilder> with LifeMixin {
  BuildFunction newBuild;
  @override
  void initState() {
    super.initState();
    newBuild = widget.builder(context, this);
  }

  @override
  Widget build(BuildContext context) {
    return newBuild?.call(context, this);
  }
}

typedef AnimatedBuildFunction = Widget Function(
    BuildContext, AnimatedLifecycleBuilderState);
typedef AnimatedLifeCycleFunction = AnimatedBuildFunction Function(
    BuildContext, AnimatedLifecycleBuilderState);

class AnimatedLifecycleBuilder extends StatefulWidget {
  final AnimatedLifeCycleFunction builder;

  const AnimatedLifecycleBuilder({Key key, this.builder}) : super(key: key);
  @override
  AnimatedLifecycleBuilderState createState() =>
      AnimatedLifecycleBuilderState();
}

class AnimatedLifecycleBuilderState extends State<AnimatedLifecycleBuilder>
    with TickerProviderStateMixin, LifeMixin {
  AnimatedBuildFunction animatedBuild;
  @override
  void initState() {
    super.initState();
    animatedBuild = widget.builder(context, this);
  }

  @override
  Widget build(BuildContext context) {
    return animatedBuild?.call(context, this);
  }
}
