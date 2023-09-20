
import 'package:fine_taste/app/arch/bloc_provider.dart';
import 'package:fine_taste/manager/user_data_store/user_data_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';
import '../../../common/toast/toast.dart';
import '../../../helper/logger/logger.dart';
import '../../../model/base_response/request_response.dart';
import '../../../model/login/login_response.dart';
import '../../../model/order/order_response.dart';
import '../../../utils/Constants.dart';
import '../../repositories/login/login_api.dart';

typedef BlocProvider<OrderListBloc> OrderListFactory(int type);
class OrderListBloc extends BlocBase{
  int type;
  BehaviorSubject<int> _screenType=BehaviorSubject();
  LoginService? loginService;
  UserDataStore? userDataStore;
  BehaviorSubject<String> _fromDate =BehaviorSubject.seeded(DateFormat('yyyy-MM-dd').format(DateTime.now()));
  BehaviorSubject<String> _toDate =BehaviorSubject.seeded(DateFormat('yyyy-MM-dd').format(DateTime.now()));
  BehaviorSubject<bool> _isLoading =BehaviorSubject.seeded(false);
  BehaviorSubject<List<Order>> _orderList =BehaviorSubject.seeded([]);
  BehaviorSubject<bool> _valid =BehaviorSubject.seeded(false);
  PublishSubject<void> _verify = PublishSubject();
  PublishSubject<Map<String,dynamic>> _submit = PublishSubject();
  Sink<void>  get verify=> _verify;
  Sink<Map<String,dynamic>> get submit=> _submit;
  Stream<bool> get valid=> _valid;
  Stream<List<Order>> get orderList => _orderList;
  Stream<bool> get isLoading=> _isLoading;
  Stream<int> get screenType => _screenType;
  Stream<String> get fromDate=> _fromDate;
  Stream<String> get toDate=> _toDate;
  Sink<String> get addFromDate=> _fromDate;
  Sink<String> get addToDate=> _toDate;

  List<Order> ordersData=[];
  DateTime? fromDateTime= DateTime.now();
  DateTime? toDateTime= DateTime.now();
  OrderListBloc(this.type,this.loginService,this.userDataStore){
    _setListeners();
    _screenType.add(type);
  }
  void _setListeners() async{
    UserInformation? userInformation=await  userDataStore?.getUser();
    String userId=userInformation!.userId!;
    if(type==Constants.TODAY_ORDERS){
      _isLoading.add(true);
      loginService!.orderList({'API_KEY':'640590',"delivery_boy_id":userId,
        "from_date":DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
        "to_date":DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()}).then((value) {
        _isLoading.add(false);
        if(value.data!=null){
          if(value.data!.status==1){
            if(value.data!.orders!=null){
              ordersData=value.data!.orders!;
              _orderList.add(value.data!.orders!);
            }else {
              _orderList.add([]);
              ToastMessage(value.data!.message!);
            }
          }else {
            _orderList.add([]);
            ToastMessage(value.data!.message!);
          }

        }else {
          _orderList.add([]);
          ToastMessage('Invalid Response');
        }
      });
    }else{
      CombineLatestStream.combine2(_fromDate, _toDate, (String a, String b,) {
        return a.isNotEmpty && b.isNotEmpty;
      }).listen((value) {
        _valid.add(value);
        if(value)
          _verify.add(null);
      },).addTo(disposeBag);

      _verify.withLatestFrom(_valid, (_, bool v) {
        printLog("title", v);
        return v;
      }).where((event) => event)
          .withLatestFrom2(_fromDate, _toDate, (t, String a, String b,) => {'API_KEY':'640590',"delivery_boy_id":userId,
        "from_date":a,
        "to_date":b})
          .listen(_submit.add)
          .addTo(disposeBag);

      _submit. doOnData((_)=> _isLoading.add(true))
          .map(loginService!.orderList)
          .listen((event) {
        _handleAuthResponse(event);
      })
          .addTo(disposeBag);
    }

  }

  _handleAuthResponse(Future<RequestResponse<OrderResponse>> result) {
    result
        .asStream()
        .where((r) => r.error == null)
        .map((r) => r.data)
        .listen((u) async {
      _isLoading.add(false);
      if(u!=null){
        if(u.status==1){
          if(u.orders!=null){
            if(type==Constants.DELIVER_ORDERS){
              List<Order> deliverData=[];
              if(u.orders!.length>0){
                for(int i=0;i<u.orders!.length;i++){
                  if(u.orders![i].isDeliver=="0"){
                    deliverData.add(u.orders![i]);
                  }
                }
              }
              ordersData=deliverData;
              _orderList.add(deliverData);
            }else{
              ordersData=u.orders!;
              _orderList.add(u.orders!);
            }

          }else {
            _orderList.add([]);
            ToastMessage(u.message!);
          }
        }else {
          _orderList.add([]);
          ToastMessage(u.message!);
        }

      }else {
        _orderList.add([]);
        ToastMessage('Invalid Response');
      }

    }).addTo(disposeBag);

    _handleError(result);
  }

  _handleError(Future<RequestResponse> result) {
    result
        .asStream()
        .where((r) => r.error != null)
        .map((r) => r.error)
        .doOnData((_) => _isLoading.add(false))
        .listen((e) {
      if (e != null){
        printLog("data", e.statusCode);
        //if(e.statusCode!=401)
      }
    }).addTo(disposeBag);


  }

  void searchData(String value){

    List<Order> searchResult = [];

    ordersData.forEach((item) {
      if (item.orderId!.toLowerCase().contains(value.toLowerCase())|| item.storeName!.toLowerCase().contains(value.toLowerCase())|| item.storeId!.toLowerCase().contains(value.toLowerCase()))
        searchResult.add(item);
    });

    _orderList.add(searchResult);
  }
  void  FromDate(){
    showDatePicker(context: Get.context!, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime.now()).then((value) {
      fromDateTime=DateTime.parse(value.toString());
      addFromDate.add(new DateFormat('yyyy-MM-dd').format(value!));
    });
  }
  void  ToDate(){
    showDatePicker(context: Get.context!, initialDate: fromDateTime!, firstDate: fromDateTime!, lastDate: DateTime.now()).then((value) {
      toDateTime=DateTime.parse(value.toString());
      addToDate.add(new DateFormat('yyyy-MM-dd').format(value!));
    });
  }
}