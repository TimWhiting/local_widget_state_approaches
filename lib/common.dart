import 'package:flutter/material.dart';

// Suppose this comes from a package and cannot be known by any
// libraries we invent (and doesn't know about our libraries).
mixin ShowAnimationsMixin<T extends StatefulWidget> on State<T> {
  bool get showAnimations => _showAnimations;
  bool _showAnimations = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('here');
    _showAnimations = !MediaQuery.of(context).disableAnimations;
  }
}
