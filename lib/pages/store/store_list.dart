import 'package:fine_taste/app/arch/bloc_provider.dart';
import 'package:fine_taste/common/load_container/load_container.dart';
import 'package:fine_taste/common/utilities/fonts.dart';
import 'package:fine_taste/common/utilities/ps_colors.dart';
import 'package:fine_taste/di/app_injector.dart';
import 'package:fine_taste/di/i_home_page.dart';
import 'package:fine_taste/pages/repositories/end_point/end_point.dart';
import 'package:fine_taste/pages/store/bloc/store_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:toast/toast.dart';

import '../../common/bottom_naviagationbar/bottom_bar.dart';
import '../../common/label/item_label_text.dart';
import '../../model/store/store_list_response.dart';

class StoreList extends StatefulWidget{

  _StoreListState createState() => _StoreListState();
}

class _StoreListState  extends State<StoreList>{
  StoreListBloc? bloc;

  @override
  void initState() {
   bloc=BlocProvider.of(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: PSColors.bg_color,
      appBar: AppBar(
        backgroundColor: PSColors.app_color,
        centerTitle: true,
        title: ItemLabelText(text:'Select Store',style:TextStyle(fontFamily: WorkSans.regular,color: Colors.white,fontSize: 18)),
      ),
      body: LoaderContainer(
        stream: bloc!.isLoading,
        child: StreamBuilder<int>(
          initialData: 1,
          stream: bloc!.typeScreen,
          builder: (context, snap) {
            return Container(
              margin: EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width*0.85,
                        height: 45,
                        decoration: BoxDecoration(
                          color: HexColor('#A7A7A7')
                        ),
                        child: TextField(
                          onChanged: (value){
                            bloc!.searchData(value);
                          },
                          maxLines: 1,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle: TextStyle(fontSize: 18,color: Colors.white,fontFamily: WorkSans.regular),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 3),
                        width: MediaQuery.of(context).size.width*0.10,
                        height: 45,
                        decoration: BoxDecoration(
                            color: Colors.white
                        ),
                        child: Icon(Icons.search),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Expanded(
                    child: StreamBuilder<List<Store>>(
                      initialData: [],
                      stream: bloc!.storeList,
                      builder: (context, snapshot) {
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            shrinkWrap: true,
                            itemBuilder: (b,i){
                              return GestureDetector(
                                onTap: (){

                                  Get.to(AppInjector.instance.orderCreate(snapshot.data![i]));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(top: 10,bottom: 10),
                                  decoration: BoxDecoration(
                                    color: PSColors.item_bg,
                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20), // Image border
                                        child: SizedBox.fromSize(
                                          size: Size.fromRadius(48), // Image radius
                                          child: Image.network(EndPoints.base_url+snapshot.data![i].image!, fit: BoxFit.cover,errorBuilder:
                                              (BuildContext context, Object exception, StackTrace? stackTrace) {
                                            return Image.asset('assets/images/splash_logo.png');
                                          }),
                                        ),
                                      ),
                                      Flexible(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 6.0,right: 6.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ItemLabelText(text: snapshot.data![i].storeName,style: TextStyle(fontSize: 16,fontFamily: WorkSans.semiBold,color: Colors.white),),
                                              SizedBox(height: 5,),
                                              ItemLabelText(text: '${snapshot.data![i].address} Ph : ${snapshot.data![i].mobile}',style: TextStyle(fontSize: 14,fontFamily: WorkSans.regular,color: Colors.white),),

                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      }
                    ),
                  )

                ],
              ),
            );
          }
        ),
      ),
      bottomNavigationBar: bottomBar() ,
    );
  }
}