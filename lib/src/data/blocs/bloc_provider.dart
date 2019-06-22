import 'package:flutter/material.dart';

Type _typeOf<T>() => T;

abstract class BlocBase{
  void dispose();
}


class BlocProvider<T extends BlocBase> extends StatefulWidget {

  final Widget child;
  final T bloc;

  BlocProvider({
    Key key,
    @required this.child,
    @required this.bloc
  });

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context){
    final type = _typeOf<_BlocProviderInherited>();
    _BlocProviderInherited<T> provider = context.ancestorInheritedElementForWidgetOfExactType(type)?.widget;
    return provider?.bloc;
  }
}

class _BlocProviderState<T extends BlocBase> extends State<BlocProvider<T>> {

  @override
  Widget build(BuildContext context) {

    return Container();
  }
}


class _BlocProviderInherited<T> extends InheritedWidget {

  final T bloc;

  const _BlocProviderInherited({
    Key key,
    @required Widget child,
    @required this.bloc
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_BlocProviderInherited old) {
    return false;
  }
}
