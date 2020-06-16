import 'package:flutter/material.dart';
import 'package:flutter_package/list_remove/remove_child.dart';
import 'package:flutter_package/list_remove/result.dart';

import '../toast.dart';
import 'bank_item.dart';

/// create by jh on 2019/12/24.
class ListRemoveFirstPage extends StatefulWidget {
  @override
  _ListRemoveFirstPageState createState() => _ListRemoveFirstPageState();
}

class _ListRemoveFirstPageState extends State<ListRemoveFirstPage> {

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
    return Scaffold(appBar: AppBar(title: Text("List滑动删除"),centerTitle: true,elevation:0),
      body:ListView.builder(itemCount:listBank.length,itemBuilder: (BuildContext context, int index){

        return Dismissible(key: listKey[index],//如果Dismissible是一个列表项 它必须有一个key 用来区别其他项
            background: new Container(color: Colors.red,margin: EdgeInsets.only(top: 15),),
            // 滑动回调
            onDismissed: (direction) {
              // 根据位置移除
              positionNow=index;
              _deleteBank();
              // 提示
              Scaffold.of(context).showSnackBar(SnackBar(content: Text("已移除 $positionNow")));
            },
            child:Container(height:100,padding: EdgeInsets.only(top: 15),width:MediaQuery.of(context).size.width,child: RemoveWidget(listBank[index]),) );
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

