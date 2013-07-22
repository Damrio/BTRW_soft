

// Liste et chargement des images Weather
public PImage[] Chargement_Image_Weather( String CheminDossierImage, String Extension) {
  File di   = new File(CheminDossierImage);
  FilenameFilter select = new FileListFilter("", Extension);
  File fl[] = di.listFiles(select);
  WeatherIcon= new PImage[fl.length];
  for (int i=0;i<fl.length;i++) {
    WeatherIcon[i]=loadImage(CheminDossierImage+"/"+fl[i].getName());
    //println(i);
  }
  return WeatherIcon;
}
private float AffichageImageWeather(YahooWeather weather, int Date, int hauteur, float x, int y) { 
  Date MaDate=weather.getLastUpdated();
  int WeatherCode;
  boolean FaitJour=Enjournee(MaDate, weather.getSunrise(), weather.getSunset());
  if (Date==0) {
    WeatherCode=weather.getWeatherConditionCode();
  }
  else if (Date==1) { 
    WeatherCode= weather.getWeatherConditionCodeTomorrow();
    MaDate=weather.getLastUpdated();
    FaitJour=true;
  }
  else if (Date==2) { 
    WeatherCode= weather.getWeatherConditionCodeDayAfterTomorrow();
    MaDate=weather.getLastUpdated();
    FaitJour=true;
  }
  else WeatherCode=weather.getWeatherConditionCode();
  int NumeroImageint=Integer.parseInt(NumeroImage(WeatherCode, tab, FaitJour))-1;
  float rationHL=(float)WeatherIcon[NumeroImageint].width/(float)WeatherIcon[NumeroImageint].height;
  image(WeatherIcon[NumeroImageint], x, y, hauteur*rationHL, hauteur);
  return rationHL;
}


private float Affichage_Text_Weather(float MargeIniH, int OffsetY) { 
  float MargeDebut=MargeIniH;
  int marginH=5;
  int marginV=1;
  int TexteSize;
  float[] XY=new float[2];
  fill(255, 255, 255);
  textFont(TextWeatherFont);
  textSize(TexteSize=15); 
  XY[1]=TexteSize+marginV+ OffsetY;
  XY[0]=0;
  XY[1]=AddText(weather.getCityName(), TexteSize, rationHL, MargeDebut, marginH, marginV, XY[1], XY[0])[1];
  textSize(TexteSize=12);
  XY=AddText(weather.getWeatherCondition(), TexteSize, rationHL, MargeDebut, marginH, marginV, XY[1], XY[0]);
  XY=AddText("Humidité: "+weather.getHumidity()+"%", TexteSize, rationHL, MargeDebut, marginH, marginV, XY[1], XY[0]);
  XY=AddText("Vent: "+weather.getWindSpeed()+" km/h", TexteSize, rationHL, MargeDebut, marginH, marginV, XY[1], XY[0]);
  XY=AddText("Lever du soleil: "+weather.getSunrise(), TexteSize, rationHL, MargeDebut, marginH, marginV, XY[1], XY[0]);
  XY=AddText("Coucher du soleil: "+weather.getSunset(), TexteSize, rationHL, MargeDebut, marginH, marginV, XY[1], XY[0]);
  return XY[0]+ MargeDebut+marginH;
}


private void Affichage_Vitesse_Vent(YahooWeather weather, float taille, float x, float y) {
  float Windspeed;
  float Direction;

  Windspeed=weather.getWindSpeed();
  Direction=weather.getWindDirection();

  pushMatrix();
  strokeWeight(5);
  smooth();
  translate(x, y);
  rotate(radians(Direction));
  if (Windspeed<20) {
    stroke(25, 225, 65);
  }
  else if (Windspeed<50) {
    stroke(243, 146, 0);
  }
  else {
    stroke(243, 24, 0);
  }
  line(0, -taille/2, 0, taille/2);
  triangle(0, -taille/2, taille/6, -taille/2+taille/6, -taille/6, -taille/2+taille/6);

  rotate(radians(-Direction));
  textFont(TextWeatherFont);
  textSize(20);
  text(round(Windspeed)+"km/h", taille/2+10, textAscent()/2);
  popMatrix();
} 



private float[] AddText(String Text, int TextSize, float rationHL, float DebutH, int marginH, int marginV, float y, float MaxH) {
  float[] XY= new float[2];
  text(Text, DebutH + marginH, y);
  XY[1] =y+TextSize+marginV;
  XY[0] = textWidth(Text);
  if (XY[0]<MaxH)XY[0]=MaxH;
  return XY;
}

private void AffichageTempertaure(YahooWeather weather, int x, int y) {   
  textFont(TextWeatherFont);
  int TexteSize=25;
  //fill( CouleurTemperature(weather.getWindTemperature()));
  textSize(TexteSize);
  text(+weather.getWindTemperature()+"°", x, TexteSize+y+3);
}

public void AffichageTemperatureLendemain(YahooWeather weather, int DayToPlot, float x, float y) {
  textFont(TextWeatherFont);
  textSize(20);

  String Texte="";
  if (DayToPlot==1)
    Texte=weather.getTemperatureLowTomorrow()+"°";
  else if (DayToPlot==2)
    Texte=weather.getTemperatureLowDayAfterTomorrow()+"°";

  float MarginIni=x;
  text(Texte, MarginIni, y);
  MarginIni+=textWidth(Texte);
  Texte="|";
  text(Texte, MarginIni, y);
  MarginIni+=textWidth(Texte);
  if (DayToPlot==1)
    Texte=weather.getTemperatureHighTomorrow()+"°";
  else if (DayToPlot==2)
    Texte=weather.getTemperatureHighDayAfterTomorrow()+"°";

  text(Texte, MarginIni, y);
}

private void Affichage_Journee(YahooWeather weather, int DayToPlot, float x, float y) {
  String Weekday="";
  if (DayToPlot==1) {
    Weekday=weather.getWeekdayTomorrow();
  }
  else if (DayToPlot==2) {
    Weekday=weather. getWeekdayDayAfterTomorrow();
  }
  //println( Weekday);
  Weekday=TraductionJournee(Weekday);
  textFont(TextWeatherFont);
  textSize(20);
  text(Weekday, x, y);
}

String TraductionJournee(String Jour) {
  String Trad="";

  if (Jour.equals("Mon"))
    Trad="Lun";
  else if (Jour.equals("Tue"))
    Trad="Mar";
  else if (Jour.equals("Wed"))
    Trad="Mer";
  else if (Jour.equals("Thu"))
    Trad="Jeu";
  else if (Jour.equals("Fri"))
    Trad="Ven";
  else if (Jour.equals("Sat"))
    Trad="Sam";
  else if (Jour.equals("Sun"))
    Trad="Dim";


  return Trad;
}

public color CouleurTemperature(int Temp) {
  int MinTemp=-20;
  int MaxTemp=40;
  int delta;
  color CouleurTexte;
  colorMode(HSB, 100);
  int H, S, B;
  B=400;
  if (Temp<MinTemp+(MaxTemp-MinTemp)/2) {
    H=188;  
    delta=(int)constrain((Temp-MinTemp)*99/((MaxTemp-MinTemp)/2), 0, 100);
    //println(delta);
    S=99-delta;
  }
  else {
    H=188; 
    delta=(int)constrain((Temp-(MinTemp+(MaxTemp-MinTemp)/2))*99/((MaxTemp-MinTemp)/2), 0, 100);
    S=0+delta;
  }
  CouleurTexte=color(H, S, B);
  colorMode(RGB);
  //println("H:"+H+" S: "+S+" B:"+B);
  return CouleurTexte;
}

private String NumeroImage(int WeatherConditionCode, String tabImageCode[][], boolean Enjournee) {
  String tempTab[];
  String res="";
  int i;
  for (i=0;i<tabImageCode.length;i++) {
    if (Integer.parseInt(tabImageCode[i][0])==WeatherConditionCode) {
      tempTab=tabImageCode[i][2].split("/");
      if (tempTab.length==1) res=tempTab[0];
      else if (tempTab.length>1 && Enjournee) res=tempTab[0];
      else res=tempTab[1];
      break;
    }
  }
  return res;
}

private boolean Enjournee(Date MaDate, String Sunrise, String Sunset) {
  String SunsetTab[]=new String[3];
  String SunriseTab[]=new String[3];
  HeureToTab(SunsetTab, Sunset);
  HeureToTab(SunriseTab, Sunrise);
  int Heure;
  Heure=Integer.parseInt(Hd.format(MaDate))*100+Integer.parseInt(md.format(MaDate));
  if (Heure>TabToInt(SunriseTab) && Heure<=TabToInt(SunsetTab)) return true;
  else return false;
}

private void HeureToTab(String tab[], String Heure) {
  String TabTemp[];
  TabTemp=Heure.split(":");
  tab[0]=TabTemp[0];
  TabTemp=TabTemp[1].split(" ");
  tab[1]=TabTemp[0];
  tab[2]=TabTemp[1];
}

private int TabToInt(String tab[]) {
  int res;
  if (tab[2].equals("am"))  res=Integer.parseInt(tab[0])*100;
  else res=(Integer.parseInt(tab[0])+12)*100; 
  res=res+Integer.parseInt(tab[1]);
  return res;
}

private String[][] lireFichierRech(String nFichier) {
  String NomFichier = nFichier; //"labo1test2.txt";
  try {
    int count=0;
    String line;
    BufferedReader in  = new BufferedReader(new FileReader(NomFichier));
    while ( (line=in.readLine ())!=null)
    {
      count +=1;
    }
    in.close();

    tab= new String[count][3];

    in  = new BufferedReader(new FileReader(NomFichier));
    int i=0;
    int j = 0;
    while ( (line = in.readLine ()) != null) {
      line = line.trim();
      tab[i]=line.split("\t", 3);
      i++;
    }
    in.close();
  }
  catch(Exception e) {
    e.printStackTrace();
  }
  return tab;
}

