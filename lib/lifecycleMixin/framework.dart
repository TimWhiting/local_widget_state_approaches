import 'package:flutter/widgets.dart';

class StateRef<T> {
  final String id;
  StateRef(this.id);
}

class Disposer<T> {
  final Function(T) onDispose;
  Disposer(this.onDispose);
}

class WidgetUpdate<T, SW extends StatefulWidget> {
  final T Function(T, SW) onUpdate;
  WidgetUpdate(this.onUpdate);
}

class DependenciesUpdate<T> {
  final T Function(T) onChange;
  DependenciesUpdate(this.onChange);
}

class Watcher<T> {
  final Function(T) onWatchUpdate;
  Watcher(this.onWatchUpdate);
}

mixin LifeMixin<SW extends StatefulWidget> on State<SW> {
  Map<StateRef, Object> _lifeStateEntries = {};
  Map<StateRef, DependenciesUpdate> _lifeStateChanges = {};
  Map<StateRef, WidgetUpdate> _lifeStateUpdates = {};
  Map<StateRef, List<Watcher>> _watchers = {};
  Map<StateRef, Disposer> _disposers = {};

  T get<T>(StateRef<T> ref) => _lifeStateEntries[ref] as T;
  set<T>(StateRef<T> ref, T value) {
    if (value != _lifeStateEntries[ref]) {
      _lifeStateEntries[ref] = value;
      setState(() {});
      for (final watcher in _watchers[ref] ?? []) {
        watcher.onWatchUpdate(get(ref));
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void watch<T>(StateRef<T> ref, Function(T) watch) {
    if (_watchers[ref] == null) {
      _watchers[ref] = [];
    }
    _watchers[ref].add(Watcher<T>(watch));
  }

  void onDidUpdateWidget<T>(
      StateRef<T> ref, T Function(T oldValue, SW oldWidget) update) {
    if (update != null) {
      _lifeStateUpdates[ref] = WidgetUpdate<T, SW>(update);
    }
  }

  void onDidChangeDependencies<T>(StateRef<T> ref, T Function(T old) change) {
    if (change != null) {
      _lifeStateChanges[ref] = DependenciesUpdate<T>(change);
    }
  }

  void onDispose<T>(StateRef<T> ref, Function(T) dispose) {
    if (dispose != null) {
      _disposers[ref] = Disposer<T>(dispose);
    }
  }

  StateRef<T> init<T>(T something, String key) {
    final ref = StateRef<T>(key);
    this._lifeStateEntries[ref] = something;
    return ref;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final ref in _lifeStateEntries.keys) {
      if (_lifeStateChanges[ref] != null) {
        set(ref, _lifeStateChanges[ref].onChange(_lifeStateEntries[ref]));
      }
    }
  }

  @override
  void didUpdateWidget(covariant SW oldWidget) {
    super.didUpdateWidget(oldWidget);
    for (final ref in _lifeStateEntries.keys) {
      if (_lifeStateUpdates[ref] != null) {
        set(ref,
            _lifeStateUpdates[ref].onUpdate(_lifeStateEntries[ref], oldWidget));
      }
    }
  }

  @override
  void dispose() {
    for (final entry in _disposers.entries) {
      entry.value.onDispose(get(entry.key));
    }
    _lifeStateEntries = {};
    _lifeStateChanges = {};
    _lifeStateUpdates = {};
    _watchers = {};
    _disposers = {};
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
