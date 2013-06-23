// A Cell object

class Cell {

  // A cell object knows about its location in the grid as well as its size with the variables x, y, w, h.
  float x, y;   // x,y location
  float w, h;   // width and height
  color couleur; 
  PImage Icone;
  Boolean FullSize;
  String Type; 
  String function_type;
  int numberofEvents;
  String Url;

  // Cell Constructor
  Cell(float tempX, float tempY, float tempW, float tempH, color Couleur) {
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
    couleur= Couleur;
    numberofEvents=0;
    FullSize=false;
    Type="Event";
    function_type = "none";
    Url="";
  }

  void SetImage(String nomImage) {
    Icone= loadImage(nomImage);
  }

  void AddEvent(int NumberEventsToAdd) {
    numberofEvents+=NumberEventsToAdd;
  }

  void ChangeColor(color colorToSet) {
    couleur= colorToSet;
    //display(Maingrille);
  }

  void displayImage(Grille CurrentGrille) {
    float rationHL;
    if (Icone!=null) {
      rationHL=(float)Icone.width/(float)Icone.height;
      if (FullSize==false) {
        image (Icone, x+1, y+1, (int)(rationHL*CurrentGrille.iconeSize), CurrentGrille.iconeSize);
        tint(255, 255);
      }
      else {

        image (Icone, x, y, (int)(rationHL*scareSize), scareSize);
        tint(255, 255);
      }
    }
  }


  void display(Grille CurrentGrille) {
    stroke(255);
    fill(couleur, 255);
    rect(x, y, w, h);
    displayImage(CurrentGrille);
    displayEvent(CurrentGrille);
  }

  void display_config(Grille CurrentGrille) {
    stroke(255);
    fill(couleur, 255);
    rect(x, y, w, h);
    displayImage(CurrentGrille);
  }


  void SetFullSize(boolean fullSize) {
    FullSize= fullSize;
  }

  void SetUrl(String url) {
    Url= url;
  }

  String getUrl() {
    return Url;
  }

  void SetType(String type) {
    Type= type;
  }

  String getFunction_type() {
    return function_type;
  }

  void displayEvent(Grille CurrentGrille) {
    textFont(CurrentGrille.font, 150);
    String Value;
    if (Type=="Event") {
      if (numberofEvents>99) {
        Value="99";
      }
      else {
        Value=String.valueOf(numberofEvents);
      }
      if (couleur==color(0)) {
        fill(255, 255, 255);
      }
      else {
        fill(0, 0, 0);
      }
      textSize(75);
      text(Value, x+(w/2-(int)(textWidth(Value)/2)), y+(int)((h+25+textAscent()-textDescent())/2));
    }
  }
}

class Grille {
  Cell[][] MaGrille;
  PFont font;
  int iconeSize;

  Grille(int cols, int rows) {
    MaGrille=new Cell[cols][rows];
  }

  void SetDefaultFont(String fontName) {
    font= createFont(fontName, 16);
  }
  void SetIconeSize(int IconeSize) {
    iconeSize= IconeSize;
  }

  void Display(int row, int col) {

    for (int i=0;i<row;i++) {
      for (int j=0;j<col;j++) {
        MaGrille[i][j].display(this);
      }
    }
  }


  void DisplayConfig(int row, int col) {

    for (int i=0;i<row;i++) {
      for (int j=0;j<col;j++) {
        MaGrille[i][j].display_config(this);
      }
    }
  }

  void InitListRSS(int row, int col) {
    for (int i=0;i<row;i++) {
      for (int j=0;j<col;j++) {
        if (MaGrille[i][j].getFunction_type().equals("Rss")) {
          ListAdresseRSS.add(MaGrille[i][j].getUrl());
          println("Flux: "+MaGrille[i][j].getFunction_type() + " ajoutée!");
        }
      }
    }
  }
  
  int[] RechercheAdresseDansGrille(int row, int col, String Url) {
   int Cellule[]=new int[2];
    for (int i=0;i<row;i++) {
      for (int j=0;j<col;j++) {
        if (MaGrille[i][j].getUrl().equals(Url)) {
          Cellule[0]=i;
          Cellule[1]=j;
        }
      }
    }
    return Cellule;
  }
  
  
  int[] Recherchefunction_typeDansGrille(int row, int col, String function_type) {
   int Cellule[]=new int[2];
    for (int i=0;i<row;i++) {
      for (int j=0;j<col;j++) {
        if (MaGrille[i][j].function_type.equals(function_type)) {
          Cellule[0]=i;
          Cellule[1]=j;
        }
      }
    }
    return Cellule;
  }
  
}

