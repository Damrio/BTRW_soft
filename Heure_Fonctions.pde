void Affichage_Heure(){
  float X_pos; 
  minutes = minute();  // Values from 0 - 59
  dizaine_de_minute=(int)(minutes/10);
  chiffre_minute=minutes-10*dizaine_de_minute;
  heures = hour();    // Values from 0 - 23
 
  textFont(FontHeure);
  X_pos=(640-textWidth(Donne_l_heure(23)))/23;
  text(Donne_l_heure(heures),X_pos*heures,150);
  
  textFont(Font_Dminutes);
  X_pos=(640-textWidth(Donne_l_heure(9)))/9;
  text(Donne_Chiffre(dizaine_de_minute), X_pos*dizaine_de_minute,300);
  textFont(Font_Cminutes);
  X_pos=(640-textWidth(Donne_l_heure(9)))/9;
  text(Donne_Chiffre(chiffre_minute), X_pos*chiffre_minute,400);
}



String Donne_l_heure(int heure) {
  String heureString="";
  switch (heure) {
  case 0: 
    heureString= "Zero"; 
    break;
  case 1: 
    heureString= "One"; 
    break;
  case 2: 
    heureString= "Two"; 
    break;
  case 3: 
    heureString= "Three"; 
    break;
  case 4: 
    heureString= "Four"; 
    break;
  case 5: 
    heureString= "Five"; 
    break;
  case 6: 
    heureString= "Six"; 
    break;
  case 7: 
    heureString= "Seven"; 
    break;
  case 8: 
    heureString= "Eight"; 
    break;
  case 9: 
    heureString= "Nine"; 
    break;
  case 10: 
    heureString= "Ten"; 
    break;
  case 11: 
    heureString= "Elve"; 
    break;
  case 12: 
    heureString= "Twelve"; 
    break;  
  case 13: 
    heureString= "Thirteen"; 
    break;
  case 14: 
    heureString= "Fourteen"; 
    break;
  case 15: 
    heureString= "Fifteen"; 
    break;
  case 16: 
    heureString= "Sixteen"; 
    break;
  case 17: 
    heureString= "Seventeen"; 
    break;
  case 18: 
    heureString= "Eighteen"; 
    break;
  case 19: 
    heureString= "Nineteen"; 
    break;
  case 20: 
    heureString= "Twenty"; 
    break;
      case 21: 
    heureString= "Twenty One"; 
    break;
  case 22: 
    heureString= "Twenty Two"; 
    break;
  case 23: 
    heureString= "Twenty Three"; 
    break;
  case 24: 
    heureString= "Zero"; 
    break;
  }
  return heureString;
}

String Donne_Chiffre(int MonChiffre) {
  String Donne_Chiffre="";
  switch (MonChiffre) {
  case 0: 
    Donne_Chiffre= "Zero"; 
    break;
  case 1: 
    Donne_Chiffre= "One"; 
    break;
  case 2: 
    Donne_Chiffre= "Two"; 
    break;
  case 3: 
    Donne_Chiffre= "Three"; 
    break;
  case 4: 
    Donne_Chiffre= "Four"; 
    break;
  case 5: 
    Donne_Chiffre= "Five"; 
    break;
  case 6: 
    Donne_Chiffre= "Six"; 
    break;
  case 7: 
    Donne_Chiffre= "Seven"; 
    break;
  case 8: 
    Donne_Chiffre= "Eight"; 
    break;
  case 9: 
    Donne_Chiffre= "Nine"; 
    break;
  }
  return Donne_Chiffre;
}

