
import 'package:injector/injector.dart';
import '../app/arch/bloc_provider.dart';
import '../app/bloc/app_bloc.dart';
import '../app_page.dart';
import '../manager/data_base/db_manager.dart';
import '../manager/user_data_store/user_data_store.dart';
import '../di/i_login_page.dart';
import '../di/i_home_page.dart';


class AppInjector{
  static final AppInjector instance=AppInjector._internal();
  final container=Injector.appInstance;

  //App
  BlocProvider<AppBloc> get app => container.get();
  UserDataStore get userDataStore => container.get();

   AppInjector._internal() {
    container.registerDependency<BlocProvider<AppBloc>>(() {
      return BlocProvider(child: AppPage(), bloc: AppBloc("",userDataStore));
    });
    registerLogin();
    registerHomePage();
    container.registerSingleton(() => UserDataStore(DBManager()));

  }
}