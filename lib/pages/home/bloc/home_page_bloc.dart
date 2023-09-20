
import 'package:fine_taste/common/toast/toast.dart';
import 'package:fine_taste/manager/user_data_store/user_data_store.dart';
import 'package:fine_taste/model/login/login_response.dart';
import 'package:fine_taste/pages/repositories/login/login_api.dart';
import 'package:rxdart/rxdart.dart';

import '../../../app/arch/bloc_provider.dart';
import '../../../model/store/last_invoice_response.dart';

typedef BlocProvider<HomePageBloc> HomePageFactory();
class HomePageBloc extends BlocBase{
  UserDataStore? userDataStore;
  LoginService? loginService;
  BehaviorSubject<bool> _isLoading =BehaviorSubject.seeded(false);
  BehaviorSubject<bool> _valid =BehaviorSubject.seeded(false);
  BehaviorSubject<UserInformation> _user=BehaviorSubject();
  BehaviorSubject<LastInvoiceResponse> _getCounts=BehaviorSubject();
  Stream<LastInvoiceResponse> get getCounts => _getCounts;
  Stream<UserInformation> get user => _user;
  Stream<bool> get  valid=> _valid;
  Stream<bool> get isLoading=> _isLoading;
  HomePageBloc(this.userDataStore,this.loginService){
    getUser();
  }

  void getUser() async{
    _isLoading.add(true);
    UserInformation? userInformation=await  userDataStore?.getUser();
    _user.add(userInformation!);
    loginService!.getCounts({'API_KEY':'640590','user_id':userInformation.userId}).then((value){
      _isLoading.add(false);
      if(value.data!=null){
        if(value.data!.status==1){
          if(value.data!=null)
          _getCounts.add(value.data!);
          else ToastMessage(value.data!.message!);
        }else ToastMessage(value.data!.message!);
      }else ToastMessage('Invalid Message');

    });

  }

}