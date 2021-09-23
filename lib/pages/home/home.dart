import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:lessgoo/PopUp/CustomRectTween.dart';
import 'package:lessgoo/PopUp/HeroDialogRoute.dart';
import 'package:lessgoo/models/TrailModel.dart';
import 'package:lessgoo/pages/chat/chat_landing.dart';
import 'package:lessgoo/pages/home/page_routes/page_preview.dart';

import 'package:lessgoo/pages/home/page_routes/trail_view.dart';
import 'package:lessgoo/pages/library/library_landing.dart';
import 'package:lessgoo/pages/player/player.dart';
import 'package:lessgoo/pages/profile/ProfilePage.dart';
import 'package:lessgoo/pages/trails/Trail_landing.dart';
import 'package:lessgoo/pages/uploadsong/uploadscreens.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

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
  final AudioPlayer homePlayer;

  State<HomePage> createState() => _HomePageState();
  const HomePage({Key? key, required this.homePlayer}) : super(key: key);
}

const String _heroAddTodo = 'add-todo-hero';

class _HomePageState extends State<HomePage> {
  Stream<DocumentSnapshot<Object?>>? docStream;

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
                        color: Theme.of(context).accentColor.withOpacity(0.9)),
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
            backgroundColor: Theme.of(context).accentColor,
            radius: 4,
          ),
          GestureDetector(
            onTap: () => pushNewScreen(context, screen: StoryPageView()),
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

  final uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    docStream =
        FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double sWidth = MediaQuery.of(context).size.width;
    ConcatenatingAudioSource _playlist;
    AudioPlayer _player = widget.homePlayer;

    return StreamBuilder<DocumentSnapshot>(
        stream: docStream,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return HomePage(homePlayer: _player);
          }
          if (snapshot.hasData) {
            var data = snapshot.data;

            return Scaffold(
                backgroundColor: Colors.black,
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
                            backgroundColor: Theme.of(context).backgroundColor,
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
                                      color: Theme.of(context).accentColor,
                                    )),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.notifications_none_rounded,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    pushNewScreen(context,
                                        screen: ChatLanding());
                                  },
                                  icon: Icon(
                                    CupertinoIcons.chat_bubble_2,
                                  )),
                              SizedBox(width: 10),
                              InkWell(
                                  child: CircleAvatar(
                                    radius: 15.0,
                                    backgroundImage: NetworkImage(data![
                                        'avatarUrl']), //data!['avatarUrl']
                                  ),
                                  onTap: () {
                                    pushNewScreen(context,
                                        screen: ProfilePage());
                                  }),
                              SizedBox(width: 15),
                            ],
                          ),
                        ],
                    body: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          trailSection(),
                          releaseSection()
                        ],
                      ),
                    )));
          } else {
            return Container(
              color: Theme.of(context).backgroundColor,
              child: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }

  Widget releaseSection() {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                'Releases',
                style: TextStyle(
                    letterSpacing: 1.2,
                    color: Theme.of(context).accentColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        releaseBlock(
            'https://www.sleek-mag.com/wp-content/uploads/2016/08/AlbumCovers_Blonde-1200x1200.jpg',
            'https://miro.medium.com/max/640/1*HEvh6wLy-z4wwt9aEatUOw@2x.png',
            'Frank Ocean',
            'White Ferrari'),
        releaseBlock(
            'https://static.billboard.com/files/media/Young-Thug-Jeffery-2016-billboard-1240-compressed.jpg',
            'https://pbs.twimg.com/media/E9WZEsxXEAMw4vO.jpg',
            'Young Thug',
            'Twister Nightmares'),
        releaseBlock(
            'https://cdn.mos.cms.futurecdn.net/g6MkYufocsYc3ToH85v2th-970-80.jpg.webp',
            'https://pyxis.nymag.com/v1/imgs/c6a/835/176402f7714503041d300b0af28af3ec2e-beyonce-dj-khaled.rsquare.w1200.jpg',
            'Beyonce',
            'Lemonade'),
      ],
    );
  }

  Widget releaseBlock(
      String imgUrl, String profilePic, String artistName, String name) {
    bool selected = true;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(imgUrl),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(profilePic),
                      ),
                      SizedBox(height: 10),
                      RotatedBox(
                          quarterTurns: 1,
                          child: Text(artistName,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)))
                    ],
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, right: 50),
            child: Row(
              children: [
                SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    selected = !selected;

                    pushNewScreen(context,
                        withNavBar: false,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                        screen: Player(
                            player: widget.homePlayer,
                            playlist: ConcatenatingAudioSource(children: [
                              AudioSource.uri(
                                  Uri.parse(
                                      'https://firebasestorage.googleapis.com/v0/b/jvsnew-93e01.appspot.com/o/tracks%2F%5BMP3DOWNLOAD.TO%5D%20Frank%20Ocean%20-%20White%20Ferrari-320k.mp3?alt=media&token=765b1c81-0ebb-4e42-883c-1cf43b09dfb1'),
                                  tag: MediaItem(
                                      id: '1',
                                      title: 'White Ferrari',
                                      artist: 'Frank Ocean',
                                      artUri: Uri.parse(imgUrl)))
                            ])));
                  },
                  icon: Icon(
                      selected
                          ? Icons.play_circle_fill_rounded
                          : Icons.pause_circle_filled_rounded,
                      size: 40),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'album',
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                    Text(
                      name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(onPressed: () {}, icon: Icon(Icons.favorite_outline))
              ],
            ),
          ),
        ],
      ),
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
                      color: Theme.of(context).accentColor,
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
            color: Theme.of(context).accentColor,
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
                        pushNewScreen(context,
                            screen: Trail_landing(
                                UPFcon: UPF,
                                uid: widget.id,
                                background: backgroundColor,
                                nextColor: otherColor));
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
                                          color: Theme.of(context).accentColor,
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
                        pushNewScreen(context,
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
                                          color: Theme.of(context).accentColor,
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
                                        color: Theme.of(context).accentColor,
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
                            color: Theme.of(context).accentColor),
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

  Future<Color> getImagePalette(ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(imageProvider);
    return paletteGenerator.dominantColor!.color;
  }
}
