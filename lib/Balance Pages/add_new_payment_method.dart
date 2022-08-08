import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_framework/responsive_framework.dart';

class NewPaymentMethodPage extends StatefulWidget{

  @override
  _NewPaymentMethodPageState createState() => _NewPaymentMethodPageState();
}

class _NewPaymentMethodPageState extends State<NewPaymentMethodPage>{

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
              title: Text('Добавить способ вывода', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30, left: 20),
          child: Row(
            children: const [
              Text('Страна', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16)),
              SizedBox(width: 30),
              Text('Russian Federation', style: TextStyle(fontSize: 16))
            ],
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: width,
          margin: EdgeInsets.only(left: 20),
          child: Text('Доступность методов вывода средств может отличаться в разных странах и регионах', style: TextStyle(color: Colors.grey.withOpacity(0.8), fontSize: 14)),
        ),
        SizedBox(height: 40),
        Container(
          margin: EdgeInsets.only(left: 20),
          child: Text('Выберете способ вывода', style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        SizedBox(height: 20),
        Container(
          height: 60,
          margin: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/payments/credit_card.svg', height: 30),
                    SizedBox(width: 10),
                    Text('Банковская карта', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 10),
                child: Text('RUB', style: TextStyle(fontSize: 14, color: Colors.grey)),
              )
            ],
          ),
        ),
        SizedBox(height: 20),
        Container(
          height: 60,
          margin: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Image.asset('assets/payments/mir_pm.png', scale: 2.5),
                    SizedBox(width: 10),
                    Text('МИР', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 10),
                child: Text('RUB', style: TextStyle(fontSize: 14, color: Colors.grey)),
              )
            ],
          ),
        ),
        SizedBox(height: 20),
        Container(
          height: 60,
          margin: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/payments/qiwi_pm.svg', height: 30),
                    SizedBox(width: 10),
                    Text('Qiwi Wallet', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 10),
                child: Text('RUB', style: TextStyle(fontSize: 14, color: Colors.grey)),
              )
            ],
          ),
        ),
        SizedBox(height: 20),
        Container(
          height: 60,
          margin: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/payments/webmoney_pm.svg', height: 30),
                    SizedBox(width: 10),
                    Text('WebMoney', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 10),
                child: Text('USD', style: TextStyle(fontSize: 14, color: Colors.grey)),
              )
            ],
          ),
        ),
        SizedBox(height: 20),
        Container(
          height: 60,
          margin: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/payments/paypal_pm.svg', height: 20),
                    SizedBox(width: 10),
                    Text('PayPal', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 10),
                child: Text('USD', style: TextStyle(fontSize: 14, color: Colors.grey)),
              )
            ],
          ),
        )
      ],
    );
  }
}