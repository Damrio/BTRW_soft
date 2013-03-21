public class RunImpl implements Runnable {
  private MailChecker monMail;

 
  public RunImpl(MailChecker monMail){
    this.monMail = monMail;

  }
 
  public void run() {

monMail.checkEmailAccount();
             
  } 
}
