import 'package:fine_taste/app/arch/bloc_provider.dart';
import 'package:fine_taste/common/load_container/load_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:toast/toast.dart';

import '../../../common/label/item_label_text.dart';
import '../../../common/textfield/pyc_text_filed.dart';
import '../../../common/utilities/fonts.dart';
import '../../../common/utilities/ps_colors.dart';
import '../bloc/forgot_bloc.dart';

class ForgotPage extends StatefulWidget{

  ForgotPageState createState() => ForgotPageState();

}
class ForgotPageState  extends State<ForgotPage>{
  ForgotBloc? bloc;

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
        title: ItemLabelText(text:'Forgot Password ',style:TextStyle(fontFamily: WorkSans.regular,color: Colors.white,fontSize: 18))),
        body: LoaderContainer(
          stream: bloc!.isLoading,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(30),
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PYCTextField(
                  labelText: '',
                  hintText: 'Email',
                  inputAction: TextInputAction.done,
                  keyboardType: TextInputType.emailAddress,
                  onChange: bloc!.email.add,
                  validationStream: bloc!.emailValidation,
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.10,),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: SizedBox(
                    height: 48,
                    width: MediaQuery.of(context).size.width*0.6,
                    child: ElevatedButton.icon(
                      icon: Icon(
                        Icons.arrow_back,
                        color: PSColors.text_black_color,
                        size: 16.0,
                      ),
                      label: Text('Forgot Password',style: TextStyle(fontSize: 14,color: PSColors.text_black_color),),
                      onPressed: () {
                        bloc!.login.add(null);

                      },
                      style: ElevatedButton.styleFrom(
                        primary: HexColor('#FFCB04'),
                        onPrimary: PSColors.text_black_color,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

    ),
        ),

    );

  }
}
