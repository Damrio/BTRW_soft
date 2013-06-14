
//Cette fonction instancie l'ensemble des objet RSS lié à une adresse de flux spécifiée par son index
void CreateRss() {
  for (int i=0;i<ListAdresseRSS.size();i++) {
    ListFeed.add(new Feeder(this));
    ListFeed.get(ListFeed.size()-1).verbose = true;
    ListFeed.get(ListFeed.size()-1).sortByPublishedDate();
    ListFeed.get(ListFeed.size()-1).load(ListAdresseRSS.get(i));
    ListFeed.get(ListFeed.size()-1).setUpdateInterval(60*1000*5);
    ListFeed.get(ListFeed.size()-1).startUpdate();
    ListLoader.add(new RSSLoader());
    ListThread.add(new Thread(ListLoader.get(ListLoader.size()-1)));  
    ListThread.get(ListThread.size()-1).start();
  }
}

//Cette fonction vient mettre à jour l'ensemble des flux RSS
void UpdateRss() {
  boolean HasBeenUpdated=false; 
  for (int i=0;i<ListAdresseRSS.size();i++) {
    boolean   FluxUpadted =false;
    while ( FluxUpadted==false ) {
      if (ListFeed.get(i).hasNext ()) {
        if ( ListThread.get(i).getState()!=Thread.State.TERMINATED) {
          // println(ListThread.get(i).getState());
          ListLoader.get(i).loadRss(ListFeed.get(i).next());
        }
        else {
          // println(ListThread.get(i).getState());
          ListLoader.get(i).loadRss(ListFeed.get(i).next());
          ListThread.remove(i);
          ListThread.add(i, new Thread(ListLoader.get(i)));
          ListThread.get(i).start();
        }
        TestIfAddToTitleList(ListLoader.get(i).RssContent.get(ListLoader.get(i).RssContent.size()-1));
        HasBeenUpdated=true;
        println("Num remaining:"+ ListLoader.get(i).remaining);
        int Cellule[]=new int[2]; 
        Cellule=Maingrille.RechercheAdresseDansGrille(cols, rows, ListAdresseRSS.get(i));
        Maingrille.MaGrille[Cellule[0]][Cellule[1]].AddEvent(1);
        Maingrille.MaGrille[Cellule[0]][Cellule[1]].ChangeColor(color(125, 10, 10));
      }
      else {
        FluxUpadted =true;
      }
    }

    if (HasBeenUpdated) {
      TitreRss=ListoFTitle();
    }

    println("Rss updated!");
    //int Cellule[]=new int[2]; 
    //Cellule=Maingrille.RechercheAdresseDansGrille(cols, rows, ListAdresseRSS.get(i));
    //Maingrille.MaGrille[Cellule[0]][Cellule[1]].numberofEvents=ListLoader.get(i).remaining;
  }
}

int getIndexFromUrl(String Url) {
  int index=-1;
  for (int i=0;i<ListAdresseRSS.size();i++) {
    if (ListAdresseRSS.get(i).equals(Url)) {
      index=i;
      break;
    }
  }
  return index;
}

void DeleteRss(int index) {
  ListThread.remove(index);  
  ListFeed.remove(index);
  ListLoader.remove(index);
}




void TestIfAddToTitleList(RssEntry EntreeCourante) {
  int i;
  boolean  flagAdded=false;
  if (ListTitleDate.size()==0) {
    ListTitleDate.add(EntreeCourante.PublishedDate);
    ListTitleToPrint.add(EntreeCourante.Title);
    flagAdded=true;
  }
  else {
    for (i=0;i<ListTitleDate.size();i++) {
      if (EntreeCourante.PublishedDate.after(ListTitleDate.get(i))) {
        if (ListTitleDate.size()>=NombreTitreToPlot) {
          ListTitleDate.remove(ListTitleDate.size()-1);  
          ListTitleToPrint.remove(ListTitleToPrint.size()-1);
          ListTitleDate.add(i, EntreeCourante.PublishedDate);
          ListTitleToPrint.add(i, EntreeCourante.Title);
          flagAdded=true;
          break;
        }
        else {
          ListTitleDate.add(i, EntreeCourante.PublishedDate);
          ListTitleToPrint.add(i, EntreeCourante.Title);
          flagAdded=true;
          break;
        }
      }
    }
    if (ListTitleDate.size()<NombreTitreToPlot && flagAdded==false) {
      ListTitleDate.add(EntreeCourante.PublishedDate);
      ListTitleToPrint.add(EntreeCourante.Title);
    }
  }
}

String ListoFTitle() {
  int i;
  String ToPrint="";
  for (i=0;i<ListTitleDate.size();i++) {
    ToPrint=ToPrint+ListTitleToPrint.get(i)+"         ";
  }
  return ToPrint;
}

