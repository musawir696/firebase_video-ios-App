// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

class sendVideo extends StatefulWidget {
  XFile imagepath;
  sendVideo({Key? key, required this.imagepath}) : super(key: key);

  @override
  State<sendVideo> createState() => _sendVideoState();
}

class _sendVideoState extends State<sendVideo> {
  VideoPlayerController? _controller;
  // var userData2 = {};
  // var userData = {};

  // getData() async {
  //   try {
  //     var Usersnap = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(FirebaseAuth.instance.currentUser!.uid)
  //         .get();
  //     setState(() {
  //       userData = Usersnap.data()!;
  //     });
  //   } catch (e) {}
  // }

  // getotherData() async {
  //   setState(() {
  //     isloading = true;
  //   });
  //   try {
  //     var Usersnap = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(widget.ChatId)
  //         .get();
  //     setState(() {
  //       userData2 = Usersnap.data()!;
  //     });
  //   } catch (e) {}
  //   setState(() {
  //     isloading = false;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.imagepath.path))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  UploadTask? task;
  Future<String> SendVideo(File VideoPath) async {
    var postId = Uuid().v1();
    Reference ref =
        FirebaseStorage.instance.ref().child('videos').child('$postId.mp4');
    task = ref.putFile(VideoPath);
    TaskSnapshot snap = await task!;
    String downloadurl = await snap.ref.getDownloadURL();
    return downloadurl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            String url = await SendVideo(File(widget.imagepath.path));
            print(url);
          },
          label: Text('Upload'),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: CupertinoButton(
              child: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context)
                            .bottomNavigationBarTheme
                            .backgroundColor ==
                        Colors.white
                    ? Colors.black
                    : Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          backgroundColor:
              Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          // iconTheme: IconThemeData(color: Colors.white),
          actions: [
            Row(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.crop,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.emoji_emotions,
                    )),
              ],
            )
          ],
        ),
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    if (_controller!.value.isPlaying) {
                      setState(() {
                        _controller!.pause();
                      });
                    } else {
                      setState(() {
                        _controller!.play();
                      });
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.4),
                    radius: 24,
                    child: Center(
                      child: Icon(
                        _controller!.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

//   Widget _buildSendFileStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
//         stream: task.snapshotEvents,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final snap = snapshot.data!;
//             final progress = snap.bytesTransferred / snap.totalBytes;
//             final percentage = (progress * 100).toStringAsFixed(2);
//             return Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 8.0),
//                   child: Container(
//                     height: 10,
//                     decoration: BoxDecoration(
//                         color: Colors.transparent,
//                         borderRadius: BorderRadius.circular(10)),
//                     width: MediaQuery.of(context).size.width - 70,
//                     child: LinearProgressIndicator(
//                       color: Colors.blue,
//                       value: progress,
//                     ),
//                   ),
//                 ),
//                 Text(
//                   '$percentage%',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ],
//             );
//           } else {
//             return Container(
//                 color: Colors.transparent,
//                 height: 10,
//                 child: LinearProgressIndicator());
//           }
//         },
//       );
// }
}
