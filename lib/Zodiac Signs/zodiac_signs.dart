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
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                Color.fromRGBO(137, 238, 254, 10),
                Color.fromRGBO(35, 113, 231, 10),
              ]
            )
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
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  Color.fromRGBO(137, 238, 254, 10),
                  Color.fromRGBO(35, 113, 231, 10),
                ]
            ),
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
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  Color.fromRGBO(105, 218, 52, 10),
                  Color.fromRGBO(24, 160, 62, 10),
                ]
             ),
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
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  Color.fromRGBO(105, 218, 52, 10),
                  Color.fromRGBO(24, 160, 62, 10),
                ]
            ),
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
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  Color.fromRGBO(75, 182, 25, 10),
                  Color.fromRGBO(22, 123, 50, 10),
                ]
            ),
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
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  Color.fromRGBO(75, 182, 25, 10),
                  Color.fromRGBO(22, 123, 50, 10),
                ]
            ),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
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
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  Color.fromRGBO(246, 172, 97, 10),
                  Color.fromRGBO(248, 108, 21, 10),
                ]
            ),
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
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  Color.fromRGBO(246, 172, 97, 10),
                  Color.fromRGBO(248, 108, 21, 10),
                ]
            ),
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
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  Color.fromRGBO(250, 230, 73, 10),
                  Color.fromRGBO(231, 144, 1, 10),
                ]
            ),
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
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  Color.fromRGBO(250, 230, 73, 10),
                  Color.fromRGBO(231, 144, 1, 10),
                ]
            ),
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
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  Color.fromRGBO(227, 139, 255, 10),
                  Color.fromRGBO(156, 35, 231, 10),
                ]
            ),
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
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  Color.fromRGBO(227, 139, 255, 10),
                  Color.fromRGBO(156, 35, 231, 10),
                ]
            ),
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
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  Color.fromRGBO(255, 135, 149, 10),
                  Color.fromRGBO(249, 90, 90, 10),
                ]
            ),
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
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  Color.fromRGBO(255, 135, 149, 10),
                  Color.fromRGBO(249, 90, 90, 10),
                ]
            ),
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
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  Color.fromRGBO(255, 135, 219, 10),
                  Color.fromRGBO(249, 90, 119, 10),
                ]
            ),
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
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  Color.fromRGBO(255, 135, 219, 10),
                  Color.fromRGBO(249, 90, 119, 10),
                ]
            ),
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
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  Color.fromRGBO(255, 137, 145, 10),
                  Color.fromRGBO(223, 30, 30, 10),
                ]
            ),
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
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  Color.fromRGBO(255, 137, 145, 10),
                  Color.fromRGBO(223, 30, 30, 10),
                ]
            ),
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
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  Color.fromRGBO(156, 218, 52, 10),
                  Color.fromRGBO(54, 190, 20, 10),
                ]
            ),
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
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  Color.fromRGBO(156, 218, 52, 10),
                  Color.fromRGBO(54, 190, 20, 10),
                ]
            ),
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
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  Color.fromRGBO(137, 198, 254, 10),
                  Color.fromRGBO(35, 42, 231, 10),
                ]
            ),
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
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  Color.fromRGBO(137, 198, 254, 10),
                  Color.fromRGBO(35, 42, 231, 10),
                ]
            ),
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
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  Color.fromRGBO(137, 142, 254, 10),
                  Color.fromRGBO(121, 35, 231, 10),
                ]
            ),
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
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  Color.fromRGBO(137, 142, 254, 10),
                  Color.fromRGBO(121, 35, 231, 10),
                ]
            ),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }


  static Widget getZodiacSign(DateTime date, int pst)  {
    var days = date.day;
    var months = date.month;

    if (months ==  1) {
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