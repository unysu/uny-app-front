import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:uny_app/Balance%20Pages/Prices%20Model/prices_model.dart';

class ReplenishmentPage extends StatefulWidget{

  @override
  _ReplenishmentPageState createState() => _ReplenishmentPageState();
}

class _ReplenishmentPageState extends State<ReplenishmentPage>{

  late double height;
  late double width;
  
  List<PriceModel> prices = [
    PriceModel(unyCount: 5, price: 10.00),
    PriceModel(unyCount: 10, price: 15.00),
    PriceModel(unyCount: 15, price: 20.00),
    PriceModel(unyCount: 20, price: 25.00),
    PriceModel(unyCount: 25, price: 30.00),
    PriceModel(unyCount: 30, price: 35.00),
  ];

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
                title: Text('Пополнение', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
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
            height: 170,
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
              ],
            )
        ),
        SizedBox(height: 20),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 20),
          child: Text('Купить монеты', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: prices.length,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(left: 20, right: 20),
          itemBuilder: (context, index){
            PriceModel price = prices[index];
            return ListTile(
              contentPadding: EdgeInsets.only(top: 10, bottom: 10),
              title: Text(price.unyCount.toString() + ' монет'),
              leading: Image.asset('assets/uny_coin.png'),
              trailing: Material(
                child: Container(
                  height: 40,
                  width: 150,
                  child: Center(
                    child: Text(price.price.toString() + ' ₽', style: TextStyle(color: Colors.white)),
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(145, 10, 251, 10),
                    borderRadius: BorderRadius.circular(15)
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}