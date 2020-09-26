import 'package:flutter/material.dart';

abstract class Disposable {
  void dispose();
}

class StateRef<T> {
  final String id;
  final Type type;
  StateRef(this.id, this.type);
}

mixin LifeMixin<SW extends StatefulWidget> on State<SW> {
  Map<StateRef, Object> _lifeStateEntries = {};
  Map<StateRef, dynamic Function(dynamic)> _lifeStateChanges = {};
  Map<StateRef, dynamic Function(dynamic, SW)> _lifeStateUpdates = {};

  T get<T>(StateRef<T> ref) => _lifeStateEntries[ref] as T;
  set<T>(StateRef<T> ref, T value) {
    if (value != _lifeStateEntries[ref]) {
      _lifeStateEntries[ref] = value;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    print('initState from StateMixin');
  }

  StateRef<T> init<T>(
    Type type,
    T something, {
    String key,
    T Function(dynamic old) change,
    T Function(dynamic old, SW oldWidget) update,
  }) {
    final ref = StateRef<T>(key, type);
    this._lifeStateEntries[ref] = something;
    if (change != null) {
      _lifeStateChanges[ref] = change;
    }
    if (update != null) {
      _lifeStateUpdates[ref] = update;
    }
    return ref;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final ref in _lifeStateEntries.keys) {
      if (_lifeStateChanges[ref] != null) {
        final newValue = _lifeStateChanges[ref](_lifeStateEntries[ref]);
        _lifeStateEntries[ref] = newValue;
      }
    }
  }

  @override
  void didUpdateWidget(covariant SW oldWidget) {
    super.didUpdateWidget(oldWidget);
    for (final ref in _lifeStateEntries.keys) {
      if (_lifeStateUpdates[ref] != null) {
        final newValue =
            _lifeStateUpdates[ref](_lifeStateEntries[ref], oldWidget);
        _lifeStateEntries[ref] = newValue;
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
