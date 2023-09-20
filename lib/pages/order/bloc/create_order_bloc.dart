
import 'package:fine_taste/app/arch/bloc_provider.dart';
import 'package:fine_taste/common/toast/toast.dart';
import 'package:fine_taste/di/app_injector.dart';
import 'package:fine_taste/di/i_home_page.dart';
import 'package:fine_taste/model/login/insert_response.dart';
import 'package:fine_taste/model/store/products_response.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../helper/logger/logger.dart';
import '../../../manager/user_data_store/user_data_store.dart';
import '../../../model/base_response/request_response.dart';
import '../../../model/login/login_response.dart';
import '../../../model/store/store_list_response.dart';
import '../../repositories/login/login_api.dart';
import '../widget/success_dialog.dart';

typedef BlocProvider<CreateOrderBloc> CreateOrderFactory(Store store);
class CreateOrderBloc extends BlocBase{
    Store? store;
    LoginService? loginService;
    UserDataStore? userDataStore;
    BehaviorSubject<Store> _store =BehaviorSubject();
    BehaviorSubject<int> _selectPos =BehaviorSubject.seeded(1);
    BehaviorSubject<bool> _isTax =BehaviorSubject.seeded(false);
    BehaviorSubject<String> _paidAmount =BehaviorSubject.seeded('');
    BehaviorSubject<String> _remarks =BehaviorSubject.seeded('');
    BehaviorSubject<double> _itemTotal =BehaviorSubject.seeded(0.0);
    BehaviorSubject<double> _taxAmount =BehaviorSubject.seeded(0.0);
    BehaviorSubject<double> _totalAmount =BehaviorSubject.seeded(0.0);
    BehaviorSubject<double> _previousBalance =BehaviorSubject.seeded(0.0);
    BehaviorSubject<List<Product>> _productList =BehaviorSubject.seeded([]);
    BehaviorSubject<List<Product>> _returnProductList =BehaviorSubject.seeded([]);
    BehaviorSubject<ProductsResponse> _productsResponse =BehaviorSubject();
    Stream<ProductsResponse> get productsResponse => _productsResponse;
    BehaviorSubject<bool> _valid = BehaviorSubject<bool>.seeded(false);
    BehaviorSubject<bool> _isLoading =BehaviorSubject.seeded(false);
    PublishSubject<void> _create = PublishSubject();
    PublishSubject<Map<String,dynamic>> _createOrder=PublishSubject();
    Sink<void> get create => _create;
    Stream<bool> get isLoading=> _isLoading;
    Stream<bool> get valid => _valid;
    Stream<Store> get storeData => _store;
    Stream<List<Product>> get productList => _productList;
    Sink<List<Product>> get addProductList => _productList;
    Stream<List<Product>> get returnProductList => _returnProductList;
    Sink<List<Product>> get addReturnProductList => _returnProductList;
    Stream<double> get itemTotal => _itemTotal;
    Stream<double> get previousBalance => _previousBalance;
    Sink<double> get addItemTotal => _itemTotal;
    Stream<double> get taxAmount => _taxAmount;
    Sink<double> get addTaxAmount => _taxAmount;
    Stream<double> get totalAmount => _totalAmount;
    Sink<double> get addTotalAmount => _totalAmount;
    Sink<String> get paidAmount => _paidAmount;
    Sink<String> get remarks => _remarks;
    Stream<bool> get isTax => _isTax;
    Sink<bool> get addIsTax=> _isTax;
    Stream<int> get selectPos => _selectPos;
    Sink<int> get addSelectPos => _selectPos;
    double prBalance=0.0;

  CreateOrderBloc(this.loginService,this.userDataStore,this.store){
    _store.add(store!);

    _setListeners();
  }

  void _setListeners() async {
    UserInformation? userInformation=await  userDataStore?.getUser();
    String userId=userInformation!.userId!;
    loginService!.productList({'API_KEY':'640590','store_id':store!.id}).then((value) {
      if(value.data!=null){
        if(value.data!.status==1){
          if(value.data!.products!=null){
            _productList.add(value.data!.products!);
            _productsResponse.add(value.data!);
          }else{
            _productList.add([]);
            ToastMessage(value.data!.message!);
          }
        }else{
          _productList.add([]);
          ToastMessage(value.data!.message!);
        }

        
      }else{
        _productList.add([]);
        ToastMessage('Invalid Response');
      }
      
    });
    loginService!.productList({'API_KEY':'640590','store_id':store!.id}).then((value) {
      if(value.data!=null){
        if(value.data!.status==1){
          if(value.data!.products!=null){
            _returnProductList.add(value.data!.products!);


          }else{
            _returnProductList.add([]);
            ToastMessage(value.data!.message!);
          }
        }else{
          _returnProductList.add([]);
          ToastMessage(value.data!.message!);
        }

      }else{
        _returnProductList.add([]);
        ToastMessage('Invalid Response');
      }

    });

    loginService!.checkPreviousInvoice({'API_KEY':'640590','store_id':store!.id}).then((value) {
      if(value.data!=null){
       if(value.data!.status==1){
         prBalance=value.data!.previousBalance!;
         _totalAmount.add(prBalance);
         _previousBalance.add(value.data!.previousBalance!);
       }else ToastMessage('No Data');

      }else{

        ToastMessage('Invalid Response');
      }

    });


    _itemTotal.listen((value) {
      _isTax.listen((taxValue) {
        if(taxValue){
          printLog("tax",value*(double.parse(store!.tax!)/100));
          _taxAmount.add(value*(double.parse(store!.tax!)/100));
          _totalAmount.add(value+(value*(double.parse(store!.tax!)/100))+prBalance);

        }else{
          _taxAmount.add(0.0);
          _totalAmount.add(value+prBalance);
        }
      }).addTo(disposeBag);

    }).addTo(disposeBag);

    CombineLatestStream.combine3(_totalAmount,_paidAmount,_productList,
            (double a, String b,List<Product> products) {

            int  qty = products.fold(0, (tot, item) => tot +item.qty!);

               return (a!=0.0&&b.isNotEmpty&&qty>0);
        })
        .listen(_valid.add)
        .addTo(disposeBag);
    _create
        .withLatestFrom(_valid, (_, bool v) {
      if(v!=true) ToastMessage('Enter Details');
      return v;
    })
        .where((event) => event)
        .withLatestFrom8(_totalAmount,_paidAmount,_productList,_returnProductList,_taxAmount,_selectPos,_previousBalance,_remarks, (t, double a, String b,
        List<Product> products,List<Product> returnProducts, double c,int d,double e,String f) {
          List<Map<String,dynamic>> orderList=[];
          List<Map<String,dynamic>> returnList=[];
          for(int i=0;i<products.length;i++){
            if(products[i].qty!>0){

              orderList.add({"product_id":int.parse(products[i].id!),  "quantity":products[i].qty, "unit_price":products[i].price, "total_price":products[i].total.toString()});
            }
          }

          for(int j=0;j<returnProducts.length;j++){
            if(returnProducts[j].qty!>0){
              returnList.add({"product_id":int.parse(returnProducts[j].id!), "quantity":returnProducts[j].qty,"unit_price": returnProducts[j].price, "total_price":returnProducts[j].total.toString()});
            }
          }
          return {
            "API_KEY":"640590", "delivery_boy_id":userId, "store_id":store!.id,'gst_amount':c.toString(),
            'previous_balance':e.toString(),'invoice_amount':a.toString(),'paid_amount':b,
            'pay_method':(d==0)?'online':'cash','order':orderList,'return':returnList,'remarks':f
          };
    }
    ).listen(_createOrder.add)
        .addTo(disposeBag);

    _createOrder.
    doOnData((_)=> _isLoading.add(true))
        .map(loginService!.createOrder)
        .listen((event) {
      _handleAuthResponse(event);
    }).addTo(disposeBag);

  }
    _handleAuthResponse(Future<RequestResponse<InsertResponse>> result) {
      result
          .asStream()
          .where((r) => r.error == null)
          .map((r) => r.data)
          .listen((u) async {
        _isLoading.add(false);
        if (u != null){
          if(u.status==1) {
            ToastMessage(u.message!);
            Get.offAll(AppInjector.instance.homePage);
            //SuccessDialog();
          }else ToastMessage('u.message!');
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
}