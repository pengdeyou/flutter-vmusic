import 'package:flutter/material.dart';
import 'package:flutter_vmusic/conf/router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter_vmusic/conf/platform.dart';

class LandingPage extends StatefulWidget {

  @override
  State createState() => new _LandingPage();
}
class _LandingPage extends State<LandingPage> with SingleTickerProviderStateMixin{

  AnimationController controllerTest;
  CurvedAnimation curve;


  @override
  void initState() {
    //初始化，当当前widget被插入到树中时调用
    super.initState();
//    全屏
    SYS.hideBar();
    controllerTest = new AnimationController(
        duration: const Duration(milliseconds: 2000),
        vsync: this);
    curve = new CurvedAnimation(parent: controllerTest, curve: Curves.easeIn);
    controllerTest.forward();
  }

  @override
  Widget build(BuildContext context) {
     return Material(
           child:FadeTransition(
             opacity: new Tween(begin: 1.0, end: 1.0).animate(curve),
             child:  Stack(
               alignment: FractionalOffset(0.5, 0.9),
               children: <Widget>[
                 Positioned(
                     child:Container(
                                color:Colors.black,
                                width: double.infinity,
                                height: double.infinity,
                                child:new CachedNetworkImage(
                                  imageUrl: 'https://source.nullno.com/images/sp3.jpg',
                                  fit:  BoxFit.cover,
                                 ),
                      )
                 ),
                 Positioned(
                     child:Container(
                         color:Colors.black54,
                         width: double.infinity,
                         height: double.infinity,
                         child: Column(
                           mainAxisAlignment:MainAxisAlignment.center,
                           children: <Widget>[
                             SlideTransition(
                               position: new Tween(
                                 begin: Offset(0.0, -0.5),
                                 end: Offset(0.0, 0.0),
                               ).animate(curve),
                               child:Text('DX MUSIC',style:TextStyle(color:Colors.white,fontSize:50.0,fontWeight:FontWeight.bold),),
                             ),
                             SizeTransition(
                               axis: Axis.horizontal, //控制宽度或者高度缩放
                               sizeFactor: new Tween(begin: 0.1, end: 1.0).animate(curve),
                               child: Container(
                                 width:300,
                                 height:3,
                                 margin:EdgeInsets.all(10.0),
                                 decoration: new BoxDecoration(
                                     border: Border.all(color: Colors.white, width: 2),
                                     borderRadius: BorderRadius.circular(10.0)
                                 ),
                               ),
                             ),
                             SlideTransition(
                                 position: new Tween(
                                   begin: Offset(0.0, 0.5),
                                   end: Offset(0.0, 0.0),
                                 ).animate(curve),
                                 child: Text('Thanks NeteaseCloudMusicApi',style:TextStyle(color:Colors.white,fontSize:20.0),)
                             )
                           ],
                         )
                     )

                 ),
                 Positioned(
                   child:RaisedButton(
                       onPressed: () {
//                       Navigator.pushNamedAndRemoveUntil( context,"/home", (router) => router == null);
                         //Navigator.of(context).pushNamed("/home");
                         //Router.goHome(context,{'des':'我是首页进来的555','from':'/launch'},(res){});
                         Router.fadeNavigator(context,"/home",{'des':'我是首页进来的555','from':'/launch'},(res){});

                       },
                       color:Color(0xff00CD81),
                       splashColor:Color(0xff221535),
                       elevation: 0.0,
                       highlightElevation: 0.0,
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(22.0))),
                       padding:EdgeInsets.fromLTRB(50,10,50,10),
                       child:Text('开始听歌',style:TextStyle(color:Colors.white, fontSize:16),textAlign: TextAlign.center)
                   ),
                 ),

               ],
             ) ,
           ),
     );
  }

  @override
  void dispose() {
    controllerTest.dispose();
    super.dispose();
  }
}