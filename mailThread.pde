public class RunImpl implements Runnable {
//  private MailChecker monMailT;

  public RunImpl(MailChecker monMail){
  //  this.monMailT = monMail;//new MailChecker();

  }
 
  public void run() {
// on checke le compte mail

monMail.checkEmailAccount();

// mise a jour de l'affichage du nombre de mails non lus
int Cellule[]=new int[2];
Cellule=Maingrille.Recherchefunction_typeDansGrille(cols, rows, "GMAIL");
        Maingrille.MaGrille[Cellule[0]][Cellule[1]].AddEvent(monMail.nb_nvx_mails);
// TODO : faire un changement de couleur "intelligent (mais ne sera probablement pas dans cette fonction"
if (monMail.nb_nvx_mails > 0) {
  Maingrille.MaGrille[Cellule[0]][Cellule[1]].ChangeCouleurBulle(color(200, 0, 0));
  if (arduino_enabled) { // flag pour pouvoir desactiver les fonctions arduino si celui ci n'est pas branche (phase de test)
    int red_value = int(red(Maingrille.MaGrille[Cellule[0]][Cellule[1]].couleur_LED));
    int green_value = int(green(Maingrille.MaGrille[Cellule[0]][Cellule[1]].couleur_LED));
    int blue_value = int(blue(Maingrille.MaGrille[Cellule[0]][Cellule[1]].couleur_LED));
   SendRGBValue_Message(Cellule[1]*4+Cellule[0]+1,red_value, green_value, blue_value);
   // TODO : resoudre probleme FADING
//   SendRGB_Fading_Start_Message(Cellule[1]*4+Cellule[0]+1, 1000, 0, red_value, 0, green_value, 0, blue_value);
    port.write("/");
       println("MAJ LED");
  }
      // TODO rajouter ici les fonctions pour controler les LED
}
  } 
}
