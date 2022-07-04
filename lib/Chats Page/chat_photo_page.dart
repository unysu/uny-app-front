import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPhotoPage extends StatefulWidget{

  String? photoUrl;

  ChatPhotoPage({this.photoUrl});

  @override
  _ChatPhotoPageState createState() => _ChatPhotoPageState();
}

class _ChatPhotoPageState extends State<ChatPhotoPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Container(
          child: Hero(
            tag: widget.photoUrl!,
            child: AspectRatio(
              aspectRatio: 1,
              child: CachedNetworkImage(
                imageUrl: widget.photoUrl!,
                fit: BoxFit.cover,
                imageBuilder: (context, imageProvider) => Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.contain
                      )
                  ),
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}