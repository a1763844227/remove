import 'package:flutter/material.dart';
import 'package:flutter_package/list_remove/remove_child.dart';
import 'package:flutter_package/list_remove/result.dart';

/// create by jh on 2019/12/24.


typedef ClickDelete =Function(int position);//定义删除方法
typedef ClickChange =Function(int position);//定义修改方法


class RemoveItem extends StatefulWidget  {
  final Result result;//数据bean
  final GlobalKey<RemoveItemState> moveKey;
  final VoidCallback onStart;//开始滑动回调
  final ClickDelete delete;
  final ClickDelete change;

  final int position;//操作position

  final Widget child;//具体显示内容

  RemoveItem(this.result,this.position,this.child,{@required this.moveKey,this.onStart,this.delete,this.change}):super(key:moveKey);
  @override
  RemoveItemState createState() => RemoveItemState();
}

class RemoveItemState extends State<RemoveItem> with SingleTickerProviderStateMixin{


  AnimationController controller;

  double moveMaxLength=160;//滑动最大距离
  double start=0;

  bool isOpen=false;//是否是打开状态


  @override
  void initState() {
    super.initState();
    controller = new AnimationController( lowerBound: 0,
        upperBound: moveMaxLength,duration: const Duration(milliseconds: 300), vsync: this)
      ..addListener((){
        start=controller.value;
        setState(() {});
      });

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(height:115,padding: EdgeInsets.only(left: 15,right: 15,top: 15),width:MediaQuery.of(context).size.width,child:GestureDetector(
      child:Stack(children: <Widget>[
        Positioned(right: 80,child:InkWell(onTap: (){widget.change(widget.position); },child:Container(width: 80,height:100,alignment: Alignment.center,color: Colors.grey, child: Text("修改",style: TextStyle(color: Colors.white),),),),),
        Align(alignment: Alignment.centerRight,child: InkWell(onTap: (){widget.delete(widget.position); },child: Container(width: 80,alignment: Alignment.center,color: Colors.red,child: Text("删除",style: TextStyle(color: Colors.white)),),),),
        Positioned(left: -start,right:start,child: widget.child),

      ],),onHorizontalDragDown: (DragDownDetails details){
      close();
      return widget.onStart();
    },
      onHorizontalDragUpdate: (DragUpdateDetails details){
        setState(() {
          start-=details.delta.dx;
          if (start<=0) {
            start=0;
          }

          if(start>=moveMaxLength){
            start=moveMaxLength;
          }
        });
      },onHorizontalDragEnd: (DragEndDetails details){
      controller.value=start;
      if (start==moveMaxLength) isOpen=true;
      else if (start>moveMaxLength/2) {
        controller.animateTo(moveMaxLength);
        isOpen=true;
      }else if(start<=moveMaxLength/2){
        close();
      }

    },));
  }

  void close(){
    if (isOpen) {
      controller.animateTo(0);
      isOpen=false;
    }


  }


}
