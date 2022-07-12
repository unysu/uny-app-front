import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shimmer/shimmer.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uny_app/API/uny_app_api.dart';
import 'package:uny_app/Chats%20Page/chat_page.dart';
import 'package:uny_app/Constants/constants.dart';
import 'package:uny_app/Providers/chat_data_provider.dart';
import 'package:uny_app/Providers/user_data_provider.dart';
import 'package:uny_app/Token%20Data/token_data.dart';

import '../Data Models/Chats Data Model/all_chats_model.dart';

class ChatsPage extends StatefulWidget{

  @override
  _ChatsPageState createState() => _ChatsPageState();
}


class _ChatsPageState extends State<ChatsPage> with SingleTickerProviderStateMixin{


  late String token;

  late double height;
  late double width;

  late String userId;

  bool _isSearching = false;

  StateSetter? _recentMessagesState;

  TabController? _tabController;

  Future<Response<AllChatsModel>>? _allChatsFuture;

  List<Chats>? _chatsList;
  List<Chats>? _chatsFilteredList;

  List<Participants>? participants = [];


  @override
  void initState() {

    token = 'Bearer ' + TokenData.getUserToken();

    _tabController = TabController(length: 2, vsync: this);

    var data = {
      'limit' : 100
    };

    _allChatsFuture = UnyAPI.create(Constants.ALL_MESSAGES_MODEL_CONVERTER).getAllChats(token, data);

    userId = Provider.of<UserDataProvider>(context, listen: false).userDataModel!.id.toString();

    super.initState();
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
             resizeToAvoidBottomInset: false,
             body: mainBody(),
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

  Widget mainBody(){
    return Column(
      children: [
        SizedBox(height: height * 0.07),
        StatefulBuilder(
          builder: (context, setState){
            return Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: width / 20),
              child: TextFormField(
                cursorColor: Color.fromRGBO(145, 10, 251, 5),
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: height / 50),
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
                  setState(() {
                    _isSearching = true;
                  });
                },

                onChanged: (value){

                  _chatsFilteredList = _chatsList!.where((element) =>
                  element.participants![1].firstName.toString().toLowerCase().contains(value.toLowerCase())
                      || element.participants![1].lastName.toString().toLowerCase().contains(value.toLowerCase())
                  ).toList();

                  _recentMessagesState!((){});

                  if (value.isEmpty) {
                    setState(() {
                      _isSearching = false;
                    });
                  } else {
                    setState(() {
                      _isSearching = true;
                    });
                  }
                },
              ),
            );
          },
        ),
        SizedBox(height: 10),
        TabBar(
          controller: _tabController,
          indicatorColor: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark ? Colors.purpleAccent : Color.fromRGBO(145, 10, 251, 5),
          labelColor: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark ? Colors.purpleAccent : Color.fromRGBO(145, 10, 251, 5),
          unselectedLabelColor: Colors.grey,
          padding: EdgeInsets.symmetric(horizontal: width / 20),
          tabs: [
            Tab(
                text: 'Недавние',
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 20),
                  Text('Уведомления'),
                  SizedBox(width: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Container(
                      height: 20,
                      width: 40,
                      child: Center(
                        child: Text(
                          '99+',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: const [
                                Color.fromRGBO(255, 83, 155, 5),
                                Color.fromRGBO(237, 48, 48, 5)
                              ]
                          )
                      ),
                    ),
                  )
                ],
              )
            )
          ],
        ),
        SizedBox(
          height: height / 1.22,
          child: TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Container(
                child: FutureBuilder<Response<AllChatsModel>>(
                  future: _allChatsFuture,
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

                    if(snapshot.connectionState == ConnectionState.done && snapshot.data!.body!.chats!.isNotEmpty){
                      _chatsList = snapshot.data!.body!.chats!.reversed.toList();
                      _chatsFilteredList = _chatsList;

                      for(var chat in _chatsFilteredList!){
                        participants!.addAll(chat.participants!.where((participant) => participant.id.toString() != userId.toString()));
                      }

                      return recentMessages();
                    }else{
                      return Center(
                        heightFactor: 25,
                        child: Text('Список пуст', style: TextStyle(fontSize: 18)),
                      );
                    }
                  },
                )
              ),
              Container(
                child: messageRequests(),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget recentMessages(){
    return StatefulBuilder(
      builder: (context, setState){
        _recentMessagesState = setState;
        return ListView.separated(
          itemCount: _chatsFilteredList!.length,
          physics: RangeMaintainingScrollPhysics(),
          separatorBuilder: (context, index) {
            return Divider(
              color: Colors.grey.withOpacity(0.7),
              indent: height / 13,
              height: 1,
              thickness: 0.5,
            );
          },
          itemBuilder: (context, index){

            if(_chatsFilteredList![index].messages!.isNotEmpty){
              Provider.of<ChatsDataProvider>(context, listen: false).setLastMessage(_chatsFilteredList![index].chatRoomId, _chatsFilteredList![index].messages!.first.text);
              Provider.of<ChatsDataProvider>(context, listen: false).setLastMessageTime(_chatsFilteredList![index].chatRoomId, _chatsFilteredList![index].messages!.first.createdAt);
            }

            return Consumer<ChatsDataProvider>(
              builder: (context, viewModel, child){
                String? lastMessage = viewModel.lastMessagesMap[_chatsFilteredList![index].chatRoomId];
                String? lastMessageTime = viewModel.lastMessageTimeMap[_chatsFilteredList![index].chatRoomId];
                return Slidable(
                  key: ValueKey(index),
                  startActionPane: null,
                  endActionPane: ActionPane(
                    extentRatio: 0.4,
                    motion: DrawerMotion(),
                    // dismissible: DismissiblePane(
                    //   onDismissed: () {},
                    // ),
                    children: [
                      SlidableAction(
                        icon: CupertinoIcons.volume_up,
                        backgroundColor: Colors.orangeAccent,
                        foregroundColor: Colors.white,
                        onPressed: null,
                        label: 'Mute',
                      ),
                      SlidableAction(
                        icon: Icons.delete_forever_outlined,
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        label: 'Удалить',
                        onPressed: (context){
                          if(UniversalPlatform.isIOS){
                            showCupertinoModalPopup(
                                context: context,
                                builder: (context){
                                  return CupertinoActionSheet(
                                    title: Text(
                                      'Удалить чат ?',
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    actions: [
                                      CupertinoActionSheetAction(
                                        onPressed: () async {
                                          var data = {
                                            'chat_room_id' : _chatsFilteredList![index].chatRoomId
                                          };

                                          Navigator.pop(context);

                                          _chatsFilteredList!.removeAt(index);

                                          await UnyAPI.create(Constants.SIMPLE_RESPONSE_CONVERTER).deleteChatRoom(token, data);

                                          setState((){});
                                        },
                                        isDestructiveAction: true,
                                        child: Text('Удалить'),
                                      ),
                                    ],
                                    cancelButton: CupertinoActionSheetAction(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Отмена', style: TextStyle(color: Colors.lightBlue)),
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
                                    'Удалить чат ?',
                                    maxLines: 1,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        var data = {
                                          'chat_room_id' : _chatsFilteredList![index].chatRoomId
                                        };

                                        Navigator.pop(context);

                                        _chatsFilteredList!.removeAt(index);

                                        await UnyAPI.create(Constants.SIMPLE_RESPONSE_CONVERTER).deleteChatRoom(token, data);

                                        setState((){});
                                      },
                                      child: Text('Удалить', style: TextStyle(color: Colors.red)),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Отмена', style: TextStyle(color: Color.fromRGBO(145, 10, 251, 5))),
                                    )
                                  ],
                                );
                              }
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UserChatPage(chat: _chatsFilteredList![index], participant: participants![index]))
                      );
                    },
                    child: SizedBox(
                      height: 90,
                      width: width,
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              Container(
                                  padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                                  child: Center(
                                    child: Stack(
                                      alignment: Alignment.centerLeft,
                                      children: [
                                        Positioned(
                                            left: 3.9,
                                            child: SizedBox(
                                              width: 52,
                                              height: 52,
                                              child: participants![index].media!.mainPhoto != null ? CachedNetworkImage(
                                                imageUrl: participants![index].media!.mainPhoto!.url,
                                                imageBuilder: (context, imageProvider) => Container(
                                                  width: 52,
                                                  height: 52,
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
                                                width: 52,
                                                height: 52,
                                                child: Center(
                                                  child: Icon(Icons.person, size: 30, color: Colors.grey),
                                                ),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle
                                                ),
                                              )
                                            )
                                        ),
                                        Positioned(
                                          child: SizedBox(
                                            height: 60,
                                            width: 60,
                                            child: SimpleCircularProgressBar(
                                              valueNotifier: ValueNotifier(double.parse(participants![index].matchPercent.toString())),
                                              backColor: Colors.grey[300]!,
                                              animationDuration: 0,
                                              backStrokeWidth: 5,
                                              progressStrokeWidth: 5,
                                              startAngle: 187,
                                              progressColors: const [
                                                Colors.deepOrange,
                                                Colors.yellowAccent,
                                                Colors.green
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 8),
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Container(
                                              height: 20,
                                              width: 45,
                                              padding: EdgeInsets.symmetric(horizontal: 3),
                                              child: Center(
                                                widthFactor: 1,
                                                child: Text('${participants![index].matchPercent.toString()} %', style: TextStyle(
                                                    color: Colors.white)),
                                              ),
                                              decoration: BoxDecoration(
                                                color: participants![index].matchPercent < 49 ? Colors.red
                                                    : (participants![index].matchPercent > 49 && participants![index].matchPercent < 65)
                                                    ? Colors.orange : (participants![index].matchPercent > 65) ? Colors.green : null,
                                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                              ),
                              Stack(
                                children: [
                                  Container(
                                    width: width / 1.19,
                                    padding: EdgeInsets.only(left: 10, top: 20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: width / 2,
                                          child: Text(participants![index].firstName, style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                                        ),
                                        SizedBox(height: 5),
                                        Padding(
                                            padding: EdgeInsets.only(left: 2),
                                            child: SizedBox(
                                              width: width / 2,
                                              child: Text(lastMessage ?? ' ', style: TextStyle(fontSize: 16, color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis),
                                            )
                                        )
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 20,
                                    right: 10,
                                    child: lastMessageTime != null ?
                                    Text(DateTime.parse(lastMessageTime).toLocal().hour.toString().padLeft(2, '0') + ':' + DateTime.parse(lastMessageTime).toLocal().minute.toString().padLeft(2, '0'), style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500))
                                        : Container(),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget messageRequests() {
    return ListView.separated(
      itemCount: 10,
      physics: RangeMaintainingScrollPhysics(),
      separatorBuilder: (context, index) {
        return Divider(
          color: Colors.grey.withOpacity(0.7),
          indent: height / 13,
          height: 1,
          thickness: 0.5,
        );
      },
      itemBuilder: (context, index) {
        return Slidable(
          key: ValueKey(index),
          startActionPane: null,
          endActionPane: ActionPane(
            extentRatio: 0.7,
            motion: DrawerMotion(),
            // dismissible: DismissiblePane(
            //   onDismissed: () {},
            // ),
            children: [
              SlidableAction(
                icon: Icons.check,
                backgroundColor: Color.fromRGBO(16, 174, 83, 10),
                onPressed: (context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserChatPage(chat: null, participant: null)
                      )
                  );
                },
                label: 'Принять',
              ),
              SlidableAction(
                icon: Icons.block_flipped,
                backgroundColor: Color.fromRGBO(68, 13, 102, 10),
                onPressed: null,
                label: 'Блок.',
              ),
              SlidableAction(
                icon: Icons.delete_forever_outlined,
                backgroundColor: Colors.red,
                onPressed: null,
                label: 'Удалить',
              ),
            ],
          ),
          child: SizedBox(
            height: height / 11,
            width: width,
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 10, left: 10),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Positioned(
                          left: 3.3,
                          child: Container(
                            height: 53,
                            width: 53,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: AssetImage('assets/sample_pic.png'),
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.high
                                ),
                            ),
                          ),
                        ),
                        Positioned(
                          child: SizedBox(
                            height: 60,
                            width: 60,
                            child: SimpleCircularProgressBar(
                              valueNotifier: ValueNotifier(64),
                              backColor: Colors.grey[300]!,
                              animationDuration: 0,
                              mergeMode: true,
                              backStrokeWidth: 5,
                              progressStrokeWidth: 5,
                              startAngle: 210,
                              progressColors: const [
                                Colors.deepOrange,
                                Colors.yellowAccent,
                                Colors.green
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            heightFactor: 5,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 3),
                              child: Text('64 %', style: TextStyle(
                                  color: Colors.white)),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10)),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ),
                SizedBox(width: 10),
                Positioned(
                  top: height / 60,
                  left: width / 5.5,
                  child: Text('Кристина З.',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Positioned(
                  top: height / 60,
                  left: width / 1.11,
                  child: Text('15:20', style: TextStyle(color: Colors.grey)),
                ),
                Positioned(
                    top: height / 26,
                    left: width / 5.5,
                    child: SizedBox(
                      width: width / 2,
                      child: Text(
                        'Проспорила вчера в карты и сделала огромную татуху с 🍆 ...',
                        style: TextStyle(color: Colors.grey.withOpacity(0.8)),
                        maxLines: 2,
                      ),
                    )
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
