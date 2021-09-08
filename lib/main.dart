import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:lessgoo/ImageDisplayer.dart';
import 'package:lessgoo/Reference/Persist.dart';
import 'package:lessgoo/loginsignup/NewUserDetail.dart';
import 'package:lessgoo/loginsignup/loginwave.dart';
import 'package:lessgoo/pages/community/communityPage.dart';
import 'package:lessgoo/pages/explore/SearchPage.dart';

import 'package:lessgoo/pages/explore/explore.dart';
import 'package:lessgoo/pages/album/view_album.dart';
import 'package:lessgoo/pages/home/chat/chat_page.dart';
import 'package:lessgoo/pages/home/page_routes/artist_connect.dart';
import 'package:lessgoo/pages/home/page_routes/release_feed.dart';
import 'package:lessgoo/pages/library/library_landing.dart';
import 'package:lessgoo/Hello.dart';
import 'package:lessgoo/pages/player/player.dart';
import 'package:lessgoo/pages/playlist/view_playlist.dart';
import 'package:lessgoo/pages/profile/ProfilePage.dart';

import 'package:lessgoo/pages/uploadsong/SuccessUpload.dart';

final storageRef = FirebaseStorage.instance.ref();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  runApp(MaterialApp(
    theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xff101011),
        backgroundColor: Color(0xff101011),
        accentColor: Color(0xff8E35EF),
        fontFamily: GoogleFonts.rubik().fontFamily),
    initialRoute: '/ok',
    routes: {
      '/ok': (context) => Hello(),
      '/Pro': (context) => abc(),
      '/display': (context) => Display(),
      '/connect': (context) => ArtistConnect(),
      '/persist': (context) => Persist(),
      '/new': (context) => NewDetail(),
      '/success': (context) => SuccessUpload(),
      '/search': (context) => ExplorePage(),
      '/release': (context) => ReleaseFeed(),
      '/profile': (context) => ProfilePage(),
      '/explore': (context) => ExplorePage()
    },
    debugShowCheckedModeBanner: false,
  ));
}
