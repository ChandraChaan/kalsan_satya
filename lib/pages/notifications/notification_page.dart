
import 'package:fine_taste/common/label/item_label_text.dart';
import 'package:fine_taste/common/utilities/convert_date_format.dart';
import 'package:fine_taste/model/store/last_invoice_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../app/arch/bloc_provider.dart';
import '../../../common/bottom_naviagationbar/bottom_bar.dart';
import '../../../common/load_container/load_container.dart';
import '../../../common/textfield/my_text_field.dart';
import '../../../common/utilities/fonts.dart';
import '../../../common/utilities/ps_colors.dart';
import '../../common/fonts/fonts.dart';
import 'bloc/notificatiion_bloc.dart';

class NotificationPage extends StatefulWidget {

  @override
  NotificationPageState createState() => NotificationPageState();
}
class NotificationPageState extends State<NotificationPage> {
  NotificationBloc? _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: PSColors.white_color,
    appBar: AppBar(
    centerTitle: true,
    automaticallyImplyLeading: false,
    backgroundColor: PSColors.app_color,
    title: Text(
    'Notifications',
    style: TextStyle(color: PSColors.white_color, fontSize: 20,fontFamily: WorkSans.regular),
    ),
    ),
      body: LoaderContainer(
        stream: _bloc!.isLoading,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<List<LastInvoiceResponse>>(
        initialData: [],
        stream: _bloc!.notifications,
        builder: (context, snapshot) {
          return (snapshot.data!.isNotEmpty)?
          ListView.builder(
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              itemBuilder: (b,i){
                return Card(
                  elevation: 2,
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(Icons.circle_notifications_sharp,color: PSColors.app_color,size: 50,),
                        SizedBox(width: 10,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ItemLabelText(text:snapshot.data![i].title,style: TextStyle(fontSize: 18,color: PSColors.text_black_color,fontFamily: WorkSans.bold),),
                            SizedBox(height: 10,),
                            ItemLabelText(text:snapshot.data![i].text,style: TextStyle(fontSize: 16,color: PSColors.text_black_color,fontFamily: WorkSans.medium),),
                            SizedBox(height: 10,),
                            ItemLabelText(text:ConvertDateFormat.customDate(snapshot.data![i].sendDate!),style: TextStyle(fontSize: 14,color: PSColors.text_black_color,fontFamily: WorkSans.regular),),

                          ],
                        )
                      ],
                    ),
                  ),
                );
              })
              :Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(child: ItemLabelText(text: 'No Data',style: TextStyle(fontSize: 18,fontFamily: WorkSans.bold,color: Colors.black),)));
        }
      ),
    ),


      ),

      bottomNavigationBar: bottomBar(),
    );
  }
}