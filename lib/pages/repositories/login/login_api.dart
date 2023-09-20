import 'package:dio/dio.dart';
import 'package:fine_taste/model/order/order_response.dart';
import 'package:fine_taste/model/store/last_invoice_response.dart';
import 'package:fine_taste/model/store/products_response.dart';
import 'package:fine_taste/model/store/store_list_response.dart';

import '../../../helper/logger/logger.dart';
import '../../../model/base_response/request_response.dart';
import '../../../model/login/insert_response.dart';
import '../../../model/login/login_response.dart';
import '../../../model/order/order_details_response.dart';
import '../base/base_api_service.dart';
import '../end_point/end_point.dart';

abstract class LoginAPI{
  Future<RequestResponse<LoginResponse>> login(Map<String,dynamic> data);
  Future<RequestResponse<InsertResponse>> forgot(Map<String,dynamic> data);
  Future<RequestResponse<StoreListResponse>> storeList(Map<String,dynamic> data);
  Future<RequestResponse<InsertResponse>> createOrder(Map<String,dynamic> data);
  Future<RequestResponse<OrderResponse>> orderList(Map<String,dynamic> data);
  Future<RequestResponse<OrderDetailsResponse>> orderDetails(Map<String,dynamic> data);
  Future<RequestResponse<ProductsResponse>> productList(Map<String,dynamic> data);
  Future<RequestResponse<InsertResponse>> updateOrder(Map<String,dynamic> data);
  Future<RequestResponse<LoginResponse>> updateProfile(Future<FormData> data);
  Future<RequestResponse<LastInvoiceResponse>> checkPreviousInvoice(Map<String,dynamic> data);
  Future<RequestResponse<LastInvoiceResponse>> getCounts(Map<String,dynamic> data);
  Future<RequestResponse<LastInvoiceResponse>> getNotifications(Map<String,dynamic> data);

}
class LoginService extends BaseAPIService implements LoginAPI{
  LoginService();
  @override
  Future<RequestResponse<LoginResponse>> login(Map<String,dynamic> data) {
    printLog("login",data);
    return make(RequestType.POST, EndPoints.login, body: data,contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        printLog("response", result.data);
        var data=LoginResponse.fromJson(result.data);
        return RequestResponse(data: data);
      } else {
        printLog("response error", result.error!.error);
        return RequestResponse(error: result.error);
      }
    });
  }

  @override
  Future<RequestResponse<LoginResponse>> updateProfile(Future<FormData> mapvalues) async{
    FormData data = await mapvalues;
    return makeDio(RequestType.POST, EndPoints.updateProfile, body: data,contentType: ContentType.multipart)
        .then((result) {
      if (result.data != null) {
        printLog("response", result.data);
        var data=LoginResponse.fromJson(result.data);
        return RequestResponse(data: data);
      } else {
        printLog("response error", result.error!.error);
        return RequestResponse(error: result.error);
      }
    });
  }

  @override
  Future<RequestResponse<StoreListResponse>> storeList(Map<String,dynamic> data) {
    return make(RequestType.GET, EndPoints.storeList, params: data,contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        printLog("response", result.data);
        var data=StoreListResponse.fromJson(result.data);
        return RequestResponse(data: data);
      } else {
        printLog("response error", result.error!.error);
        return RequestResponse(error: result.error);
      }
    });
  }

  @override
  Future<RequestResponse<InsertResponse>> createOrder(Map<String,dynamic> data) {
    printLog("login",data);
    return make(RequestType.POST, EndPoints.createOrder, body: data,contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        printLog("response", result.data);
        var data=InsertResponse.fromJson(result.data);
        return RequestResponse(data: data);
      } else {
        printLog("response error", result.error!.error);
        return RequestResponse(error: result.error);
      }
    });
  }

  @override
  Future<RequestResponse<OrderResponse>> orderList(Map<String,dynamic> data) {
    return make(RequestType.POST, EndPoints.ordersList, body: data,contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        printLog("response", result.data);
        var data=OrderResponse.fromJson(result.data);
        return RequestResponse(data: data);
      } else {
        printLog("response error", result.error!.error);
        return RequestResponse(error: result.error);
      }
    });
  }

  @override
  Future<RequestResponse<ProductsResponse>> productList(Map<String,dynamic> data) {
    return make(RequestType.GET, EndPoints.products, params: data,contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        printLog("response", result.data);
        var data=ProductsResponse.fromJson(result.data);
        return RequestResponse(data: data);
      } else {
        printLog("response error", result.error!.error);
        return RequestResponse(error: result.error);
      }
    });
  }

  @override
  Future<RequestResponse<OrderDetailsResponse>> orderDetails(Map<String,dynamic> data) {
    return make(RequestType.POST, EndPoints.orderDetails, body: data,contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        printLog("response", result.data);
        var data=OrderDetailsResponse.fromJson(result.data);
        return RequestResponse(data: data);
      } else {
        printLog("response error", result.error!.error);
        return RequestResponse(error: result.error);
      }
    });
  }

  @override
  Future<RequestResponse<InsertResponse>> updateOrder(Map<String,dynamic> data) {
    return make(RequestType.POST, EndPoints.updateDelivery, body: data,contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        printLog("response", result.data);
        var data=InsertResponse.fromJson(result.data);
        return RequestResponse(data: data);
      } else {
        printLog("response error", result.error!.error);
        return RequestResponse(error: result.error);
      }
    });
  }
  @override
  Future<RequestResponse<InsertResponse>> forgot(Map<String,dynamic> data) {
    printLog("login",data);
    return make(RequestType.POST, EndPoints.forgot, body: data,contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        printLog("response", result.data);
        var data=InsertResponse.fromJson(result.data);
        return RequestResponse(data: data);
      } else {
        printLog("response error", result.error!.error);
        return RequestResponse(error: result.error);
      }
    });
  }

  @override
  Future<RequestResponse<LastInvoiceResponse>> checkPreviousInvoice(Map<String,dynamic> data) {
    return make(RequestType.GET, EndPoints.checkPreviousInvoice, params: data,contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        printLog("response", result.data);
        var data=LastInvoiceResponse.fromJson(result.data);
        return RequestResponse(data: data);
      } else {
        printLog("response error", result.error!.error);
        return RequestResponse(error: result.error);
      }
    });
  }

  @override
  Future<RequestResponse<LastInvoiceResponse>> getCounts(Map<String,dynamic> data) {
    return make(RequestType.GET, EndPoints.getCounts, params: data,contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        printLog("response", result.data);
        var data=LastInvoiceResponse.fromJson(result.data);
        return RequestResponse(data: data);
      } else {
        printLog("response error", result.error!.error);
        return RequestResponse(error: result.error);
      }
    });
  }

  @override
  Future<RequestResponse<LastInvoiceResponse>> getNotifications(Map<String,dynamic> data) {
    return make(RequestType.GET, EndPoints.notificationList,params: data,contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        printLog("response", result.data);
        var data=LastInvoiceResponse.fromJson(result.data);
        return RequestResponse(data: data);
      } else {
        printLog("response error", result.error!.error);
        return RequestResponse(error: result.error);
      }
    });
  }

}