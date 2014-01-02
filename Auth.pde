// Daniel Shiffman               
// http://www.shiffman.net       

// Simple Authenticator          
// Careful, this is terribly unsecure!!

public class Auth extends Authenticator {

  public Auth() {
    super();
  }

  public PasswordAuthentication getPasswordAuthentication() {
    String username, password;
    String donnees_auth[]=loadStrings(RecupCheminRef(ref_chemin)+"/donnees_auth.txt");
    username = donnees_auth[0];
    password = donnees_auth[1];
    System.out.println("authenticating. . ");
    return new PasswordAuthentication(username, password);
  }
}
