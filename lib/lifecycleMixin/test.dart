abstract class Baz {
  initState() {
    print('initState from baz');
  }

  dispose() {
    print('dispose from baz');
  }

  build() {}

  setState() {
    print('Set state called');
    Future.microtask(() => build());
  }
}

abstract class Disposable {
  void dispose();
}

class StateRef<T> {
  final String id;
  final Type type;
  StateRef(this.id, this.type);
}

mixin LifeMixin on Baz {
  Map<StateRef, Object> entries = {};
  Map<StateRef, dynamic Function(dynamic)> changes = {};

  T get<T>(StateRef<T> ref) => entries[ref] as T;
  set<T>(StateRef<T> ref, T value) {
    if (value != entries[ref]) {
      entries[ref] = value;
      setState();
    }
  }

  @override
  initState() {
    super.initState();
    print('initState from StateMixin');
  }

  StateRef<T> init<T>(Type type, T something,
      {String key, T Function(dynamic) change}) {
    final ref = StateRef<T>(key, type);
    this.entries[ref] = something;
    if (change != null) {
      changes[ref] = change;
    }
    return ref;
  }

  didChangeDependencies() {
    for (final ref in entries.keys) {
      if (changes[ref] != null) {
        final newValue = changes[ref](entries[ref]);
        entries[ref] = newValue;
      }
    }
  }

  dispose() {
    print('dispose from StateMixin');
    for (final entry in entries.values) {
      if (entry is Disposable) {
        entry.dispose();
        print('Disposing $entry');
      }
    }
    super.dispose();
  }
}

class D implements Disposable {
  final String s;
  D(this.s);

  @override
  dispose() {
    print('Disposing d: $s');
  }
}

class C extends Baz with LifeMixin {
  StateRef<String> str;
  StateRef<String> str2;
  StateRef<int> i;
  StateRef<D> d;

  @override
  initState() {
    super.initState();
    str = init(String, 'Initialized String', change: (old) {
      if (old.contains('Newly')) return 'Back';
      return 'Newly ' + old;
    });
    str2 = init(String, 'Other String', key: '0', change: (old) {
      if (get(str).contains('Newly')) return 'Wow';
      Future.delayed(Duration(seconds: 1), () => set(d, D('haha')));
      return 'Uh Oh';
    });
    i = init(int, 0);
    d = init(D, D('Hi'));
    print('initState from C');
  }

  build() {
    print('build');
    print(get(str));
    print(get(str2));
    print(get(i));
    print(get(d).s);
  }
}

void main() async {
  final c = C();
  c.initState();
  c.build();
  c.didChangeDependencies();
  c.build();
  c.didChangeDependencies();
  c.build();
  await Future.delayed(Duration(seconds: 2));
  c.dispose();
}
