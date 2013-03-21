//-----------------------------------------------------------------------------------------------------------------------//
//                                 SOUS FONCTIONS DE DRAW()
//-----------------------------------------------------------------------------------------------------------------------//


////////////////////////////////////////////////////
//		draw_configuration()		  //
////////////////////////////////////////////////////
public void draw_configuration()
{
  Maingrille.DisplayConfig(cols, rows);

  fill(50, 0, 0);
  rect(0, gridSize-100, gridSize, int(gridSize/4));

  PFont myFont2 = createFont("Arial Italic", 32);
  textFont(myFont2);
  fill(200, 0, 0);
  textSize(40);

  text("CONFIGURATION", 30, 365);
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////
//		draw_case_a_configurer()	  //
////////////////////////////////////////////////////
public void draw_case_a_configurer()
{

  int ligne_selected = int(floor(case_courante / cols));
  int col_selected   = int(case_courante%4);

  fill(0);
  rect(0, 0, 400, 300);

  /////////////////////////////////////////////////////////    

  // affichage thumbnail
  fill(50, 50, 200);
  textSize(20);
  textAlign(LEFT);
  text(" Thumbnail : ", 10, 100, 200, 50);

  fill(200);
  rect(280, 100, 90, 25);
  fill(50);
  textSize(14);
  textAlign(CENTER);
  text(" Browse... ", 280, 100, 90, 25);

  PImage image_a_afficher = cellule_fictive.Icone;
  image (image_a_afficher, 200, 90, 40, 40);
  tint(255, 255);


  /////////////////////////////////////////////////////////  

  // affichage type de la case 


  PFont myFont2 = createFont("Arial Italic", 32);
  textFont(myFont2);
  fill(50, 50, 200);
  textSize(20);
  textAlign(LEFT);
  text("Case Type : ", 10, 50, 200, 50);
  text(cellule_fictive.function_type, 200, 50, 200, 50);

  // affichage du bouton
  fill(200);
  rect(280, 50, 90, 25);
  fill(50);
  textSize(14);
  textAlign(CENTER);
  text(" Change... ", 280, 50, 90, 25);

  // si on a appuye sur le bouton
  if (flag_bouton_type_case == true)
  {
    fill(200);
    rect(280, 75, 90, 25);
    rect(280, 100, 90, 25);
    rect(280, 125, 90, 25);

    fill(50);
    textSize(14);
    textAlign(CENTER);
    text(" MAIL ", 280, 75, 90, 25);
    text(" RSS ", 280, 100, 90, 25);
    text(" CALENDAR", 280, 125, 90, 25);
  }


  /////////////////////////////////////////////////////////  

  // affichage bouton OK
  fill(200);
  rect(225, 200, 100, 50);
  fill(50);
  textSize(20);
  textAlign(CENTER);
  text(" OK ", 225, 225, 100, 50);


  /////////////////////////////////////////////////////////  

  // affichage bouton CANCEL
  fill(200);
  rect(75, 200, 100, 50);
  fill(50);
  textSize(20);
  textAlign(CENTER);
  text(" CANCEL ", 75, 225, 100, 50);
}



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////
//           draw_case_cliquee()                  //
////////////////////////////////////////////////////

public void draw_case_cliquee() {


  int ligne_selected = int(floor(case_courante / cols));
  int col_selected   = int(case_courante%4);

  String curr_function_type = Maingrille.MaGrille[col_selected][ligne_selected].function_type;

  if (curr_function_type.equals("GMAIL"))
  {
    int y=mouseY;
    affichage_gmail(y);
  }

  if (curr_function_type.equals("Rss")) {
    String curr_Url=Maingrille.MaGrille[col_selected][ligne_selected].Url;
     int currentListIndex=getIndexFromUrl(curr_Url);
     
    if (last_mode==2) {
      if (ModeLevel==0 && mouseButton==LEFT ) {

        indicePrintedRss=NumRss(ListLoader.get(currentListIndex));
        offsetLecture=0;
        ModeLevel=1 ;
      }
      if (ModeLevel==1 &&  mouseButton==RIGHT) {
        ModeLevel=0;
        offset=0;
      }
    }

    if ( ModeLevel==0) {
      offset=ComputeOffset(offset);
       currentListIndex=getIndexFromUrl(curr_Url);
      AffichageRss(offset, ListLoader.get(currentListIndex));
    }
    else if (ModeLevel==1) {
      offsetLecture=ComputeOffsetLecture(offsetLecture); 
       currentListIndex=getIndexFromUrl(curr_Url);
      maxOffsetLecture=DisplayCurrentRSS(offsetLecture, indicePrintedRss, ListLoader.get(currentListIndex)) ;
    }

    Maingrille.MaGrille[col_selected][ligne_selected].numberofEvents=0;
    Maingrille.MaGrille[col_selected][ligne_selected].ChangeColor(color(0, 0, 0));
  }
}




//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////
//           draw_applique_tache_planifiee()      //
//////////////////////////////////////////////////// 


public void draw_applique_tache_planifiees() {

  // monMail.checkEmailAccount(); // cette methode permet de compter les messages et de les recuperer
}









//-----------------------------------------------------------------------------------------------------------------------//  










//-----------------------------------------------------------------------------------------------------------------------//
//                        SOUS FONCTIONS DE MOUSEPRESSED()  
//-----------------------------------------------------------------------------------------------------------------------//

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//  mousepressed_gestion_boutons(x,y)   EN MODE CASE A CONFIGURER          //
////////////////////////////////////////////////////////////////////////////
public String mousepressed_gestion_boutons(int x, int y)
{

  String string_to_return = "-1";
  int ligne_selected = int(floor(case_courante / cols));
  int col_selected   = int(case_courante%4);
  println("ligne : " + ligne_selected + "\n col : " + col_selected);

  // si on appuie sur le bouton de config du type de case
  if (x >280 && x < 370 && y > 50 && y < 75)
  {

    if (flag_bouton_type_case == true)
    {
      flag_bouton_type_case = false;
    }
    else
    {
      flag_bouton_type_case = true;
    }
  } 

  if (flag_bouton_type_case == true)
  { 
    if (x >280 && x < 370 && y > 75 && y < 100)
    {
      cellule_fictive.function_type = "MAIL";
      flag_bouton_type_case = false;
    }

    if (x >280 && x < 370 && y > 100 && y < 125)
    {
      cellule_fictive.function_type = "RSS";
      flag_bouton_type_case = false;
    }

    if (x >280 && x < 370 && y > 125 && y < 150)
    {
      cellule_fictive.function_type = "CALENDAR";
      flag_bouton_type_case = false;
    }
  }


  ///////////////////////////////////////////////////////////////////////
  // si on appuie sur le bouton de config du thumbnail
  else if (x >280 && x < 370 && y > 100 && y < 125) {

    println("case de config thumbnail cliquee");
    // on ouvre une fenetre pour naviguer dans les dossiers et retrouver le thumbnail que l'on desire appliquer
    String chemin_thumbnail = open_file_function();

    // si NOT_VALID : on ne traite pas, sinon on remplace le thumbnail
    if (chemin_thumbnail != "NOT_VALID")
    {

      cellule_fictive.SetImage(chemin_thumbnail);
    }
  }


  ///////////////////////////////////////////////////////////////////////
  // si on appuie sur le bouton OK  
  else if (x >225 && x < 325 && y > 200 && y < 250) {
    string_to_return = "OK";
    Maingrille.MaGrille[col_selected][ligne_selected].Icone = cellule_fictive.Icone;
    Maingrille.MaGrille[col_selected][ligne_selected].function_type = cellule_fictive.function_type;
    // TEST
    modifier_fichier_config(chemin_fichier_config, "function_type", "cellule_fictive.function_type", 0, 0);
    // TODO : pareil avec les images
    //modifier_fichier_config(chemin_fichier_config,"function_type","cellule_fictive.function_type", 0, 0);
  }


  ///////////////////////////////////////////////////////////////////////
  // si on appuie sur le bouton CANCEL 
  else if (x >75 && x < 175 && y > 200 && y < 250) {
    string_to_return = "CANCEL";
  }


  return string_to_return;
}







//-----------------------------------------------------------------------------------------------------------------------//
//                                    FONCTIONS FICHIER DE CONFIG
//-----------------------------------------------------------------------------------------------------------------------//


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////
//           applique_fichier_config()            //
////////////////////////////////////////////////////

public void applique_fichier_config(String chemin_fichier_config) {
  // applique le fichier de config
  // pour l'instant suppose d'avoir deja un objet Magrille deja instancie


  String lines[] = loadStrings(chemin_fichier_config);
  // println("there are " + lines.length + " lines");

  int curr_row = 0;
  int curr_col = 0;

  for (int i = 0 ; i < lines.length; i++) {
    // println(lines[i]);

    if (!lines[i].startsWith("#")) { // si la ligne ne commence pas par un diese (caractere de commentaire)

      int index_egal = lines[i].indexOf("=");

      if (index_egal != -1) { // sil y a un signe egal dans la ligne


        String attrib_nom    = lines[i].substring(0, index_egal).trim();
        String attrib_valeur = lines[i].substring(index_egal+1, lines[i].length()).trim();
        // println(attrib_nom);
        // println("attrib valeur : " + attrib_valeur);


        // on ferait un switch sur des Strings mais ce n'est dispo que depuis JAVA 7 : me suis fait jeter sous LINUX !!
        //switch(attrib_nom) {

        // a chaque fois on met a jour le bon parametre et on remplit les cellules
        if (attrib_nom.equals("row")) { // TODO : GESTION DES EXCEPTIONS
          try {
            curr_row = Integer.parseInt(attrib_valeur);
          } 
          catch (Exception e) {
          }
        }

        else if (attrib_nom.equals("col")) {
          try {
            curr_col = Integer.parseInt(attrib_valeur);
          } 
          catch (Exception e) {
          }
        }

        else if (attrib_nom.equals("function_type")) {
          try { // ici : rajouter la creation/destruction d'objets en checkant si le type a change
            Maingrille.MaGrille[curr_col][curr_row].function_type = attrib_valeur;
          } 
          catch (Exception e) {
          }
        }

        else if (attrib_nom.equals("icon")) {
          try {
            Maingrille.MaGrille[curr_col][curr_row].SetImage(attrib_valeur);
          } 
          catch (Exception e) {
          }
        }

        else if (attrib_nom.equals("couleur")) {
          try {
            Maingrille.MaGrille[curr_col][curr_row].ChangeColor(color(Integer.parseInt(attrib_valeur)));
          } 
          catch (Exception e) {
          }
        }

        else if (attrib_nom.equals("FullSize")) {
          try {
            Maingrille.MaGrille[curr_col][curr_row].SetFullSize(Boolean.parseBoolean(attrib_valeur));
          } 
          catch (Exception e) {
          }
        }
        else if (attrib_nom.equals("Url")) {
          try {
            Maingrille.MaGrille[curr_col][curr_row].SetUrl(attrib_valeur);
          } 
          catch (Exception e) {
          }
        }
        //}
      }
    }
  }
}



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////
//           modifier_fichier_config()            //
////////////////////////////////////////////////////

public void modifier_fichier_config(String chemin_fichier_config, String nom_attrib_a_changer, String valeur_attrib_a_changer, int col_selected, int ligne_selected) {

  String lines[] = loadStrings(chemin_fichier_config);
  //println("there are " + lines.length + " lines");

  int curr_row = 0;
  int curr_col = 0;

  for (int i = 0 ; i < lines.length; i++) {
    //println(lines[i]);

    if (!lines[i].startsWith("#")) { // si la ligne ne commence pas par un diese (caractere de commentaire)

      int index_egal = lines[i].indexOf("=");

      if (index_egal != -1) { // sil y a un signe egal dans la ligne

        String attrib_nom    = lines[i].substring(0, index_egal).trim();
        String attrib_valeur = lines[i].substring(index_egal+1, lines[i].length()).trim();


        if (attrib_nom.equals("row")) { // TODO : GESTION DES EXCEPTIONS
          try {
            curr_row = Integer.parseInt(attrib_valeur);
          } 
          catch (Exception e) {
          }
        }

        else if (attrib_nom.equals("col")) {
          try {
            curr_col = Integer.parseInt(attrib_valeur);
          } 
          catch (Exception e) {
          }
        }

        if (attrib_nom.equals(nom_attrib_a_changer) && curr_col == col_selected && curr_row == ligne_selected) {

          lines[i] = attrib_nom + "     =   " + valeur_attrib_a_changer;
        }
      }
    }
  }

  saveStrings(chemin_fichier_config, lines);
}

//-----------------------------------------------------------------------------------------------------------------------//




//-----------------------------------------------------------------------------------------------------------------------//
//                                 SOUS FONCTIONS DE NIVEAU 2 (APPELEE PAR UNE AUTRE SOUS FONCTION)
//-----------------------------------------------------------------------------------------------------------------------//


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////
//  affichage_gmail()            //
////////////////////////////////////////////////////
public void affichage_gmail(int y)
{
  if (y < bloc_gmail.debut_zone_message + 20 && y > bloc_gmail.debut_zone_message) {
    // on a la souris en haut

    // on avance la position de defilement
    bloc_gmail.pos_defil_courant = bloc_gmail.pos_defil_courant + 15;
    // on rafraichit 
    bloc_gmail.affiche_data(monMail.array_from, monMail.array_sujet);

    // on dessine une petite fleche
    fill(230, 230, 255, 50);
    rect(0, bloc_gmail.debut_zone_message, bloc_gmail.total_width, 20);
    fill(150, 150, 255, 50);
    stroke(200);
    triangle(0 + 100, bloc_gmail.debut_zone_message, int(gridSize/2), bloc_gmail.debut_zone_message + 20, gridSize -100, bloc_gmail.debut_zone_message);
  }

  else if (y < bloc_gmail.debut_zone_message + bloc_gmail.total_height && y > bloc_gmail.debut_zone_message + bloc_gmail.total_height-20) {
    // on a la souris en bas

    // on recule la position de defilement
    bloc_gmail.pos_defil_courant = bloc_gmail.pos_defil_courant - 15;
    // on rafraichit 
    bloc_gmail.affiche_data(monMail.array_from, monMail.array_sujet);

    // on dessine une petite fleche
    fill(230, 230, 255, 50);
    rect(0, bloc_gmail.debut_zone_message + bloc_gmail.total_height -20, bloc_gmail.total_width, 20);
    fill(150, 150, 255, 50);
    stroke(200);
    triangle(0 + 100, bloc_gmail.debut_zone_message + bloc_gmail.total_height, int(gridSize/2), bloc_gmail.debut_zone_message + bloc_gmail.total_height-20, gridSize -100, bloc_gmail.debut_zone_message + bloc_gmail.total_height);
  }   

  else {
    bloc_gmail.affiche_data(monMail.array_from, monMail.array_sujet);
  }
}













