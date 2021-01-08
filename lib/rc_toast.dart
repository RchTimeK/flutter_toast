import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:flutter_rc_toast/main.dart';

class RCToast{
  static final RCToast _instance = RCToast._internal();
  factory RCToast() => _instance;
  RCToast._internal();

  OverlayEntry _overlayEntry;
  bool _showing = false;
  Timer _timer;

  // txt
  void showText(String text,{BuildContext context}){
    Widget RCCardText = Card(
      color: Colors.black87,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          text,
          style: TextStyle(fontSize: 15,color: Colors.white),
        ),
      ),
    );
    _autoRemove(RCCardText, text,context: context);
  }

  // success
  void showSuccessText(String text,{BuildContext context }){
    _showIconInfoText(text,"assets/images/alter_ok.png",context);
  }
  // info
  void showInfoText(String text,{BuildContext context }){
    _showIconInfoText(text,"assets/images/alter_info.png",context);
  }
  // error
  void showErrorText(String text,{BuildContext context }){
    _showIconInfoText(text,"assets/images/alter_wro.png",context);
  }
  // hud + text
  void showHudText(String text,{BuildContext context }){
    Widget HudText = Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            width: 60,height: 40,
            padding:EdgeInsets.all(10),
            child: Theme(
              data: ThemeData(
                cupertinoOverrideTheme: CupertinoThemeData(
                  brightness: Brightness.dark,
                ),
              ),
              child: CupertinoActivityIndicator(
                radius: 16,
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: Text(text,
              style: TextStyle(fontSize: 14,color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
    _handMovementRemove(HudText,context: context);
  }
  // hud
  void showHud({BuildContext context}){
    Widget Hud = Container(
      width: 80,height: 80,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Theme(
        data: ThemeData(
          cupertinoOverrideTheme: CupertinoThemeData(
            brightness: Brightness.dark,
          ),
        ),
        child: CupertinoActivityIndicator(
          radius: 16,
        ),
      ),
    );
    _handMovementRemove(Hud,context: context);
  }
  // dismiss
  void hideHud(){
    if(_overlayEntry != null){
      _overlayEntry.remove();
      _overlayEntry = null;
      _timer?.cancel();
    }
  }

  void _showIconInfoText(String text,String imageName,BuildContext context){
    Widget RCIconText = Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            width: 60,height: 40,
            padding:EdgeInsets.fromLTRB(10, 5, 10, 10),
            child: Image.asset(imageName,width: 40,height: 40,),
          ),
          Material(
            color: Colors.transparent,
            child: Text(text,
              style: TextStyle(color: Colors.white,),
            ),
          ),
        ],
      ),
    );
    _autoRemove(RCIconText, text,context: context);
  }

  void _autoRemove(Widget child,String text,{BuildContext context}){
    hideHud();
    // 简单写个消失的动画，可自行自定义
    _showing = true;
    _setOverlayEntry(AnimatedOpacity(
      opacity: _showing ? 1.0 : 0.0,
      duration: _showing ? Duration(milliseconds: 50) : Duration(milliseconds: 100),
      child: child,
    ),context);
    _removeText(text);
  }

  void _handMovementRemove(Widget child,{BuildContext context}){
    hideHud();
    _setOverlayEntry(child, context);
  }

  void _setOverlayEntry(Widget child,BuildContext context){
    if(context == null){
      context = RCGlobalKey.currentState.context;
    }
    if (context == null)
      throw ("Error: Context is null, Please call init(context) before showing toast.");
    if(_overlayEntry == null){
      _overlayEntry = OverlayEntry(
          builder: (BuildContext context) => Positioned(
            top: MediaQuery.of(context).padding.top + kToolbarHeight,
            child: Container(
              alignment: Alignment.center,
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height-kToolbarHeight - MediaQuery.of(context).padding.top,
              padding: EdgeInsets.only(bottom: kToolbarHeight + MediaQuery.of(context).padding.top),
              child: child,
            ),
          )
      );
      //插入到整个布局的最上层
      Overlay.of(context).insert(_overlayEntry);
    }else{
      //重新绘制UI，类似setState
      _overlayEntry.markNeedsBuild();
    }
  }

  // 传入text，根据字数判断显示的时长(1-3s)
  void _removeText(String text){
    if(_overlayEntry != null){
      // 显示时间
      int _showTime = text.length * 200;
      if(_showTime < 1000){
        _showTime = 1000;
      }else if(_showTime > 3000){
        _showTime = 3000;
      }
      _timer = Timer(Duration(milliseconds: _showTime), (){
        _showing = false;
        _overlayEntry.markNeedsBuild();
        Future.delayed(Duration(milliseconds: 200),(){
          _overlayEntry.remove();
          _overlayEntry = null;
          _timer?.cancel();
        });
      });
    }
  }
}