

import 'dart:io';

import 'package:fine_taste/di/app_injector.dart';
import 'package:fine_taste/di/i_login_page.dart';
import 'package:fine_taste/helper/logger/logger.dart';
import 'package:fine_taste/model/login/login_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../app/arch/bloc_provider.dart';
import '../../../common/bottom_naviagationbar/bottom_bar.dart';
import '../../../common/load_container/load_container.dart';
import '../../../common/textfield/my_text_field.dart';
import '../../../common/utilities/fonts.dart';
import '../../../common/utilities/ps_colors.dart';
import '../../repositories/end_point/end_point.dart';
import '../bloc/profile_bloc.dart';

class ProfilePage extends StatefulWidget {

  @override
  ProfilePageState createState() => ProfilePageState();
}
class ProfilePageState extends State<ProfilePage> {
  ProfilePageBloc? _bloc;

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
    'Profile',
    style: TextStyle(color: PSColors.white_color, fontSize: 20,fontFamily: WorkSans.regular),
    ),
    ),
      body: LoaderContainer(
        stream: _bloc!.isLoading,

        child: StreamBuilder<UserInformation>(
          initialData: null,
          stream: _bloc!.user,
          builder: (context, snapshot) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10,right: 10),
                    alignment: Alignment.centerRight,

                    child: ElevatedButton.icon(
                      icon: Icon(
                        Icons.logout,
                        color: PSColors.white_color,
                        size: 16.0,
                      ),
                      label: Text('Logout',style: TextStyle(fontSize: 14,color: PSColors.white_color),),
                      onPressed: () {
                        _bloc!.deleteUser();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: HexColor('#A7A7A7'),
                        onPrimary: PSColors.white_color,
                        shape:  RoundedRectangleBorder(
                          borderRadius: new BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),

                  ),
                  Center(
                    child: Stack(
                      children: [
                        StreamBuilder<File>(
                          initialData: null,
                          stream: _bloc!.profileFile,
                          builder: (context, snap) {
                            return CircleAvatar(
                              radius: 65,
                              backgroundColor:Colors.grey,
                              child: ClipOval(
                                child: SizedBox.fromSize(
                                  size: Size.fromRadius(64), // Image radius
                                  child: (snap.data==null)?(snapshot.data!=null)?Image.network(EndPoints.base_url+snapshot.data!.userImage!,
                                      width: 60, height: 60, fit: BoxFit.fill, errorBuilder:
                                          (BuildContext context, Object exception, StackTrace? stackTrace) {
                                        return Image.asset('assets/images/splash_logo.png');
                                      },):Image.asset('assets/images/splash_logo.png'):Image.file
                                    (snap.data!,fit: BoxFit.fill),
                                ),
                              ),
                            );
                          }
                        ),
                        Positioned(
                          top:80,
                          left: 80,
                          child: GestureDetector(
                            onTap: ()=>_bloc!.selectImage(),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.black,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 24,
                                child: Icon(Icons.camera_alt_rounded,color: Colors.black,),
                              ),
                            ),
                          ),
                        ),

                      ],

                    ),
                  ),
                   SizedBox(height: 30,),
                  Container(
                    margin: EdgeInsets.only(left: 20,right: 20),
                    child: Column(
                      children: [
                        MyTextField(
                          labelText: '',
                          hintText: 'Name',
                          initialText: (snapshot.data!=null)?snapshot.data!.userName!:'',
                          inputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          onChange: _bloc!.name.add,
                        ),
                        SizedBox(height: 20,),
                        MyTextField(
                          labelText: '',
                          hintText: 'Email',
                          initialText: (snapshot.data!=null)?snapshot.data!.email!:'',
                          inputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          onChange: _bloc!.email.add,
                          validationStream: _bloc!.emailValidation,
                        ),
                        SizedBox(height: 20,),
                        MyTextField(
                          labelText: '',
                          hintText: 'Mobile No',
                          initialText: (snapshot.data!=null)?snapshot.data!.mobileNo!:'',
                          inputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          onChange: _bloc!.mobil.add,
                          validationStream: _bloc!.phoneValidation,
                          charactersLimit:10,
                        ),
                        SizedBox(height: 30,),
                        SizedBox(
                          height: 35,
                          width: 100,
                          child: ElevatedButton(
                            onPressed: (){
                               _bloc!.save.add(null);
                            }, child: Text('Save'),
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<
                                  Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<
                                  Color>(
                                  HexColor('#0B8BCB')),

                            ),
                          ),

                        )
                      ],
                    ),
                  )








                ],
              ),
            );
          }
        ),


      ),

      bottomNavigationBar: bottomBar(),
    );
  }
}