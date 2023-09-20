import 'package:json_annotation/json_annotation.dart';
part 'last_invoice_response.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake)
class LastInvoiceResponse{

  int? status;
  String? message;

  LastInvoiceResponse(
      this.status,
      this.message,
      this.previousBalance,
      this.counts,
      this.totalOrders,
      this.todayOrders,
      this.deliverOrders,
      this.storesCount,
      this.notifications,
      this.id,
      this.title,
      this.text,
      this.sendDate,
      this.opening_stock,
      this.close_stock,
      this.remaining_stock,
      this.return_stock
      );

  double? previousBalance;
  LastInvoiceResponse? counts;
  int? totalOrders;
  int? todayOrders;
  int? deliverOrders;
  int? storesCount;
  List<LastInvoiceResponse>? notifications;
  String? id;
  String? title;
  String? text;
  String? sendDate;
  List<Common>? opening_stock;
  List<Common>? close_stock;
  List<Common>? remaining_stock;
  List<Common>? return_stock;


  factory LastInvoiceResponse.fromJson(Map<String,dynamic> json) => _$LastInvoiceResponseFromJson(json);

}

@JsonSerializable(fieldRename: FieldRename.snake)
class Common {
  String? name;
  int? value;
  Common(this.name, this.value);

  factory Common.fromJson(Map<String,dynamic> json) => _$CommonFromJson(json);

}


