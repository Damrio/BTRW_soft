

///////////////////////////////////////////////
//           FONCTION PRINCIPALE
//////////////////////////////////////////////


// IMPORT BIBLIOTHEQUES
//--------------------------------------------------------
import com.onformative.yahooweather.*;
import java.util.Date;
import javax.mail.*;
import javax.mail.internet.*;
import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;
import javax.swing.*; 
import com.wyldco.romefeeder.*;
import com.sun.syndication.feed.synd.*;
import com.sun.syndication.feed.*; 
import processing.serial.*;
//--------------------------------------------------------


//--------------------------------------------------------
//  DECLARATION DES VARIABLES GLOBALES
//--------------------------------------------------------

// 2D Array of objects
Grille Maingrille;

// Number of columns and rows in the Maingrille.MaGrille
int cols = 4;
int rows = 3;
int scareSize;
int gridSize=480;

//=========================================================================
//     DECLARATION DES VARIABLES DE LA PARTIE DYNAMIQUE

// case qui est couramment cliquee (mis a -1 si affichage principal en cours)
// les cases sont numerotees :
//    0   1   2   3
//    4   5   6   7
//    ..  ..  ..  ..
int case_courante         =   -1;
int led_courante          =   -1;
int ligne_selected        =   -1;
int col_selected          =   -1;
String curr_function_type =   "";


//--------------------------------------------------------------------
//      INSTANCIATION DE l'INDICATEUR DE MODE
// Il s'agit de savoir dans quel menu on est
// CONVENTION :
// 0 - MODE VEILLE
// 1 - MODE principal
// 2 - MODE case cliquee
// 3 - MODE config
// 4 - MODE case a configurer
int indicateur_mode = 1;
//--------------------------------------------------------------------
//     Niveau du mode activé 
int ModeLevel=0;
//0- 1er Niveau
//1- 2nd Noveau
//2- 3ème niveau
//...

//--------------------------------------------------------------------


// creation d'un flag pour le bouton type de case dans le menu config
boolean flag_bouton_type_case = false;

//===========================================================================

// chemin dossier local
String ref_chemin = "./data/Chemin_ref.txt";

// chemin du fichier de configuration
String chemin_fichier_config ="";

// on cree un objet cell pour le menu config : cellule ou on enregistre les changements avant de les appliquer
Cell cellule_fictive = new Cell(0, 0, int(gridSize/cols), int(gridSize/rows), 0);

//Paramètres affichage Weather
int WindowLargeur=480;
int WindowHauteur=120;
String nFichier="";
String CheminDossierImage="";
String Lieu="Toulouse";
String tab[][];
Endroit[] ListeEndroits;
PImage[] WeatherIcon; 
YahooWeather weather;
float rationHL;
int updateIntervallMillis = 30000;
String Ville="";
SimpleDateFormat Hd = new SimpleDateFormat("HH");
SimpleDateFormat md = new SimpleDateFormat("mm");
PFont TextWeatherFont;

//Paramètre affichage RSS
PFont fnt;
PFont myfont;
PFont myfontTittleRSS;
int offset=0;
float maxOffset;
int offsetLecture=0;
float maxOffsetLecture;
int indicePrintedRss;
int LargeurPhoto=200;
int HauteurPhoto=160;
int FlagMainRss=1;
float interstice=5;
List<Feeder> ListFeed = new ArrayList<Feeder>(); 
List<RSSLoader> ListLoader = new ArrayList<RSSLoader>(); 
List<Thread> ListThread = new ArrayList<Thread>(); 
List<String> ListAdresseRSS = new ArrayList<String>(); 

//-------------------------------------------------------------------
// DECLARATION DE LA PARTIE HEURE
int minutes;
int dizaine_de_minute;
int chiffre_minute;
int heures; 
PFont FontHeure;
PFont Font_Dminutes;
PFont Font_Cminutes;


//-------------------------------------------------------------------
// DECLARATION DE LA PARTIE BANDEAU Titre RSS
List<String> ListTitleToPrint = new ArrayList<String>(); // Liste des titres des entrées Rss
List<Date> ListTitleDate= new ArrayList<Date>(); // Liste des dates des entrées Rss
int NombreTitreToPlot=10; //Nombres d'entrées à afficher
int OffsetTitreRss; 
String TitreRss;
int indice=0;
int Offset_deplacement=3;// vitesse de déplacment du bandeau en pixel
long nb_millisec_deplacement=20;// intervalle de temps entre chaque déplacement du bandeau
long temps_dernier_deplacement_bandeau=System.currentTimeMillis();// temps de la dernière mise à jour du bandeau

//-------------------------------------------------------------------
// DECLARATION DE LA PARTIE MAILS
// on declare un objet monMail qui va s'occuper de recuperer les mails
MailChecker monMail = new MailChecker();
int NB_MAX_MESSAGES = 15; // nombre max de messages que l'on veut recuperer
// attention : ils seront tous precharges lors de l'affichage

// creation de l'afficheur GMail
Afficheur_data bloc_gmail = new Afficheur_data();
//----------------------------------------------------------------------


//----------------------
// OUVERTURE DES THREADS
//----------------------
Thread t = new Thread(new RunImpl(monMail));
//TestThread s = new TestThread();


//--------------------------------------------------------------------------------------


//--------------------------------------------------------------------------------------
// COMPTEURS POUR LES TACHES PLANIFIEES
long temps_derniere_action=System.currentTimeMillis();// garde le temps  de la dernière action de l'utilisateur
long temps_de_ref_mails = System.currentTimeMillis();// temps de la dernière MAJ mail en secondes
long nb_sec_refresh_mails = 30;// en secondes
long temps_de_ref_Rss = System.currentTimeMillis();// temps de la dernière MAJ RSS en seconde
long tempsIni=System.currentTimeMillis();// temps du démarrage de l'application
long nb_sec_refresh_Rss;
long nb_sec_refresh_Rss_ini=1;//intervalle de temps de rafraîchissement des flux Rss initial
long nb_sec_refresh_Rss_nominal=60;//intervalle de temps de rafraîchissement des flux Rss nominal
long Init_Temps_Rss=20;//en secondes
long nb_sec_mode_veille=100;// en secondes
//-------------------------------------------------------------------------------------- 


// ----------------------------------------------------------
//   DECLARATION DES VARIABLES POUR COMMUNIQUER AVEC ARUDINO
int nombre_Led_RGB=16;//Nombrte de LED RGB du projet
Serial port; // On déclare le port série
boolean arduino_enabled = false; // flag pour pouvoir desactiver les fonctions arduino si celui ci n'est pas branche
// ----------------------------------------------------------




////////////////////////////////////////////////////
//              FONCTION SETUP                    //
////////////////////////////////////////////////////
void setup() {


  scareSize=(int)(gridSize/4);
  size(640, gridSize);
  Maingrille= new Grille(cols, rows);
  Maingrille.SetDefaultFont("K22 Didoni Swash.ttf");
//  Maingrille.SetIconeSize((int)(scareSize*0.3));
  Maingrille.SetIconeSize((int)(scareSize*0.85));

  fnt=createFont("Courier", 18);
  myfont=  createFont("MARYJ___.ttf", 32);
  myfontTittleRSS=  createFont("Chunkfive Ex.ttf", 32);
  FontHeure=createFont("PostinkantajaJob.ttf", 90);
  Font_Dminutes=createFont("CuteWriting.ttf", 80);
  Font_Cminutes=createFont("DK Father Frost.otf", 70);

  //Instanciation du chemin courant
  String CheminRef=RecupCheminRef(ref_chemin);
  println(CheminRef);
  nFichier=CheminRef+"/data/yahoo Weather Code.txt";
  CheminDossierImage=CheminRef+"/data/026";
  chemin_fichier_config=CheminRef+"/config_rpi.txt";

  // creation du Calendrier : TODO
  Calendrier monCalendrier = new Calendrier();

  // demarrage thread gmail
  t.start();

  //Instancitation de l'offset du bandeau de flux Rss 
  OffsetTitreRss=650;
  TitreRss="";

  // demarrage du Thread du bandeau Rss
  //s.setPriority(Thread.MAX_PRIORITY);
  //s.start();



  TextWeatherFont=createFont("Georgia", 15);
  //Initilaisation du tableau de correspondance Weather Code/ Image
  tab=lireFichierRech(nFichier);
  Lieu=Lieu.replaceAll(" ", "%20");
  ListeEndroits=GetEndroit(Lieu);
  int woeid;
  if (ListeEndroits==null) woeid=628886;
  else woeid=Integer.parseInt(ListeEndroits[0].woeid);
  weather = new YahooWeather(this, woeid, "c", updateIntervallMillis);
  weather.setTempertureUnit("c");
  WeatherIcon=Chargement_Image_Weather(CheminDossierImage, "png");


  // The counter variables i and j are also the column and row numbers
  // In this example, they are used as arguments to the constructor for each object in the Maingrille.MaGrille.

  for (int i = 0; i < cols; i ++ ) {
    for (int j = 0; j < rows; j ++ ) {
      Maingrille.MaGrille[i][j] = new Cell(i*scareSize, j*scareSize, scareSize, scareSize, color(0, 0, 0));
    }
  }


  // ON lit le fichier de configuration pour mettre a jour les cellules de la grille
  // TODO : gerer les exceptions si le fichier n'est pas bien configure (valeurs idiotes)
  applique_fichier_config(chemin_fichier_config);
  
 
  //InitilialisationRSS
  Maingrille.InitListRSS(cols, rows);
  CreateRss() ;
  UpdateRss() ;
  
  
  // INIT PORT SERIE POUR ARDUINO
  // On sélectionne le premier, mais il faut vérifier que ce soit bien celui la
  if (arduino_enabled) { // flag pour pouvoir desactiver les fonctions arduino si celui ci n'est pas branche (phase de test)
  println(port.list()[0]);
  port = new Serial(this, Serial.list()[0], 115200); // On établit une connexion série à 115,2 Mbaud
  port.clear(); //On efface le buffer du port série 
  port.bufferUntil('\n'); // On indique qu'on bufferise jusqu'à l'arrivée d'un saut de ligne
  
  SendRGBValue_Message(1,255,0,0);
  }
}  



////////////////////////////////////////////////////
//              FONCTION DRAW                     //
////////////////////////////////////////////////////
void draw() {

  background(0);
  // fonction de taches planifiees
  draw_applique_tache_planifiees();

  // Si on n'est dans le mode veille on ne fait rien on laisse le background en noir
  if (indicateur_mode == 0)
  {
   Affichage_Heure();
  } 


  // ON ne rafraichit l'affichage que si on est dans le MODE principal 
  // (sinon cela signifie que les mails sont consultes et le reste de l'affichage est freeze)
  if (indicateur_mode == 1) // Il faudrait rajouter une condition : and Change_flag == true
  {
    
    strokeWeight(1);
    frameRate(30);
    Maingrille.Display(cols, rows); 

    
    int xpos;
    xpos=0;
    int hauteurVent=40;
    AffichageTempertaure(weather, 480+3, xpos);
    rationHL=AffichageImageWeather(weather, 0, 100, 480, xpos+3); 
    xpos+=(int)rationHL*100+10;
    Affichage_Vitesse_Vent(weather,hauteurVent,480+10+hauteurVent/2, xpos);
    xpos+=hauteurVent+20;
    AffichageTemperatureLendemain(weather, 1,480+3, xpos);
    rationHL=AffichageImageWeather(weather, 1, 80, 480, xpos);
    Affichage_Journee(weather, 1,  480+110, xpos);
    xpos+=(int)rationHL*100+10;
    AffichageTemperatureLendemain(weather, 2,480+3, xpos);
    rationHL=AffichageImageWeather(weather, 2, 80, 480, xpos);
    Affichage_Journee(weather, 2,  480+110, xpos);
    

    if (ListTitleToPrint.size()>=NombreTitreToPlot) {
      DefilerBandeauTitreRss();
      textFont(myfontTittleRSS, 45);
      text(TitreRss, OffsetTitreRss, 360+(60)+textAscent()/2);
      
      
    }
  }

  else if (indicateur_mode == 2) // cas ou on est en MODE case cliquee

  {
    draw_case_cliquee();
  }  


  else if (indicateur_mode == 3 ) // cas ou l'on est en MODE configuration
  {
    draw_configuration();
  }


  else if (indicateur_mode == 4) // cas ou l'on est en MODE CASE A CONFIGURER
  {
    draw_case_a_configurer();
  }
}




////////////////////////////////////////////////////
//              FONCTION KEYPRESSED               //
////////////////////////////////////////////////////
void keyPressed() {

  Action_detectee(); 

  // basculement dans le MODE config (pour l'instant accessible uniquement depuis le mode principal)
  if (key == 'M' || key == 'm') 

  {

    if (indicateur_mode == 1) // si on est dans le mode principal  
    {
      indicateur_mode = 3;
      System.out.println("MODE CONFIGURATION ON");
    }
    else if (indicateur_mode == 3 || indicateur_mode == 4)
    {
      indicateur_mode = 1;
      System.out.println("MODE CONFIGURATION OFF");
    }
  } 

  else

  {

    if (key!=SHIFT) {
      if (key == ENTER) {
        println(Ville);
        if (Ville != null) {
          Ville = Ville.replaceAll(" ", "%20");
          ListeEndroits=GetEndroit(Ville);
          if (ListeEndroits!=null) {
            weather.setWOEID(Integer.parseInt(ListeEndroits[0].woeid));
            weather.update();
          }
          Ville="";
        }
      }
      else {
        Ville=Ville+key;
      }
    }
  }
}





//////////////////////////////////////////////////////
//              FONCTION MOUSEPRESSED               //
//////////////////////////////////////////////////////
void mousePressed()

{
  Action_detectee(); 

  // on recupere les coordonnees de la souris a l'endroit ou le bouton a ete presse
  int x=mouseX;
  int y=mouseY;


  // d'abord on regarde si on a deja ouvert une case (MODE case cliquee)
  if (indicateur_mode == 2) {

    ligne_selected = int(floor(case_courante / cols));
    col_selected   = int(case_courante%4);
    curr_function_type = Maingrille.MaGrille[col_selected][ligne_selected].function_type;

    String curr_Url=Maingrille.MaGrille[col_selected][ligne_selected].Url;
    int currentListIndex=getIndexFromUrl(curr_Url);


    if (mouseButton==RIGHT &&  ModeLevel==0) {
      indicateur_mode    =    1; // on repasse en MODE principal
      case_courante      =   -1; // on met case_courante a -1
    }



    if (ModeLevel==0 && mouseButton==LEFT ) { // cas ou on veut lire un flux, un mail

      ModeLevel=1 ;


      if (curr_function_type.equals("GMAIL")) {
        // on determine index du mail a afficher et mise a jour offset lecture
        bloc_gmail.pos_defil_contenu_mail_courant = 0;
        bloc_gmail.index_mail_a_afficher = round((mouseY - bloc_gmail.pos_defil_courant) / bloc_gmail.message_height);
      }



      if (curr_function_type.equals("Rss")) {
        // mise a jour offset lecture (uniquement pour RSS)

        indicePrintedRss=NumRss(ListLoader.get(currentListIndex));
        offsetLecture=0;
      }
    }

    if (ModeLevel==1 &&  mouseButton==RIGHT) { // cas ou on veut revenir a la liste des flux, mails
      ModeLevel=0;
      offset=0;
    }

    // TODO : rajouter un compteur pour ne pas que cet ecran soit ouvert trop longtemps ? (genre qqs min)
  }


  else if (indicateur_mode == 1) // sinon on regarde si on est dans le mode principal
  {              
    //last_mode       = 1 ;
    indicateur_mode = 2 ; // on bascule en MODE case cliquee

    // on calcule la case courante, la ligne, la colonne, et le type de fonction selectionne
    case_courante = (int)(x/(gridSize/4)) + cols*(int)(y/(gridSize/4));
    led_courante =  case_courante+1;
    ligne_selected = int(floor(case_courante / cols));
    col_selected   = int(case_courante%4);
    curr_function_type = Maingrille.MaGrille[col_selected][ligne_selected].function_type;
    ModeLevel=0;

    if (curr_function_type.equals("GMAIL")) {
    Maingrille.MaGrille[col_selected][ligne_selected].numberofEvents=0;
    color couleur_originale = Maingrille.MaGrille[col_selected][ligne_selected].couleur_bulle;
    println(couleur_originale);
    Maingrille.MaGrille[col_selected][ligne_selected].ChangeCouleurBulle(color(0, 0, 100));
      if (arduino_enabled) { // flag pour pouvoir desactiver les fonctions arduino si celui ci n'est pas branche (phase de test)
        Stop_Fading_Message (led_courante);
        port.write("/");
        SendRGBValue_Message(led_courante, 0, 0, 0);
        port.write("/");
      }
    }
    
    if (curr_function_type.equals("Rss")) {
    Maingrille.MaGrille[col_selected][ligne_selected].numberofEvents=0;
    Maingrille.MaGrille[col_selected][ligne_selected].ChangeCouleurBulle(color(0, 0, 100));
    // TODO rajouter ici les fonctions pour controler les LED
    }
    // on regarde sur quelle case on a clique : les cases sont numerotees :
    //    0   1   2   3
    //    4   5   6   7
    //    ..  ..  ..  ..
  }


  else if (indicateur_mode == 3) // cas ou est en mode config et ou on a clique sur une case
  {
    case_courante = (int)(x/(gridSize/4)) + cols*(int)(y/(gridSize/4));
    ligne_selected = int(floor(case_courante / cols));
    col_selected   = int(case_courante%4);
    indicateur_mode = 4; // on passe en mode CASE A CONFIGURER

    ligne_selected = int(floor(case_courante / cols));
    col_selected   = int(case_courante%4);
    // on met dans la cellule fictive les valeurs courante de la case
    cellule_fictive.Icone = Maingrille.MaGrille[col_selected][ligne_selected].Icone;
    cellule_fictive.function_type = Maingrille.MaGrille[col_selected][ligne_selected].function_type;
  }


  else if (indicateur_mode == 4) // cas ou on est en mode CASE A CONFIGURER
  {
    String case_cliquee_mode_4 = "-1";
    case_cliquee_mode_4 = mousepressed_gestion_boutons(x, y);

    // si on sort en ayant clique sur OK alors on repasse dans le mode principal
    if (case_cliquee_mode_4.equals("OK")) {

      indicateur_mode = 1;
    }

    else if (case_cliquee_mode_4.equals("CANCEL")) {

      indicateur_mode = 3;
    }
  }
}

void mouseMoved() {
  Action_detectee();
}

