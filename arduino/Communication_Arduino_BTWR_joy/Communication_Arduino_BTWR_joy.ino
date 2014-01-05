

#include "Tlc5940.h"
#include "tlc_fades.h"
int octetReception=0; // variable de stockage des valeurs reçues sur le port Série (ASCII)
byte caractereRecu=0; // variable pour stockage caractère recu
int compt=0; // variable comptage caractères reçus
int nombreOctetMessage=0;// nombre octet du messages (compteur pour information)
byte chaineReception[300]; // tableau contenant qui va contebir les octets recus sur le port d'entrée
int Nombre_RGB_LED=12;// Nombre de Led RGB controlées
// Indique l'ordre des canaux des TLCs (utile par exemple si on a monté les TLCs dnas le mauvaise ordre)
int ChannelOrder[36]= { 
  0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35};
TLC_CHANNEL_TYPE channel;
int RGB_Led_Fading_Information[12][8];
;
// Tableau contenant les informations de Fading pour chacune des Leds
/* 1ère dimension = numero de la Led
 2eme dimension valeur du paramètre:
 1: Fading Actif ou non
 2: Durée du Fadding
 3: Valeur ini  Rouge
 4: Valeur fin  Rouge
 5: Valeur ini  Vert
 6: Valeur fin  Vert
 7: Valeur ini  Vert
 8: Valeur fin  Vert*/

const int VERT = 0; // analog
const int HORIZ = 1; // analog
const int SEL = 2; // digital
const int SEL2 = 7; // digital
const long joy_refresh = 1000;
int vertical, horizontal, select1, select2;
boolean Previous_flag=false;
boolean Previous_flag_bouton1=false;
boolean Previous_flag_bouton2=false;
long Timer;



void setup() { 
  Tlc.init();//initialise le TLC
  Serial.flush();// efface le buffer d'entrée
  Serial.begin(115200);// initialise connexion série à 115200 bauds
  for(int i=0;i<12;i++){// On initialise le tableau de Fadinf à 0 (inactif) 
    RGB_Led_Fading_Information[i][0]=0;
  } 

  // make the SEL line an input
  pinMode(SEL,INPUT);
  // turn on the pull-up resistor for the SEL line (see http://arduino.cc/en/Tutorial/DigitalPins)
  digitalWrite(SEL,HIGH);
  digitalWrite(SEL2,HIGH);
  Timer=millis();
} 
// ********************************************************************************

void loop(){ // debut de la fonction loop()

  while (Serial.available()>0) { // tant qu'un octet en réception
  //-----------------------------
  //Partie LEDs RGB
  //-----------------------------

    octetReception=Serial.read(); // Lit le 1er octet reçu et le met dans la variable
    compt=compt+1;

    if (octetReception==47) { // si Octet reçu est le saut de ligne
      //Serial.println();
      //Serial.println("**** Reponse Arduino **** :");
      //Serial.println ("Nombre Octets : "+ String(nombreOctetMessage));
      TreatMessage(chaineReception,nombreOctetMessage);// Ontraite le message recu
      compt=0; // RAZ compteur
      nombreOctetMessage=0;// compteur du nombre d'octet de la trame recue
      delay(100); // pause
      break; // sort de la boucle while

    }
    else { // si le caractère reçu n'est pas un saut de ligne
      caractereRecu=byte(octetReception); 
      chaineReception[nombreOctetMessage]=caractereRecu; // ajoute l'octet au tableau de recption
      nombreOctetMessage++;  
    }


  } // fin tant que  octet réception
  MiseAJourFading();//On met à jour le tableau de Fading
  tlc_updateFades();// On met à jour les fading si nécessaire
   
   
  //-----------------------------
  //Partie Joystick et bouton
  //-----------------------------

  vertical = analogRead(VERT); // will be 0-1023
  horizontal = analogRead(HORIZ); // will be 0-1023
  select1 = digitalRead(SEL); // will be HIGH (1) if not pressed, and LOW (0) if pressed
  select2 = digitalRead(SEL2);

  if(vertical<300 || vertical>700 || horizontal<300 || horizontal>700 ){
    if(Previous_flag==false)
    {
      send_joy_message();
      Timer=millis();
      Previous_flag=true;

    }
    else{

      long currentTimer = millis();

      if (currentTimer - Timer > joy_refresh){

        send_joy_message();
        Timer = millis();

      }

    }

  }
  else{

    Previous_flag=false;
  }


  if(select1==1){
    if(Previous_flag_bouton1==false){
      send_bouton1_message();
    }
    Previous_flag_bouton1=true;
  }
  else{
    Previous_flag_bouton1=false;
  }

  if(select2==1){
    if(Previous_flag_bouton2==false){
      send_bouton2_message();
    }
    Previous_flag_bouton2=true;
  }
  else{
    Previous_flag_bouton2=false;
  }

} // fin de la fonction loop() - le programme recommence au début de la fonction loop sans fin
// ********************************************************************************


// ////////////////////////// FONCTIONS DE GESTION DES INTERRUPTIONS ////////////////////
// Fonction de traitements des messages recus
void TreatMessage(byte* chaineRecue,int NombreOctetsATraiter){
  // chaineRecue.toCharArray(charBuf, 300) ;
  int i=0;
  boolean Quit=false;// Variable permettant de sortir de la boucle while
  /*
  //Permet de vérifier que les octets émis sont bien recus
   Serial.println("Debut du message");
   //Serial.println();
   //Serial.println("Octets recus");
   
   for(int j=0;j<NombreOctetsATraiter;j++){
   //Serial.println (chaineRecue[j],DEC);
   }
   */

  while(i<NombreOctetsATraiter && !Quit) { 
    int Mode=chaineRecue[i];
    //Serial.println (Mode,DEC);
    if(Mode==1){// On regarde si on a une trame allumage RGB 
      //Serial.println("Mode1 recu");
      int RGBLED=chaineRecue[i+1]; // Numéro de la Le RGB à controller
      //  Serial.print("LED a allumer: ");
      //Serial.println (RGBLED,DEC);
      int RValue= map(chaineRecue[i+2], 0, 255, 0, 4095); // Valeur de commande du rouge
      int GValue= map(chaineRecue[i+3], 0, 255, 0, 4095); // Valeur de commande du vert
      int BValue= map(chaineRecue[i+4], 0, 255, 0, 4095); // Valeur de commande du bleu
      i+=5;// On incrémente le buffer pour lecture du message suivant

      Tlc.set(ChannelOrder[(RGBLED-1)*3], RValue);// On allume la LED Rouge à la valeur désirée
      Tlc.set(ChannelOrder[(RGBLED-1)*3+1], GValue);// On allume la LED Verte à la valeur désirée
      Tlc.set(ChannelOrder[(RGBLED-1)*3+2], BValue);// On allume la LED Bleue à la valeur désirée
      // on met à jour les TLCs
      //Serial.println("******");
    }
    else if(Mode==2){// On regarde si on a une trame de Fading RGB 
      int RGBLED=chaineRecue[i+1]; // Numéro de la LED concernée
      byte DurationBytes[4] ;// tableau acceuillant la durée du Fading
      DurationBytes[0]=chaineRecue[i+2];
      DurationBytes[1]=chaineRecue[i+3];
      DurationBytes[2]=chaineRecue[i+4];
      DurationBytes[3]=chaineRecue[i+5];
      int Duration=fromByteArray(DurationBytes);// Convertit la durée d'octets en int
      int RMinValue=chaineRecue[i+6]; 
      int RMaxValue=chaineRecue[i+7]; 
      int GMinValue=chaineRecue[i+8]; 
      int GMaxValue=chaineRecue[i+9]; 
      int BMinValue=chaineRecue[i+10]; 
      int BMaxValue=chaineRecue[i+11]; 
      UpadateTableFading(RGBLED,true,Duration,map(RMinValue, 0, 255, 0, 4095),map(RMaxValue, 0, 255, 0, 4095),map(GMinValue, 0, 255, 0, 4095),map(GMaxValue, 0, 255, 0, 4095),map(BMinValue, 0, 255, 0, 4095),map(BMaxValue, 0, 255, 0, 4095));
      i+=12;// On incrémente le buffer pour lecture du message suivant
    }
    else if(Mode==3){
      int RGBLED=chaineRecue[i+1]; // Numéro de la Led à éteindre
      UpadateTableFading(RGBLED,false,0,0,0,0,0,0,0);// On met à jour le tableau de fading
      tlc_removeFades(ChannelOrder[i*3]);// On efface les fading sur les buffers
      tlc_removeFades(ChannelOrder[i*3+1]);
      tlc_removeFades(ChannelOrder[i*3+2]);
      i+=2;// On incrémente le buffer pour lecture du message suivant
    }
    else{
      Quit=true;// si on décode un mode non prévu on quitte
    }
  }
  Tlc.update();// On met à jour les TLCs

}


// ////////////////////////// AUTRES FONCTIONS DU PROGRAMME ////////////////////
// Fonction qui convertit 4 octets en int
int fromByteArray(byte* bytes) {
  return bytes[0] << 24 | (bytes[1] & 0xFF) << 16 | (bytes[2] & 0xFF) << 8 | (bytes[3] & 0xFF);
}

// On met à jour la Table de Fading
void UpadateTableFading(int LedNumber ,boolean Activated, int Duration,int RMinValue, int RMaxValue,int GMinValue,int GMaxValue,int BMinValue,int BMaxValue){
  if (Activated) {
    RGB_Led_Fading_Information[LedNumber-1][0]=1;
    RGB_Led_Fading_Information[LedNumber-1][1]=Duration;
    RGB_Led_Fading_Information[LedNumber-1][2]=RMinValue;
    RGB_Led_Fading_Information[LedNumber-1][3]=RMaxValue;
    RGB_Led_Fading_Information[LedNumber-1][4]=GMinValue;
    RGB_Led_Fading_Information[LedNumber-1][5]=GMaxValue;
    RGB_Led_Fading_Information[LedNumber-1][6]=BMinValue;
    RGB_Led_Fading_Information[LedNumber-1][7]=BMaxValue; 
  }
  else RGB_Led_Fading_Information[LedNumber-1][0]=0;
}

// Fonction qui teste si une ou plusieurs LED possède un Fading
boolean FadingExistant(){
  for(int i=0;i<12;i++){
    if(RGB_Led_Fading_Information[i][0]==1){
      return true;
    }
  }
  return false;
}

// Fonction qui vient rajouter des fadings sur les canaux avec Fadings activés
void MiseAJourFading(){
  for(int i=0;i<12;i++){
    if (tlc_fadeBufferSize < TLC_FADE_BUFFER_LENGTH - 6) {// On vérife que l'on a la place de rajouter 6 fadings: 2 allumages et extinctions par couleur de la LED
      uint32_t startMillis;
      uint32_t endMillis;
      if(RGB_Led_Fading_Information[i][0]==1){// Si la LED est en mode Fading
        startMillis = millis() + 50;
        endMillis = startMillis + RGB_Led_Fading_Information[i][1];// On prévoit une durée de la valeur enregsitrée
        if( (RGB_Led_Fading_Information[i][2]-RGB_Led_Fading_Information[i][3])!=0 && !tlc_isFading(ChannelOrder[i*3])){
          tlc_addFade(ChannelOrder[i*3], RGB_Led_Fading_Information[i][2], RGB_Led_Fading_Information[i][3], startMillis, endMillis);
          tlc_addFade(ChannelOrder[i*3], RGB_Led_Fading_Information[i][3], RGB_Led_Fading_Information[i][2], endMillis, endMillis + RGB_Led_Fading_Information[i][1]);
        }
        if( (RGB_Led_Fading_Information[i][4]-RGB_Led_Fading_Information[i][5])!=0 && !tlc_isFading(ChannelOrder[i*3+1])){
          tlc_addFade(ChannelOrder[i*3+1], RGB_Led_Fading_Information[i][4], RGB_Led_Fading_Information[i][5], startMillis, endMillis);
          tlc_addFade(ChannelOrder[i*3+1], RGB_Led_Fading_Information[i][5], RGB_Led_Fading_Information[i][4], endMillis, endMillis + RGB_Led_Fading_Information[i][1]);
        }
        if( (RGB_Led_Fading_Information[i][6]-RGB_Led_Fading_Information[i][7])!=0 && !tlc_isFading(ChannelOrder[i*3+2])){
          tlc_addFade(ChannelOrder[i*3+2], RGB_Led_Fading_Information[i][6], RGB_Led_Fading_Information[i][7], startMillis, endMillis);
          tlc_addFade(ChannelOrder[i*3+2], RGB_Led_Fading_Information[i][7], RGB_Led_Fading_Information[i][6], endMillis, endMillis + RGB_Led_Fading_Information[i][1]);
        }
      }
    } 
  }
}

// Fonction qui envoie le message Joystick
void send_joy_message() {
  Serial.write(byte(85));
  if(vertical<300) Serial.write(byte(49));
  if(vertical>700) Serial.write(byte(50));
  if(horizontal<300) Serial.write(byte(51));
  if(horizontal>700) Serial.write(byte(52));
  Serial.write('\n');

}

// Fonction qui envoie le message bouton1
void send_bouton1_message() {
  Serial.write(byte(86));
  Serial.write(byte(49));
  Serial.write('\n');
}

// Fonction qui envoie le message bouton2
void send_bouton2_message() {
  Serial.write(byte(87));
  Serial.write(byte(49));
  Serial.write('\n');
}
// ////////////////////////// Fin du programme //////////////////// 







































