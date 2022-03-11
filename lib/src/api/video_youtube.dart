import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:music/src/models/query_video.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'dart:io';
// packages
import 'package:path_provider/path_provider.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';

class VideoYoutube {
  final YoutubeExplode yt;
  dynamic directory;

  VideoYoutube(this.yt);

  Future search(query) async {
    var request = await yt.search.getVideos(query);
    var result = [];
    result.addAll(request.where((e) => !e.isLive).map((e) => QueryVideo(
        e.title, e.id.value, e.author, e.duration!, e.thumbnails.highResUrl)));

    return result;
    // .catchError((e, s) {
    //     print(e);
    //     print(s);
    //   });
  }

  void download(id, title) async {
    if (Platform.isIOS || Platform.isAndroid) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = await getDownloadsDirectory();
    }

    var manifest = await yt.videos.streamsClient.getManifest(id);

    var streamInfo = manifest.audioOnly.withHighestBitrate();
    // Get the actual stream
    var stream = yt.videos.streamsClient.get(streamInfo);

    // Open a file for writing.
    File file = File(directory.path + "/$title");
    var fileStream = file.openWrite();

    // Pipe all the content of the stream into the file.
    await stream.pipe(fileStream);

    // Close the file.
    await fileStream.flush();
    await fileStream.close();
  }
}
