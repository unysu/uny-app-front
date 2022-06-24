import 'dart:convert';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shimmer/shimmer.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uny_app/API/uny_app_api.dart';
import 'package:uny_app/Constants/constants.dart';
import 'package:uny_app/Data%20Models/Chats%20Data%20Model/all_chats_model.dart';
import 'package:uny_app/Data%20Models/Chats%20Data%20Model/room_messages_model.dart';
import 'package:uny_app/Providers/chat_data_provider.dart';
import 'package:uny_app/Providers/user_data_provider.dart';
import 'package:uny_app/Token%20Data/token_data.dart';

class UserChatPage extends StatefulWidget{

  Chats? chat;

  UserChatPage({required this.chat});

  @override
  _UserChatPageState createState() => _UserChatPageState();
}

class _UserChatPageState extends State<UserChatPage> with TickerProviderStateMixin{

  TextEditingController? _textMessageFieldController;
  FocusNode? _messageTextFocusNode;

  int? _currentlyEditingMessageIndex;

  late String token;

  late double height;
  late double width;

  late Chats chat;

  var formatter = DateFormat('yyyy-MM-dd');

  bool _isTyping = false;
  bool _isEditing = false;
  
  Future<Response<RoomMessagesModel>>? _chatMessagesFuture;

  StateSetter? iconState;

  List<Message>? _messagesList = [];

  double? _scale;
  List<AnimationController>? _controllerList = [];

  @override
  void initState() {

    token = 'Bearer ' + TokenData.getUserToken();

    chat = widget.chat!;

    _textMessageFieldController = TextEditingController();
    _messageTextFocusNode = FocusNode();

    if(chat.messages!.isNotEmpty){
      _chatMessagesFuture = UnyAPI.create(Constants.ROOM_MESSAGES_CONVERTER).getRoomMessages(
          token,
          widget.chat!.chatRoomId,
          formatter.format(DateTime.now()) + DateTime.parse(chat.messages!.last.createdAt).toLocal().hour.toString().padLeft(2, '0')
              + ':'
              + DateTime.parse(chat.messages!.last.createdAt).toLocal().minute.toString().padLeft(2, '0') + ':' + DateTime.parse(chat.messages!.last.createdAt).toLocal().second.toString().padLeft(2, '0'));
    }


    // if(Provider.of<ChatsDataProvider>(context, listen: false).roomMessages[chat.chatRoomId] != null){
    //   _messagesList = Provider.of<ChatsDataProvider>(context, listen: false).roomMessages[chat.chatRoomId];
    // }

    super.initState();
  }

  @override
  void dispose() {

    _messageTextFocusNode!.dispose();
    _textMessageFieldController!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        return ResponsiveWrapper.builder(
          Scaffold(
            extendBodyBehindAppBar: false,
            appBar: AppBar(
              elevation: 0.5,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              centerTitle: false,
              toolbarHeight: 70,
              leadingWidth: 30,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: Colors.grey),
              ),
              title: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        child: CachedNetworkImage(
                          imageUrl: chat.participants![0].media!.mainPhoto!.url,
                          imageBuilder: (context, imageProvider) => Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.4),
                                  spreadRadius: 10,
                                  blurRadius: 7,
                                ),
                              ],
                            ),
                          ),
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.white,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 2.5,
                        left: 2.7,
                        child: Container(
                          height: 55,
                          width: 55,
                          child: SimpleCircularProgressBar(
                            valueNotifier: ValueNotifier(double.parse(chat.participants![0].matchPercent.toString())),
                            backColor: Colors.grey[300]!,
                            animationDuration: 0,
                            mergeMode: true,
                            backStrokeWidth: 5,
                            progressStrokeWidth: 5,
                            startAngle: 210,
                            progressColors: [
                              Colors.deepOrange,
                              Colors.yellowAccent,
                              Colors.green
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 12,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          child: Text('${chat.participants![0].matchPercent.toString()} %', style: TextStyle(
                              color: Colors.white, fontSize: 11)),
                          decoration: BoxDecoration(
                            color: chat.participants![0].matchPercent < 49 ? Colors.red
                                : (chat.participants![0].matchPercent > 49 && chat.participants![0].matchPercent < 65)
                                ? Colors.orange : (chat.participants![0].matchPercent > 65) ? Colors.green : null,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${chat.participants![0].firstName}',
                        style: TextStyle(fontSize: 17, color: Colors.black),
                      ),
                      Text(
                        'В сети',
                        style: TextStyle(fontSize: 15, color: Colors.green),
                      )
                    ],
                  )
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () => null,
                  icon: Icon(Icons.more_horiz, color: Colors.grey),
                )
              ],
            ),
            body: GestureDetector(
              onTap: (){
                FocusManager.instance.primaryFocus!.unfocus();
              },
               child: getMessages() /*_messagesList!.isEmpty ? getMessages() : mainBody() */
            )
          ),
          maxWidth: 800,
          minWidth: 450,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.resize(450, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: MOBILE),
          ],
        );
      },
    );
  }

  FutureBuilder<Response<RoomMessagesModel>> getMessages(){
    return FutureBuilder<Response<RoomMessagesModel>>(
      future: _chatMessagesFuture,
      builder: (context, snapshot){
        while(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            heightFactor: 25,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Color.fromRGBO(145, 10, 251, 5),
            ),
          );
        }

        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          _messagesList = snapshot.data!.body!.messages;


          /* Map<int, List<Message>> _messagesMap = {
            chat.chatRoomId : _messagesList!
          };

          Provider.of<ChatsDataProvider>(context, listen: false).setRoomMessages(_messagesMap); */

          return mainBody();
        }else{
          return mainBody();
        }
      },
    );
  }

  Widget mainBody(){
    return Stack(
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/chats_background_image.png'),
                      fit: BoxFit.cover
                  )
              ),
            ),
          ],
        ),
        _messagesList!.isNotEmpty ? ListView.builder(
          itemCount: _messagesList!.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index){
            Message chatMessage = _messagesList![index];
            return  Container(
              padding: EdgeInsets.only(left: 16,right: 16,top: 5),
              child: Align(
                  alignment: chatMessage.userId == Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id ? Alignment.bottomRight : Alignment.bottomLeft,
                  child: FocusedMenuHolder(
                    openWithTap: false,
                    menuWidth: width / 2,
                    menuOffset: 10,
                    animateMenuItems: true,
                    duration: Duration(milliseconds: 250),
                    menuBoxDecoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    menuItems: chatMessage.userId == Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id ? [
                      FocusedMenuItem(
                          title: Text('Изменить', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                          trailingIcon: Icon(Icons.edit, color: Colors.grey),
                          backgroundColor: Color.fromRGBO(218, 218, 218, 10),
                          onPressed: () async {
                            _currentlyEditingMessageIndex = index;
                            _textMessageFieldController!.value = _textMessageFieldController!.value.copyWith(text: _messagesList![_currentlyEditingMessageIndex!].text);

                            setState((){
                              _isEditing = true;
                            });
                            _messageTextFocusNode!.requestFocus();
                          }
                      ),
                      FocusedMenuItem(
                          title: Text('Ответить', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                          trailingIcon: Icon(CupertinoIcons.reply_all, color: Colors.grey),
                          backgroundColor: Color.fromRGBO(218, 218, 218, 10),
                          onPressed: () => null
                      ),
                      FocusedMenuItem(
                          title: Text('Удалить', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.red)),
                          trailingIcon: Icon(Icons.delete_outline, color: Colors.red),
                          backgroundColor: Color.fromRGBO(218, 218, 218, 10),
                          onPressed: (){
                            if(UniversalPlatform.isIOS){
                              showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoActionSheet(
                                      actions: [
                                        CupertinoActionSheetAction(
                                          child: Text(
                                              'Удалить у меня и у ${chat.participants![0].firstName}', textAlign: TextAlign.center, style: TextStyle(color: Colors.red)),
                                          onPressed: () async {
                                            deleteMessage('', Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id, chat.participants![0].id, chatMessage.messageId);
                                          },
                                        ),
                                        CupertinoActionSheetAction(
                                          child: Text(
                                              'Удалить у меня', textAlign: TextAlign.center, style: TextStyle(color: Colors.red)),
                                          onPressed: () async {
                                            deleteMessage('for_me', Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id, null, chatMessage.messageId);
                                          },
                                        )
                                      ],
                                      cancelButton: CupertinoActionSheetAction(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Отмена', style: TextStyle(color: Color.fromRGBO(145, 10, 251, 10))),
                                      ),
                                    );
                                  }
                              );
                            }else if(UniversalPlatform.isAndroid){
                              showDialog(
                                  context: context,
                                  builder: (context){
                                    return AlertDialog(
                                      title: Text(
                                        'Вы уверены, что хотите выйти?',
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: (){
                                            deleteMessage('for_me', Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id, null, chatMessage.messageId);
                                          },
                                          child: Text('Удалить у меня', style: TextStyle(color: Colors.red)),
                                        ),
                                        TextButton(
                                          onPressed: (){
                                            deleteMessage('', Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id, chat.participants![0].id, chatMessage.messageId);
                                          },
                                          child: Text('Удалить у меня и у ${chat.participants![0].firstName}', style: TextStyle(color: Colors.lightBlue)),
                                        ),
                                      ],
                                    );
                                  }
                              );
                            }
                          }
                      ),
                      FocusedMenuItem(
                          title: Text('Выбрать', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                          trailingIcon: Icon(Icons.check_circle_outline, color: Colors.grey),
                          backgroundColor: Color.fromRGBO(218, 218, 218, 10),
                          onPressed: () => null
                      ),
                    ] : [
                      FocusedMenuItem(
                          title: Text('Ответить', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                          trailingIcon: Icon(CupertinoIcons.reply_all, color: Colors.grey),
                          backgroundColor: Color.fromRGBO(218, 218, 218, 10),
                          onPressed: () async {

                          }
                      ),
                      FocusedMenuItem(
                          title: Text('Пожаловаться', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                          trailingIcon: Icon(Icons.report_gmailerrorred, color: Colors.grey),
                          backgroundColor: Color.fromRGBO(218, 218, 218, 10),
                          onPressed: () => null
                      ),
                      FocusedMenuItem(
                          title: Text('Удалить', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.red)),
                          trailingIcon: Icon(Icons.delete_outline, color: Colors.red),
                          backgroundColor: Color.fromRGBO(218, 218, 218, 10),
                          onPressed: (){
                            if(UniversalPlatform.isIOS){
                              showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoActionSheet(
                                      actions: [
                                        CupertinoActionSheetAction(
                                          child: Text(
                                              'Удалить у меня и у ${chat.participants![0].firstName}', textAlign: TextAlign.center, style: TextStyle(color: Colors.red)),
                                          onPressed: () async {
                                            deleteMessage('', Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id, chat.participants![0].id, chatMessage.messageId);
                                          },
                                        ),
                                        CupertinoActionSheetAction(
                                          child: Text(
                                              'Удалить у меня', textAlign: TextAlign.center, style: TextStyle(color: Colors.red)),
                                          onPressed: () async {
                                            deleteMessage('for_me', Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id, null, chatMessage.messageId);
                                          },
                                        )
                                      ],
                                      cancelButton: CupertinoActionSheetAction(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Отмена', style: TextStyle(color: Color.fromRGBO(145, 10, 251, 10))),
                                      ),
                                    );
                                  }
                              );
                            }else if(UniversalPlatform.isAndroid){
                              showDialog(
                                  context: context,
                                  builder: (context){
                                    return AlertDialog(
                                      title: Text(
                                        'Вы уверены, что хотите выйти?',
                                        maxLines: 2,
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: (){
                                            deleteMessage('for_me', Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id, null, chatMessage.messageId);
                                          },
                                          child: Text('Удалить у меня', style: TextStyle(color: Colors.red)),
                                        ),
                                        TextButton(
                                          onPressed: (){
                                            deleteMessage('', Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id, chat.participants![0].id, chatMessage.messageId);
                                          },
                                          child: Text('Удалить у меня и у ${chat.participants![0].firstName}', style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    );
                                  }
                              );
                            }
                          }
                      ),
                      FocusedMenuItem(
                          title: Text('Выбрать', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                          trailingIcon: Icon(Icons.check_circle_outline, color: Colors.grey),
                          backgroundColor: Color.fromRGBO(218, 218, 218, 10),
                          onPressed: () => null
                      ),
                    ],
                    onPressed: () => null,
                    child: chatMessage.text == null ? Container() : Container(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(chatMessage.text, style: TextStyle(
                              color: chatMessage.userId == Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id ? Colors.white : Colors.black,
                              fontSize: 16
                          ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(chatMessage.isEdited != null && chatMessage.isEdited ? 'Ред.' : '', style: TextStyle(color: chatMessage.userId == Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5))),
                              SizedBox(width: 5),
                              Text(DateTime.parse(chatMessage.createdAt).toLocal().hour.toString().padLeft(2, '0') + ':' + DateTime.parse(chatMessage.createdAt).toLocal().minute.toString().padLeft(2, '0'),
                                style: TextStyle(color: chatMessage.userId == Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5)),
                              )
                            ],
                          )
                        ],
                      ),
                      decoration: chatMessage.userId != Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id ? BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                              bottomLeft: Radius.circular(0)
                          ),
                          color: Color.fromRGBO(237, 235, 235, 10)
                      ) : BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(0)
                          ),
                          color: Color.fromRGBO(145, 10, 251, 10)
                      ),
                    ),
                  )
              ),
            );
          },
        ) : Center(
          child: Text('У вас пока нет сообщений', style: TextStyle(fontSize: 18)),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 100),
                child: _isEditing ? Container(
                  height: height / 18,
                  padding: EdgeInsets.only(left: width / 8, right: width / 25),
                  color: Colors.white,
                  child: Container(
                    width: width,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.edit, color: Color.fromRGBO(145, 10, 251, 10)),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: VerticalDivider(
                            color: Colors.black,
                            thickness: 1,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Редактирование', style: TextStyle(color: Color.fromRGBO(145, 10, 251, 10))),
                            Text('${_messagesList![_currentlyEditingMessageIndex!].text}'),
                          ],
                        ),
                        SizedBox(width: width / 2.5),
                        IconButton(
                          icon: Icon(CupertinoIcons.clear_circled, color: Color.fromRGBO(145, 10, 251, 10)),
                          onPressed: (){
                            setState((){
                              _isEditing = false;
                              _textMessageFieldController!.clear();

                              FocusManager.instance.primaryFocus!.unfocus();
                            });
                          },
                        ),
                      ],
                    ),
                  )
                ) : Container(),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 100),
                height: height / 12,
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: IconButton(
                        onPressed: () => null,
                        icon: Icon(Icons.attach_file, color: Colors.grey),
                        splashRadius: 10,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Container(
                        height: 45,
                        width: 390,
                        child: TextFormField(
                          controller: _textMessageFieldController,
                          focusNode: _messageTextFocusNode,
                          cursorColor: Color.fromRGBO(145, 10, 251, 5),
                          textAlign: TextAlign.left,
                          textInputAction: TextInputAction.send,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10, bottom: height / 50),
                            filled: true,
                            hintText: 'Сообщение',
                            fillColor: Colors.grey.withOpacity(0.1),
                            suffixIcon: StatefulBuilder(
                              builder: (context, setState){
                                iconState = setState;
                                return IconButton(
                                    onPressed: _isTyping ? () => sendMessage() : _isEditing ? () => editMessage() : () => print('nullg'),
                                    splashRadius: 10,
                                    icon: AnimatedContainer(
                                      height: 30,
                                      width: 30,
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeInOutBack,
                                      child: _isTyping ? Center(
                                        child: Icon(Icons.arrow_upward, color: Colors.white),
                                      ) : _isEditing ? Center(
                                        child: Icon(Icons.check_circle, color: Color.fromRGBO(145, 10, 251, 10), size: 30),
                                      ) : Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
                                      decoration: _isTyping ? BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color.fromRGBO(145, 10, 251, 10)
                                      ) : null,
                                    )
                                );
                              },
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                borderSide: BorderSide(color: Colors.grey.withOpacity(0.1))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                borderSide: BorderSide(color: Colors.grey.withOpacity(0.1))),
                          ),

                          onChanged: (value) {
                            if(!_isEditing){
                              if(value == ''){
                                iconState!((){
                                  _isTyping = false;
                                });
                              }else{
                                iconState!((){
                                  _isTyping = true;
                                });
                              }
                            }
                          },


                          onFieldSubmitted: (value) async {
                            if(value != ''){
                              if(_isTyping){
                                sendMessage();
                              }else{
                                editMessage();
                              }
                            }else{
                              setState((){
                                _isTyping = false;
                              });
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        )
      ],
    );
  }

  void sendMessage() async {
    var data = {
      'chat_room_id' : chat.chatRoomId,
      'text' : _textMessageFieldController!.text
    };

    await UnyAPI.create(Constants.SIMPLE_MESSAGE_CONVERTER).sendMessage(token, data).then((value){
      _messagesList!.add(value.body!);
    });

    _textMessageFieldController!.clear();
    setState((){});
  }


  void editMessage() async {

    var data = {
      'message_id' : _messagesList![_currentlyEditingMessageIndex!].messageId,
      'text' : _textMessageFieldController!.text
    };

    await UnyAPI.create(Constants.SIMPLE_MESSAGE_CONVERTER).editMessage(token, data).then((value){
      _messagesList![_currentlyEditingMessageIndex!] = value.body!;
    });

    _textMessageFieldController!.clear();

    FocusManager.instance.primaryFocus!.unfocus();

    _isEditing = false;
    setState((){});
  }


  void deleteMessage(String forWho, int myId, int? participantId, int messageId) async {
    List<int> idList = [];
    var data;
    if(forWho == 'for_me'){
      idList.add(myId);
      data = {
         'message_id' : messageId,
         'remove_for' : jsonEncode(idList)
      };
    }else{
      idList.add(myId);
      idList.add(participantId!);
      data = {
        'message_id' : messageId,
        'remove_for' : jsonEncode(idList)
      };
    }

    await UnyAPI.create(Constants.SIMPLE_MESSAGE_CONVERTER).deleteMessage(token, data).whenComplete((){
      _messagesList!.removeWhere((element) => element.messageId == messageId);
      setState((){});

      idList.clear();
    });

    Navigator.pop(context);
  }

  bool isKeyboardOpened(){
    return MediaQuery.of(context).viewInsets.bottom != 0.0;
  }
}