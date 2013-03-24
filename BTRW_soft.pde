

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
int gridSize=400;



//=========================================================================
//     DECLARATION DES VARIABLES DE LA PARTIE DYNAMIQUE

// case qui est couramment cliquee (mis a -1 si affichage principal en cours)
// les cases sont numerotees :
//    0   1   2   3
//    4   5   6   7
//    ..  ..  ..  ..
int case_courante = -1;


//--------------------------------------------------------------------
//      INSTANCIATION DE l'INDICATEUR DE MODE
// Il s'agit de savoir dans quel menu on est
// CONVENTION :
// 1 - MODE principal
// 2 - MODE case cliquee
// 3 - MODE config
// 4 - MODE case a configurer
int indicateur_mode = 1;
int last_mode=1;
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

// chemin du fichier de configuration
String chemin_fichier_config ="/home/damien/sketchbook/maquette_main/config_rpi.txt";

// on cree un objet cell pour le menu config : cellule ou on enregistre les changements avant de les appliquer
Cell cellule_fictive = new Cell(0, 0, int(gridSize/cols), int(gridSize/rows), 0);


int WindowLargeur=400;
int WindowHauteur=100;
String nFichier="/home/damien/sketchbook/maquette_main/data/yahoo Weather Code.txt";
String CheminDossierImage="/home/damien/sketchbook/maquette_main/data/026";
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

PFont fnt;
PFont myfont;
int offset=0;
float maxOffset;
int offsetLecture=0;
float maxOffsetLecture;
int indicePrintedRss;
int LargeurPhoto=100;
int HauteurPhoto=80;
int FlagMainRss=1;
float interstice=5;
List<Feeder> ListFeed = new ArrayList<Feeder>(); 
List<RSSLoader> ListLoader = new ArrayList<RSSLoader>(); 
List<Thread> ListThread = new ArrayList<Thread>(); 
List<String> ListAdresseRSS = new ArrayList<String>(); 
int indice=0;


//-------------------------------------------------------------------
// DECLARATION DE LA PARTIE MAILS
// on declare un objet monMail qui va s'occuper de recuperer les mails
MailChecker monMail = new MailChecker();
int NB_MAX_MESSAGES = 12; // nombre max de messages que l'on veut recuperer
// attention : ils seront tous precharges lors de l'affichage

// creation de l'afficheur GMail
Afficheur_data bloc_gmail = new Afficheur_data();
//----------------------------------------------------------------------


//----------------------
// OUVERTURE DES THREADS
//----------------------
Thread t = new Thread(new RunImpl());

//--------------------------------------------------------------------------------------


//--------------------------------------------------------------------------------------
// COMPTEURS POUR LES TACHES PLANIFIEES
long temps_de_ref = System.currentTimeMillis();
long nb_sec_refresh_mails = 60*5; // en secondes
//-------------------------------------------------------------------------------------- 



////////////////////////////////////////////////////
//              FONCTION SETUP                    //
////////////////////////////////////////////////////
void setup() {


  scareSize=(int)(gridSize/4);
  size(gridSize, gridSize);
  Maingrille= new Grille(cols, rows);
  Maingrille.SetDefaultFont("K22 Didoni Swash.ttf");
  Maingrille.SetIconeSize((int)(scareSize*0.25));

  fnt=createFont("Courier", 18, false);
  myfont=  createFont("stalker2", 32);

  // creation du Calendrier : TODO
  Calendrier monCalendrier = new Calendrier();

  // demarrage thread gmail
  t.start();

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
}  



////////////////////////////////////////////////////
//              FONCTION DRAW                     //
////////////////////////////////////////////////////
void draw() {
  background(0);
  // fonction de taches planifiees
  draw_applique_tache_planifiees();

  //Mis a jour Flux RSS
  UpdateRss();


  // ON ne rafraichit l'affichage que si on est dans le MODE principal 
  // (sinon cela signifie que les mails sont consultes et le reste de l'affichage est freeze)
  if (indicateur_mode == 1)
  {

    strokeWeight(1);
    frameRate(24);
    Maingrille.Display(cols, rows);

    rationHL=AffichageImageWeather(weather, 0, WindowHauteur, 0, 300); 
    float MarginH=Affichage_Text_Weather(WindowHauteur*rationHL, 300);
    rationHL=AffichageImageWeather(weather, 1, WindowHauteur/2, MarginH+20, 300);
    textFont(TextWeatherFont);
    AffichageTempertaure(weather, 3, 300);
    AffichageTemperatureLendemain(weather, MarginH+10, 20+WindowHauteur/2+7+300);
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
  // on recupere les coordonnees de la souris a l'endroit ou le bouton a ete presse
  int x=mouseX;
  int y=mouseY;


  // d'abord on regarde si on a deja ouvert une case (MODE case cliquee)
  if (indicateur_mode == 2) {
    // si OUI alors l'ecran d'affichage des mails est deja ouvert et il faut le refermer : pour cela il suffit de remettre le flag a false
    last_mode          =    2;
    if (mouseButton==RIGHT &&  ModeLevel==0) {
      indicateur_mode    =    1; // on repasse en MODE principal
      case_courante      =   -1; // on met case_courante a -1
    }
    // TODO : rajouter un compteur pour ne pas que cet ecran soit ouvert trop longtemps ? (genre qqs min)
  }


  else if (indicateur_mode == 1) // sinon on regarde si on est dans le mode principal
  {              
    last_mode       = 1 ;
    indicateur_mode = 2 ; // on bascule en MODE case cliquee
    ModeLevel=0;
    case_courante = (int)(x/(gridSize/4)) + cols*(int)(y/(gridSize/4));
    // on regarde sur quelle case on a clique : les cases sont numerotees :
    //    0   1   2   3
    //    4   5   6   7
    //    ..  ..  ..  ..
  }


  else if (indicateur_mode == 3) // cas ou est en mode config et ou on a clique sur une case
  {
    case_courante = (int)(x/(gridSize/4)) + cols*(int)(y/(gridSize/4));
    indicateur_mode = 4; // on passe en mode CASE A CONFIGURER
    last_mode       = 3 ;
    int ligne_selected = int(floor(case_courante / cols));
    int col_selected   = int(case_courante%4);
    // on met dans la cellule fictive les valeurs courante de la case
    cellule_fictive.Icone = Maingrille.MaGrille[col_selected][ligne_selected].Icone;
    cellule_fictive.function_type = Maingrille.MaGrille[col_selected][ligne_selected].function_type;
  }


  else if (indicateur_mode == 4) // cas ou on est en mode CASE A CONFIGURER
  {
    String case_cliquee_mode_4 = "-1";
    case_cliquee_mode_4 = mousepressed_gestion_boutons(x, y);
    last_mode       = 4 ;
    // si on sort en ayant clique sur OK alors on repasse dans le mode principal
    if (case_cliquee_mode_4.equals("OK")) {

      indicateur_mode = 1;
    }

    else if (case_cliquee_mode_4.equals("CANCEL")) {

      indicateur_mode = 3;
    }
  }
}

