class EndPoint {
  final String base;
  final String path;

  EndPoint({required this.base, required this.path});
}


class EndPoints {
  static String _devBase = "kalsanfood.com";
  static String get _base {return _devBase;}

  static final  _api = '/kalsan_dev/api/';
  static String base_url='https://'+_devBase+'/kalsan_dev/';

  //login
  static EndPoint get login => _getEndPointWithPath(_api + 'login');
  //update profile
  static EndPoint get updateProfile => _getEndPointWithPath(_api + 'update_profile');
  //forgot
  static EndPoint get forgot => _getEndPointWithPath(_api + 'forgot_password');
  //Store list
  static EndPoint get storeList => _getEndPointWithPath(_api + 'stores');

  //get Dashboard data
  static EndPoint get getCounts => _getEndPointWithPath(_api + 'get_counts');
  //Order list
  static EndPoint get createOrder => _getEndPointWithPath(_api + 'create_order');
  //Order list
  static EndPoint get ordersList => _getEndPointWithPath(_api + 'delivery_boy_orders');
  //Order Details
  static EndPoint get orderDetails => _getEndPointWithPath(_api + 'order_details');
  //update Order
  static EndPoint get updateDelivery => _getEndPointWithPath(_api + 'update_delivery');

  //products
  static EndPoint get products => _getEndPointWithPath(_api + 'products');

  //check_previous_invoice Amoount
  static EndPoint get checkPreviousInvoice => _getEndPointWithPath(_api + 'check_previous_invoice');

  //notification List
  static EndPoint get notificationList => _getEndPointWithPath(_api + 'notifications');

  static EndPoint _getEndPointWithPath(String path) {
    return EndPoint(base: _base, path: path);
  }
}