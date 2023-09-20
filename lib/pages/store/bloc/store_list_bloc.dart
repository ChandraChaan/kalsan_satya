
import 'package:fine_taste/app/arch/bloc_provider.dart';
import 'package:fine_taste/common/toast/toast.dart';
import 'package:fine_taste/manager/user_data_store/user_data_store.dart';
import 'package:fine_taste/model/login/login_response.dart';
import 'package:fine_taste/model/store/store_list_response.dart';
import 'package:rxdart/rxdart.dart';

import '../../repositories/login/login_api.dart';

typedef BlocProvider<StoreListBloc> StoreListFactory(int type);
class StoreListBloc extends BlocBase{
  LoginService? loginService;
  BehaviorSubject<bool> _isLoading =BehaviorSubject.seeded(false);
  BehaviorSubject<List<Store>> _storeList =BehaviorSubject.seeded([]);
  BehaviorSubject<int> _typeScreen =BehaviorSubject.seeded(1);
  BehaviorSubject<UserInformation> _user=BehaviorSubject();

  Stream<int> get typeScreen => _typeScreen;
  Stream<List<Store>> get storeList => _storeList;
  Stream<bool> get isLoading=> _isLoading;
  List<Store> storesData=[];
  Stream<UserInformation> get user => _user;
  UserDataStore? userDataStore;


  int? screenType;
  StoreListBloc(this.loginService,this.screenType,this.userDataStore){
    _typeScreen.add(screenType!);
    _setListeners();

  }

  void _setListeners()  async{
    _isLoading.add(true);
    UserInformation? userInformation=await  userDataStore?.getUser();
    _user.add(userInformation!);
    loginService!.storeList({'API_KEY':'640590','user_id':userInformation.userId}).then((value) {
      _isLoading.add(false);
      if(value.data!=null){
        if(value.data!.status==1){
          if(value.data!.stores!=null){
            storesData=value.data!.stores!;
            _storeList.add(value.data!.stores!);
          }else {
            _storeList.add([]);
            ToastMessage(value.data!.message!);
          }
        }else {
          _storeList.add([]);
          ToastMessage(value.data!.message!);
        }

      }else {
        _storeList.add([]);
        ToastMessage('Invalid Response');
      }

    });
  }

  void searchData(String value){

    List<Store> searchResult = [];

    storesData.forEach((item) {
      if (item.storeName!.toLowerCase().contains(value.toLowerCase()))
        searchResult.add(item);
    });

    _storeList.add(searchResult);
  }

}