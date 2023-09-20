
import 'package:fine_taste/common/validators/validators.dart';
import 'package:fine_taste/pages/repositories/login/login_api.dart';

import '../app/arch/bloc_provider.dart';
import '../pages/login/bloc/forgot_bloc.dart';
import '../pages/login/bloc/login_bloc.dart';
import '../pages/login/widget/fotgot_page.dart';
import '../pages/login/widget/login_page.dart';
import 'app_injector.dart';

extension LoginExtension on AppInjector {
  LoginFactory get  loginPage => container.get();
  ForgotFactory get  forgot => container.get();

  registerLogin(){
    container.registerDependency<LoginFactory>((){
      return()=> BlocProvider<LoginPageBloc>(bloc: LoginPageBloc(FormValidator(),LoginService(),userDataStore), child:  LoginPage());
    });

    container.registerDependency<ForgotFactory>((){
      return()=> BlocProvider<ForgotBloc>(bloc: ForgotBloc(FormValidator(),LoginService(),userDataStore), child:  ForgotPage());
    });
  }

}