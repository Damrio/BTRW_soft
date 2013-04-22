void AffichageRss(int offset, RSSLoader RSSToLoad) {
  int X=0;
  int Y=offset;
  int  Debut=offset;
  float RatioHL;
  RssEntry CurrentEntry;
  DateFormat df = new SimpleDateFormat("dd/MM HH:mm");



  for (int i=RSSToLoad.RssContent.size()-1; i>=0; i--) {
    Y=Debut;
    CurrentEntry=RSSToLoad.getRss(i);
    X=0;  
    if (CurrentEntry.HasImage==true) {
      PImage tmp=RSSToLoad.getImage(i);  
      if (tmp!=null) {
        RatioHL=tmp.width/tmp.height;
        float larg;
        if (RatioHL*HauteurPhoto>LargeurPhoto) larg=LargeurPhoto;
        else larg=RatioHL*HauteurPhoto;
        image(tmp, X+(LargeurPhoto-larg)/2, Y, larg, HauteurPhoto);
      }
    }
    else {
      if (CurrentEntry.PublishedDate!=null) {
        textFont(myfont, 12);
        text( df.format(CurrentEntry.PublishedDate), X+(LargeurPhoto-textWidth(df.format(CurrentEntry.PublishedDate)))/2, Y+HauteurPhoto/2);
      }
    }
    X+=LargeurPhoto;
    textFont(myfontTittleRSS, 18);
    text(CurrentEntry.Title, X, Y, 640-X-4, HauteurPhoto);
    //println("text Width:"+textWidth(CurrentEntry.Title));
    int numLine=(int)(textWidth(CurrentEntry.Title)/(gridSize-X))+1;
    //println("Nombre de lignes:"+ numLine);
    float saut=(textAscent()+textDescent())*numLine+5;
    Y+=saut;
     textFont(myfont, 16);
    text(CurrentEntry.Description, X, Y, 640-X-4, HauteurPhoto-saut);
    Debut=Debut+HauteurPhoto+20;
  }
}

int ComputeOffset(int CurrentOffset) {
  if (mouseY< gridSize && mouseY> gridSize-20 && mouseX>0 && mouseX< gridSize) {
    offset=offset-15;
  }
  else if (mouseY>0 && mouseY<20 && mouseX>0 && mouseX< gridSize) {
    offset=offset+15;
  }
  maxOffset=(ListLoader.get(indice).RssContent.size())*(HauteurPhoto+20);
  if (offset>0)offset=0;
  if (offset<-(int)((maxOffset-gridSize)/4)*4)offset=-(int)((maxOffset-gridSize)/4+1)*4; 

  return offset;
}


int NumRss(RSSLoader RSSToLoad) {
  int res=(RSSToLoad.RssContent.size()-1)-(int)((mouseY-offset)/(HauteurPhoto+20));
  res=res;
  println(res);
  return res;
}


float DisplayCurrentRSS(int offset, int indexRss, RSSLoader RSSToLoad) {
  int X=0;
  int Y=offset+10;
  float HauteurPhoto=200; 
  float LargeurPhoto=640; 
  float HauteurEcrite=0;
  float RatioHL;
  RssEntry CurrentEntry;
  CurrentEntry=RSSToLoad.getRss(indexRss);


  textFont(myfontTittleRSS, 30);
  textAlign(CENTER);
  text(CurrentEntry.Title, X+5, Y, 640-10, HauteurPhoto);
  int numLine=(int)(textWidth(CurrentEntry.Title)/(640-10))+1;
  float saut=(textAscent()+textDescent())*numLine*1.3; 
  Y+=saut;
  HauteurEcrite+=saut;

  if (CurrentEntry.HasImage==true) {
    PImage tmp=RSSToLoad.getImage(indexRss);  
    if (tmp!=null) {
      RatioHL=tmp.width/tmp.height;
      float larg;
      if (RatioHL*HauteurPhoto>LargeurPhoto) larg=LargeurPhoto;
      else larg=RatioHL*HauteurPhoto;
      image(tmp, X+(LargeurPhoto-larg)/2, Y, larg, HauteurPhoto);
      Y+=HauteurPhoto;
      HauteurEcrite+=HauteurPhoto;
    }
  }
  Y+=20;
  HauteurEcrite+=20;
  textFont(myfont, 22);
  textAlign(LEFT);
  text(CurrentEntry.Description, X+5, Y, 640-10, 8000);

  numLine=(int)(textWidth(CurrentEntry.Description)/(640))+1;
  saut=(textAscent()+textDescent())*numLine*1.3; 
  HauteurEcrite+=saut;
  HauteurEcrite-=gridSize*2/3;

  return HauteurEcrite;
}


int ComputeOffsetLecture(int CurrentOffset) {
  int increment=5;
  if (mouseY< gridSize && mouseY>gridSize-20 && mouseX>0 && mouseX<gridSize) {
    offsetLecture=offsetLecture-increment;
  }
  else if (mouseY>0 && mouseY<20 && mouseX>0 && mouseX<gridSize) {
    offsetLecture=offsetLecture+increment;
  }
  if (offsetLecture>0)offsetLecture=0;
  if (offsetLecture<-(int)maxOffsetLecture) offsetLecture+=increment; 

  return offsetLecture;
}

