import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:uny_app/Balance%20Pages/replenishment_page.dart';
import 'package:uny_app/Balance%20Pages/withdrawal_page.dart';

class BalancePage extends StatefulWidget{

  @override
  _BalancePageState createState() => _BalancePageState();
}


class _BalancePageState extends State<BalancePage> with SingleTickerProviderStateMixin{

  late double height;
  late double width;

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        return ResponsiveWrapper.builder(
            Scaffold(
              appBar: AppBar(
                elevation: 0.5,
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                centerTitle: false,
                title: Text('Баланс', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_outlined, color: Colors.grey, size: 25),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.more_horiz, color: Colors.grey),
                    onPressed: () => null,
                  )
                ],
              ),
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
        Container(
          height: 200,
          width: width,
          margin: EdgeInsets.only(top: 15, left: 15, right: 15),
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              colors: const [
                Color.fromRGBO(145, 10, 251, 10),
                Color.fromRGBO(29, 105, 218, 10),
              ]
            )
          ),
          child: Column(
            children: [
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Ваш баланс', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                          SizedBox(height: 20),
                          Text('1000 UNY', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('10 000 ₽', style: TextStyle(color: Colors.white, fontSize: 18))
                        ],
                      ),
                    ),
                    Container(
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/uny_coin.png'),
                              fit: BoxFit.cover
                          )
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            CupertinoPageRoute(builder: (context) => ReplenishmentPage())
                          );
                        },
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            height: 40,
                            child: Center(
                              child: Text('Пополнить баланс', style: TextStyle(color: Colors.white)),
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(15)
                            ),
                          ),
                        ),
                      )
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            CupertinoPageRoute(builder: (context) => WithdrawalPage())
                          );
                        },
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            height: 40,
                            child: Center(
                              child: Text('Вывести средства', style: TextStyle(color: Color.fromRGBO(29, 105, 217, 10), fontWeight: FontWeight.w600)),
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(15)
                            ),
                          ),
                        ),
                      )
                    )
                  ],
                ),
              ),
            ],
          )
        ),
        SizedBox(height: 10),
        Divider(
          color: Colors.grey,
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('История', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24)),
              SizedBox(height: 10),
              TabBar(
                controller: _tabController,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Color.fromRGBO(145, 10, 251, 5),
                labelColor: Color.fromRGBO(145, 10, 251, 5),
                labelStyle: TextStyle(fontSize: 16),
                physics: BouncingScrollPhysics(),
                isScrollable: true,
                tabs: const [
                  Tab(text: 'Все'),
                  Tab(text: 'Входящие'),
                  Tab(text: 'Исходящие'),
                ],
              ),
            ],
          )
        ),
        SizedBox(height: 10),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
            child: Center(
              child: SizedBox(
                width: 220,
                child: Text('У вас пока не было операций', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
              ),
            ),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20)
            ),
          ),
        )
      ],
    );
  }
}
