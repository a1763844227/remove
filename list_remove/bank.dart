import 'package:flutter/material.dart';
import 'package:flutter_package/list_remove/remove_child.dart';
import 'package:flutter_package/list_remove/result.dart';

import '../toast.dart';
import 'bank_item.dart';

/// create by jh on 2019/12/24.
class ListRemovePage extends StatefulWidget {
  @override
  _ListRemovePageState createState() => _ListRemovePageState();
}

class _ListRemovePageState extends State<ListRemovePage> {


  List<Result> listBank=new List();
  int positionNow=0;

  List<GlobalKey<RemoveItemState>> listKey=[];//通过给各个item设置key，点击其它item的时候，打开的item关闭

  @override
  void initState(){
    super.initState();
    initList();
  }

  void initList(){
    listBank=List.generate(10, (index){
      Result result=new Result("title $index","detail $index");
      return result;
    });
    updateView(listBank);
  }



  void updateView(List<Result> list){
    listKey.clear();
    listKey.addAll(setKey(list.length));
    setState(() {});
  }

  List<GlobalKey<RemoveItemState>> setKey(int length){
    var list=<GlobalKey<RemoveItemState>>[];
    for (int i = 0; i < length; i++) {
      var key=GlobalKey<RemoveItemState>();
      list.add(key);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("List滑动删除"),centerTitle: true,elevation:0,
      actions: <Widget>[IconButton(icon: Image.asset("assets/drawable/card_manager_add_img.png",width: 20,height: 20,), onPressed: (){})],),
      body:ListView.builder(itemCount:listBank.length,itemBuilder: (BuildContext context, int index){
        return RemoveItem(listBank[index],index,new RemoveWidget(listBank[index]),moveKey: listKey[index],onStart:(){
          listKey.forEach((bankKey){
            if (bankKey!=listKey[index]) {
              bankKey.currentState?.close();
            }
          });
        },delete: (position){
          positionNow=position;
          showLoginDialog();
        },change: (position){
          Toast.toast(context,msg: "你点击了修改 $position");
        },);
      }),
    );
  }


  void showLoginDialog() {

    showModalBottomSheet(context: context, builder: (context){
      return Container(height: 170,color: Colors.white,child: Column(children: <Widget>[
        SizedBox(height: 20,),
        Text("删除后将无法看到该条记录，请谨慎操作",style: TextStyle(color: Colors.grey,fontSize: 14),),
        SizedBox(height: 1,),
        Container(height: 50,width:double.infinity,margin:EdgeInsets.only(left: 15,right: 15),
          child:  FlatButton(onPressed:(){
            Navigator.of(context).pop();
            _deleteBank();
            Toast.toast(context,msg: "你点击了删除 $positionNow");
          },
            child: Text("删除",style: TextStyle(fontSize: 16,color:Colors.blue),),),),
        SizedBox(height: 10,),
        Container(height: 50,width:double.infinity,margin:EdgeInsets.only(left: 15,right: 15),
          child:  FlatButton(onPressed:(){Navigator.of(context).pop();}, child: Text("取消",style: TextStyle(fontSize: 14),),),),
      ],),);
    });
  }

  void _deleteBank(){
    listKey.removeAt(positionNow);
    listBank.removeAt(positionNow);
    setState(() {});
  }

}

