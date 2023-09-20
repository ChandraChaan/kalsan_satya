import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import '../container_widget/container_widget.dart';


class ListviewWidget extends StatefulWidget{

  final Stream<Tuple2<bool, List<ContainerWithWidget>?>>? onListUpdate;
  final Function(int)? onTap;

  ListviewWidget(
      {this.onListUpdate,this.onTap});
  ListviewWidgetState  createState() => ListviewWidgetState();

}
class ListviewWidgetState extends State<ListviewWidget> {
  List<ContainerWithAction> containers=[];
  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder<Tuple2<bool, List<ContainerWithWidget>?>>(
            initialData: Tuple2(false, containers),
            stream: widget.onListUpdate,
            builder: (c, s) {
              return  s.data!.item2!.isNotEmpty?
              ListView.builder(
                shrinkWrap: true,

                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: s.data!.item2!.length,
                itemBuilder: (c, i) {
                  return
                    GestureDetector(
                      key: UniqueKey(),
                      onTap: () {
                        var f = widget.onTap;
                        if (f != null) {
                          f(i);
                        }
                      },
                      child: (s.data!.item2![i].getContainer()!=null)?s.data!.item2![i].getContainer():SizedBox(),
                    );


                },
              )
                  : SizedBox();
            })
    );

  }
}