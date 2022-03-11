import 'dart:io' show Platform;
import 'dart:io';
// framework
import 'package:flutter/material.dart';
import 'dart:async';

// packages
import 'package:path_provider/path_provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/foundation.dart';

// components
import 'package:music/src/views/search.dart';
// ignore: unused_import
import 'package:music/src/components/music_control.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<File> items = [];
  Directory? directory;

  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    audioPlayer.notificationService.startHeadlessService();
    _searchFile();
  }

  void _serchPage() {
    Navigator.push(context,
        MaterialPageRoute<void>(builder: (BuildContext context) {
      return SearchPage();
    }));
  }

  void _menuPage() {
    Navigator.push(context, MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Menu'),
          ),
          body: const Center(
            child: Text(
              'This is the Menu page',
              style: TextStyle(fontSize: 24),
            ),
          ),
        );
      },
    ));
  }

  String _getFileName(file) {
    var slashes = Platform.isWindows ? '\\' : '/';

    return file.path.split(slashes).last;
  }

  void _playMusic(path) async {
    if (Platform.isIOS || Platform.isAndroid) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = await getDownloadsDirectory();
    }

    print(_getFileName(path));

    int result = await audioPlayer
        .play(directory!.path + "/" + _getFileName(path), isLocal: true)
        .catchError((e) {
      print(e);
    });

    print(result);
    print(audioPlayer.onPlayerError);
  }

  _searchFile() async {
    dynamic root;

    if (Platform.isIOS || Platform.isAndroid) {
      root = await getApplicationDocumentsDirectory();
    } else {
      root = await getDownloadsDirectory();
    }

    items = await FileManager(root: root).filesTree(
        // excludedPaths: ["/storage/emulated/0/Android"],
        // extensions: ["m4a", "flac", "wav", "wma", "aac", "mp3", "mp4"]
        );
    print(items);
    setState(() {});
  }

  Future<void> _onRefresh() {
    return _searchFile();
  }

  @override
  Widget build(BuildContext context) {
    // SimplePermissions.requestPermission(Permission.ReadExternalStorage);
    return Stack(
      children: <Widget>[
        Image.asset(
          "lib/assets/images/Background.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text(
              'Local Music',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            // leading: IconButton(
            //   icon: const Icon(
            //     Icons.menu_outlined,
            //     color: Colors.white,
            //   ),
            //   onPressed: _menuPage,
            // ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.search_outlined,
                  color: Colors.white,
                ),
                onPressed: _serchPage,
              )
            ],
          ),
          body: RefreshIndicator(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Card(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          _playMusic(items[index]);
                        },
                        child: ListTile(
                          // leading: FlutterLogo(),
                          title: Text(
                            _getFileName(items[index]),
                            style: const TextStyle(color: Colors.white),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                _playMusic(items[index]);
                              },
                              icon: const Icon(
                                Icons.play_circle,
                                color: Colors.white,
                              )),
                        ),
                      ));
                },
              ),
              onRefresh: _onRefresh),
        )
      ],
    );
  }
}
