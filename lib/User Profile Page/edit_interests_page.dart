import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_framework.dart';

class EditInterestsPage extends StatefulWidget {

  @override
  _EditInterestsPage createState() => _EditInterestsPage();
}

class _EditInterestsPage extends State<EditInterestsPage> with SingleTickerProviderStateMixin{

  late double height;
  late double width;

  bool _isSearching = false;

  TabController? _tabController;
  PageController? _pageViewController;

  bool _isAllSelected = false;
  bool _isFamilySelected = false;
  bool _isCareerSelected = false;
  bool _isSportSelected = false;
  bool _isTravelingSelected = false;
  bool _isGeneralSelected = false;

  int _page = 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    _pageViewController = PageController(
        initialPage: _page
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
       height = constraints.maxHeight;
       width = constraints.maxWidth;
       return ResponsiveWrapper.builder(
         Scaffold(
           appBar: AppBar(
             elevation: 0,
             automaticallyImplyLeading: false,
             backgroundColor: Colors.transparent,
             systemOverlayStyle: SystemUiOverlayStyle.dark,
             leading: IconButton(
               icon: Icon(Icons.arrow_back, color: Colors.grey),
               onPressed: () => Navigator.pop(context),
             ),
             title: Container(
               height: height / 23,
               padding: EdgeInsets.only(right: width / 20),
               child: TextFormField(
                 cursorColor: Color.fromRGBO(145, 10, 251, 5),
                 textAlign: TextAlign.center,
                 decoration: InputDecoration(
                   contentPadding: EdgeInsets.only(bottom: height / 50),
                   filled: true,
                   fillColor: Colors.grey.withOpacity(0.1),
                   prefixIcon: _isSearching != true
                       ? Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Icon(CupertinoIcons.search, color: Colors.grey),
                       Text('Поиск интересов',
                           style: TextStyle(
                               fontSize: 17, color: Colors.grey))
                     ],
                   )
                       : null,
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
                   if (value.length == 0) {
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
             ),
             centerTitle: true,
             bottom: TabBar (
               controller: _tabController,
               indicatorColor: Color.fromRGBO(145, 10, 251, 5),
               labelColor: Color.fromRGBO(145, 10, 251, 5),
               unselectedLabelColor: Colors.grey,
               padding: EdgeInsets.symmetric(horizontal: width / 7),
               tabs: [
                 Tab(
                   text: 'Мои интересы'
                 ),
                 Tab(
                   text: 'Рекомендуемые',
                 )
               ],
               onTap: (pageIndex){
                 _pageViewController!.animateToPage(pageIndex, duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
               },
             ),
           ),
           body: mainBody(),
         )
       );
      },
    );
  }

  Widget mainBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: height / 50, left: width / 20),
          child: Text('Выберите категорию', style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold))
        ),
        Padding(
          padding: EdgeInsets.only(top: height / 40, left: width / 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                InkWell(
                  onTap: (){
                    setState(() {
                      _isAllSelected = true;

                      _isFamilySelected = false;
                      _isCareerSelected = false;
                      _isSportSelected = false;
                      _isTravelingSelected = false;
                      _isGeneralSelected = false;
                    });
                  },
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  child: Container(
                    height: 35,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Center(child: Text('Все', style: TextStyle(fontSize: 15, color: Colors.black))),
                    decoration: BoxDecoration(
                        color: _isAllSelected ? Colors.purpleAccent.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.all(
                            color: _isAllSelected ? Colors.purpleAccent : Colors.grey.withOpacity(0.2)
                        )
                    ),
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    setState(() {
                      _isFamilySelected = true;

                      _isAllSelected = false;
                      _isCareerSelected = false;
                      _isSportSelected = false;
                      _isTravelingSelected = false;
                      _isGeneralSelected = false;
                    });
                  },
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  child: Container(
                    height: 35,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Center(child: Text('Семья', style: TextStyle(fontSize: 15, color: _isFamilySelected ? Colors.white : Colors.black))),
                    decoration: BoxDecoration(
                        color:  _isFamilySelected ? Colors.green : Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.all(
                            color: _isFamilySelected ? Colors.green : Colors.grey.withOpacity(0.2)
                        )
                    ),
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    setState(() {
                      _isCareerSelected = true;

                      _isFamilySelected = false;
                      _isAllSelected = false;
                      _isSportSelected = false;
                      _isTravelingSelected = false;
                      _isGeneralSelected = false;
                    });
                  },
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  child: Container(
                    height: 35,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Center(child: Text('Карьера', style: TextStyle(fontSize: 15, color: _isCareerSelected ? Colors.white : Colors.black))),
                    decoration: BoxDecoration(
                        color: _isCareerSelected ? Colors.lightBlueAccent : Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.all(
                            color: _isCareerSelected ? Colors.lightBlueAccent : Colors.grey.withOpacity(0.2)
                        )
                    ),
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    setState(() {
                      _isSportSelected = true;

                      _isCareerSelected = false;
                      _isFamilySelected = false;
                      _isAllSelected = false;
                      _isTravelingSelected = false;
                      _isGeneralSelected = false;
                    });
                  },
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  child: Container(
                    height: 35,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Center(child: Text('Спорт', style: TextStyle(fontSize: 15, color: _isSportSelected ? Colors.white : Colors.black))),
                    decoration: BoxDecoration(
                        color: _isSportSelected ? Colors.blueAccent : Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.all(
                            color: _isSportSelected ? Colors.blueAccent : Colors.grey.withOpacity(0.2)
                        )
                    ),
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    setState(() {
                      _isTravelingSelected = true;

                      _isSportSelected = false;
                      _isCareerSelected = false;
                      _isFamilySelected = false;
                      _isAllSelected = false;
                      _isGeneralSelected = false;
                    });
                  },
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  child: Container(
                    height: 35,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Center(child: Text('Путешествия', style: TextStyle(fontSize: 15, color: _isTravelingSelected ? Colors.white : Colors.black))),
                    decoration: BoxDecoration(
                        color: _isTravelingSelected ? Colors.deepOrangeAccent : Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.all(
                            color: _isTravelingSelected ? Colors.deepOrangeAccent : Colors.grey.withOpacity(0.2)
                        )
                    ),
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    setState(() {
                      _isGeneralSelected = true;

                      _isTravelingSelected = false;
                      _isSportSelected = false;
                      _isCareerSelected = false;
                      _isFamilySelected = false;
                      _isAllSelected = false;
                    });
                  },
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  child: Container(
                    height: 35,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Center(child: Text('Общее', style: TextStyle(fontSize: 15, color: _isGeneralSelected ? Colors.white : Colors.black))),
                    decoration: BoxDecoration(
                        color: _isGeneralSelected ? Color.fromRGBO(145, 10, 251, 5) : Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.all(
                            color: _isGeneralSelected ? Color.fromRGBO(145, 10, 251, 5) : Colors.grey.withOpacity(0.2)
                        )
                    ),
                  ),
                ),
              ],
            ),
          )
        ),
        SizedBox(height:  10),
        Divider(
          thickness: 5,
        ),
        Container(
          height: height / 1.47,
          child: PageView(
            controller: _pageViewController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Container(
                child: Text(''),
              ),
              Padding(
                  padding: EdgeInsets.only(top: height / 100, left: width / 20),
                  child: Text('В тренде', style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold))
              ),
            ],
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }
}