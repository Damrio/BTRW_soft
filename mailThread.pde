public class RunImpl implements Runnable {
//  private MailChecker monMailT;

  public RunImpl(MailChecker monMail){
  //  this.monMailT = monMail;//new MailChecker();

  }
 
  public void run() {
// on checke le compte mail
println("NB MAILS DZZZZZZZZZZZ1 : "+monMail.current_nb_mails);
monMail.checkEmailAccount();

// TODO : regarder les differences entre monMailT et la variable globale monMail
println("NB MAILS DZZZZZZZZZZZ2 : "+monMail.current_nb_mails);
// MAJ de monMail : pour l'instant on remplace bourrinement
//monMail = monMailT;             
println("NB MAILS DZZZZZZZZZZZ3 : "+monMail.current_nb_mails);
// mise a jour de l'affichage du nombre de mails non lus
int Cellule[]=new int[2]; 
Cellule=Maingrille.Recherchefunction_typeDansGrille(cols, rows, "GMAIL");
        Maingrille.MaGrille[Cellule[0]][Cellule[1]].AddEvent(monMail.nb_nvx_mails);
// TODO : faire un changement de couleur "intelligent (mais ne sera probablement pas dans cette fonction"
if (monMail.nb_nvx_mails > 0) {
  Maingrille.MaGrille[Cellule[0]][Cellule[1]].ChangeColor(color(125, 10, 10));
}
  } 
}
