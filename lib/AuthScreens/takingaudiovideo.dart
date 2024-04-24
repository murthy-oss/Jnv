
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:full_picker/full_picker.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:open_file/open_file.dart';
  import 'package:open_file/open_file.dart';
import 'package:webview_flutter/webview_flutter.dart';



class FilePickerTest extends StatefulWidget {
  const FilePickerTest({super.key});

  @override
  State<FilePickerTest> createState() => _ExonFilePicker();
}

class _ExonFilePicker extends State<FilePickerTest> {
  ValueNotifier<double> onProgress = ValueNotifier<double>(0);

  String info = 'Not Selected !';
  
  AudioPlayer? _audioPlayerController;
  WebViewController? _webViewController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    //_videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Full Picker Example')),
        body: Column(
          children: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Open Full Picker',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
              onPressed: () async{
                
               
                  },
            ),
          ],
        ),
      );
      
        void Openfile(PlatformFile file) {
       

OpenFile.open(file.path!);

        }
}
class VideoPlay extends StatefulWidget {
  

  const VideoPlay( {super.key});

  @override
  State<VideoPlay> createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
VideoPlayerController? _videoPlayerController;
   @override
  void initState() {
    // TODO: implement initState
     super.initState();
    
   
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _videoPlayerController?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _videoPlayerController!.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _videoPlayerController!.value.aspectRatio,
                  child: VideoPlayer(_videoPlayerController!),
                )
              : Container(),
        
         FloatingActionButton(
          onPressed: () {
            setState(() {
              _videoPlayerController!.value.isPlaying
                  ? _videoPlayerController!.pause()
                  : _videoPlayerController!.play();
            });
          },
          child: Icon(
            _videoPlayerController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
          FloatingActionButton(onPressed: ()async{
            final file=await pickVideoFile();
            if(file==null)return;
            _videoPlayerController=VideoPlayerController.file(file);
             
          })
        ],
      ),
    );
  }Future<File?> pickVideoFile() async {
 try {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result == null || result.files.isEmpty) {
      return null;
    }
    return File(result.files.first.path!);
 } catch (e) {
    print("Error picking file: $e");
    return null;
 }
}



                
}
/*
class AudioPlayer extends StatefulWidget {
  const AudioPlayer({
    required this.controller,
  });
  
  final AudioPlayerController controller;

  @override
  State<AudioPlayer> createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer> {
  String? durationText;
  Duration? duration;
  Duration? position;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(updateValues);
    position = widget.controller.position;
    duration = widget.controller.duration;
    durationText = duration!.inMinutes.toString() + ':' + (duration!.inSeconds % 60).toString().padLeft(2, '0');
    if (kDebugMode) {
      print('initState $duration $position $durationText');
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(updateValues);
    super.dispose();
  }

  void updateValues() {
    position = widget.controller.position;
    duration = widget.controller.duration;
    durationText = duration!.inMinutes.toString() + ':' + (duration!.inSeconds % 60).toString().padLeft(2, '0');
    if (kDebugMode) {
      print('updateValues $duration $position $durationText');
    }
    setState(() {});
  }

  @override
  Widget build(final BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.fast_rewind),
                onPressed: () {
                  widget.controller.seekTo(const Duration(seconds: 0));
                },
              ),
              IconButton(
                icon: widget.controller.isPlaying ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
                onPressed: () {
                  widget.controller.isPlaying ? widget.controller.pause() : widget.controller.play();
                },
              ),
              IconButton(
                icon: const Icon(Icons.fast_forward),
                onPressed: () {
                  widget.controller.seekTo(duration!);
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                position!.inMinutes.toString() + ':' + (position!.inSeconds % 60).toString().padLeft(2, '0'),
              ),
              const Text(' / '),
              Text(durationText ?? ''),
            ],
          ),
          Slider(
            value: position?.inSeconds.toDouble() ?? 0.0,
            min: 0.0,
            max: duration?.inSeconds.toDouble() ?? 0.0,
            onChanged: (final double value) {
              widget.controller.seekTo(Duration(seconds: value.toInt()));
            },
          ),
        ],
      );
}

*/