/*
*搜索页
 */


import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter_vmusic/utils/FixedSizeText.dart';
import 'dart:ui';
import 'package:flutter_vmusic/utils/tool.dart';

import 'package:flutter_vmusic/conf/api.dart';

import 'package:flutter_vmusic/conf/platform.dart';
import 'package:audioplayers/audioplayers.dart';


class PlayerPage extends StatefulWidget{
  final Map params;
  PlayerPage({
    Key key,
    this.params,
  }) : super(key: key);
  @override
  _PlayerPage createState() => _PlayerPage();
}

class _PlayerPage extends State<PlayerPage> with SingleTickerProviderStateMixin{

  //音乐控制
  AudioPlayer audioPlayer = new AudioPlayer();
  bool playStatus=false;
  //旋转动画
  AnimationController _myController;
  Animation<double> rotateDisc;
  //歌单详情
  Map songDetail =  new Map();

  //加载状态
  int loadState = 0; //0 加载中  1加载完成  2 失败

  String playUrl ='';

  @override
  void initState() {
    super.initState();
    //动画控制器
    _myController = new AnimationController(duration: const Duration(seconds: 10), vsync: this);


    rotateDisc = new Tween(begin: 0.0, end: 1.0).animate(_myController);
    rotateDisc.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //动画从 controller.forward() 正向执行 结束时会回调此方法
        print("status is completed");
        //重置起点
        _myController.reset();
        //开启
         _myController.forward();
      } else if (status == AnimationStatus.dismissed) {
        //动画从 controller.reverse() 反向执行 结束时会回调此方法
        print("status is dismissed");
      } else if (status == AnimationStatus.forward) {
        print("status is forward");
        //执行 controller.forward() 会回调此状态
      } else if (status == AnimationStatus.reverse) {
        //执行 controller.reverse() 会回调此状态
        print("status is reverse");
      }
      });

    SYS.hideBar();

    //歌曲详情
    getSongDetail(widget.params['id'],(res){
       setState(() {
         songDetail = res['songs'][0];
       });

    },(err){
      loadState=2;
    });
    //歌曲链接
    getSongUrl(widget.params['id'],(res){
        setState(() {
          if(res['data'].length>0){
          this.playUrl=res['data']['url'];
//          playSong(this.playUrl);
          }
        });
    },(err){
    loadState=2;
    });

  }



  void playSong(url) async{
    int result = await audioPlayer.play(url);
    if(result==1) {
      playStatus = !playStatus;
    }
  }

  void pauseSong(url) async{
    int result = await audioPlayer.pause();
    if(result==1) {
      playStatus = !playStatus;
    }
  }


  @override
  Widget build(BuildContext context) {
    //顶部导航
    Widget appNav = Offstage(
      child:SafeArea(child: Container(
        color: Colors.transparent,
        width: double.infinity,
        height: 50.0,
        child: Material(
          color: Colors.transparent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child:Visibility(
                    child:IconButton(
                      padding:EdgeInsets.all(0.0),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.white70,
                          size: 30.0),
                    ),
                    visible:true,
                  )
              ),
              Expanded(
                  flex: 5,
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FixedSizeText(songDetail.isNotEmpty?songDetail['name']:'loading...',maxLines:1,overflow:TextOverflow.ellipsis,textAlign:TextAlign.center, style:TextStyle(color:Colors.white),),
                      FixedSizeText(songDetail.isNotEmpty?songDetail['ar'][0]['name']:'loading...',maxLines:1,overflow:TextOverflow.ellipsis,textAlign:TextAlign.center, style:TextStyle(fontSize:12.0, color:Colors.grey),)
                    ],
                  )
              ),
              Expanded(
                  flex: 1,
                  child:Visibility(
                    child:IconButton(
                      onPressed: (){

                      },
                      color: Colors.redAccent,
                      icon: Icon(Icons.more_vert, color: Colors.white70, size: 25.0),

                    ),
                    visible:true,
                  )
              )
            ],
          ),
        ),

      )),
      offstage:false,
    );
    //播放主界面
    Widget playView= Container(
        decoration:new BoxDecoration(
            image: new DecorationImage(
                image:NetworkImage(songDetail.isNotEmpty?songDetail['al']['picUrl']:'https://p4.music.126.net/PeIyrKa1NL2BUAzw8kcnpQ==/109951164144255354.jpg?param=200y200'),
                fit:BoxFit.fill,
            )

        ),
         child: Stack(
                  children: [
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                      child: new Container(
                        color:Colors.black.withOpacity(0.5),
                        width: 500,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black45,
                            Colors.transparent,
                            Colors.black45
                          ],
                        ),
                      ),
                      child:Center(
                      child: Container(
                       height:380,
                       child:Stack(
                         alignment:Alignment.topCenter,
                         children: <Widget>[
                           RotationTransition(
                             turns: rotateDisc,
                             child:
                             Center(
                               child: Container(
                                 height:266,width:266.0,
                                 decoration:new BoxDecoration(
                                     image: new DecorationImage(
                                       image:AssetImage('assets/image/disc.png'),
                                       fit:BoxFit.fill,
                                     )
                                 ),
                                 child:Padding(
                                     padding:EdgeInsets.all(50.0),
                                     child:  ClipRRect(
                                         borderRadius: BorderRadius.circular(100.0),
                                         child:Image.network(songDetail.isNotEmpty?songDetail['al']['picUrl']:'')
                                     )
                                 ),

                               ),
                             ),
                           ),
                           Transform.rotate(
                           angle:playStatus?0:-0.5,
                             alignment:Alignment.topLeft,
                             child:Container(
                               height:100,
                               child: Image.asset('assets/image/needle.png'),
                             ) ,
                           ),
                         ],
                       ) ,
                      ),
                      ),


                    ),
          ])
    );
    //播放控制
    Widget playControl = Container(
          height:150.0,
//          color:Colors.black,
          padding:EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment:MainAxisAlignment.end,
            children: <Widget>[
              Row(),
              Padding(padding: EdgeInsets.only(
                top:10,bottom:10,),
                child: Row(
                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex:1,
                    child: FixedSizeText('05:03',maxLines:1,textAlign:TextAlign.center, style:TextStyle(color:Colors.white54,fontSize:12.0),),
                  ),
                  Expanded(
                    flex:5,
                    child:Container(
                        color:Colors.transparent,
                        height:8,
                        child:Stack(
                          alignment:Alignment.centerLeft,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child:Container(
                                width:double.infinity,
                                height:2,
                                color:Colors.white54,
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child:Container(
                                width:200,
                                height:2,
                                color:Colors.red,
                              ),
                            ),
                            Positioned(
                              left:200,
                              child:ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Container(
                                    width:8.0,
                                    height:8.0,
                                    color:Colors.red,
                                  )
                              ),
                            )
                          ],
                        )
                    ),

                  ),
                  Expanded(
                    flex:1,
                    child: FixedSizeText('06:03',maxLines:1,textAlign:TextAlign.center, style:TextStyle(color:Colors.white54,fontSize:12.0),),
                  ),
                ],
              )
              ),
              Row(
                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                        padding:EdgeInsets.all(0.0),
                              onPressed: () {

                              },
                              icon: Icon(Icons.repeat, color: Colors.white24,
                                  size: 30.0),
                  ),
                  IconButton(
                    padding:EdgeInsets.all(0.0),
                    onPressed: () {

                    },
                    icon: Icon(Icons.skip_previous, color: Colors.white54,
                        size: 30.0),
                  ),
                  IconButton(
                    padding:EdgeInsets.all(0.0),
                    onPressed: () {

                      if(!playStatus){
                        _myController.forward();
                      }else{
                        _myController.stop();
                      }
                      setState(() {
                        playStatus=!playStatus;
                      });
                    },
                    icon: Icon(playStatus?Icons.pause_circle_outline:Icons.play_circle_outline, color: Colors.white70,
                        size: 50.0),
                  ),
                  IconButton(
                    padding:EdgeInsets.all(0.0),
                    onPressed: () {

                    },
                    icon: Icon(Icons.skip_next, color: Colors.white54,
                        size: 30.0),
                  ),
                  IconButton(
                    padding:EdgeInsets.all(0.0),
                    onPressed: () {

                    },
                    icon: Icon(Icons.playlist_play, color: Colors.white24,
                        size: 30.0),
                  ),
                ],
              ),
            ],
          ),
    );

    //主内容区
    Widget mainWarp= new Stack(
        alignment:Alignment.topCenter,
        children: <Widget>[
           playView,
           appNav,
           Align(
             alignment: Alignment.bottomCenter,
             child: playControl,
           )
        ]

    );

    //主内容区
    return  Material(color:Colors.white, child:mainWarp);
  }
  @override
  void dispose() {
    _myController.dispose();
    super.dispose();

  }

}
