import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ZodiacSigns {

  static Widget getBliznetsiSign(){
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
          child: Center(
            child: SvgPicture.asset('assets/bliznetsi.svg'),
          ),
          decoration: BoxDecoration(
              color: Colors.lightBlue,
              shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 5),
        Text('Близнецы', style: TextStyle(fontSize: 17))
      ],
    );
  }


  static Widget getDevaSign(){
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
          child: Center(
            child: SvgPicture.asset('assets/deva.svg'),
          ),
          decoration: BoxDecoration(
              color: Colors.lightGreen,
              shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 5),
        Text('Дева', style: TextStyle(fontSize: 17))
      ],
    );
  }

  static Widget getKozerogSign() {
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
          child: Center(
            child: SvgPicture.asset('assets/kozerog.svg'),
          ),
          decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,

          ),
        ),
        SizedBox(width: 5),
        Text('Козерог', style: TextStyle(fontSize: 17))
      ],
    );
  }

  static Widget getLevSign() {
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
          child: Center(
            child: SvgPicture.asset('assets/lev.svg'),
          ),
          decoration: BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 5),
        Text('Лев', style: TextStyle(fontSize: 17))
      ],
    );
  }

  static Widget getOvenSign() {
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
          child: Center(
            child: SvgPicture.asset('assets/oven.svg'),
          ),
          decoration: BoxDecoration(
              color: Colors.yellow,
              shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 5),
        Text('Овен', style: TextStyle(fontSize: 17))
      ],
    );
  }

  static Widget getRakSign() {
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
          child: Center(
            child: SvgPicture.asset('assets/rak.svg'),
          ),
          decoration: BoxDecoration(
              color: Colors.purpleAccent,
              shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 5),
        Text('Рак')
      ],
    );
  }

  static Widget getRibiSign() {
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
          child: Center(
            child: SvgPicture.asset('assets/ribi.svg'),
          ),
          decoration: BoxDecoration(
              color: Colors.pinkAccent,
              shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 5),
        Text('Рыбы', style: TextStyle(fontSize: 17))
      ],
    );
  }

  static Widget getScorpionSign() {
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
          child: Center(
            child: SvgPicture.asset('assets/scorpion.svg'),
          ),
          decoration: BoxDecoration(
              color: Colors.purpleAccent[100],
              shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 5),
        Text('Скорпион', style: TextStyle(fontSize: 17))
      ],
    );
  }

  static Widget getStreletsSign() {
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
          child: Center(
            child: SvgPicture.asset('assets/strelets.svg'),
          ),
          decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 5),
        Text('Стрелец', style: TextStyle(fontSize: 17))
      ],
    );
  }

  static Widget getTelecSign() {
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
          child: Center(
            child: SvgPicture.asset('assets/telec.svg'),
          ),
          decoration: BoxDecoration(
              color: Colors.green[400],
              shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 5),
        Text('Телец', style: TextStyle(fontSize: 17))
      ],
    );
  }

  static Widget getVesiSign() {
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
          child: Center(
            child: SvgPicture.asset('assets/vesi.svg'),
          ),
          decoration: BoxDecoration(
              color: Colors.blueAccent[400],
              shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 5),
        Text('Весы', style: TextStyle(fontSize: 17))
      ],
    );
  }

  static Widget getVodoleiSign() {
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
          child: Center(
            child: SvgPicture.asset('assets/vodolei.svg'),
          ),
          decoration: BoxDecoration(
              color: Colors.purple,
              shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 5),
        Text('Водолей', style: TextStyle(fontSize: 17))
      ],
    );
  }
}