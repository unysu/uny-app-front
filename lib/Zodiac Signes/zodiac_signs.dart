import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ZodiacSigns {

  static Widget _getBliznetsiSign(int pst){
    return pst == 0 ? Row(
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
        Text('Близнецы', style: TextStyle(fontSize: 16))
      ],
    ) : Row(
      children: [
        Text('Близнецы', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
        SizedBox(width: 5),
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
      ],
    );
  }

  static Widget _getDevaSign(int pst){
    return pst == 0 ? Row(
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
        Text('Дева', style: TextStyle(fontSize: 16))
      ],
    ) : Row(
      children: [
        Text('Дева', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
        SizedBox(width: 5),
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
      ],
    );
  }

  static Widget _getKozerogSign(int pst) {
    return pst == 0 ? Row(
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
        Text('Козерог', style: TextStyle(fontSize: 16))
      ],
    ) : Row(
      children: [
        Text('Козерог', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
        SizedBox(width: 5),
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
      ],
    );;
  }

  static Widget _getLevSign(int pst) {
    return pst == 0 ? Row(
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
        Text('Лев', style: TextStyle(fontSize: 16))
      ],
    ) : Row(
      children: [
        Text('Лев', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
        SizedBox(width: 5),
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
      ],
    );
  }

  static Widget _getOvenSign(int pst) {
    return pst == 0 ? Row(
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
        Text('Овен', style: TextStyle(fontSize: 16))
      ],
    ) : Row(
      children: [
        Text('Овен', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
        SizedBox(width: 5),
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
      ],
    );
  }

  static Widget _getRakSign(int pst) {
    return pst == 0 ? Row(
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
        Text('Рак', style: TextStyle(fontSize: 16))
      ],
    ) : Row(
      children: [
        Text('Рак', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
        SizedBox(width: 5),
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
      ],
    );
  }

  static Widget _getRibiSign(int pst) {
    return pst == 0 ? Row(
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
        Text('Рыбы', style: TextStyle(fontSize: 16))
      ],
    ) : Row(
      children: [
        Text('Рыбы', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
        SizedBox(width: 5),
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
      ],
    );
  }

  static Widget _getScorpionSign(int pst) {
    return pst == 0 ? Row(
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
        Text('Скорпион', style: TextStyle(fontSize: 16))
      ],
    ) : Row(
      children: [
        Text('Скорпион', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
        SizedBox(width: 5),
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
      ],
    );
  }

  static Widget _getStreletsSign(int pst) {
    return pst == 0 ? Row(
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
        Text('Стрелец', style: TextStyle(fontSize: 16))
      ],
    ) : Row(
      children: [
        Text('Стрелец', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
        SizedBox(width: 5),
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
      ],
    );
  }

  static Widget _getTelecSign(int pst) {
    return pst == 0 ? Row(
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
        Text('Телец', style: TextStyle(fontSize: 16))
      ],
    ) : Row(
      children: [
        Text('Телец', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
        SizedBox(width: 5),
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
      ],
    );
  }

  static Widget _getVesiSign(int pst) {
    return pst == 0 ? Row(
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
        Text('Весы', style: TextStyle(fontSize: 16))
      ],
    ) : Row(
      children: [
        Text('Весы', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
        SizedBox(width: 5),
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
      ],
    );
  }

  static Widget _getVodoleiSign(int pst) {
    return pst == 0 ? Row(
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
        Text('Водолей', style: TextStyle(fontSize: 16))
      ],
    ) : Row(
      children: [
        Text('Водолей', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
        SizedBox(width: 5),
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
      ],
    );
  }


  static Widget getZodiacSign(DateTime date, int pst)  {
    var days = date.day;
    var months = date.month;

    if (months == 1) {
      if (days >= 21) {
        return _getVodoleiSign(pst);
      }else {
        return _getKozerogSign(pst);
      }
    }else if (months == 2) {
      if (days >= 20) {
        return _getRibiSign(pst);
      }else {
        return _getVodoleiSign(pst);
      }
    }else if (months == 3) {
      if (days >= 21) {
        return _getOvenSign(pst);
      }else {
        return _getRibiSign(pst);
      }
    }else if (months == 4) {
      if (days >= 21) {
        return _getTelecSign(pst);
      }else {
        return _getOvenSign(pst);
      }
    }else if (months == 5) {
      if (days >= 22) {
        return _getBliznetsiSign(pst);
      }else {
        return _getTelecSign(pst);
      }
    }else if (months == 6) {
      if (days >= 22) {
        return _getRakSign(pst);
      }else {
        return _getBliznetsiSign(pst);
      }
    }else if (months == 7) {
      if (days >= 23) {
        return _getLevSign(pst);
      }else {
        return _getRakSign(pst);
      }
    }else if (months == 8) {
      if (days >= 23) {
        return _getDevaSign(pst);
      }else {
        return _getLevSign(pst);
      }
    }else if (months == 9) {
      if (days >= 24) {
        return _getVesiSign(pst);
      }else {
        return _getDevaSign(pst);
      }
    }else if (months == 10) {
      if (days >= 24) {
        return _getScorpionSign(pst);
      }else {
        return _getVesiSign(pst);
      }
    }else if (months == 11) {
      if (days >= 23) {
        return _getStreletsSign(pst);
      }else {
        return _getScorpionSign(pst);
      }
    }else if (months == 12) {
      if (days >= 22) {
        return _getKozerogSign(pst);
      }else {
        return _getStreletsSign(pst);
      }
    }
    return Container();
  }
}