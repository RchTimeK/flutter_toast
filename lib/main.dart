

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rc_toast/rc_toast.dart';

GlobalKey RCGlobalKey = GlobalKey();

void main() => runApp(
  MaterialApp(
    home: MyApp(),
  )
);

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: RCGlobalKey,
      body: Container(
        child: InkWell(
          onTap: (){
          //  RCToast().showText("你好，世界",context: context);
          //  RCToast().showHud(context: context);
          //  RCToast().showHudText("加载中");
          //  RCToast().showSuccessText("支付成功");
          //  RCToast().showErrorText("请求失败");
            RCToast().showInfoText("请输入密码");
          },
          child: Container(
            width: 100,height: 100,
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }
}

