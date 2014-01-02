

void DefilerBandeauTitreRss() {

  if (TitreRss!="") {
    if (System.currentTimeMillis()-temps_dernier_deplacement_bandeau>nb_millisec_deplacement) {
      OffsetTitreRss-=Offset_deplacement;
      temps_dernier_deplacement_bandeau=System.currentTimeMillis();
      textFont(myfontTittleRSS, 70);
      if (OffsetTitreRss<640-textWidth(TitreRss)-50) {
        OffsetTitreRss=650;
      }
    }
  }
}

