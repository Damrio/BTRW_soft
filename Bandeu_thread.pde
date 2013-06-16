public class TestThread extends Thread {
  public TestThread() {
    //super(name);
  }
  public void run() {
    while (true) {
      if(indicateur_mode == 1){
      //println("In thread");
      DefilerBandeauTitreRss();
      }
      try {
        // thread to sleep for 1000 milliseconds
        Thread.sleep(nb_millisec_deplacement);
      } 
      catch (Exception e) {
        System.out.println(e);
      }
    }
  }
}

void DefilerBandeauTitreRss() {

  if (TitreRss!="") {
    if (System.currentTimeMillis()-temps_dernier_deplacement_bandeau>nb_millisec_deplacement) {
      OffsetTitreRss-=Offset_deplacement;
      temps_dernier_deplacement_bandeau=System.currentTimeMillis();
      if (OffsetTitreRss<640-textWidth(TitreRss)-50) {
        OffsetTitreRss=650;
      }
    }
  }
}

