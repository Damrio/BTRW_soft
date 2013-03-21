
private Endroit[] GetEndroit(String Localisation) {
  XMLElement xml;
  Endroit[] ListeEndroits;
  ListeEndroits=null;
  String[] ListeAttributs;
  int i;
  xml = new XMLElement("http://where.yahooapis.com/v1/places.q('"+Localisation+"');start=0;count=5?lang=fr&appid=[75IHsenV34E3VqJUbdXEwHKQYh04AejslpFkGCj0Pbv9_UpWQmCR50bqwkESRumtt35eXEU-]");
  if( xml!=null) {
  ListeAttributs=xml.listAttributes();
     if (xml.hasChildren()) {
      XMLElement[] children = xml.getChildren("place");
      if (children.length!=0) {
        int count=0;
        for (i=0;i< children.length;i++) {
          if (children[i].getChild("placeTypeName").getContent().equals("Ville"))count+=1;
        } 
        if (count!=0) {
          int compteur=0;
          ListeEndroits= new Endroit[count];
          for (i = 0; i < children.length; i++) {
            if (children[i].getChild("placeTypeName").getContent().equals("Ville")) {   
              ListeEndroits[compteur]=new Endroit(children[i].getChild("placeTypeName").getContent(), children[i].getChild("country").getContent(), children[i].getChild("admin1").getContent(), children[i].getChild("woeid").getContent());
              compteur+=1;
            }
          }
        }
      }
    }
  }
  return ListeEndroits;
}


class Endroit {

  String placeType;
  String pays;
  String admin1;
  String woeid;

  Endroit(String PlaceType, String Pays, String Admin1, String Woeid) {
    this.placeType=PlaceType;
    this.pays=Pays;
    this.admin1=Admin1;
    this.woeid=Woeid;
  }
}











//private Endroit[] GetEndroit(String Localisation) {
//  XML xml;
//  Endroit[] ListeEndroits;
//  ListeEndroits=null;
//  String[] ListeAttributs;
//  int i;
//  xml = loadXML("http://where.yahooapis.com/v1/places.q('"+Localisation+"');start=0;count=5?lang=fr&appid=[75IHsenV34E3VqJUbdXEwHKQYh04AejslpFkGCj0Pbv9_UpWQmCR50bqwkESRumtt35eXEU-]");
//  if( xml!=null) {
//  ListeAttributs=xml.listAttributes();
//  println(ListeAttributs);
//     if (xml.hasChildren()) {
//      XML[] children = xml.getChildren("place");
//      if (children.length!=0) {
//        int count=0;
//        for (i=0;i< children.length;i++) {
//          if (children[i].getChild("placeTypeName").getContent().equals("Ville"))count+=1;
//        } 
//        if (count!=0) {
//          int compteur=0;
//          ListeEndroits= new Endroit[count];
//          for (i = 0; i < children.length; i++) {
//            if (children[i].getChild("placeTypeName").getContent().equals("Ville")) {   
//              ListeEndroits[compteur]=new Endroit(children[i].getChild("placeTypeName").getContent(), children[i].getChild("country").getContent(), children[i].getChild("admin1").getContent(), children[i].getChild("woeid").getContent());
//              compteur+=1;
//            }
//          }
//        }
//      }
//    }
//  }
//  return ListeEndroits;
//}


//class Endroit {

//  String placeType;
//  String pays;
//  String admin1;
//  String woeid;

//  Endroit(String PlaceType, String Pays, String Admin1, String Woeid) {
//    this.placeType=PlaceType;
//    this.pays=Pays;
//    this.admin1=Admin1;
//    this.woeid=Woeid;
//  }
//}

