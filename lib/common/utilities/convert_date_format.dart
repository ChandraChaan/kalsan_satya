
import 'package:intl/intl.dart';

abstract class ConvertDateFormat {
 static String customDate(String val){
  DateTime parseDate = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(val);
  var inputDate = DateTime.parse(parseDate.toString());
  var outputFormat = DateFormat('dd/MM/yyyy');
  var outputDate = outputFormat.format(inputDate);
return outputDate;
 }
}