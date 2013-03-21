public class RunImpl implements Runnable {
  private MailChecker monMailT;

  public RunImpl(){
    this.monMailT = new MailChecker();

  }
 
  public void run() {
// on checke le compte mail
monMailT.checkEmailAccount();

// TODO : regarder les differences entre monMailT et la variable globale monMail

// MAJ de monMail : pour l'instant on remplace bourrinement
monMail = monMailT;             
  } 
}
