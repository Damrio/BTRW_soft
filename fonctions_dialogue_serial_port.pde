// Called whenever there is something available to read
void serialEvent(Serial port) {
  // ******** Gestion de la valeur reçue sur le port série : **********
  String inString = port.readStringUntil('\n'); // chaine stockant la chaîne reçue sur le port Série
  if (inString != null) { // si la chaine recue n'est pas vide
    print(inString); // affiche chaine recue
  }
}

// Fonction qui envoie un message d'allumage d'une led RGB explicitée par son numéro avec une couleur RGB (0-255/0-255/0-255) 
/*
Un message de controle d'une led a la structure suivante:
 - Octet 1: "1" pour signifier que l'on est dans le mode 1 
 - Octet 2: numéro de la LED RGB à controller (1-12)
 - Octet 3-5: Valeur du rouge,vert et bleu (0-255)
 */
void SendRGBValue_Message( Integer RGB_Led_Num, Integer RValue, Integer GValue, Integer BValue  ) {
  port.write(byte(1));
  port.write(byte(RGB_Led_Num));
  port.write(byte(RValue));
  port.write(byte(GValue));
  port.write(byte(BValue));
  /*
  println("1 "+ RGB_Led_Num + " " + RValue + " " +  GValue +" "+ BValue);
   println("Message envoye a l'Arduino: ");
   println(byte(1));
   println(byte(RGB_Led_Num));
   println(byte( RValue));
   println(byte( GValue));
   println(byte( BValue));
   println();
   */
}
// Fonction qui envoie une commande de fading ("respiration"), d'une ligne RGB.
// La LED sera en mode fading jusqu'à ce qu'on lui envoie un message d'arrêt
/*
Un message de commande de fading à la structure suivante
 - Octet 1: "2" code du mode fading
 - Octet 2: numéro de la LED RGB à controller (1-12)
 - Octet 3-6: Durée la  demi période du  Fading (allumage ou extinction)
 - Octet 7-12: Valeur Min et Max de la commande de Fading pour chacune des couleurs de la LED RGB
 */
void SendRGB_Fading_Start_Message (Integer RGB_Led_Num, Integer Duration, Integer Rmin, Integer Rmax, Integer Gmin, Integer Gmax, Integer Bmin, Integer Bmax  ) {
  port.write(byte(2));
  port.write(byte(RGB_Led_Num));
  byte[] DurationInByte= toByteArray( Duration );// On stocke sur 4 octets la période du fading
  port.write(DurationInByte[0]);
  port.write(DurationInByte[1]);
  port.write(DurationInByte[2]);
  port.write(DurationInByte[3]);
  port.write(byte(Rmin));
  port.write(byte(Rmax));
  port.write(byte(Gmin));
  port.write(byte(Gmax));
  port.write(byte(Bmin));
  port.write(byte(Bmax));
}

// Fonction qui envoie une commande de fin de Fading d'une LED RGB
/*
Un message d'arrêt de fading à la structure suivante
 - Octet 1: "3" code de la commande arrêt fading
 - Octet 2: numéro de la LED RGB à controller (1-12)
 */
void Stop_Fading_Message (Integer RGB_Led_Num ) {
  port.write(byte(3));
  port.write(byte(RGB_Led_Num));
}

// Fonction de stockage d'un int en un tableau de 4 octets
byte[] toByteArray(int value) {
  return new byte[] {
    (byte) (value >> 24), 
    (byte) (value >> 16), 
    (byte) (value >> 8), 
    (byte) value
  };
}

