import 'package:flutter/material.dart';
import 'package:flutter_package/list_remove/result.dart';

/// create by jh on 2020/1/6.

class RemoveWidget extends StatelessWidget {

  final Result result;

  RemoveWidget(this.result);

  @override
  Widget build(BuildContext context) {
    return Container(height: 100, padding: EdgeInsets.only(left: 15,right: 15), decoration: BoxDecoration(color: Colors.blue,), child: Row(children: <Widget>[
      SizedBox(width: 15,),
      Expanded(child:Column(mainAxisAlignment:MainAxisAlignment.center,crossAxisAlignment:CrossAxisAlignment.start,children: <Widget>[
        Text(result.title,style: TextStyle(color: Colors.white),),
        Text(result.detail,style: TextStyle(color: Colors.white),),
      ],)),

    ],),);
  }
}
