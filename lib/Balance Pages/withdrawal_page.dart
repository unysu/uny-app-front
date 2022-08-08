import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:uny_app/Balance%20Pages/add_new_payment_method.dart';

class WithdrawalPage extends StatefulWidget{

  @override
  _WithdrawalPageState createState() => _WithdrawalPageState();
}


class _WithdrawalPageState extends State<WithdrawalPage>{

  late double height;
  late double width;

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
                title: Text('Вывод средств', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
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
                            Text('0 UNY', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                            Text('0 ₽', style: TextStyle(color: Colors.white, fontSize: 18))
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
        SizedBox(height: 10),
        Divider(thickness: 1),
        SizedBox(height: 10),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Счет для вывода', style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600)),
              GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => NewPaymentMethodPage())
                  );
                },
                child: Row(
                  children: const [
                    Icon(Icons.add, size: 15),
                    Text('Добавить', style: TextStyle(fontSize: 14))
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 14),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  children: [
                    SvgPicture.asset('assets/payments/credit_card.svg'),
                    creditCardDots(),
                  ],
                ),
              ),
              Icon(Icons.arrow_drop_down, color: Colors.grey.withOpacity(0.4))
            ],
          ),
        ),
        SizedBox(height: 10),
        Divider(thickness: 1),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(top: 15, left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Сумма', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              SizedBox(height: 20),
              Text('Введите сумму которую хотите вывести'),
              SizedBox(height: 5),
              TextFormField(
                cursorColor: Color.fromRGBO(145, 10, 251, 10),
                decoration: InputDecoration(
                  hintText: 'Минимальная сумма в рублях: 100 ₽',
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.3),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.1))
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey.withOpacity(0.1))
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Доступный баланс: 0₽', style: TextStyle(fontSize: 14, color: Colors.black)),
                  Text('Вывести все средства', style: TextStyle(fontSize: 14, color: Colors.black, decoration: TextDecoration.underline))
                ],
              ),
              SizedBox(height: height / 5),
              Material(
                child: Container(
                  height: 50,
                  width: width,
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Center(
                    child: Text('Вывести средства', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(145, 10, 251, 10),
                    borderRadius: BorderRadius.circular(15)
                  ),
                ),
              )
            ],
          )
        ),
      ],
    );
  }

  Widget creditCardDots(){
    return Container(
      margin: EdgeInsets.only(left: 30),
      child: Row(
        children: [
          Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.withOpacity(0.4)),
          ),
          SizedBox(width: 5),
          Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.withOpacity(0.4)),
          ),
          SizedBox(width: 5),
          Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.withOpacity(0.4)),
          ),
          SizedBox(width: 5),
          Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.withOpacity(0.4)),
          ),
          SizedBox(width: 15),
          Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.withOpacity(0.4)),
          ),
          SizedBox(width: 5),
          Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.withOpacity(0.4)),
          ),
          SizedBox(width: 5),
          Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.withOpacity(0.4)),
          ),
          SizedBox(width: 5),
          Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.withOpacity(0.4)),
          ),
          SizedBox(width: 15),
          Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.withOpacity(0.4)),
          ),
          SizedBox(width: 5),
          Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.withOpacity(0.4)),
          ),
          SizedBox(width: 5),
          Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.withOpacity(0.4)),
          ),
          SizedBox(width: 5),
          Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.withOpacity(0.4)),
          ),
          SizedBox(width: 15),
          Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.withOpacity(0.4)),
          ),
          SizedBox(width: 5),
          Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.withOpacity(0.4)),
          ),
          SizedBox(width: 5),
          Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.withOpacity(0.4)),
          ),
          SizedBox(width: 5),
          Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.withOpacity(0.4)),
          ),
        ],
      ),
    );
  }
}