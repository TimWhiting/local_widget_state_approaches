import 'package:flutter/material.dart';

abstract class Disposable {
  void dispose();
}

class StateRef<T> {
  final String id;
  StateRef(this.id);
}

mixin LifeMixin<SW extends StatefulWidget> on State<SW> {
  Map<StateRef, Object> _lifeStateEntries = {};
  Map<StateRef, dynamic Function(dynamic)> _lifeStateChanges = {};
  Map<StateRef, dynamic Function(dynamic, SW)> _lifeStateUpdates = {};
  Map<StateRef, Function(Object)> _rebuilders = {};
  Map<StateRef, Set<StateRef>> _stateWatchers = {};
  Map<StateRef<Object>, List<Function(Object)>> _watchers = {};

  T get<T>(StateRef<T> ref) => _lifeStateEntries[ref] as T;
  set<T>(StateRef<T> ref, T value) {
    if (value != _lifeStateEntries[ref]) {
      _lifeStateEntries[ref] = value;
      setState(() {});
      for (final watcher in _stateWatchers[ref] ?? {}) {
        set(watcher, _rebuilders[watcher](get(watcher)));
      }
      for (final watcher in _watchers[ref] ?? []) {
        watcher(get(ref));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    print('initState from StateMixin');
  }

  watch<T>(StateRef<T> ref, Function(T) watch) {
    if (_watchers[ref] == null) {
      _watchers[ref] = [];
    }
    _watchers[ref].add(watch);
  }

  StateRef<T> init<T>(
    T something,
    String key, {
    T Function(dynamic old) change,
    T Function(dynamic old, SW oldWidget) update,
    Set<StateRef> rebuildOnChange,
    T Function(dynamic) rebuild,
  }) {
    final ref = StateRef<T>(key);
    this._lifeStateEntries[ref] = something;
    if (change != null) {
      _lifeStateChanges[ref] = change;
    }
    if (update != null) {
      _lifeStateUpdates[ref] = update;
    }
    if (rebuild != null) {
      _rebuilders[ref] = rebuild;
    }
    if (rebuildOnChange != null) {
      for (final stateRef in rebuildOnChange) {
        if (_stateWatchers[stateRef] == null) {
          _stateWatchers[stateRef] = {};
        }
        _stateWatchers[stateRef].add(ref);
      }
    }
    return ref;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final ref in _lifeStateEntries.keys) {
      if (_lifeStateChanges[ref] != null) {
        set(ref, _lifeStateChanges[ref](_lifeStateEntries[ref]));
      }
    }
  }

  @override
  void didUpdateWidget(covariant SW oldWidget) {
    super.didUpdateWidget(oldWidget);
    for (final ref in _lifeStateEntries.keys) {
      if (_lifeStateUpdates[ref] != null) {
        set(ref, _lifeStateUpdates[ref](_lifeStateEntries[ref], oldWidget));
      }
    }
  }

  @override
  dispose() {
    print('dispose from StateMixin');
    for (final entry in _lifeStateEntries.values) {
      if (entry is Disposable) {
        entry.dispose();
        print('Disposing $entry');
      }
    }
    super.dispose();
  }
}
