public class Afficheur_data {

  public int total_width;
  public int total_height;
  public int debut_zone_message;
  public int message_height;
  public int message_width;
  public int pos_defil_courant;

  // CONSTRUCTEUR
  Afficheur_data() {
    total_width = gridSize;
    total_height = gridSize; //int(gridSize/2);
    debut_zone_message = 0;//int(gridSize/2);
    message_height = int(gridSize/8);
    message_width = gridSize;
    pos_defil_courant = 0;
  }



  // fonction d'affichage
  void affiche_data(ArrayList array_from, ArrayList array_sujet) {

    int nb_messages_available =  array_from.size();

    // on verifie si la consigne de defilement n'est pas excessive par rapport au nb de messages, sinon on la corrige
    // ATTENTION : cela signifie que chaque fois que l'on touche la consigne dans le main() il faut faire appel a affiche_data ensuite
    int hauteur_max = debut_zone_message;
    int hauteur_min = total_height - nb_messages_available * message_height;

    if (pos_defil_courant > hauteur_max) {
      pos_defil_courant = hauteur_max;
    }
    if (pos_defil_courant < hauteur_min) {
      pos_defil_courant = hauteur_min;
    }


    fill(230, 230, 255);
    rect(0, 0, total_width, total_height);


    strokeWeight(0); 
    stroke(50, 50, 200);


    // on recupere les mails et on les affiche
    for (int i=0; i < nb_messages_available; i++) {

      // On remplit la zone de fond
      fill(230, 230, 255);
      rect(0, pos_defil_courant + debut_zone_message + i*message_height, message_width, message_height);

      //               // On ecrit le numero du message 
      //               fill(0,128,0);
      //               textSize(14);
      //               text("Message #" + (i+1) + "\n",5,debut_zone_message + i*message_height, message_width, message_height);


      // On ecrit le titre du message


      PFont myFont2 = createFont("Arial Italic", 32);
      textFont(myFont2);
      fill(50, 50, 200);
      textSize(14);
      String string_from = array_from.get(i).toString();
      int index_adresse  =      string_from.indexOf("<");
      String string_from_to_display;
      if (index_adresse == -1) {
        string_from_to_display = string_from;
      }
      else
      {
        string_from_to_display = string_from.substring(0, index_adresse);
      }
      int numLine=(int)(textWidth(string_from_to_display)/(message_width-X))+1;               
      if (numLine == 1) {
        text(string_from_to_display, 5, pos_defil_courant + debut_zone_message + i*message_height+5, message_width, message_height);
      }
      else
      {
        text(string_from_to_display.substring(0, 30)+" ...", 5, pos_defil_courant + debut_zone_message + i*message_height+5, message_width, message_height);
      }


      // On ecrit le sujet du message

      int numLine2=(int)(textWidth(array_sujet.get(i).toString())/(message_width-X))+1; 
      PFont myFont = createFont("Arial Bold", 32);
      textFont(myFont);
      fill(150, 150, 255);
      textSize(14);
      if (numLine2 == 1) {
        text(array_sujet.get(i).toString(), 5, pos_defil_courant + debut_zone_message + i*message_height+5 + 20, message_width, message_height);
      }
      else
      {
        text(array_sujet.get(i).toString().substring(0, 40)+" ...", 5, pos_defil_courant + debut_zone_message + i*message_height+5 + 20, message_width, message_height);
      }
    }
  }
}

