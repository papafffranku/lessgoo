import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:lessgoo/PopUp/CustomRectTween.dart';
import 'package:lessgoo/PopUp/HeroDialogRoute.dart';
import 'package:lessgoo/main.dart';
import 'package:lessgoo/models/TrailModel.dart';
import 'package:lessgoo/pages/activityfeed/activityfeed.dart';
import 'package:lessgoo/pages/chat/chat_landing.dart';
import 'package:lessgoo/pages/home/page_routes/trail_view.dart';
import 'package:lessgoo/pages/home/timeline.dart';
import 'package:lessgoo/pages/player/player.dart';
import 'package:lessgoo/pages/profile/ProfilePage.dart';
import 'package:lessgoo/pages/trails/Trail_landing.dart';
import 'package:lessgoo/pages/uploadsong/ModalScreens.dart';
import 'package:lessgoo/pages/uploadsong/uploadscreens.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

final currentUserId = FirebaseAuth.instance.currentUser!.uid;

List<Trails> trailList = [
  Trails(
    artistName: 'Tame_Impala',
    imgUrl:
        'https://www.rollingstone.com/wp-content/uploads/2019/05/tame-impala-lead-photo.jpg',
  ),
  Trails(
    artistName: 'Kanye_West',
    imgUrl:
        'https://media.pitchfork.com/photos/60fabf372e77ffecd64d64ad/2:1/w_2560%2Cc_limit/Kanye-West.jpg',
  ),
  Trails(
    artistName: 'J.Cole',
    imgUrl: 'https://i.scdn.co/image/ab6761610000e5ebadd503b411a712e277895c8a',
  ),
  Trails(
    artistName: 'Brockhampton',
    imgUrl:
        'https://media.newyorker.com/photos/607de09d8f675fab920cd1f1/1:1/w_1920,h_1920,c_limit/Pearce-BrockhamptonPandemic.jpg',
  ),
  Trails(
    artistName: 'Tame_Impalalalala',
    imgUrl:
        'https://www.rollingstone.com/wp-content/uploads/2019/05/tame-impala-lead-photo.jpg',
  ),
  Trails(
    artistName: 'Tame_Impala',
    imgUrl:
        'https://www.rollingstone.com/wp-content/uploads/2019/05/tame-impala-lead-photo.jpg',
  ),
];

class HomePage extends StatefulWidget {
  State<HomePage> createState() => _HomePageState();
  const HomePage({Key? key}) : super(key: key);
}

const String _heroAddTodo = 'add-todo-hero';

class _HomePageState extends State<HomePage> {
  Stream<DocumentSnapshot<Object?>>? docStream;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  void showNotification(RemoteNotification remoteNotification) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.dfa.flutterchatdemo'
          : 'com.duytq.flutterchatdemo',
      'Flutter chat demo',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails(threadIdentifier: 'thread_id');
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    print(remoteNotification);

    await FlutterLocalNotificationsPlugin().show(
      0,
      remoteNotification.title,
      remoteNotification.body,
      platformChannelSpecifics,
      payload: null,
    );
  }

  void registerNotification() {
    firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage: $message');
      if (message.notification != null) {
        showNotification(message.notification!);
      }
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('push token: $token');
      if (token != null) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .update({'pushToken': token});
      }
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  Widget playlister(String imgUrl, String playlistName, String playlistDesc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(imgUrl),
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: 150,
          child: RichText //Welcome Header
              (
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: playlistName,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                ),
                TextSpan(
                  text: '\n$playlistDesc',
                  style: TextStyle(fontSize: 12, color: Colors.white54),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget artistRelease(
      String imgUrl, String trackName, String artistName, String releaseType) {
    return Container(
      height: 180,
      width: 180,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          image: DecorationImage(
            fit: BoxFit.contain,
            image: NetworkImage(imgUrl),
          )),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.8),
              ],
            )),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText //Welcome Header
                (
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: '$releaseType',
                    style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor.withOpacity(0.9)),
                  ),
                  TextSpan(
                    text: '\n$trackName',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  TextSpan(
                    text: '\n$artistName',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.white54),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget trailAvatar(String imgurl, String artistName) {
    return Column(
      children: [
        Stack(children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).hintColor,
            radius: 4,
          ),
          GestureDetector(
            onTap: () => PersistentNavBarNavigator.pushNewScreen(context, screen: StoryPageView()),
            child: CircleAvatar(
              backgroundImage: NetworkImage(imgurl),
              radius: 32,
            ),
          ),
        ]),
        SizedBox(height: 5),
        Container(
          width: 60,
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    artistName.toLowerCase(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  final uid = currentUserId;
  String notif = 'something';
  @override
  void initState() {
    docStream =
        FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final modal = ModalScreens();
    Size size = MediaQuery.of(context).size;
    double width=size.width;
    double height=size.height;

    return StreamBuilder<DocumentSnapshot>(
        stream: docStream,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return HomePage();
          }
          if (snapshot.hasData) {
            var data = snapshot.data;

            return Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-2.5, -2.5),
                  colors: [
                    Theme.of(context).hintColor,
                    Colors.black
                  ],
                  radius: 2.6,
                  stops: [0.005, 0.995],
                ),
              ),
              child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: NestedScrollView(
                      floatHeaderSlivers: true,
                      headerSliverBuilder: (context, innerBoxIsScrolled) => [
                            SliverAppBar //QuickAccess Bar
                                (
                              title: SvgPicture.asset(
                                'lib/assets/juke_title.svg',
                                height: 25,
                                placeholderBuilder: (context) =>
                                    Icon(Icons.error),
                              ),
                              backgroundColor: Colors.transparent,
                              floating: true,
                              onStretchTrigger: () {
                                return Future<void>.value();
                              },
                              actions: [
                                Hero(
                                  tag: _heroAddTodo,
                                  createRectTween: (begin, end) {
                                    return CustomRectTween(
                                        begin: begin, end: end);
                                  },
                                  child: IconButton(
                                      onPressed: () {
                                        String id = data!['id'];
                                        Navigator.of(context).push(
                                            HeroDialogRoute(builder: (context) {
                                          return _AddTodoPopupCard(id: id);
                                        }));
                                      },
                                      icon: Icon(
                                        CupertinoIcons.add,
                                        color: Theme.of(context).hintColor,
                                      )),
                                ),
                                IconButton(
                                    onPressed: () {
                                      PersistentNavBarNavigator.pushNewScreen(context,
                                          withNavBar: false,
                                          screen: ChatLanding());
                                    },
                                    icon: Icon(
                                      CupertinoIcons.chat_bubble_2,
                                    )),
                                SizedBox(width: 10),
                              ],
                            ),
                          ],
                      body: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text('Hey, '+data!['username'],style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text('Check out whats new!',style: TextStyle(color: Colors.white70,fontWeight: FontWeight.bold),),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: InkWell(
                                  onTap: (){modal.newUserRec(context,uid);},
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 0.30*width,
                                        width: 0.45*width,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                          image: DecorationImage(
                                            image: AssetImage(
                                              'lib/assets/Bandppl.jpg',
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 0.30*width,
                                        width: 0.45*width,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                          gradient: RadialGradient(
                                            center: Alignment(-0.8, 0.8),
                                            colors: [
                                              Colors.blue,
                                              Colors.transparent
                                            ],
                                            radius: 2.4,
                                            stops: [0.005, 0.995],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 0.15*width,left: 5),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: 'New Artists',
                                                    style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
                                                  ),
                                                  WidgetSpan(
                                                    child: Icon(CupertinoIcons.forward,color: Theme.of(context).hintColor,size: 22,),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text('See the newbies',style: TextStyle(color: Colors.white70),),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 0.30*width,
                                      width: 0.45*width,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'lib/assets/musicdiscussion.jpg',
                                          ),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 0.3*width,
                                      width: 0.45*width,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                        gradient: RadialGradient(
                                          center: Alignment(-0.8, 0.8),
                                          colors: [
                                            Colors.blue,
                                            Colors.transparent
                                          ],
                                          radius: 2.4,
                                          stops: [0.005, 0.995],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 0.15*width,left: 5),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Discussions',
                                                  style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
                                                ),
                                                WidgetSpan(
                                                  child: Icon(CupertinoIcons.forward,color: Theme.of(context).hintColor,size: 22,),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text('Get on the soapbox',style: TextStyle(color: Colors.white70),),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Timeline(),
                        ],
                      ))),
            );
          } else {
            return Container(
              color: Theme.of(context).backgroundColor,
              child: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }

  Widget releaseSection() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text(
            'Releases',
            style: TextStyle(
                letterSpacing: 1.2,
                color: Theme.of(context).hintColor,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget trailSection() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trails',
                  style: TextStyle(
                      letterSpacing: 1.2,
                      color: Theme.of(context).hintColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "check what everyone's upto",
                  style: TextStyle(
                      letterSpacing: 1.3,
                      color: Colors.white54,
                      fontSize: 12,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
              height: 110,
              child: ListView.builder(
                itemCount: trailList.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Column(
                      children: [
                        trailAvatar(trailList[index].imgUrl,
                            trailList[index].artistName)
                      ],
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }
}

class _AddTodoPopupCard extends StatefulWidget {
  final id;
  const _AddTodoPopupCard({Key? key, this.id}) : super(key: key);

  @override
  __AddTodoPopupCardState createState() => __AddTodoPopupCardState();
}

class __AddTodoPopupCardState extends State<_AddTodoPopupCard> {
  FilePickerResult? result;
  late PlatformFile file;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Hero(
          tag: _heroAddTodo,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            color: Theme.of(context).hintColor,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 30, bottom: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        result = await FilePicker.platform
                            .pickFiles(type: FileType.image);
                        file = result!.files.first;
                        final File UPF = File(file.path.toString());
                        Color backgroundColor =
                            await getImagePalette(FileImage(UPF));
                        String nextColor = backgroundColor.toString();
                        print(nextColor);
                        var newNextColor =
                            int.parse(nextColor.substring(10, 11));
                        newNextColor = newNextColor + 2;
                        nextColor = '0xff' +
                            newNextColor.toString() +
                            nextColor.substring(11, 16);
                        Color otherColor = new Color(int.parse(nextColor));
                        print(otherColor.toString());
                        PersistentNavBarNavigator.pushNewScreen(context,
                            screen: Trail_landing(
                              UPFcon: UPF,
                              uid: widget.id,
                              background: backgroundColor,
                              nextColor: otherColor,
                              number: '1',
                            ));
                      },
                      child: Container(
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: Colors.black),
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Center(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Create a ",
                                      style: TextStyle(
                                          letterSpacing: 1.2,
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    TextSpan(
                                      text: "Trail",
                                      style: TextStyle(
                                          letterSpacing: 1.2,
                                          color: Theme.of(context).hintColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['mp3'],
                        );
                        file = result!.files.first;
                        final File UPF = File(file.path.toString());
                        PersistentNavBarNavigator.pushNewScreen(context,
                            screen: SongUpload(
                              UPFcon: UPF,
                              uid: widget.id,
                            ));
                      },
                      child: Container(
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: Colors.black),
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Center(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Upload a ",
                                      style: TextStyle(
                                          letterSpacing: 1.2,
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    TextSpan(
                                      text: "Song",
                                      style: TextStyle(
                                          letterSpacing: 1.2,
                                          color: Theme.of(context).hintColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          color: Colors.black),
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Upload an ",
                                    style: TextStyle(
                                        letterSpacing: 1.2,
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  TextSpan(
                                    text: "Album",
                                    style: TextStyle(
                                        letterSpacing: 1.2,
                                        color: Theme.of(context).hintColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: Theme.of(context).hintColor),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Center(
                              child: Icon(
                            Icons.cancel_rounded,
                            size: 25,
                            color: Colors.black,
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _saveDeviceToken() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    if (fcmToken != null) {
      var tokenRef =
          userRef.doc(currentUserId).collection('tokens').doc(fcmToken);

      await tokenRef.set({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem
      });
    }
  }

  Future<Color> getImagePalette(ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(imageProvider);
    return paletteGenerator.dominantColor!.color;
  }
}
