import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chopper/chopper.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shimmer/shimmer.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uny_app/API/uny_app_api.dart';
import 'package:uny_app/Chats%20Page/chat_page_visibility.dart';
import 'package:uny_app/Chats%20Page/chat_photo_page.dart';
import 'package:uny_app/Chats%20Page/chat_video_player.dart';
import 'package:uny_app/Constants/constants.dart';
import 'package:uny_app/Data%20Models/Chats%20Data%20Model/all_chats_model.dart';
import 'package:uny_app/Data%20Models/Chats%20Data%20Model/room_messages_model.dart';
import 'package:uny_app/Data%20Models/Photo%20Search%20Data%20Model/photo_search_data_model.dart';
import 'package:uny_app/FCM%20Controller/notification_manager.dart';
import 'package:uny_app/Other%20Users%20Page/other_users_page.dart';
import 'package:uny_app/Providers/chat_counter_provider.dart';
import 'package:uny_app/Providers/chat_data_provider.dart';
import 'package:uny_app/Providers/user_data_provider.dart';
import 'package:uny_app/Token%20Data/token_data.dart';
import 'package:uny_app/Web%20Socket%20Settings/web_socket_settings.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class UserChatPage extends StatefulWidget{

  Chats? chat;
  Participants? participant;

  UserChatPage({Key? key, required this.chat, required this.participant}) : super(key: key);

  @override
  _UserChatPageState createState() => _UserChatPageState();
}


class _UserChatPageState extends State<UserChatPage> with SingleTickerProviderStateMixin{

  late SocketSettings socket;

  late String token;

  late double height;
  late double width;

  late Chats chat;

  late List<AssetPathEntity> albums;
  late List<AssetEntity> media;
  late List<Uint8List> mediaBytesList;

  late NotificationManager notificationManager;

  var formatter = DateFormat('yyyy-MM-dd');

  bool _isUserLoaded = false;

  Future<Response<RoomMessagesModel>>? _chatMessagesFuture;

  TextEditingController? _textMessageFieldController;
  FocusNode? _messageTextFocusNode;

  ScrollController? _controller;

  int? _currentlyEditingMessageIndex;
  int? _currentlyReplyingMessageIndex;

  bool _showSearch = false;
  bool _isSearching = false;
  bool _showMediaLoading = false;
  bool _isSendingMedia = false;
  bool _isTyping = false;
  bool _isReplying = false;
  bool _isEditing = false;
  bool _isSelecting = false;
  bool _showLoading = false;

  StateSetter? iconState;
  StateSetter? mediaState;
  StateSetter? chatListState;
  StateSetter? loadingBarState;
  StateSetter? mediaLoadingBarState;

  List<Message> _messagesList = [];
  List<Message> _messagesFilteredList = [];
  List<bool> _checkedMessages = [];

  File? _mediaFile;
  Uint8List? _mediaBytes;

  String? _mediaType;
  String? _selectedVideoDuration;

  Participants? participant;

  Matches? matches;

  @override
  void initState() {

    _fetchAlbums();

    token = 'Bearer ' + TokenData.getUserToken();

    chat = widget.chat!;
    participant = widget.participant;

    socket = SocketSettings.init();
    socket.joinRoom(chat.chatRoomId.toString());

    _controller = ScrollController();
    
    _textMessageFieldController = TextEditingController();
    _messageTextFocusNode = FocusNode();

    notificationManager = NotificationManager.init();

    if(chat.messages!.isNotEmpty){
      _chatMessagesFuture = UnyAPI.create(Constants.ROOM_MESSAGES_CONVERTER).getRoomMessages(
          token,
          widget.chat!.chatRoomId,
          formatter.format(DateTime.now()) + DateTime.parse(chat.messages!.last.createdAt).toLocal().hour.toString().padLeft(2, '0')
              + ':'
              + DateTime.parse(chat.messages!.last.createdAt).toLocal().minute.toString().padLeft(2, '0') + ':' + DateTime.parse(chat.messages!.last.createdAt).toLocal().second.toString().padLeft(2, '0'));
    }else{
      _chatMessagesFuture = UnyAPI.create(Constants.ROOM_MESSAGES_CONVERTER).getRoomMessages(
          token,
          widget.chat!.chatRoomId,
          formatter.format(DateTime.now()) + DateTime.now().toLocal().hour.toString().padLeft(2, '0')
              + ':'
              + DateTime.now().toLocal().minute.toString().padLeft(2, '0') + ':' + DateTime.now().toLocal().second.toString().padLeft(2, '0'));
    }



    socket.getStream()!.listen((event) {
      if(utf8.decode(event).contains('msg')){
        Map<String, dynamic> data = jsonDecode(utf8.decode(event));

        Message message = Message.fromJson(jsonDecode(data['msg']));

        if(!(_messagesFilteredList.contains(message))){
          _messagesFilteredList.add(message);
        }

        Provider.of<ChatsDataProvider>(context, listen: false).setLastMessage(chat.chatRoomId, _messagesFilteredList.last.text);
        Provider.of<ChatsDataProvider>(context, listen: false).setLastMessageTime(chat.chatRoomId, _messagesFilteredList.last.createdAt);

        setState((){});
      }else if(utf8.decode(event).contains('edited_message')){
        Map<String, dynamic> data = jsonDecode(utf8.decode(event));

        Message message = Message.fromJson(jsonDecode(data['edited_message']));

        int index = _messagesFilteredList.indexWhere((element) => element.messageId == message.messageId);

        _messagesFilteredList[index] = message;

        if(_messagesFilteredList.last == _messagesFilteredList[index]){
          Provider.of<ChatsDataProvider>(context, listen: false).setLastMessage(chat.chatRoomId, _messagesFilteredList.last.text);
          Provider.of<ChatsDataProvider>(context, listen: false).setLastMessageTime(chat.chatRoomId, _messagesFilteredList.last.createdAt);
        }

        setState((){});

      }else if(utf8.decode(event).contains('deleted_message_id')){
        Map<String, dynamic> data = jsonDecode(utf8.decode(event));

        String id = data['deleted_message_id'];

        _messagesFilteredList.removeWhere((element) => element.messageId.toString() == id.toString());

        if(_messagesFilteredList.isNotEmpty){
          Provider.of<ChatsDataProvider>(context, listen: false).setLastMessage(chat.chatRoomId, _messagesFilteredList.last.text);
          Provider.of<ChatsDataProvider>(context, listen: false).setLastMessageTime(chat.chatRoomId, _messagesFilteredList.last.createdAt);
        }

        setState((){});
      }else if(utf8.decode(event).contains('clear_chat')){
        _messagesFilteredList.clear();

        Provider.of<ChatsDataProvider>(context, listen: false).setLastMessage(chat.chatRoomId, null);
        Provider.of<ChatsDataProvider>(context, listen: false).setLastMessageTime(chat.chatRoomId, null);
        setState((){});
      }
    });


    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Participants _participants = chat.participants!.where((element) => element.id.toString() != Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id.toString()).first;

      Response<Matches> user = await UnyAPI.create(Constants.MATCHES_JSON_CONVERTER).getUserById(token, _participants.id.toString());
      matches = user.body;

      setState((){
        _isUserLoaded = true;
      });
    });

    var bytes = utf8.encode(chat.chatRoomId.toString());
    ChatPageVisibility.openedChatId = sha256.convert(bytes).toString();

    super.initState();
  }


  @override
  void dispose() {

    _chatMessagesFuture = null;
    _messageTextFocusNode!.dispose();
    _textMessageFieldController!.dispose();

    ChatPageVisibility.openedChatId = '';

    super.dispose();
  }

  _fetchAlbums() async {
    albums = await PhotoManager.getAssetPathList(onlyAll: true);
    media = await albums[0].getAssetListPaged(page: 0, size: 10000);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        return Material(
          child: ResponsiveWrapper.builder(
            Scaffold(
                extendBodyBehindAppBar: false,
                appBar: AppBar(
                  elevation: 0.5,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  centerTitle: _isSelecting ? true : false,
                  toolbarHeight: 70,
                  leadingWidth: _isSelecting ? 100 : _showSearch ? 0 : 30,
                  leading: _isSelecting ? TextButton(
                    child: Text('Очистить', style: TextStyle(color: Color.fromRGBO(145, 10, 251, 10), fontSize: 15)),
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                    ),
                    onPressed: (){
                      if(UniversalPlatform.isIOS){
                        showCupertinoModalPopup(
                            context: context,
                            builder: (context) {
                              return CupertinoActionSheet(
                                title: Column(
                                  children: const [
                                    Text('Вы уверены, что хотите очистить историю?', style: TextStyle(color: Colors.black, fontSize: 12)),
                                    Text('Сообщения в этом чате также удалятся у собеседника', style: TextStyle(color: Colors.black, fontSize: 12)),
                                    Text('Это действие невозможно отменить', style: TextStyle(color: Colors.red))
                                  ],
                                ),
                                actions: [
                                  CupertinoActionSheetAction(
                                      child: Text('Очистить историю', textAlign: TextAlign.center, style: TextStyle(color: Colors.red)),
                                      onPressed: () => clearChat()
                                  )
                                ],
                                cancelButton: CupertinoActionSheetAction(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Отмена', style: TextStyle(color: Colors.blue)),
                                ),
                              );
                            }
                        );
                      }else if(UniversalPlatform.isAndroid){
                        showDialog(
                            context: context,
                            builder: (context){
                              return AlertDialog(
                                title: Column(
                                  children: const [
                                    Text('Вы уверены, что хотите очистить историю?', style: TextStyle(color: Colors.black, fontSize: 12), textAlign: TextAlign.center),
                                    Text('Сообщения в этом чате также удалятся у собеседника', style: TextStyle(color: Colors.black, fontSize: 12), textAlign: TextAlign.center),
                                    Text('Это действие невозможно отменить', style: TextStyle(color: Colors.red, fontSize: 12))
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => clearChat(),
                                    child: Text('Очистить историю', style: TextStyle(color: Colors.red)),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Отмена', style: TextStyle(color: Colors.lightBlue)),
                                  ),
                                ],
                              );
                            }
                        );
                      }
                    },
                  ) : _showSearch ? Container() : IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back, color: Colors.grey),
                  ),
                  title: _isSelecting ? Consumer<ChatCounterProvider>(
                    builder: (context, viewModel, child){
                      return Container(
                        child: Text('${viewModel.chatCount} выбрано' , style: TextStyle(color: Colors.black)),
                      );
                    },
                  ) : _showSearch ? StatefulBuilder(
                    builder: (context, searchBarState){
                      return SizedBox(
                        height: 50,
                        width: width,
                        child: TextFormField(
                          cursorColor: Color.fromRGBO(145, 10, 251, 5),
                          autofocus: true,
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 20, left: 20),
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.1),
                            prefixIcon: _isSearching != true ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(CupertinoIcons.search, color: Colors.grey),
                                Text('Поиск сообщений',
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.grey))
                              ],
                            ) : null,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                borderSide: BorderSide(color: Colors.grey.withOpacity(0.1))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                borderSide: BorderSide(color: Colors.grey.withOpacity(0.1))),
                          ),
                          onTap: () {
                            searchBarState(() {
                              _isSearching = true;
                            });
                          },

                          onChanged: (value){

                            _messagesFilteredList = _messagesList.where((element) => element.text.toString().toLowerCase().contains(value.toString().toLowerCase())).toList();
                            chatListState!((){});

                            if (value.isEmpty) {
                              searchBarState(() {
                                _isSearching = false;
                              });
                            } else {
                              searchBarState(() {
                                _isSearching = true;
                              });
                            }
                          },
                        ),
                      );
                    },
                  ) : GestureDetector(
                    onTap: _isUserLoaded ? (){
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => OtherUsersPage(user: matches!))
                      );
                    } : null,
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: participant!.media!.mainPhoto != null ? CachedNetworkImage(
                                imageUrl: participant!.media!.mainPhoto!.url,
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
                              ) : Container(
                                height: 60,
                                width: 60,
                                child: Center(
                                  child: Icon(Icons.person, size: 30, color: Colors.grey),
                                ),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle
                                ),
                              ),
                            ),
                            Positioned(
                              child: ClipOval(
                                child: SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: SimpleCircularProgressBar(
                                    valueNotifier: ValueNotifier(double.parse(participant!.matchPercent.toString())),
                                    backColor: Colors.grey[300]!,
                                    animationDuration: 0,
                                    mergeMode: true,
                                    backStrokeWidth: 9,
                                    progressStrokeWidth: 9,
                                    startAngle: 210,
                                    progressColors: const [
                                      Colors.deepOrange,
                                      Colors.yellowAccent,
                                      Colors.green
                                    ],
                                  ),
                                ),
                              )
                            ),
                            Positioned(
                              bottom: 0,
                              left: 6,
                              right: 6,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                child: Center(
                                  child: Text('${participant!.matchPercent.toString()} %', style: TextStyle(
                                      color: Colors.white, fontSize: 11)),
                                ),
                                decoration: BoxDecoration(
                                  color: participant!.matchPercent < 49 ? Colors.red
                                      : (participant!.matchPercent > 49 && participant!.matchPercent < 65)
                                      ? Colors.orange : (participant!.matchPercent > 65) ? Colors.green : null,
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
                              '${participant!.firstName}',
                              style: TextStyle(fontSize: 17, color: Colors.black), maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'В сети',
                              style: TextStyle(fontSize: 15, color: Colors.green),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  actions: [
                    _isSelecting ? TextButton(
                      child: Text('Отмена', style: TextStyle(color: Color.fromRGBO(145, 10, 251, 10), fontSize: 15)),
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                      ),
                      onPressed: (){
                        Provider.of<ChatCounterProvider>(context, listen: false).resetCount();

                        setState((){
                          _isSelecting = false;
                        });
                      },
                    ) : _showSearch ? TextButton(
                      child: Text('Отмена', style: TextStyle(color: Color.fromRGBO(145, 10, 251, 10))),
                      onPressed: () => setState(() => _showSearch = false),
                    ) : IconButton(
                      icon: Icon(Icons.more_horiz, color: Colors.grey),
                      onPressed: (){
                        if(UniversalPlatform.isIOS){
                          showCupertinoModalPopup(
                            context: context,
                            barrierColor: Colors.black.withOpacity(0.5),
                            builder: (context){
                              return CupertinoActionSheet(
                                actions: [
                                  CupertinoActionSheetAction(
                                      onPressed: (){
                                        setState(() => _showSearch = true);

                                        Navigator.pop(context);
                                      },
                                      child: Row(
                                        children: const [
                                          Icon(CupertinoIcons.search, color: Colors.blue),
                                          SizedBox(width: 10),
                                          Text('Поиск сообщений', style: TextStyle(color: Colors.blue)),
                                        ],
                                      )
                                  ),

                                  CupertinoActionSheetAction(
                                      onPressed: () => Navigator.pop(context),
                                      child: Row(
                                        children: const [
                                          Icon(CupertinoIcons.volume_off, color: Colors.blue),
                                          SizedBox(width: 10),
                                          Text('Отключить уведомления', style: TextStyle(color: Colors.blue)),
                                        ],
                                      )
                                  ),

                                  CupertinoActionSheetAction(
                                      onPressed: () => Navigator.pop(context),
                                      child: Row(
                                        children: const [
                                          Icon(CupertinoIcons.photo_on_rectangle, color: Colors.blue),
                                          SizedBox(width: 10),
                                          Text('Показать вложения', style: TextStyle(color: Colors.blue)),
                                        ],
                                      )
                                  ),

                                  CupertinoActionSheetAction(
                                      onPressed: () => Navigator.pop(context),
                                      child: Row(
                                        children: const [
                                          Icon(CupertinoIcons.trash, color: Colors.red),
                                          SizedBox(width: 10),
                                          Text('Очистить историю', style: TextStyle(color: Colors.red)),
                                        ],
                                      )
                                  ),
                                ],
                                cancelButton: CupertinoActionSheetAction(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Отмена', style: TextStyle(color: Colors.blue)),
                                ),
                              );
                            }
                          );
                        }else if(UniversalPlatform.isAndroid){
                          showModalBottomSheet(
                            context: context,
                            barrierColor: Colors.black.withOpacity(0.5),
                            builder: (context){
                              return Container(
                                child: Wrap(
                                  children: [
                                    ListTile(
                                      title: Text('Поиск сообщений', style: TextStyle(color: Colors.blue)),
                                      leading: Icon(CupertinoIcons.search, color: Colors.blue),
                                      onTap: (){
                                        setState(() => _showSearch = true);

                                        Navigator.pop(context);
                                      }
                                    ),
                                    ListTile(
                                      title: Text('Отключить уведомления', style: TextStyle(color: Colors.blue)),
                                      leading: Icon(CupertinoIcons.volume_off, color: Colors.blue),
                                      onTap: () => null,
                                    ),
                                    ListTile(
                                      title: Text('Показать вложения', style: TextStyle(color: Colors.blue)),
                                      leading: Icon(CupertinoIcons.photo_on_rectangle, color: Colors.blue),
                                      onTap: () => null,
                                    ),
                                    ListTile(
                                      title: Text('Очистить историю', style: TextStyle(color: Colors.red)),
                                      leading: Icon(CupertinoIcons.trash, color: Colors.red),
                                      onTap: () => null,
                                    ),
                                    SizedBox(height: 50),
                                    ListTile(
                                      title: Center(
                                        child: Text('Отмена', style: TextStyle(color: Colors.blue)),
                                      ),
                                      onTap: () => Navigator.pop(context),
                                    )
                                  ],
                                ),
                              );
                            }
                          );
                        }
                      },
                    )
                  ],
                ),
                body: Container(
                  child: Stack(
                    children: [
                      GestureDetector(
                          onTap: (){
                            FocusManager.instance.primaryFocus!.unfocus();
                          },
                          child: getMessages()
                      ),
                      StatefulBuilder(
                        builder: (context, setState){
                          loadingBarState = setState;
                          return _showLoading ? Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                height: 80,
                                width: 80,
                                color: Colors.black.withOpacity(0.7),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ) : Container();
                        },
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/chats_background_image.png'),
                          fit: BoxFit.cover
                      )
                  ),
                )
            ),
            maxWidth: 800,
            minWidth: 450,
            defaultScale: true,
            breakpoints: [
              ResponsiveBreakpoint.resize(450, name: MOBILE),
              ResponsiveBreakpoint.autoScale(800, name: MOBILE),
            ],
          ),
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
          _messagesList = snapshot.data!.body!.messages!;
          _messagesFilteredList = _messagesList;
          
          _checkedMessages = List.generate(_messagesFilteredList.length, (index) => false);

          Provider.of<ChatCounterProvider>(context, listen: false).setCheckBoxList(_checkedMessages);

          return mainBody();
        }else{
          return mainBody();
        }
      },
    );
  }

  Widget mainBody(){
    return StatefulBuilder(
      builder: (context, listState){
        chatListState = listState;
        return _messagesFilteredList.isNotEmpty ? Container(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      reverse: true,
                      controller: _controller,
                      itemCount: _messagesFilteredList.length,
                      itemBuilder: (context, index){

                        int itemCount = _messagesFilteredList.length;
                        int reversedIndex = itemCount - 1 - index;

                        Message chatMessage = _messagesFilteredList[reversedIndex];
                          return Container(
                            padding: EdgeInsets.only(left: 16, top: 5),
                            child: Align(
                                alignment: Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id == chatMessage.userId ? Alignment.bottomRight : Alignment.bottomLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: FocusedMenuHolder(
                                      onPressed: (){},
                                      openWithTap: false,
                                      menuWidth: width / 2,
                                      menuOffset: 10,
                                      animateMenuItems: true,
                                      duration: Duration(milliseconds: 150),
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
                                              _textMessageFieldController!.value = _textMessageFieldController!.value.copyWith(text: _messagesList[_currentlyEditingMessageIndex!].text);

                                              setState((){
                                                _isTyping = false;
                                                _isEditing = true;
                                              });
                                              _messageTextFocusNode!.requestFocus();
                                            }
                                        ),
                                        FocusedMenuItem(
                                            title: Text('Ответить', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                                            trailingIcon: Icon(CupertinoIcons.reply_all, color: Colors.grey),
                                            backgroundColor: Color.fromRGBO(218, 218, 218, 10),
                                            onPressed: (){
                                              _currentlyReplyingMessageIndex = index;
                                              setState((){
                                                _isReplying = true;
                                              });
                                            }
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
                                                                'Удалить у меня и у ${participant!.firstName}', textAlign: TextAlign.center, style: TextStyle(color: Colors.red)),
                                                            onPressed: () async {
                                                              deleteMessage('', Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id, participant!.id, chatMessage.messageId);
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
                                                              deleteMessage('', Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id, participant!.id, chatMessage.messageId);
                                                            },
                                                            child: Text('Удалить у меня и у ${participant!.firstName}', style: TextStyle(color: Colors.lightBlue)),
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
                                            onPressed: (){
                                              setState((){
                                                _isSelecting = true;
                                              });
                                            }
                                        ),
                                      ] : [
                                        FocusedMenuItem(
                                            title: Text('Ответить', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                                            trailingIcon: Icon(CupertinoIcons.reply_all, color: Colors.grey),
                                            backgroundColor: Color.fromRGBO(218, 218, 218, 10),
                                            onPressed: () async {
                                              _currentlyReplyingMessageIndex = index;
                                              setState((){
                                                _isReplying = true;
                                              });
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
                                                                'Удалить у меня и у ${participant!.firstName}', textAlign: TextAlign.center, style: TextStyle(color: Colors.red)),
                                                            onPressed: () async {
                                                              deleteMessage('', Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id, participant!.id, chatMessage.messageId);
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
                                                              deleteMessage('', Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id, participant!.id, chatMessage.messageId);
                                                            },
                                                            child: Text('Удалить у меня и у ${participant!.firstName}', style: TextStyle(color: Colors.lightBlue)),
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
                                            onPressed: (){
                                              setState((){
                                                _isSelecting = true;
                                              });
                                            }
                                        ),
                                      ],
                                      child: chatMessage.media == null && chatMessage.text == null ? Container() : chatMessage.media != null && chatMessage.text == null
                                          ? Consumer<ChatCounterProvider>(
                                        builder: (context, viewModel, child){
                                          return Row(
                                            mainAxisSize: Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id == chatMessage.userId && _isSelecting ? MainAxisSize.max : MainAxisSize.min,
                                            mainAxisAlignment: Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id == chatMessage.userId ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                                            children: [
                                              _isSelecting ? Transform.scale(
                                                scale: 1.2,
                                                child: Checkbox(
                                                  value: viewModel.getMessageIndexValue(index),
                                                  onChanged: (value){
                                                    viewModel.changeSelectedMessageValue(index, value!);

                                                    if(viewModel.getMessageIndexValue(index)){
                                                      Provider.of<ChatCounterProvider>(context, listen: false).addCount();
                                                    }else{
                                                      Provider.of<ChatCounterProvider>(context, listen: false).decrementCount();
                                                    }

                                                  },
                                                  shape: CircleBorder(),
                                                  checkColor: Colors.white,
                                                  side: BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                  splashRadius: UniversalPlatform.isIOS ? 2 : null,
                                                  activeColor: Color.fromRGBO(145, 10, 251, 5),
                                                ),
                                              ) : Container(),
                                              Stack(
                                                children: [
                                                  GestureDetector(
                                                    onTap: _isSelecting ? (){
                                                      if(viewModel.getMessageIndexValue(index)){
                                                        viewModel.changeSelectedMessageValue(index, false);
                                                        Provider.of<ChatCounterProvider>(context, listen: false).decrementCount();
                                                      }else{
                                                        viewModel.changeSelectedMessageValue(index, true);
                                                        Provider.of<ChatCounterProvider>(context, listen: false).addCount();
                                                      }
                                                    } : chatMessage.media != null ? chatMessage.media[0]['type'].toString().startsWith('video') ? (){
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context) => ChatVideoPlayer(url: chatMessage.media[0]['media']))
                                                      );
                                                    } : (){
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context) => ChatPhotoPage(photoUrl: chatMessage.media[0]['media']))
                                                      );
                                                    } : null,
                                                    child: Container(
                                                      padding: chatMessage.media == null && chatMessage.text != null
                                                          ? EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10)
                                                          : chatMessage.media != null && chatMessage.text == null
                                                          ? EdgeInsets.all(5)
                                                          : chatMessage.media != null && chatMessage.text != null
                                                          ? EdgeInsets.only(top: 10) : null,
                                                      child: Stack(
                                                        children: [
                                                          SizedBox(
                                                            height: 200,
                                                            width: 200,
                                                            child: Hero(
                                                              tag: chatMessage.media[0]['media'].toString(),
                                                              child: CachedNetworkImage(
                                                                imageUrl: chatMessage.media[0]['type'].toString().startsWith('video') ? chatMessage.media[0]['thumbnail'] : chatMessage.media[0]['media'],
                                                                imageBuilder: (context, imageProvider){
                                                                  return Container(
                                                                    height: 100,
                                                                    width: 100,
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                                                      image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                                                    ),
                                                                  );
                                                                },
                                                                placeholder: (context, url) => Shimmer.fromColors(
                                                                  baseColor: Colors.grey[300]!,
                                                                  highlightColor: Colors.white,
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                                                      color: Colors.grey,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                            top: 80,
                                                            left: 80,
                                                            child: chatMessage.media[0]['type'].toString().startsWith('video') ? Container(
                                                              height: 50,
                                                              width: 50,
                                                              child: Center(
                                                                child: Icon(CupertinoIcons.play_arrow_solid, color: Colors.black),
                                                              ),
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape.circle,
                                                                  color: Colors.white
                                                              ),
                                                            ) : Container(),
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
                                                  ),
                                                  Positioned(
                                                    bottom: 15,
                                                    right: 20,
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Text(chatMessage.isEdited != null && chatMessage.isEdited ? 'Ред.' : '', style: TextStyle(color: chatMessage.userId == Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5))),
                                                        SizedBox(width: 5),
                                                        Text(DateTime.parse(chatMessage.createdAt).toLocal().hour.toString().padLeft(2, '0') + ':' + DateTime.parse(chatMessage.createdAt).toLocal().minute.toString().padLeft(2, '0'),
                                                          style: TextStyle(color: chatMessage.userId == Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.5)),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          );
                                        },
                                      ) : chatMessage.media != null && chatMessage.text != null ? Consumer<ChatCounterProvider>(
                                        builder: (context, viewModel, child){
                                          return Row(
                                            mainAxisSize: Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id == chatMessage.userId && _isSelecting ? MainAxisSize.max : MainAxisSize.min,
                                            mainAxisAlignment: Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id == chatMessage.userId ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                                            children: [
                                              _isSelecting ? Transform.scale(
                                                scale: 1.2,
                                                child: Checkbox(
                                                  value: viewModel.getMessageIndexValue(index),
                                                  onChanged: (value){
                                                    viewModel.changeSelectedMessageValue(index, value!);

                                                    if(viewModel.getMessageIndexValue(index)){
                                                      Provider.of<ChatCounterProvider>(context, listen: false).addCount();
                                                    }else{
                                                      Provider.of<ChatCounterProvider>(context, listen: false).decrementCount();
                                                    }

                                                  },
                                                  shape: CircleBorder(),
                                                  checkColor: Colors.white,
                                                  side: BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                  splashRadius: UniversalPlatform.isIOS ? 2 : null,
                                                  activeColor: Color.fromRGBO(145, 10, 251, 5),
                                                ),
                                              ) : Container(),
                                              Stack(
                                                children: [
                                                  GestureDetector(
                                                    onTap: _isSelecting ? (){
                                                      if(viewModel.getMessageIndexValue(index)){
                                                        viewModel.changeSelectedMessageValue(index, false);
                                                        Provider.of<ChatCounterProvider>(context, listen: false).decrementCount();
                                                      }else{
                                                        viewModel.changeSelectedMessageValue(index, true);
                                                        Provider.of<ChatCounterProvider>(context, listen: false).addCount();
                                                      }
                                                    } : chatMessage.media != null ? chatMessage.media[0]['type'].toString().startsWith('video') ? (){
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context) => ChatVideoPlayer(url: chatMessage.media[0]['media']))
                                                      );
                                                    } : (){
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context) => ChatPhotoPage(photoUrl: chatMessage.media[0]['media']))
                                                      );
                                                    } : null,
                                                    child: Container(
                                                      padding: chatMessage.media == null && chatMessage.text != null
                                                          ? EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10)
                                                          : chatMessage.media != null && chatMessage.text == null
                                                          ? EdgeInsets.all(0)
                                                          : chatMessage.media != null && chatMessage.text != null
                                                          ? EdgeInsets.all(5) : null,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets.only(left: 10),
                                                            width: 200,
                                                            child: Text(chatMessage.text, style: TextStyle(
                                                              color: chatMessage.userId == Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id ? Colors.white : Colors.black,
                                                              fontSize: 16,
                                                            ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 5),
                                                          Stack(
                                                            children: [
                                                              SizedBox(
                                                                  height: 200,
                                                                  width: 200,
                                                                  child: Hero(
                                                                    tag: chatMessage.media[0]['media'],
                                                                    child: CachedNetworkImage(
                                                                      imageUrl: chatMessage.media[0]['type'].toString().startsWith('video') ? chatMessage.media[0]['thumbnail'] : chatMessage.media[0]['media'],
                                                                      imageBuilder: (context, imageProvider) => Container(
                                                                        width: 100,
                                                                        height: 100,
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                                                          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                                                        ),
                                                                      ),
                                                                      placeholder: (context, url) => Shimmer.fromColors(
                                                                        baseColor: Colors.grey[300]!,
                                                                        highlightColor: Colors.white,
                                                                        child: Container(
                                                                          decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.all(Radius.circular(20)),
                                                                            color: Colors.grey,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                              ),
                                                              Positioned(
                                                                top: 80,
                                                                left: 80,
                                                                child: chatMessage.media[0]['type'].toString().startsWith('video') ? Container(
                                                                  height: 50,
                                                                  width: 50,
                                                                  child: Center(
                                                                    child: Icon(CupertinoIcons.play_arrow_solid, color: Colors.black),
                                                                  ),
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape.circle,
                                                                      color: Colors.white
                                                                  ),
                                                                ) : Container(),
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
                                                  ),
                                                  Positioned(
                                                    bottom: 15,
                                                    right: 20,
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Text(chatMessage.isEdited != null && chatMessage.isEdited ? 'Ред.' : '', style: TextStyle(color: chatMessage.userId == Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5))),
                                                        SizedBox(width: 5),
                                                        Text(DateTime.parse(chatMessage.createdAt).toLocal().hour.toString().padLeft(2, '0') + ':' + DateTime.parse(chatMessage.createdAt).toLocal().minute.toString().padLeft(2, '0'),
                                                          style: TextStyle(color: chatMessage.userId == Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.5)),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          );
                                        },
                                      ) : Consumer<ChatCounterProvider>(
                                        builder: (context, viewModel, child){
                                          return Row(
                                            mainAxisSize: Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id == chatMessage.userId && _isSelecting ? MainAxisSize.max : MainAxisSize.min,
                                            mainAxisAlignment: Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id == chatMessage.userId ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                                            children: [
                                              _isSelecting ? Transform.scale(
                                                scale: 1.2,
                                                child: Checkbox(
                                                  value: viewModel.getMessageIndexValue(index),
                                                  onChanged: (value){
                                                    viewModel.changeSelectedMessageValue(index, value!);

                                                    if(viewModel.getMessageIndexValue(index)){
                                                      Provider.of<ChatCounterProvider>(context, listen: false).addCount();
                                                    }else{
                                                      Provider.of<ChatCounterProvider>(context, listen: false).decrementCount();
                                                    }

                                                  },
                                                  shape: CircleBorder(),
                                                  checkColor: Colors.white,
                                                  side: BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                  splashRadius: UniversalPlatform.isIOS ? 2 : null,
                                                  activeColor: Color.fromRGBO(145, 10, 251, 5),
                                                ),
                                              ) : Container(),
                                              GestureDetector(
                                                onTap: _isSelecting ? (){
                                                  if(viewModel.getMessageIndexValue(index)){
                                                    viewModel.changeSelectedMessageValue(index, false);
                                                    Provider.of<ChatCounterProvider>(context, listen: false).decrementCount();
                                                  }else{
                                                    viewModel.changeSelectedMessageValue(index, true);
                                                    Provider.of<ChatCounterProvider>(context, listen: false).addCount();
                                                  }
                                                } : chatMessage.media != null ? chatMessage.media[0]['type'].toString().startsWith('video') ? (){
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => ChatVideoPlayer(url: chatMessage.media[0]['media']))
                                                  );
                                                } : (){
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => ChatPhotoPage(photoUrl: chatMessage.media[0]['media']))
                                                  );
                                                } : null,
                                                child: Container(
                                                  padding: chatMessage.media == null && chatMessage.text != null
                                                      ? EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10)
                                                      : chatMessage.media != null && chatMessage.text == null
                                                      ? EdgeInsets.all(0)
                                                      : chatMessage.media != null && chatMessage.text != null
                                                      ? EdgeInsets.only(top: 15) : null,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      _messagesFilteredList[index].replyTo != null ? SizedBox(
                                                          height: 40,
                                                          width: 150,
                                                          child: Row(
                                                            children: [
                                                              VerticalDivider(
                                                                color: Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id == _messagesFilteredList[index].userId ? Colors.white : Colors.black,
                                                                thickness: 2,
                                                              ),
                                                              _messagesFilteredList[index].replyTo['media'] != null ?
                                                              SizedBox(
                                                                height: 40,
                                                                width: 40,
                                                                child: CachedNetworkImage(
                                                                  imageUrl: _messagesFilteredList[index].replyTo['media'][0]['type'].toString().startsWith('video')
                                                                      ? _messagesFilteredList[index].replyTo['media'][0]['thumbnail']
                                                                      : _messagesFilteredList[index].replyTo['media'][0]['media'],
                                                                  imageBuilder: (context, imageProvider) => Container(
                                                                    height: 40,
                                                                    width: 40,
                                                                    decoration: BoxDecoration(
                                                                        image: DecorationImage(
                                                                            image: imageProvider
                                                                        )
                                                                    ),
                                                                  ),
                                                                ),
                                                              ) : Container(),
                                                              SizedBox(width: 5),
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id == _messagesFilteredList[index].replyTo['user_id']
                                                                        ? '${Provider.of<UserDataProvider>(context, listen: false).userDataModel!.firstName}' : '${participant!.firstName}',
                                                                    style: TextStyle(color: Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id == _messagesFilteredList[index].userId ? Colors.white : Colors.black, fontSize: 17, fontWeight: FontWeight.w600),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 80,
                                                                    child: Text(
                                                                      _messagesFilteredList[index].replyTo['text'],
                                                                      style: TextStyle(
                                                                          fontSize: 14,
                                                                          color: Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id == _messagesFilteredList[index].userId ? Colors.white : Colors.black,
                                                                          overflow: TextOverflow.ellipsis),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          )
                                                      ) : Container(),
                                                      SizedBox(height: 5),
                                                      Wrap(
                                                        alignment: WrapAlignment.center,
                                                        crossAxisAlignment: WrapCrossAlignment.end,
                                                        spacing: 3,
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets.only(left:5, bottom: 5),
                                                            width: chatMessage.text.toString().length > 70 ? width * 0.8 : null,
                                                            child: Text(chatMessage.text, style: TextStyle(
                                                              color: chatMessage.userId == Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id ? Colors.white : Colors.black,
                                                              fontSize: 16,
                                                            ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 5),
                                                          Text(chatMessage.isEdited != null && chatMessage.isEdited ? 'Ред.' : '', style: TextStyle(color: chatMessage.userId == Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5))),
                                                          SizedBox(width: 5),
                                                          Text(DateTime.parse(chatMessage.createdAt).toLocal().hour.toString().padLeft(2, '0') + ':' + DateTime.parse(chatMessage.createdAt).toLocal().minute.toString().padLeft(2, '0'),
                                                            style: TextStyle(color: chatMessage.userId == Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5), fontSize: 12),
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
                                            ],
                                          );
                                        },
                                      )
                                  ),
                                )
                            ),
                          );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AnimatedContainer(
                              duration: Duration(milliseconds: 100),
                              child: _isEditing ? Container(
                                  height: height / 18,
                                  padding: EdgeInsets.only(left: width / 8, right: width / 25),
                                  color: Colors.white,
                                  child: SizedBox(
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
                                            Text('${_messagesFilteredList[_currentlyEditingMessageIndex!].text ?? ''}'),
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
                              ) : _isReplying ? Container(
                                  height: height / 13,
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  color: Colors.white,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 5),
                                    padding: EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 10),
                                          child: VerticalDivider(
                                            color: Colors.black,
                                            thickness: 1,
                                          ),
                                        ),
                                        _messagesFilteredList[_currentlyReplyingMessageIndex!].media != null ? SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: CachedNetworkImage(
                                              imageUrl: _messagesFilteredList[_currentlyReplyingMessageIndex!].media[0]['type'].toString().startsWith('video')
                                                  ? _messagesFilteredList[_currentlyReplyingMessageIndex!].media[0]['thumbnail']
                                                  : _messagesFilteredList[_currentlyReplyingMessageIndex!].media[0]['media'],
                                            )
                                        ) : Container(),
                                        SizedBox(width: 5),
                                        Container(
                                          width: _messagesFilteredList[_currentlyReplyingMessageIndex!].media != null ? width / 1.4 : width / 1.2,
                                          padding: EdgeInsets.only(top: 5),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                  width: width,
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                          Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id == _messagesFilteredList[_currentlyReplyingMessageIndex!].userId ?
                                                          'Ответить ${Provider.of<UserDataProvider>(context, listen: false).userDataModel!.firstName}' : 'Ответить ${participant!.firstName}',
                                                          style: TextStyle(color: Color.fromRGBO(145, 10, 251, 10))),
                                                      SizedBox(width: 5),
                                                      Icon(CupertinoIcons.reply_all, color: Color.fromRGBO(145, 10, 251, 10), size: 18)
                                                    ],
                                                  )
                                              ),
                                              Container(
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: width / 2,
                                                        child: Text('${_messagesFilteredList[_currentlyReplyingMessageIndex!].text ?? ''}', overflow: TextOverflow.ellipsis, maxLines: 2),
                                                      )
                                                    ],
                                                  )
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: IconButton(
                                            icon: Icon(CupertinoIcons.clear_circled, color: Color.fromRGBO(145, 10, 251, 10)),
                                            onPressed: (){
                                              setState((){
                                                _currentlyReplyingMessageIndex = null;
                                                _isReplying = false;
                                                _textMessageFieldController!.clear();

                                                FocusManager.instance.primaryFocus!.unfocus();
                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.2),
                                        borderRadius: BorderRadius.all(Radius.circular(10))
                                    ),
                                  )
                              ) : _isSendingMedia ? Container(
                                  height: height / 5,
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  color: Colors.white,
                                  child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          StatefulBuilder(
                                            builder: (context, setState){
                                              mediaLoadingBarState = setState;
                                              return Stack(
                                                children: [
                                                  Container(
                                                    height: 150,
                                                    width: 150,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                                        image: DecorationImage(
                                                            image: MemoryImage(_mediaBytes!),
                                                            fit: BoxFit.cover
                                                        )
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 10,
                                                    left: 10,
                                                    child: _mediaType == 'video'
                                                        ? Row(
                                                      children: [
                                                        Icon(CupertinoIcons.play_arrow_solid, color: Colors.white),
                                                        SizedBox(width: 50),
                                                        Text(_selectedVideoDuration!.split('.')[0], style: TextStyle(color: Colors.white))
                                                      ],
                                                    ) : Container(),
                                                  ),
                                                  Positioned(
                                                    top: 55 ,
                                                    left: 55,
                                                    child: _showMediaLoading ? CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 2,
                                                    ) : Container(),
                                                  )
                                                ],
                                              );
                                            },
                                          ),
                                          SizedBox(width: 10),
                                          IconButton(
                                            icon: Icon(CupertinoIcons.clear_circled, size: 30, color: Color.fromRGBO(145, 10, 251, 10)),
                                            onPressed: (){
                                              setState((){
                                                _isSendingMedia = false;
                                                _isTyping = false;

                                                _mediaFile = null;
                                                _mediaBytes = null;
                                              });
                                            },
                                          )
                                        ],
                                      )
                                  )
                              ) : Container(),
                            ),
                            AnimatedContainer(
                              padding: !_isSelecting ? null : EdgeInsets.only(left: 10, right: 10, bottom: 20),
                              duration: Duration(milliseconds: 100),
                              height: height / 11,
                              color: Colors.white,
                              child: !_isSelecting ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 6),
                                    child: IconButton(
                                      onPressed: () async {
                                        showCupertinoModalBottomSheet(
                                            context: context,
                                            duration: Duration(milliseconds: 250),
                                            topRadius: Radius.circular(25),
                                            builder: (context) {
                                              return DraggableScrollableSheet(
                                                initialChildSize: 0.5,
                                                maxChildSize: 1,
                                                minChildSize: 0.3,
                                                expand: false,
                                                builder: (context, scrollController) {
                                                  return media.isNotEmpty ? showPhotoVideoBottomSheet(scrollController, media) : Center(
                                                    child: Text('У вас нет фото или видео'),
                                                  );
                                                },
                                              );
                                            }
                                        );
                                      },
                                      icon: Icon(Icons.attach_file, color: Colors.grey),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: SizedBox(
                                      width: 390,
                                      child: TextFormField(
                                        controller: _textMessageFieldController,
                                        focusNode: _messageTextFocusNode,
                                        cursorColor: Color.fromRGBO(145, 10, 251, 5),
                                        textAlign: TextAlign.left,
                                        textCapitalization: TextCapitalization.sentences,
                                        textInputAction: TextInputAction.send,
                                        keyboardType: TextInputType.multiline,
                                        maxLength: 1000,
                                        maxLines: null,
                                        style: TextStyle(fontSize: 19),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(left: 10, bottom: height / 50),
                                          filled: true,
                                          counterText: '',
                                          hintText: 'Сообщение',
                                          hintStyle: TextStyle(fontSize: 16),
                                          fillColor: Colors.grey.withOpacity(0.1),
                                          suffixIcon: StatefulBuilder(
                                            builder: (context, setState){
                                              iconState = setState;
                                              return IconButton(
                                                  onPressed: _isTyping ? () => sendMessage() : _isEditing ? () => editMessage() : null,
                                                  splashRadius: 10,
                                                  icon: AnimatedContainer(
                                                    height: 30,
                                                    width: 30,
                                                    duration: Duration(milliseconds: 300),
                                                    curve: Curves.easeInOutBack,
                                                    child: _isTyping? Center(
                                                      child: Icon(Icons.arrow_upward, color: Colors.white),
                                                    ) : _isEditing ? Center(
                                                      child: Icon(Icons.check_circle, color: Color.fromRGBO(145, 10, 251, 10), size: 30),
                                                    ) : Container(),
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
                              ) : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Consumer<ChatCounterProvider>(
                                    builder: (context, viewModel, child){
                                      return IconButton(
                                          icon: Icon(CupertinoIcons.trash, color: viewModel.chatCount == 0 ? Colors.grey : Color.fromRGBO(145, 10, 251, 10), size: 25),
                                          splashRadius: 1,
                                          onPressed: viewModel.chatCount == 0 ? null : (){
                                            if(UniversalPlatform.isIOS){
                                              showCupertinoModalPopup(
                                                  context: context,
                                                  builder: (context) {
                                                    return CupertinoActionSheet(
                                                      actions: [
                                                        CupertinoActionSheetAction(
                                                          child: Text(
                                                              'Удалить у меня и у ${participant!.firstName}', textAlign: TextAlign.center, style: TextStyle(color: Colors.red)),
                                                          onPressed: () async {

                                                            List<bool> _selectedMessagesList = Provider.of<ChatCounterProvider>(context, listen: false).selectedMessagesList;
                                                            List<int> _messageIds = [];

                                                            for(int i = 0; i < _selectedMessagesList.length; i++){
                                                              if(_selectedMessagesList[i] == true){
                                                                _messageIds.add(_messagesFilteredList[i].messageId);
                                                              }
                                                            }

                                                            deleteMultipleMessages('', Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id, participant!.id, _messageIds);
                                                          },
                                                        ),
                                                        CupertinoActionSheetAction(
                                                          child: Text(
                                                              'Удалить у меня', textAlign: TextAlign.center, style: TextStyle(color: Colors.red)),
                                                          onPressed: () async {
                                                            List<bool> _selectedMessagesList = Provider.of<ChatCounterProvider>(context, listen: false).selectedMessagesList;
                                                            List<int> _messageIds = [];

                                                            for(int i = 0; i < _selectedMessagesList.length; i++){
                                                              if(_selectedMessagesList[i] == true){
                                                                _messageIds.add(_messagesFilteredList[i].messageId);
                                                              }
                                                            }

                                                            deleteMultipleMessages('for_me', Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id, null, _messageIds);
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
                                                        'Вы уверены, что хотите удалить сообщение?',
                                                        maxLines: 2,
                                                        style: TextStyle(fontSize: 13),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () async {
                                                            List<bool> _selectedMessagesList = Provider.of<ChatCounterProvider>(context, listen: false).selectedMessagesList;
                                                            List<int> _messageIds = [];

                                                            for(int i = 0; i < _selectedMessagesList.length; i++){
                                                              if(_selectedMessagesList[i] == true){
                                                                _messageIds.add(_messagesFilteredList[i].messageId);
                                                              }
                                                            }

                                                            deleteMultipleMessages('for_me', Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id, null, _messageIds);
                                                          },
                                                          child: Text('Удалить у меня', style: TextStyle(color: Colors.red)),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {

                                                            List<bool> _selectedMessagesList = Provider.of<ChatCounterProvider>(context, listen: false).selectedMessagesList;
                                                            List<int> _messageIds = [];

                                                            for(int i = 0; i < _selectedMessagesList.length; i++){
                                                              if(_selectedMessagesList[i] == true){
                                                                _messageIds.add(_messagesFilteredList[i].messageId);
                                                              }
                                                            }

                                                            deleteMultipleMessages('', Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id, participant!.id, _messageIds);
                                                          },
                                                          child: Text('Удалить у меня и у ${participant!.firstName}', style: TextStyle(color: Colors.red)),
                                                        ),
                                                      ],
                                                    );
                                                  }
                                              );
                                            }
                                          }
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(CupertinoIcons.share, color: Color.fromRGBO(145, 10, 251, 10), size: 25),
                                    splashRadius: 1,
                                    onPressed: () => null,
                                  ),
                                  IconButton(
                                    icon: Icon(CupertinoIcons.arrowshape_turn_up_right, color: Color.fromRGBO(145, 10, 251, 10), size: 25),
                                    splashRadius: 1,
                                    onPressed: () => null,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                  )
                ],
              )
            ) : Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Center(
                child: Text('У вас пока нет сообщений', style: TextStyle(fontSize: 18)),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 100),
                          child: _isEditing ? Container(
                              height: height / 18,
                              padding: EdgeInsets.only(left: width / 8, right: width / 25),
                              color: Colors.white,
                              child: SizedBox(
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
                                        Text('${_messagesFilteredList[_currentlyEditingMessageIndex!].text ?? ''}'),
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
                          ) : _isReplying ? Container(
                              height: height / 13,
                              padding: EdgeInsets.only(left: 5, right: 5),
                              color: Colors.white,
                              child: Container(
                                margin: EdgeInsets.only(top: 5),
                                padding: EdgeInsets.only(left: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      child: VerticalDivider(
                                        color: Colors.black,
                                        thickness: 1,
                                      ),
                                    ),
                                    _messagesFilteredList[_currentlyReplyingMessageIndex!].media != null ? SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: CachedNetworkImage(
                                          imageUrl: _messagesFilteredList[_currentlyReplyingMessageIndex!].media[0]['type'].toString().startsWith('video')
                                              ? _messagesFilteredList[_currentlyReplyingMessageIndex!].media[0]['thumbnail']
                                              : _messagesFilteredList[_currentlyReplyingMessageIndex!].media[0]['media'],
                                        )
                                    ) : Container(),
                                    SizedBox(width: 5),
                                    Container(
                                      width: _messagesFilteredList[_currentlyReplyingMessageIndex!].media != null ? width / 1.4 : width / 1.2,
                                      padding: EdgeInsets.only(top: 5),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                              width: width,
                                              child: Row(
                                                children: [
                                                  Text(
                                                      Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id == _messagesFilteredList[_currentlyReplyingMessageIndex!].userId ?
                                                      'Ответить ${Provider.of<UserDataProvider>(context, listen: false).userDataModel!.firstName}' : 'Ответить ${participant!.firstName}',
                                                      style: TextStyle(color: Color.fromRGBO(145, 10, 251, 10))),
                                                  SizedBox(width: 5),
                                                  Icon(CupertinoIcons.reply_all, color: Color.fromRGBO(145, 10, 251, 10), size: 18)
                                                ],
                                              )
                                          ),
                                          Container(
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: width / 2,
                                                    child: Text('${_messagesFilteredList[_currentlyReplyingMessageIndex!].text ?? ''}', overflow: TextOverflow.ellipsis, maxLines: 2),
                                                  )
                                                ],
                                              )
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: IconButton(
                                        icon: Icon(CupertinoIcons.clear_circled, color: Color.fromRGBO(145, 10, 251, 10)),
                                        onPressed: (){
                                          setState((){
                                            _currentlyReplyingMessageIndex = null;
                                            _isReplying = false;
                                            _textMessageFieldController!.clear();

                                            FocusManager.instance.primaryFocus!.unfocus();
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                              )
                          ) : _isSendingMedia ? Container(
                              height: height / 5,
                              padding: EdgeInsets.only(left: 5, right: 5),
                              color: Colors.white,
                              child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      StatefulBuilder(
                                        builder: (context, setState){
                                          mediaLoadingBarState = setState;
                                          return Stack(
                                            children: [
                                              Container(
                                                height: 150,
                                                width: 150,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                                    image: DecorationImage(
                                                        image: MemoryImage(_mediaBytes!),
                                                        fit: BoxFit.cover
                                                    )
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 10,
                                                left: 10,
                                                child: _mediaType == 'video'
                                                    ? Row(
                                                  children: [
                                                    Icon(CupertinoIcons.play_arrow_solid, color: Colors.white),
                                                    SizedBox(width: 50),
                                                    Text(_selectedVideoDuration!.split('.')[0], style: TextStyle(color: Colors.white))
                                                  ],
                                                ) : Container(),
                                              ),
                                              Positioned(
                                                top: 55 ,
                                                left: 55,
                                                child: _showMediaLoading ? CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2,
                                                ) : Container(),
                                              )
                                            ],
                                          );
                                        },
                                      ),
                                      SizedBox(width: 10),
                                      IconButton(
                                        icon: Icon(CupertinoIcons.clear_circled, size: 30, color: Color.fromRGBO(145, 10, 251, 10)),
                                        onPressed: (){
                                          setState((){
                                            _isSendingMedia = false;
                                            _isTyping = false;

                                            _mediaFile = null;
                                            _mediaBytes = null;
                                          });
                                        },
                                      )
                                    ],
                                  )
                              )
                          ) : Container(),
                        ),
                        AnimatedContainer(
                          padding: !_isSelecting ? null : EdgeInsets.only(left: 10, right: 10, bottom: 20),
                          duration: Duration(milliseconds: 100),
                          height: height / 11,
                          color: Colors.white,
                          child: !_isSelecting ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 6),
                                child: IconButton(
                                  onPressed: () async {
                                    if(UniversalPlatform.isIOS){
                                      showCupertinoModalBottomSheet(
                                          context: context,
                                          duration: Duration(milliseconds: 250),
                                          topRadius: Radius.circular(25),
                                          builder: (context) {
                                            return DraggableScrollableSheet(
                                              initialChildSize: 0.5,
                                              maxChildSize: 1,
                                              minChildSize: 0.3,
                                              expand: false,
                                              builder: (context, scrollController) {
                                                return media.isNotEmpty ? showPhotoVideoBottomSheet(scrollController, media) : Center(
                                                  child: Text('У вас нет фото или видео'),
                                                );
                                              },
                                            );
                                          }
                                      );
                                    }else if(UniversalPlatform.isAndroid){
                                      showCupertinoModalBottomSheet(
                                          context: context,
                                          duration: Duration(milliseconds: 250),
                                          topRadius: Radius.circular(25),
                                          builder: (context) {
                                            return DraggableScrollableSheet(
                                              initialChildSize: 0.5,
                                              maxChildSize: 1,
                                              minChildSize: 0.3,
                                              expand: false,
                                              builder: (context, scrollController) {
                                                return media.isNotEmpty ? showPhotoVideoBottomSheet(scrollController, media) : Center(
                                                  child: Text('У вас нет фото или видео'),
                                                );
                                              },
                                            );
                                          }
                                      );
                                    }
                                  },
                                  icon: Icon(Icons.attach_file, color: Colors.grey),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: SizedBox(
                                  height: 45,
                                  width: 390,
                                  child: TextFormField(
                                    controller: _textMessageFieldController,
                                    focusNode: _messageTextFocusNode,
                                    cursorColor: Color.fromRGBO(145, 10, 251, 5),
                                    textAlign: TextAlign.left,
                                    textCapitalization: TextCapitalization.sentences,
                                    textInputAction: TextInputAction.send,
                                    style: TextStyle(fontSize: 19),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 10, bottom: height / 50),
                                      filled: true,
                                      hintText: 'Сообщение',
                                      fillColor: Colors.grey.withOpacity(0.1),
                                      suffixIcon: StatefulBuilder(
                                        builder: (context, setState){
                                          iconState = setState;
                                          return IconButton(
                                              onPressed: _isTyping ? () => sendMessage(): _isEditing ? () => editMessage() : null,
                                              splashRadius: 10,
                                              icon: AnimatedContainer(
                                                height: 30,
                                                width: 30,
                                                duration: Duration(milliseconds: 300),
                                                curve: Curves.easeInOutBack,
                                                child: _isTyping? Center(
                                                  child: Icon(Icons.arrow_upward, color: Colors.white),
                                                ) : _isEditing ? Center(
                                                  child: Icon(Icons.check_circle, color: Color.fromRGBO(145, 10, 251, 10), size: 30),
                                                ) : Container(),
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
                          ) : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Consumer<ChatCounterProvider>(
                                builder: (context, viewModel, child){
                                  return IconButton(
                                      icon: Icon(CupertinoIcons.trash, color: viewModel.chatCount == 0 ? Colors.grey : Color.fromRGBO(145, 10, 251, 10), size: 25),
                                      splashRadius: 1,
                                      onPressed: viewModel.chatCount == 0 ? null : (){
                                        if(UniversalPlatform.isIOS){
                                          showCupertinoModalPopup(
                                              context: context,
                                              builder: (context) {
                                                return CupertinoActionSheet(
                                                  actions: [
                                                    CupertinoActionSheetAction(
                                                      child: Text(
                                                          'Удалить у меня и у ${participant!.firstName}', textAlign: TextAlign.center, style: TextStyle(color: Colors.red)),
                                                      onPressed: () async {

                                                        List<bool> _selectedMessagesList = Provider.of<ChatCounterProvider>(context, listen: false).selectedMessagesList;
                                                        List<int> _messageIds = [];

                                                        for(int i = 0; i < _selectedMessagesList.length; i++){
                                                          if(_selectedMessagesList[i] == true){
                                                            _messageIds.add(_messagesFilteredList[i].messageId);
                                                          }
                                                        }

                                                        deleteMultipleMessages('', Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id, participant!.id, _messageIds);
                                                      },
                                                    ),
                                                    CupertinoActionSheetAction(
                                                      child: Text(
                                                          'Удалить у меня', textAlign: TextAlign.center, style: TextStyle(color: Colors.red)),
                                                      onPressed: () async {
                                                        List<bool> _selectedMessagesList = Provider.of<ChatCounterProvider>(context, listen: false).selectedMessagesList;
                                                        List<int> _messageIds = [];

                                                        for(int i = 0; i < _selectedMessagesList.length; i++){
                                                          if(_selectedMessagesList[i] == true){
                                                            _messageIds.add(_messagesFilteredList[i].messageId);
                                                          }
                                                        }

                                                        deleteMultipleMessages('for_me', Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id, null, _messageIds);
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
                                                    'Вы уверены, что хотите удалить сообщение?',
                                                    maxLines: 2,
                                                    style: TextStyle(fontSize: 13),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () async {
                                                        List<bool> _selectedMessagesList = Provider.of<ChatCounterProvider>(context, listen: false).selectedMessagesList;
                                                        List<int> _messageIds = [];

                                                        for(int i = 0; i < _selectedMessagesList.length; i++){
                                                          if(_selectedMessagesList[i] == true){
                                                            _messageIds.add(_messagesFilteredList[i].messageId);
                                                          }
                                                        }

                                                        deleteMultipleMessages('for_me', Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id, null, _messageIds);
                                                      },
                                                      child: Text('Удалить у меня', style: TextStyle(color: Colors.red)),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {

                                                        List<bool> _selectedMessagesList = Provider.of<ChatCounterProvider>(context, listen: false).selectedMessagesList;
                                                        List<int> _messageIds = [];

                                                        for(int i = 0; i < _selectedMessagesList.length; i++){
                                                          if(_selectedMessagesList[i] == true){
                                                            _messageIds.add(_messagesFilteredList[i].messageId);
                                                          }
                                                        }

                                                        deleteMultipleMessages('', Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id, participant!.id, _messageIds);
                                                      },
                                                      child: Text('Удалить у меня и у ${participant!.firstName}', style: TextStyle(color: Colors.red)),
                                                    ),
                                                  ],
                                                );
                                              }
                                          );
                                        }
                                      }
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(CupertinoIcons.share, color: Color.fromRGBO(145, 10, 251, 10), size: 25),
                                splashRadius: 1,
                                onPressed: () => null,
                              ),
                              IconButton(
                                icon: Icon(CupertinoIcons.arrowshape_turn_up_right, color: Color.fromRGBO(145, 10, 251, 10), size: 25),
                                splashRadius: 1,
                                onPressed: () => null,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
              )
            ],
        );
      },
    );
  }

  Widget showPhotoVideoBottomSheet(ScrollController scrollController, List<AssetEntity> media) {
    return StatefulBuilder(
      builder: (context, medState){
        mediaState = medState;
        return Material(
          child: ListView(
            controller: scrollController,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: width / 20),
                    Text('Фото/Видео', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Center(
                          child: Icon(Icons.close, size: 17, color: Colors.grey),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            shape: BoxShape.circle
                        ),
                      ),
                    )
                  ],
                ),
              ),
              GridView.count(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(left: 10, right: 10),
                shrinkWrap: true,
                crossAxisCount: 4,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                children: List.generate(media.length, (index){
                  return InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    onTap: () async {
                      media[index].file.then((file) async {
                        _mediaFile = file;

                        if(media[index].type.name.startsWith('video')){
                          _mediaType = 'video';

                          final u8intList = await VideoThumbnail.thumbnailData(
                              video: _mediaFile!.path,
                              imageFormat: ImageFormat.JPEG,
                              quality: 25
                          );

                          _selectedVideoDuration = media[index].videoDuration.toString();

                          _mediaBytes = u8intList;

                          setState((){
                            _isSendingMedia = true;
                            _isTyping = true;
                          });

                          Navigator.pop(context);

                        }else{
                          _mediaType = 'image';

                          _mediaBytes = _mediaFile!.readAsBytesSync();

                          setState((){
                            _isSendingMedia = true;
                            _isTyping = true;
                          });

                          Navigator.pop(context);
                        }
                      });
                    },
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          child: AssetEntityImage(
                            media[index],
                            width: 5,
                            height: 5,
                            fit: BoxFit.cover,
                            isOriginal: false,
                          ),
                        ),
                        Positioned(
                            bottom: 10,
                            left: 2,
                            child: media[index].type.name.toString().startsWith('video') ? Icon(Icons.play_arrow, color: Colors.white, size: 20) : Container()
                        ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: media[index].type.name.toString().startsWith('video') ? Text(media[index].videoDuration.toString().split('.')[0], style: TextStyle(color: Colors.white)) : Container(),
                        )
                      ],
                    ),
                  );
                })
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Center(
                      child: Text('Закрыть', style: TextStyle(color: Color.fromRGBO(145, 10, 251, 10), fontSize: 15)),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.grey.withOpacity(0.2)
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void sendMessage() async {

    Map<String, String?> mediaJsonData;
    List mediaArray = [];

    if(_mediaBytes != null){
      mediaJsonData = {
        'mime' : lookupMimeType(_mediaFile!.path),
        'media' : base64Encode(_mediaFile!.readAsBytesSync())
      };

      mediaArray.add(mediaJsonData);

      mediaLoadingBarState!(() => _showMediaLoading = true);
    }

    var data = {
      'chat_room_id' : chat.chatRoomId,
      'text' : _textMessageFieldController!.text,
      'reply_to_message_id' : _currentlyReplyingMessageIndex != null ? _messagesFilteredList[_currentlyReplyingMessageIndex!].messageId : '',
      'media' : _mediaBytes != null ? jsonEncode(mediaArray) : jsonEncode([])
    };

    await UnyAPI.create(Constants.SIMPLE_MESSAGE_CONVERTER).sendMessage(token, data).then((value){

      notificationManager.notify(
          Provider.of<UserDataProvider>(context, listen: false).userDataModel!.firstName.toString(),
          Provider.of<UserDataProvider>(context, listen: false).mediaDataModel!.mainPhoto!.url.toString(),
          _textMessageFieldController!.text.toString(),
          chat.chatRoomId.toString(),
          Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id.toString());


      if(_mediaBytes != null){
        mediaLoadingBarState!(() => _showMediaLoading = true);
      }

      socket.sendMessage(chat.chatRoomId.toString(), value.body!);

      Provider.of<ChatsDataProvider>(context, listen: false).setLastMessage(chat.chatRoomId, _textMessageFieldController!.text);
      Provider.of<ChatsDataProvider>(context, listen: false).setLastMessageTime(chat.chatRoomId, value.body!.createdAt);
    });


    _currentlyReplyingMessageIndex = null;
    _mediaBytes = null;
    _mediaFile = null;
    _textMessageFieldController!.clear();
    _isSendingMedia = false;
    _isTyping = false;
    _isReplying = false;

    _checkedMessages.add(false);
    Provider.of<ChatCounterProvider>(context, listen: false).setCheckBoxList(_checkedMessages);
    //
    // _controller!.animateTo(_controller!.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  void editMessage() async {

    var data = {
      'message_id' : _messagesFilteredList[_currentlyEditingMessageIndex!].messageId,
      'text' : _textMessageFieldController!.text
    };

    await UnyAPI.create(Constants.SIMPLE_MESSAGE_CONVERTER).editMessage(token, data).then((value){
      _messagesFilteredList[_currentlyEditingMessageIndex!] = value.body!;

      socket.editMessage(chat.chatRoomId.toString(), value.body!);
    });

    _textMessageFieldController!.clear();

    FocusManager.instance.primaryFocus!.unfocus();

    _isEditing = false;
    setState((){});
  }

  void deleteMessage(String forWho, int myId, int? participantId, int messageId) async {
    
    List<int> idList = [];
    List<int> messageIds = [];
    
    Map<String, String> data;
    if(forWho == 'for_me'){
      
      idList.add(myId);
      messageIds.add(messageId);
      
      data = {
         'message_id' : jsonEncode(messageIds),
         'remove_for' : jsonEncode(idList)
      };
    }else{
      idList.add(myId);
      idList.add(participantId!);

      messageIds.add(messageId);
      data = {
        'message_id' : jsonEncode(messageIds),
        'remove_for' : jsonEncode(idList)
      };
    }

    await UnyAPI.create(Constants.SIMPLE_MESSAGE_CONVERTER).deleteMessage(token, data).then((value){

      if(idList.length == 2){
        socket.removeMessageForEveryone(chat.chatRoomId.toString(), messageId.toString());
      }else{
        setState((){});
      }

      _messagesFilteredList.removeWhere((element) => element.messageId == messageId);
      messageIds.clear();
      idList.clear();
    });

    if(_messagesFilteredList.isNotEmpty){
      Provider.of<ChatsDataProvider>(context, listen: false).setLastMessage(chat.chatRoomId, _messagesFilteredList.last.text);
      Provider.of<ChatsDataProvider>(context, listen: false).setLastMessageTime(chat.chatRoomId, _messagesFilteredList.last.createdAt);
    }else{
      Provider.of<ChatsDataProvider>(context, listen: false).setLastMessage(chat.chatRoomId, null);
      Provider.of<ChatsDataProvider>(context, listen: false).setLastMessageTime(chat.chatRoomId, null);
    }

    Navigator.pop(context);
  }

  void deleteMultipleMessages(String forWho, int myId, int? participantId, List<int> messagesIds) async {
    loadingBarState!((){
      _showLoading = true;
    });

    List<int> ids = [];

    Map<String, String> data;
    if(forWho == 'for_me'){
      ids.add(myId);

      data = {
        'message_id' : jsonEncode(messagesIds),
        'remove_for' : jsonEncode(ids)
      };
    }else{
      ids.add(myId);
      ids.add(participantId!);

      data = {
        'message_id' : jsonEncode(messagesIds),
        'remove_for' : jsonEncode(ids)
      };
    }


    await UnyAPI.create(Constants.SIMPLE_RESPONSE_CONVERTER).deleteMessage(token, data).whenComplete((){
      for(int i = 0; i < messagesIds.length; i++){
        _messagesFilteredList.removeWhere((element) => element.messageId == messagesIds[i]);
      }

      loadingBarState!((){
        _showLoading = false;
      });

      ids.clear();
      messagesIds.clear();

      setState((){
        _isSelecting = false;
      });

      Provider.of<ChatCounterProvider>(context, listen: false).resetCount();

      if(_messagesFilteredList.isNotEmpty){
        Provider.of<ChatsDataProvider>(context, listen: false).setLastMessage(chat.chatRoomId, _messagesFilteredList.last.text);
        Provider.of<ChatsDataProvider>(context, listen: false).setLastMessageTime(chat.chatRoomId, _messagesFilteredList.last.createdAt);
      }else{
        Provider.of<ChatsDataProvider>(context, listen: false).setLastMessage(chat.chatRoomId, null);
        Provider.of<ChatsDataProvider>(context, listen: false).setLastMessageTime(chat.chatRoomId, null);
      }

      Navigator.pop(context);
    });
  }

  void clearChat() async {
    loadingBarState!((){
      _showLoading = true;
    });


    var data = {
      'chat_room_id' : chat.chatRoomId,
      'remove_for_all' : true,
    };

    await UnyAPI.create(Constants.SIMPLE_RESPONSE_CONVERTER).clearChat(token, data).whenComplete((){
      Navigator.pop(context);

      _messagesFilteredList.clear();

      socket.clearChat(chat.chatRoomId.toString(), true);

      Provider.of<ChatsDataProvider>(context, listen: false).clearChatData(chat.chatRoomId);

      loadingBarState!((){
        _showLoading = false;
      });

      setState((){
        _isSelecting = false;
      });
    });
  }
}