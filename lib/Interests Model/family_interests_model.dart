class FamilyInterests {

  FamilyInterests? instance;

  FamilyInterests? init() {
    if(instance != null){
      return instance;
    }else{
      return instance = FamilyInterests();
    }
  }
}