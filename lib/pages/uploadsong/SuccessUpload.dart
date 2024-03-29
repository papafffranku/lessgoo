import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

class SuccessUpload extends StatefulWidget {
  const SuccessUpload({Key? key}) : super(key: key);

  @override
  _SuccessUploadState createState() => _SuccessUploadState();
}

class _SuccessUploadState extends State<SuccessUpload> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: ColorfulSafeArea(
        child: Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Text(
                    'Successfully uploaded',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Your song is now online',
                    style: TextStyle(
                        color: Colors.white38,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 100,),
                  Container(
                    height: 300,
                    width: 300,
                    child: Success(),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget Loading() {
    return FlareActor(
      'lib/assets/MusicLoad.flr',
      animation: 'searching',
      fit: BoxFit.contain,
    );
  }

  Widget Success() {
    return FlareActor(
      'lib/assets/tickAnimation.flr',
      animation: 'Untitled',
      fit: BoxFit.contain,
    );
  }
}
