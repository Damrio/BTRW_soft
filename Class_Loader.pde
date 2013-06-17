class RSSLoader implements Runnable {

  List<RssEntry> RssContent; 
  int num, remaining;
  boolean loadDone=true;
  int tailleMax;

  public RSSLoader() {
    RssContent= new ArrayList<RssEntry>();
    remaining=1;
    tailleMax=10;
  }
 
  //Charge un flux RSS
  void loadRss(SyndEntry entry) {
    // expand array if necessary
    if (RssContent.size()>this.tailleMax) 
    {
      if(RssContent.get(0).HasImage==true && !RssContent.get(0).ImageRSS.loaded )remaining--;
      if(remaining<0) remaining=0;
      RssContent.remove(0);
    }

    RssContent.add(new RssEntry(entry));
    
    if (RssContent.get(RssContent.size()-1).HasImage==true) {
      remaining++;
      loadDone=false;
    }
  }    

  public PImage getImage(int id) {
    // return null if incorrect ID, image not loaded or error occurred
    //println(id);
    if (RssContent.get(id)==null|| RssContent.get(id).ImageRSS.error|| !RssContent.get(id).ImageRSS.loaded  || !RssContent.get(id).HasImage ) 
      return null;

    return RssContent.get(id).ImageRSS.img;
  }

  public RssEntry getRss(int id) {
    // return null if incorrect ID, image not loaded or error occurred
    if (RssContent.get(id)==null ) 

      return null;

    return RssContent.get(id);
  }

  public void run() {
    int loadID=99;


    // loop run() until loadDone is set to true
    while (!loadDone ) {
      // find an image to load {
      if (loadID>RssContent.size()-1) {
        loadID--;
      }
      else {
        if (RssContent.get(loadID).HasImage==true) {
          if (RssContent.get(loadID).ImageRSS.loaded==true || !RssContent.get(loadID).HasImage) loadID--;
          else {
            if (RssContent.get(loadID)!=null) {
              RssContent.get(loadID).ImageRSS.load();
              remaining--;
              println("Moins 1!");
              loadID--;
              if (remaining==0)loadDone=true;
              try {
                Thread.sleep(500L);
              }
              catch(InterruptedException e) {
                e.printStackTrace();
              }
              //break; // exit do loop;
            }
            else {
              loadID--;
            }
          }
        }
        else {
          loadID--;
        }
      }
      if (loadID==-1)loadID=99;
    }
    println("Loader thread exiting.");
  }
}

class ImageURL {
  PImage img;
  boolean loaded=false, error=false;
  String url;

  public ImageURL(String _url) {
    url=_url;
  }


  void load() {
    println("\n Loading image: "+url);
    img=loadImage(url);
    if (img==null) {
      error=true;
      loaded=false;
    }
    loaded=true;
    if (error) println("Error occurred when loading image.");
    else println("Load successful. "+
      "Image size is "+img.width+"x"+img.height+".");
  }
}

class RssEntry {
  String  Title;
  Date   PublishedDate;
  String Link;
  String Description;
  boolean HasImage=false;
  ImageURL ImageRSS;
  Boolean error=false;


  public RssEntry(SyndEntry entry) {
    Title=entry.getTitle();
    PublishedDate=entry.getPublishedDate();
    Link=entry.getLink();
    Description= entry.getDescription().getValue().replaceAll("<[^>]*>", "");
    String ImagePath;
    ImagePath=ImageUrl(entry);
    if (ImagePath!="") {
      ImageRSS=new ImageURL(ImagePath);
      HasImage=true;
    }
    else println("vide");
  }
}

String ImageUrl(SyndEntry entry) {

  List Enclosure;
  String[] EnclosureTab;
  String res="";
  Enclosure=entry.getEnclosures();

  //println(Enclosure.size()+"\n");
  // println(entry.getEnclosures()+"\n");

  if (Enclosure!=null) {
    for (int i=0;i<Enclosure.size();i++) {
      String EnclosureString =  Enclosure.get(i).toString();
      EnclosureTab= EnclosureString.split("\n");
      if (EnclosureString.contains("image")||EnclosureString.contains("octet-stream")) {
        for (int j=0;j<EnclosureTab.length;j++) {
          if (EnclosureTab[j].contains("url=")) {
            res=EnclosureTab[j].split("=")[1];
            println(res);
          }
        }
      }
    }
  }
  return res;
}

