import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lessgoo/pages/swiper/modalswipe.dart';

class communityPage extends StatefulWidget {
  const communityPage({Key? key}) : super(key: key);

  @override
  _communityPageState createState() => _communityPageState();
}

class _communityPageState extends State<communityPage> {
  @override
  Widget build(BuildContext context) {
    return ColorfulSafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Community",
                      style: TextStyle(
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w800,
                          fontSize: 40),
                    ),
                    WidgetSpan(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0,top: 10),
                        child: Icon(CupertinoIcons.link_circle_fill,color: Color(0xff5338FF),size: 35,),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
              child: InkWell(
                child: Container(
                  width: 170,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius:
                      BorderRadius.circular(13),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 17),
                          blurRadius: 17,
                          spreadRadius: -23,
                        )
                      ]),
                  child: Center(
                      child: RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                  child: Icon(
                                    CupertinoIcons.shuffle_thick,
                                    color: Colors.black,
                                    size: 20,
                                  )),
                              TextSpan(
                                  text: '  Connect  ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ))),
                ),
                  onTap: ()=> showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (_) => MyBottomSheet(),
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
