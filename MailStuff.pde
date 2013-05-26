// Daniel Shiffman               
// http://www.shiffman.net       


// Classe MailChecker qui sera notre classe concernant les mails
class MailChecker {

  
  //--------------------------------------------
  // ATTRIBUTS
  //--------------------------------------------
  
  // les attributs sont declares en public pour ne pas avoir besoin de faire d'accesseur
  public int numberofMessages;            // nombre de messages non lus
  public ArrayList array_contenu;         // liste des N derniers messages
  public ArrayList array_from;
  public ArrayList array_sujet;  
  
  public boolean flag_changement;         // TODO : flag pour voir si le nombre de messages a change depuis la derniere fois
  
  
  
  //--------------------------------------------
  // METHODES
  // ------------------------------------------- 
  
  // CONSTRUCTEUR  
  MailChecker() {
    numberofMessages           =   0;
    array_contenu            =  new ArrayList<String>();
    array_from                 =  new ArrayList<String>();

    
    array_sujet                =  new ArrayList<String>();

    flag_changement            =  false;
  }
  
  
  // A function to check a mail account
  public void checkEmailAccount() {
  
  println("MAIL CHECKING...");  
  int result                   =   0;
  int result2                  =   0;
  
  try {
    
    // MAJ des proprietes systeme
    Properties props           =   System.getProperties();
    
    props.setProperty("mail.store.protocol", "imaps");
    props.setProperty("mail.imaps.host", "imap.gmail.com");
    props.setProperty("mail.imaps.port", "993");
    props.setProperty("mail.imaps.connectiontimeout", "5000");
    props.setProperty("mail.imaps.timeout", "5000");


    // Create authentication object (permet de se connecter avec login et mdp)
    Auth auth                  =   new Auth();
    
    // Make a session
    Session session            =   Session.getDefaultInstance(props, auth);
    Store store                =   session.getStore("imaps");
    store.connect();
    
    // Get inbox
    Folder folder              =   store.getFolder("INBOX");
    folder.open(Folder.READ_ONLY);
    
    // compte et met a jour le nombre de messages
    numberofMessages   =   folder.getMessageCount();
    System.out.println(numberofMessages + " total messages.");
    
    // on recupere les N derniers messages non lus et on les met dans un tableau
    //  Message message[]      =   folder.getMessages();
    
    FlagTerm ft                =   new FlagTerm(new Flags(Flags.Flag.SEEN), false);
    Message message[]          =   folder.search(ft);
    
    // on nettoie les tableaux des mails precedents
    array_from.clear();
    array_sujet.clear();
    array_contenu.clear();
    
    int nb_mails               =   min(message.length, NB_MAX_MESSAGES);
    
    for (int i=0; i < nb_mails; i++) {
    
    
            String from        =  message[message.length-(i+1)].getFrom()[0].toString();
            InternetAddress myadress = new InternetAddress(from);
            String from_unicode       = myadress.toUnicodeString();
            
            String sujet       =  message[message.length-(i+1)].getSubject();
            String contenu = message[message.length-(i+1)].getContent().toString(); 

            array_from.add(from_unicode);
            array_sujet.add(sujet);
            array_contenu.add("Salut\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na");
            
            Message p = message[message.length-(i+1)];
            
            if (p.isMimeType("text/plain")) {
	    println("This is plain text");
	    println("---------------------------");
            println(p.getContent());
	} else if (p.isMimeType("multipart/*")) {
	    println("This is a Multipart");
	    println("---------------------------");
	    Multipart mp = (Multipart)p.getContent();
	    int count = mp.getCount();
	    for (int j = 0; j < count; j++) {
  
  println(mp.getBodyPart(j).getContentType());
            }
	} else if (p.isMimeType("message/rfc822")) {
	    println("This is a Nested Message");
	    println("---------------------------");

	}
            
            
//            array_contenu.add(contenu);
//            println(contenu);
            
          
    }
    
    
    // Close the session
    folder.close(false);
    store.close();
    
    println("MAIL CHECKED !"); 

  } 
  
  // gestion d'erreur (si un truc a foire dans le bloc try)
  // This error handling isn't very good
  catch (Exception e) {
    e.printStackTrace();
    
  }
}

}


class Calendrier {}
