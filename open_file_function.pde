/**
 filechooser taken from http://processinghacks.com/hacks:filechooser
 @author Tom Carden
 */



// set system look and feel
public String open_file_function() {

String path_value = "NOT_VALID";
  
  
  try { 
    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
  } 
  catch (Exception e) { 
    e.printStackTrace();
  } 

  // create a file chooser 
  final JFileChooser fc = new JFileChooser(); 

  // in response to a button click: 
  int returnVal = fc.showOpenDialog(this); 

  if (returnVal == JFileChooser.APPROVE_OPTION) { 
    File file = fc.getSelectedFile(); 
    // see if it's an image 
    // (better to write a function and check for all supported extensions) 
    if (file.getName().endsWith("png") || file.getName().endsWith("jpg")) { 

      path_value = file.getPath(); 
      
      }
     
    else { 
      // just print the contents to the console 
      // note: loadStrings can take a Java File Object too 
      println(file.getName() + " is not valid");
      
      
      
    }
  } 
  else { 
    println("Open command cancelled by user.");
  }
  
  
  return path_value;
  
  
}

