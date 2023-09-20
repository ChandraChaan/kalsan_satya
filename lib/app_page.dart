import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/arch/bloc_provider.dart';
import '../app/bloc/app_bloc.dart';
import '../app/life_cycle/life_cycle.dart';

class AppPage extends StatefulWidget {
  const AppPage({Key? key}) : super(key: key);

  @override
  AppPageState createState() => AppPageState();
}

class AppPageState extends State<AppPage> {
  late AppBloc _bloc;
  @override
  void initState() {
    _bloc = BlocProvider.of(context);
    _bloc.onClick();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LifeCycleManager(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        routingCallback: (r) => _bloc.onRouteGenrate.add(null),
        home: StreamBuilder<Widget>(
            stream: _bloc.startPage,
            builder: (c, s) {
              return (s.data != null)
                  ? s.data!
                  : Container(
                      color: Colors.white,
                    );
            }),
      ),
    );
  }
}
