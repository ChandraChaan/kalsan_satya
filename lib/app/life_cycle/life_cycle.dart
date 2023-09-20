import 'package:flutter/material.dart';

class LifeCycleManager extends StatefulWidget {
  final Widget child;
  LifeCycleManager({Key? key, required this.child}) : super(key: key);
  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');

    // if (state == AppLifecycleState.resumed){
    //   FlutterBackgroundService().invoke("setAsForeground");
    //    return;
    // }
    // if(state == AppLifecycleState.inactive || state == AppLifecycleState.paused){
    //   FlutterBackgroundService().invoke("setAsBackground");
    //   return;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}