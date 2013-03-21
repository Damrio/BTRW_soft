
//Cette fonction instancie l'ensemble des objet RSS lié à une adresse de flux spécifiée par son index
void CreateRss() {
  for (int i=0;i<ListAdresseRSS.size();i++) {
    ListFeed.add(new Feeder(this));
    ListFeed.get(ListFeed.size()-1).verbose = true;
    ListFeed.get(ListFeed.size()-1).sortByPublishedDate();
    ListFeed.get(ListFeed.size()-1).load(ListAdresseRSS.get(i));
    ListFeed.get(ListFeed.size()-1).setUpdateInterval(60*1000);
    ListFeed.get(ListFeed.size()-1).startUpdate();
    ListLoader.add(new RSSLoader());
    ListThread.add(new Thread(ListLoader.get(ListLoader.size()-1)));  
    ListThread.get(ListThread.size()-1).start();
  }
}

//Cette fonction vient mettre à jour l'ensemble des flux RSS
void UpdateRss() {
  for (int i=0;i<ListAdresseRSS.size();i++) {
    if (ListFeed.get(i).hasNext ()) {
      if ( ListThread.get(i).getState()!=Thread.State.TERMINATED) {
        println(ListThread.get(i).getState());
        ListLoader.get(i).loadRss(ListFeed.get(i).next());
      }
      else {
        println(ListThread.get(i).getState());
        ListLoader.get(i).loadRss(ListFeed.get(i).next());
        ListThread.remove(i);
        ListThread.add(i, new Thread(ListLoader.get(i)));
        ListThread.get(i).start();
      }
      int Cellule[]=new int[2]; 
      Cellule=Maingrille.RechercheAdresseDansGrille(cols, rows, ListAdresseRSS.get(i));
      Maingrille.MaGrille[Cellule[0]][Cellule[1]].AddEvent(1);
      Maingrille.MaGrille[Cellule[0]][Cellule[1]].ChangeColor(color(125, 10, 10));
    }
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

