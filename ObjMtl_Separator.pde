
class Rectangle
{
  PVector position;
  PVector size;
  boolean isHovered = false;

  Rectangle(float x, float y, float w, float h)
  {
    position = new PVector(x, y);
    size = new PVector(w, h);
  }
  void update()
  {
    isHovered =
      mouseX >= position.x && mouseX <= position.x + size.x &&
      mouseY >= position.y && mouseY <= position.y + size.y;
  }
  void draw(color border, color fill)
  {
    stroke(border);
    fill(fill);
    rect(position.x, position.y, size.x, size.y);
  }
}

class RectangleText
{
  Rectangle rectangle;
  color borderColor;
  color bgColor;
  color textColor;
  String text; 
  boolean adjustLongText = false;

  RectangleText(float x, float y, float w, float h, color borderC, color bgC, String default_text, color textC)
  {
    rectangle = new Rectangle(x, y, w, h);
    borderColor = borderC;
    bgColor = bgC;
    textColor = textC;
    text = default_text;
  }

  void draw()
  {
    rectangle.draw(borderColor, bgColor);

    textSize(14);
    fill(textColor);
    clip(rectangle.position.x, rectangle.position.y, rectangle.size.x, rectangle.size.y);
    float offsetW = 0.0;
    if (adjustLongText)
    {
      float textW = textWidth(text);
      if (textW > rectangle.size.x)
      {
        offsetW = rectangle.size.x - 4 - textW;
        float offsetWMod = mouseX / float(width);
        offsetWMod = constrain(offsetWMod * 2.0 - 0.5, 0.0, 1.0);
        offsetW *= offsetWMod;
      }
    }
    text(text, rectangle.position.x + 2 + offsetW, rectangle.position.y + rectangle.size.y - textDescent());
    noClip();
  }
}

class Button
{
  Rectangle rectangle;
  color borderColor;
  color restingColor;
  color hoverColor;
  color pressedColor;

  Button(float x, float y, float w, float h, color borderC, color c1, color c2, color c3)
  {
    rectangle = new Rectangle(x, y, w, h);
    borderColor = borderC;
    restingColor = c1;
    hoverColor = c2;
    pressedColor = c3;
  }

  void update()
  {
    rectangle.update();
  }
  void draw()
  {
    stroke(borderColor);

    if (rectangle.isHovered)
      if (mousePressed)
        rectangle.draw(borderColor, pressedColor);
      else
        rectangle.draw(borderColor, hoverColor);
    else
      rectangle.draw(borderColor, restingColor);
  }
}

float padding = 4;
float yOffset = 24 + padding;

//
RectangleText targetRectangleText = null;

//
RectangleText selectMTL_info = new RectangleText(padding, padding, 640 - padding * 2.0, 24, color(150), color(20), "MTL File", color(255));

Button selectMTL_btn = new Button(padding, padding + yOffset, 24, 24, color(150), color(255), color(175), color(105));
RectangleText selectMTL_text = new RectangleText(24 + padding * 2.0, padding + yOffset, 100, 24, color(150), color(20), "N/A", color(255));

//
RectangleText selectObj_info = new RectangleText(padding, padding + yOffset * 3.0, 640 - padding * 2.0, 24, color(150), color(20), "Obj File", color(255));

Button selectObj_btn = new Button(padding, padding + yOffset * 4.0, 24, 24, color(150), color(255), color(175), color(105));
RectangleText selectObj_text = new RectangleText(24 + padding * 2.0, padding + yOffset * 4.0, 100, 24, color(150), color(20), "N/A", color(255));

//
RectangleText selectOutput_info = new RectangleText(padding, padding + yOffset * 6.0, 640 - padding * 2.0, 24, color(150), color(20), "Output Directory", color(255));

Button selectOutput_btn = new Button(padding, padding + yOffset * 7.0, 24, 24, color(150), color(255), color(175), color(105));
RectangleText selectOutput_text = new RectangleText(24 + padding * 2.0, padding + yOffset * 7.0, 100, 24, color(150), color(20), "", color(255));

//
Button render_btn = new Button(padding, padding + yOffset * 9.0, 24, 24, color(150), color(255), color(175), color(105));
RectangleText render_text = new RectangleText(24 + padding * 2.0, padding + yOffset * 9.0, 100, 24, color(150), color(20), "Compile Objs", color(255));

void setup()
{
  
  size(640, 320);
  surface.setResizable(true);
  //selectInput("Select a file to process:", "fileSelected");
  selectMTL_text.adjustLongText = true;
  selectObj_text.adjustLongText = true;
  selectOutput_text.adjustLongText = true;
  //
  background(51);
}
void draw()
{
  
  //float t = millis() / 1000.0;
  //float y = sin(t) * 320.0 + 320.0;
  //stroke(255, 255, 255);
  //line(0, y, 640, y);
  colorMode(HSB);
  int x = int(random(width));
  int y = int(random(height));
  noStroke();
  float hue = random(360);
  fill(hue, 100, 100, 255);
  float size = random(4, 32);
  ellipse(x, y, size, size);
  colorMode(RGB);
  //
  selectMTL_info.rectangle.size.x = width - padding * 2.0;
  selectMTL_info.draw();

  selectMTL_btn.update();
  selectMTL_btn.draw();


  selectMTL_text.rectangle.size.x = width - padding * 3.0 - 24;
  selectMTL_text.draw();
  //
  selectObj_info.rectangle.size.x = width - padding * 2.0;
  selectObj_info.draw();

  selectObj_btn.update();
  selectObj_btn.draw();

  selectObj_text.rectangle.size.x = width - padding * 3.0 - 24;
  selectObj_text.draw();
  //
  selectOutput_info.rectangle.size.x = width - padding * 2.0;
  selectOutput_info.draw();

  selectOutput_btn.update();
  selectOutput_btn.draw();

  selectOutput_text.rectangle.size.x = width - padding * 3.0 - 24;
  selectOutput_text.draw();

  //
  render_btn.update();
  render_btn.draw();

  render_text.draw();
}

import java.util.TreeMap;
import java.util.Set;
import java.util.Iterator;
import java.util.Map;
import static javax.swing.JOptionPane.*;


boolean checkFile(String path)
{
  // Check data path
  File file = new File(dataPath("") + '/' + path);
  if (file.isFile())
    return true;

  // Check full path
  file = new File(path);
  return file.isFile(); // return file.exists();
}
boolean checkFolder(String path)
{
  File f = dataFile(path);
  return f.isDirectory();
}
boolean Overwrite_Accept(String fileName)
{
  String[] options = {"Overwrite", "Cancel"};
  int x = showOptionDialog(null, "Do you want to overwrite existinf file (" + fileName + ")", 
    "Notice", 
    DEFAULT_OPTION, WARNING_MESSAGE, null, options, options[0]);
  return x == 0;
}


void compileFiles()
{
  //
  boolean outputDirIsEmpty = selectOutput_text.text.equals("");

  // Check valid MTL
  if (!checkFile(selectMTL_text.text))
  {
    showMessageDialog(null, "Not a valid MTL File", " Failed to Compile Objs", ERROR_MESSAGE);
    return;
  }

  // Check Valid OBJ
  if (!checkFile(selectObj_text.text))
  {
    showMessageDialog(null, "Not a valid OBJ File", " Failed to Compile Objs", ERROR_MESSAGE);
    return;
  }

  // Check Valid Output Dir
  if (!checkFolder(selectOutput_text.text))
  {
    showMessageDialog(null, "Not a valid Output Location", " Failed to Compile Objs", ERROR_MESSAGE);
    return;
  }

  // Create Obj Names
  File ObjFile = dataFile(selectObj_text.text); // f.getPath();
  String ObjNameNoExt = ObjFile.getName().replaceFirst("[.][^.]+$", "");

  // Materials to Check in OBJ from MTL
  ArrayList<String> MaterialNames = new ArrayList<String>();
  HashMap<String, PVector> MaterialDiffuseColors = new HashMap<String, PVector>();
  String CurrentMaterial = "";

  // Read MTL
  {
    String[] lines = loadStrings(selectMTL_text.text);
    for (int i = 0; i < lines.length; i++)
    {
      // check for newmtl
      if (lines[i].length() > 0 && lines[i].charAt(0) == 'n')
      {
        String[] words = split(lines[i], ' ');
        if (words.length == 2 && words[0].equals("newmtl"))
        {
          CurrentMaterial = words[1];
          MaterialNames.add(words[1]);
        }
      }
      // check for color
      else if (lines[i].length() > 2 && lines[i].charAt(0) == 'K' && lines[i].charAt(1) == 'd')
      {
        String[] words = split(lines[i], ' ');
        if (words.length >= 4)
        {
          MaterialDiffuseColors.put(CurrentMaterial, new PVector(
            Float.parseFloat(words[1]), 
            Float.parseFloat(words[2]), 
            Float.parseFloat(words[3])
            ));
        }
      }
    }
  }

  // Safety, check if 2 or more materials
  if (MaterialNames.size() < 2)
  {
    showMessageDialog(null, "Less than 2 Material(s) in MTL, no purpose of doing this", " Failed to Compile Objs", WARNING_MESSAGE);
    return;
  }

  // Create output files
  class OutputFile
  {
    String fileName;
    PrintWriter file;
    String materialName;

    OutputFile(String _fileName, String _filePath, String _materialName)
    {
      fileName = _fileName;
      file = createWriter(_filePath);
      materialName = _materialName;
    }
  }
  //
  ArrayList<OutputFile> outputFiles = new ArrayList<OutputFile>();
  for (int i = 0; i < MaterialNames.size(); i++)
  {
    String filePath = "";
    String fileName = ObjNameNoExt + Integer.toString(i) + ".obj";
    if (outputDirIsEmpty)
      filePath = dataPath("") + '/' + fileName;
    else
      filePath = selectOutput_text.text + '\\' + fileName;

    // Check if file already exists
    if (checkFile(filePath))
    {
      // Check if don't overwrite
      if (Overwrite_Accept(fileName) == false)
      {
        continue;
      }
    }

    // File to write
    outputFiles.add(new OutputFile(fileName, filePath, MaterialNames.get(i)));

  }

  // If no outputfiles, then ignore
  if (outputFiles.size() == 0)
  {
    showMessageDialog(null, "No files are being outputted from ignoring overwrites", " Failed to Compile Objs", WARNING_MESSAGE);
    return;
  }

  // Read OBJ
  {

    // usemtl locations in OBJ
    class MtlStopper {
      int endLineIndex = -1;
      String materialName;

      MtlStopper(String _materialName)
      {
        materialName = _materialName;
      }
    };

    TreeMap<Integer, MtlStopper> useMtlLocations = new TreeMap<Integer, MtlStopper>();
    MtlStopper activeMtlStopper = null;

    //ArrayList<useMTLLocation> useMTLLocations = new ArrayList<useMTLLocation>();
    //useMTLLocation activeUseMTLLocation = null;

    // OBJ Lines
    String[] lines = loadStrings(selectObj_text.text);

    // Read OBJ once to get all correct ranges for materials
    for (int i = 0; i < lines.length; i++)
    {
      // Find usemtl
      if (lines[i].length() > 0 && lines[i].charAt(0) == 'u')
      {
        String[] words = split(lines[i], ' ');
        if (words.length == 2 && words[0].equals("usemtl"))
        {
          // End previous one
          if (activeMtlStopper != null)
            activeMtlStopper.endLineIndex = i;

          // new active one
          activeMtlStopper = new MtlStopper(words[1]);//

          // Store start
          useMtlLocations.put(i, activeMtlStopper);
          // Add range
          //useMtlLocations.get(words[1]).add(activeUseMtlRange);
        }
      }
      // End of usemtl cases
      else if (activeMtlStopper != null && lines[i].length() > 0 && (lines[i].charAt(0) == 'g' || lines[i].charAt(0) == 'v'))
      {
        //println("End: (" + Integer.toString(i) + ") = " + lines[i]);
        // Store end
        activeMtlStopper.endLineIndex = i;
        activeMtlStopper = null;
      }
    }
    // End of file
    if (activeMtlStopper != null)
      activeMtlStopper.endLineIndex = lines.length - 0;


    //for (Map.Entry me : useMtlLocations.entrySet())
    //{
    //  println("Start: " + me.getKey());
    //  MtlStopper stopper = (MtlStopper)me.getValue();
    //  println("End: " + Integer.toString(stopper.endLineIndex));
    //  println("TYpe: " + stopper.materialName);
    //  println();
    //}

    // Look at all ranges
    Set set = useMtlLocations.entrySet();
    Iterator iterator = set.iterator();
    Map.Entry mentry = (Map.Entry)iterator.next();
    int startIndex = (int)mentry.getKey();
    MtlStopper stopper = (MtlStopper)mentry.getValue();
    //println("FINAL START: " + Integer.toString(startIndex));
    //println("FINAL END: " + Integer.toString(stopper.endLineIndex));
    //print("Final Material: " + stopper.materialName);
    boolean inMaterialRange = false;

    // Copy all data from original OBJ onto clones
    // while exluding specific ranges
    for (int i = 0; i < lines.length; i++)
    {

      // check if leaving range
      if (stopper != null && inMaterialRange && i == stopper.endLineIndex)
      {
        inMaterialRange = false;
        // Iterate to next
        if (iterator.hasNext())
        {
          mentry = (Map.Entry)iterator.next();
          startIndex = (int)mentry.getKey();
          stopper = (MtlStopper)mentry.getValue();
          //println("FINAL START: " + Integer.toString(startIndex));
          //println("FINAL END: " + Integer.toString(stopper.endLineIndex));
          //println("Final Material: " + stopper.materialName);
        }
        // reached end of iterators
        else
          stopper = null;
      }
      // Check if can be in range
      if (stopper != null && !inMaterialRange && i == startIndex)
      {
        inMaterialRange = true;
      }

      //
      for (int j = 0; j < outputFiles.size(); j++)
      {
        // If inside a material range, only output if matching material type
        if (inMaterialRange && stopper != null)
        {
          OutputFile f = outputFiles.get(j);
          if (f.materialName.equals(stopper.materialName))
            f.file.println(lines[i]);
        }
        // not in a material range, output normally
        else
          outputFiles.get(j).file.println(lines[i]);
      }
    }

    // Close Files
    for (int i = 0; i < outputFiles.size(); i++)
    {
      outputFiles.get(i).file.flush();
      outputFiles.get(i).file.close();
    }
  }

  // Colors output txt
  String colorsOutputFile = "";
  if (outputDirIsEmpty)
    colorsOutputFile = dataPath("") + '/' + ObjNameNoExt + "_colours.txt";
  else
    colorsOutputFile = selectOutput_text.text + '/' + ObjNameNoExt + "_colours.txt";

  // Output Txt with all colors
  PrintWriter colorsTxt = createWriter(colorsOutputFile);

  //
  for (int i = 0; i < outputFiles.size(); i++)
  //for (Map.Entry me : MaterialDiffuseColors.entrySet())
  {
    String materialName = outputFiles.get(i).materialName;

    
    PVector p = (PVector)MaterialDiffuseColors.get(materialName);
    int px = int(p.x * 255.0);
    int py = int(p.y * 255.0);
    int pz = int(p.z * 255.0);
    //
    colorsTxt.println(materialName + " - " + outputFiles.get(i).fileName);
    colorsTxt.println(Integer.toString(px) + ", " + Integer.toString(py) + ", " + Integer.toString(pz));
    colorsTxt.println();
  }
  //
  colorsTxt.flush();
  colorsTxt.close();

  // Done
  showMessageDialog(null, "Successfully Created OBJ Files", "", INFORMATION_MESSAGE);
}

void mouseClicked()
{
  //
  if (selectMTL_btn.rectangle.isHovered)
  {
    targetRectangleText = selectMTL_text;
    selectInput("Select an MTL file to process:", "fileSelected");
  } else if (selectObj_btn.rectangle.isHovered)
  {
    targetRectangleText = selectObj_text;
    selectInput("Select an OBJ file to process:", "fileSelected");
  } else if (selectOutput_btn.rectangle.isHovered)
  {
    targetRectangleText = selectOutput_text;
    //File desktopPath = new File(System.getProperty("user.home") + "/Desktop");
    selectFolder("Select a directory to output", "folderSelected"); // ,desktopPath
  } else if (render_btn.rectangle.isHovered)
  {
    //println("RENDER");
    compileFiles();
  }
  //
}

void folderSelected(File selection) {
  if (selection != null)
  {
    if (targetRectangleText != null)
      targetRectangleText.text = selection.getAbsolutePath();
    //println("User selected " + selection.getAbsolutePath());
  }
}
void fileSelected(File selection) {
  if (selection != null)
  {
    if (targetRectangleText != null)
      targetRectangleText.text = selection.getAbsolutePath();
    //println("User selected " + selection.getAbsolutePath());
  }
}
