public class Afficheur_data {

  public int total_width;
  public int total_height;
  public int debut_zone_message;
  public int message_height;
  public int message_width;
  public int pos_defil_courant;
  public int pos_defil_contenu_mail_courant;
  public int index_mail_a_afficher;       // index du mail a afficher

  // CONSTRUCTEUR
  Afficheur_data() {
    total_width = 640;
    total_height = gridSize; //int(gridSize/2);
    debut_zone_message = 0;//int(gridSize/2);
    message_height = int(gridSize/8);
    message_width = 640;
    pos_defil_courant = 0;
    pos_defil_contenu_mail_courant = 0;
    index_mail_a_afficher = 0;
  }



  // fonction d'affichage
  void affiche_data(ArrayList array_from, ArrayList array_sujet, ArrayList array_date) {

    int nb_messages_available =  array_from.size();

    // on verifie si la consigne de defilement n'est pas excessive par rapport au nb de messages, sinon on la corrige
    // ATTENTION : cela signifie que chaque fois que l'on touche la consigne dans le main() il faut faire appel a affiche_data ensuite
    int hauteur_max = debut_zone_message;
    int hauteur_min = total_height - nb_messages_available * message_height;
    
    // on calcul la taille de police a utiliser
    int marge = 3; // marge a prendre pour ne pas etre au bord du cadre
    int size_font = message_height / 2 - 2*marge;
    textSize(size_font);
    String date_type = "00/00/0000 00:00:00";
    int date_size = int(textWidth(date_type));   

    if (pos_defil_courant > hauteur_max) {
      pos_defil_courant = hauteur_max;
    }
    if (pos_defil_courant < hauteur_min) {
      pos_defil_courant = hauteur_min;
    }



    fill(0);
    rect(0, 0, total_width, total_height);


    strokeWeight(0); 
    stroke(255);



    // on recupere les mails et on les affiche
    for (int i=0; i < nb_messages_available; i++) {

      // On remplit la zone de fond
      fill(0);

      rect(0, pos_defil_courant + debut_zone_message + i*message_height, message_width, message_height);



      PFont myFont2 = createFont("Arial Italic", 32);
      textFont(myFont2);
      fill(255);
      textSize(size_font);
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
      int numLine=(int)(textWidth(string_from_to_display)/(message_width-date_size-marge))+1;               
      if (numLine == 1) {
        text(string_from_to_display, marge, pos_defil_courant + debut_zone_message + i*message_height+marge, message_width, message_height);
      }
      else
      {
        text(string_from_to_display.substring(0, int(15*(message_width-date_size)/date_size))+" ...", marge, pos_defil_courant + debut_zone_message + i*message_height+marge, message_width, message_height);
      }

     // on ecrit la date
     textSize(size_font);
     fill(200,200,255);
      String date_to_display = array_date.get(i).toString();
      text(date_to_display, message_width - date_size -marge, pos_defil_courant + debut_zone_message + i*message_height+message_height/2-size_font/2, message_width, message_height);

      // On ecrit le sujet du message

      int numLine2=(int)(textWidth(array_sujet.get(i).toString())/(message_width-date_size-marge))+1; 
      PFont myFont = createFont("Arial Bold", 32);
      textFont(myFont);
      fill(255);
      textSize(size_font-3);
      if (numLine2 == 1) {
        text(array_sujet.get(i).toString(), marge, pos_defil_courant + debut_zone_message + i*message_height+message_height/2 + marge, message_width, message_height);
      }
      else
      {
        text(array_sujet.get(i).toString().substring(0, int(15*(message_width-date_size)/date_size))+" ...", marge, pos_defil_courant + debut_zone_message + i*message_height+message_height/2 + marge, message_width, message_height);
      }
    }
  }






  // fonction d'affichage du contenu d'un
  void affiche_contenu_mail(ArrayList array_from, ArrayList array_sujet, ArrayList array_contenu) {

    
    
    // on verifie si la consigne de defilement n'est pas excessive par rapport au nb de messages, sinon on la corrige
    // ATTENTION : cela signifie que chaque fois que l'on touche la consigne dans le main() il faut faire appel a affiche_data ensuite
    int hauteur_max = debut_zone_message;
    // TODO : calculer la hauteur min

    if (pos_defil_contenu_mail_courant > hauteur_max) {
      pos_defil_contenu_mail_courant = hauteur_max;
    }
//    if (pos_defil_courant < hauteur_min) {
//      pos_defil_contenu_mail_courant = hauteur_min;
//    }
    
    
    
    
    
    
   // On affiche d'abord from et sujet dans un entete
     
     // AFFICHAGE from
      PFont myFont2 = createFont("Arial Italic", 32);
      textFont(myFont2);
      fill(255);
      textSize(14);
      String string_from = array_from.get(index_mail_a_afficher).toString();
      int index_adresse  =      string_from.indexOf("<");
      String string_from_to_display;
      if (index_adresse == -1) {
        string_from_to_display = "FROM : " + string_from;
      }
      else
      {
        string_from_to_display = "FROM : " + string_from.substring(0, index_adresse);
      }
      int numLine=(int)(textWidth(string_from_to_display)/(gridSize-X))+1;               
      if (numLine == 1) {
        text(string_from_to_display, 5, 5 + pos_defil_contenu_mail_courant, gridSize, gridSize);
      }
      else
      {
        text(string_from_to_display.substring(0, 30)+" ...", 5, 5 + pos_defil_contenu_mail_courant, gridSize, gridSize);
      }
  
  
    // AFFICHAGE Sujet
      String string_sujet = array_sujet.get(index_mail_a_afficher).toString();
      int numLine_sujet=(int)(textWidth(string_sujet)/(gridSize-X))+1;               
      if (numLine_sujet == 1) {
        text(string_sujet, 5, 5 + 20 + pos_defil_contenu_mail_courant, gridSize, gridSize);
      }
      else
      {
        text(string_sujet.substring(0, 40)+" ...", 5 , 5 + pos_defil_contenu_mail_courant + 20, gridSize, gridSize);
      }


  // On met un ligne de separation
      stroke(255);
      line ( 5, 55 + pos_defil_contenu_mail_courant, gridSize -5, 55 + pos_defil_contenu_mail_courant);

    // puis on affiche le contenu proprement dit
      String string_contenu = array_contenu.get(index_mail_a_afficher).toString();
      text(string_contenu, 5, 5 + 60 + pos_defil_contenu_mail_courant, gridSize, gridSize*5);
    
  
    
 }   
    
   
    
    
 }
