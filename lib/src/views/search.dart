import 'package:flutter/material.dart';
import 'package:music/src/components/music_list.dart';
import 'package:music/src/api/video_youtube.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List items = [];
  final videoYoutube = VideoYoutube(YoutubeExplode());
  final searchControler = TextEditingController();
  bool loading = false;

  void _search(value) async {
    loading = true;
    await videoYoutube.search(value).then((e) => {items = e});
    setState(() {
      loading = false;
    });
  }

  void _download(id, title) async {
    videoYoutube.download(id, title);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    searchControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "lib/assets/images/Background.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(
                color: Colors.white, //change your color here
              ),
              title: Container(
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: TextField(
                    controller: searchControler,
                    textInputAction: TextInputAction.search,
                    autofocus: true,
                    onSubmitted: _search,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                    decoration: InputDecoration(
                        hintText: 'Search Music',
                        hintStyle: const TextStyle(color: Colors.white60),
                        contentPadding: const EdgeInsets.fromLTRB(15, 3, 0, 0),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        suffixIcon: IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: loading
                                ? null
                                : () {
                                    _search(searchControler.text);
                                  },
                            disabledColor: Colors.white60,
                            icon: const Icon(Icons.search,
                                color: Colors.white)))),
              )),
          body: loading
              ? const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                    color: Colors.white,
                  ),
                )
              : MusicList(
                  showType: 'search',
                  items: items,
                  onDownload: (id, title) => _download(id, title),
                ),
        )
      ],
    );
  }
}
