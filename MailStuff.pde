// Daniel Shiffman               
// http://www.shiffman.net       


// Classe MailChecker qui sera notre classe concernant les mails
class MailChecker {

  
  //--------------------------------------------
  // ATTRIBUTS
  //--------------------------------------------
  
  // les attributs sont declares en public pour ne pas avoir besoin de faire d'accesseur
  public int numberofMessages;            // nombre de messages non lus
//  public ArrayList array_message;         // liste des N derniers messages
  public ArrayList array_from;
  public ArrayList array_sujet;  
  public boolean flag_changement;         // TODO : flag pour voir si le nombre de messages a change depuis la derniere fois
  
  
  
  //--------------------------------------------
  // METHODES
  // ------------------------------------------- 
  
  // CONSTRUCTEUR  
  MailChecker() {
    numberofMessages           =   0;
//    array_message            =  new ArrayList<String>();
    array_from                 =  new ArrayList<String>();
//    array_from.add("cdiscount");
//    array_from.add("lequipe.fr <djkdas@lequipe.com>");
//    array_from.add("cdlahfkjsldf <djkdas@lequipe.com>");
//    array_from.add("moi <daajfajf@gmail.com>");
//    array_from.add("cdiscount");
//    array_from.add("lequipe.fr <djkdas@lequipe.com>");
//    array_from.add("cdlahfkjsldf <djkdas@lequipe.com>");
//    array_from.add("moi <daajfajf@gmail.com>");
//    array_from.add("cdiscount");
//    array_from.add("lequipe.fr <djkdas@lequipe.com>");
//    array_from.add("cdlahfkjsldf <djkdas@lequipe.com>");
    
    array_sujet                =  new ArrayList<String>();

//    array_sujet.add("On vend de la merde");
//    array_sujet.add("girondins de bordeaux offre exceptionnelle");
//    array_sujet.add("cdlahfkjsldf <alksds;lflksfa;lskf;l");
//    array_sujet.add("Test");
//    array_sujet.add("On vend de la merde");
//    array_sujet.add("girondins de bordeaux offre exceptionnelle");
//    array_sujet.add("cdlahfkjsldf <alksds;lflksfa;lskf;l");
//    array_sujet.add("Test");
//    array_sujet.add("On vend de la merde");
//    array_sujet.add("girondins de bordeaux offre exceptionnelle");
//    array_sujet.add("cdlahfkjsldf <alksds;lflksfa;lskf;l");
    
    flag_changement            =  false;
  }
  
  
  // A function to check a mail account
  public void checkEmailAccount() {
  
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
//    props.setProperty("mail.mime.decodetext.strict", "false");
//System.setProperty("mail.mime.charset", "utf8");

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
    int nb_mails               =   min(message.length, NB_MAX_MESSAGES);
    
    for (int i=0; i < nb_mails; i++) {
    
    
            //String mess_no     =  "  Message # " + (i+1) + " :\n";
//            String from        =  "  De : " + message[message.length-(i+1)].getFrom()[0] + "\n";
//            String sujet       =  "  Sujet : " + message[message.length-(i+1)].getSubject()+ "\n";
                        
//            String from        =  InternetAddress.toUnicodeString(message[message.length-(i+1)].getFrom());
            String from        =  message[message.length-(i+1)].getFrom()[0].toString();
            InternetAddress myadress = new InternetAddress(from);
            String from_unicode       = myadress.toUnicodeString();
            
            String sujet       =  message[message.length-(i+1)].getSubject();

            //String curr_email  = mess_no + from + sujet;
            //array_message.add(curr_email);
            //aray_mess_no.add(mess_no);
            array_from.add(from_unicode);
            array_sujet.add(sujet);
            
          
    }
    
    
    // Close the session
    folder.close(false);
    store.close();
    
  

  } 
  
  // gestion d'erreur (si un truc a foire dans le bloc try)
  // This error handling isn't very good
  catch (Exception e) {
    e.printStackTrace();
    
  }
}

}


class Calendrier {}
