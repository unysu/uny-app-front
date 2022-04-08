class Reports{

  bool _isSpam = false;
  bool _isAbuse = false;
  bool _isAdultContent = false;
  bool _isChildPorn = false;
  bool _isDrugPropoganda = false;
  bool _isViolentContent = false;
  bool _isCallForPersecution = false;
  bool _isSuicideCall = false;
  bool _isRudeToAnimals = false;
  bool _isMisLeading = false;
  bool _isFraud = false;
  bool _isExtreme = false;
  bool _isHostileRemark = false;


  static var _instance;
  static Reports init(){
    if(_instance != null){
      return _instance;
    }else{
      return Reports();
    }
  }

  bool get isSpam => _isSpam;

  set isSpam(bool value) {
    _isSpam = value;
  }

  bool get isAbuse => _isAbuse;

  bool get isHostileRemark => _isHostileRemark;

  set isHostileRemark(bool value) {
    _isHostileRemark = value;
  }

  bool get isExtreme => _isExtreme;

  set isExtreme(bool value) {
    _isExtreme = value;
  }

  bool get isFraud => _isFraud;

  set isFraud(bool value) {
    _isFraud = value;
  }

  bool get isMisLeading => _isMisLeading;

  set isMisLeading(bool value) {
    _isMisLeading = value;
  }

  bool get isRudeToAnimals => _isRudeToAnimals;

  set isRudeToAnimals(bool value) {
    _isRudeToAnimals = value;
  }

  bool get isSuicideCall => _isSuicideCall;

  set isSuicideCall(bool value) {
    _isSuicideCall = value;
  }

  bool get isCallForPersecution => _isCallForPersecution;

  set isCallForPersecution(bool value) {
    _isCallForPersecution = value;
  }

  bool get isViolentContent => _isViolentContent;

  set isViolentContent(bool value) {
    _isViolentContent = value;
  }

  bool get isDrugPropoganda => _isDrugPropoganda;

  set isDrugPropoganda(bool value) {
    _isDrugPropoganda = value;
  }

  bool get isChildPorn => _isChildPorn;

  set isChildPorn(bool value) {
    _isChildPorn = value;
  }

  bool get isAdultContent => _isAdultContent;

  set isAdultContent(bool value) {
    _isAdultContent = value;
  }

  set isAbuse(bool value) {
    _isAbuse = value;
  }
}