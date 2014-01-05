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
  public ArrayList array_date;
  public int nb_nvx_mails;
  public int current_nb_mails;            // nombre de mails courant (utilise pour faire un delta et ne recuperer que les derniers)
  public String flag_type;


  //--------------------------------------------
  // METHODES
  // ------------------------------------------- 

  // CONSTRUCTEUR  
  MailChecker(String flag) {
    numberofMessages           =   0;
    array_contenu              =   new ArrayList<String>();
    array_from                 =   new ArrayList<String>();
    current_nb_mails           =   0;
    nb_nvx_mails               =   0;
    array_sujet                =   new ArrayList<String>();
    array_date                 =   new ArrayList<String>();
    flag_type                  =   flag;

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

Message message[]  = null;
 
  if (flag_type.equals("MAIL")) {
      // compte et met a jour le nombre de messages
      numberofMessages   =   folder.getMessageCount();

      System.out.println(numberofMessages + " total messages.");

      // on compte le nombre de nouveaux mails depuis le dernier check
      nb_nvx_mails = numberofMessages - current_nb_mails;      
      
      // on recupere au plus les NB_MAX_MESSAGES derniers messages      
      message      =   folder.getMessages(max(numberofMessages-NB_MAX_MESSAGES, 1), numberofMessages);  

   }

  else if (flag_type.equals("FB")) {
/////////////////////////////////////////////////////////////////////////////////////
// WORK IN PROGRESS

SearchTerm fb_search = new FromTerm(new InternetAddress("materiel.net"));

     message      =   folder.search(fb_search);  
     //println("NOMBRE DE MESSAGES FB : "+message.length);

    numberofMessages   = message.length;
    nb_nvx_mails = numberofMessages - current_nb_mails;



////////////////////////////////////////////////////////////////////////////////////
  }

      
      // Si il y a des nouveaux mails, on recharge tout
      if (nb_nvx_mails > 0) {
      
        int nb_mails =   min(message.length, NB_MAX_MESSAGES);
        
        // on nettoie les tableaux des mails precedents
            array_from.clear();
            array_sujet.clear();
            array_contenu.clear();
        
        // pour chaque mail recupere
        for (int i=0; i < nb_mails; i++) {
          
          // on recupere le from
          String from        =  message[message.length-(i+1)].getFrom()[0].toString();

          // TODO : RAJOUTER Date du message, et flag SEEN / NOT SEEN
          
          // Reupceration de la date du message et mise au bon format
          Date date_mail = message[message.length-(i+1)].getReceivedDate();
          GregorianCalendar cal = new GregorianCalendar();
          cal.setTime(date_mail);
          // on recupere chaque item de la date
          int year     =   cal.get(Calendar.YEAR);
          int month    =   cal.get(Calendar.MONTH);
          int day      =   cal.get(Calendar.DAY_OF_MONTH);
          int hour     =   cal.get(Calendar.HOUR);
          int minute   =   cal.get(Calendar.MINUTE);
          int second   =   cal.get(Calendar.SECOND);
          // on met tout dans une string
          String cal_str = String.valueOf(day)+"/"+String.valueOf(month+1)+"/"+String.valueOf(year)+"  "+String.valueOf(hour)+":"+String.valueOf(minute)+":"+String.valueOf(second);


          InternetAddress myadress = new InternetAddress(from);
          String from_unicode       = myadress.toUnicodeString();

          // on recupere le sujet
          String sujet       =  message[message.length-(i+1)].getSubject();

          // on recupere le contenu
          Message p = message[message.length-(i+1)];
          String resultat = dumpPart(p);

          // on les ajoute au tableau des mails
          if (from_unicode != null) { array_from.add(from_unicode); } else { array_from.add("No author");}
          if (sujet != null) { array_sujet.add(sujet); } else { array_sujet.add("No subject");}
          if (cal_str != null) { array_date.add(cal_str); } else { array_date.add("No date");}
          if (resultat != null) { array_contenu.add(resultat); } else { array_contenu.add("No content");}
          
        }
      }


      // MAJ current nb mails
      current_nb_mails = numberofMessages;
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




  // fonction recursive qui sert a lire le contenu des mails

  public String dumpPart(Part p) throws Exception {


    String result="";
    String mess_erreur = "ERROR READING THE EMAIL : no text found";
    /*
        	 * Using isMimeType to determine the content type avoids
     	 * fetching the actual content data until we need it.
     	 */

    // si le mail est deja du texte
    if (p.isMimeType("text/plain")) {
      //println("This is plain text");
      result = p.getContent().toString();
      return result;
    } 

    // sinon si c'est un objet multipart
    else if (p.isMimeType("multipart/*")) {
      //println("This is a Multipart");

      Multipart mp = (Multipart)p.getContent();
      int count = mp.getCount();
      for (int i = 0; i < count; i++) {
        String rs = dumpPart(mp.getBodyPart(i));
        // TODO : eventuellement deleter les objets crees de maniere recursive ? (si besoin pour memoire)
        if (!rs.equals(mess_erreur)) {

          return rs;
        }
      }
    } 


    // sinon on retourne un message d'erreur
    else {

      result = mess_erreur;
      return result;
    }

    return mess_erreur;
  }
}


