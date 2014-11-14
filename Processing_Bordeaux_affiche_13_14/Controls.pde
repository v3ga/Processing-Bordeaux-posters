ControlP5 cp5;
ControlWindow cp5Window;
Button btnExport;
Slider sliderNbShleves;
Range rangeHeightBooks,rangeWidthBooks,rangeGapBooks;
Toggle chkDebug;
// --------------------------------------------------------
void initControls()
{
  cp5 = new ControlP5(this);
//  cp5Window = cp5.addControlWindow("controlP5window", 0, 0, 300, 320).hideCoordinates().setBackground(color(40));
  cp5.setColorLabel(0xff000000);
  cp5.setColorValue(0xffffffff);
  cp5.setColorForeground(0xffFDEB34);
  cp5.setColorBackground(0xff000000);
  cp5.setColorActive(0xffFDEB34);


    rangeWidthBooks = cp5.addRange("widthBooks").setLabel("Largeur livres").setRange(5, 30).setRangeValues(8,15).setSize(200, 18).setPosition(0,height/2).linebreak();
    rangeHeightBooks = cp5.addRange("heightBooks").setLabel("Hauteur livres").setRange(0.2, 0.95).setRangeValues(0.6,0.8).setSize(200, 18).setPosition(0, height/2+20).linebreak();
    rangeGapBooks = cp5.addRange("gapBooks").setLabel("Ecart livres").setRange(0, 10).setRangeValues(2,5).setSize(200, 18).setPosition(0,height/2+40).linebreak();

  cp5.begin(0,height/2+60);
    sliderNbShleves = cp5.addSlider("nbShelvesNew").setLabel("Nb Etageres").setRange(3,12).setSize(200, 18).linebreak();
    btnExport = cp5.addButton("export PDF").setLabel("Export PDF");
    chkDebug = cp5.addToggle("debug").setLabelVisible(false).setWidth(18);
  cp5.end();
/*
  btnExport.setWindow(cp5Window);
  sliderNbShleves.setWindow(cp5Window);
  rangeHeightBooks.setWindow(cp5Window);
  rangeWidthBooks.setWindow(cp5Window);
  rangeGapBooks.setWindow(cp5Window);
  chkDebug.setWindow(cp5Window);
*/
}

// --------------------------------------------------------
void controlEvent(ControlEvent theEvent) 
{
  String name = theEvent.getName();
  if (name.equals("export PDF"))
  {
    isExportPDF = true;
  }
  else
  if (name.equals("nbShelvesNew"))
  {
    nbShelvesNew = int(theEvent.getValue());
    if (nbShelvesNew != nbShelves){
      recreateBookStore = true;
    }
  }
  else
  if (name.equals("widthBooks"))
  {
      widthBooksMin = theEvent.getController().getArrayValue(0); 
      widthBooksMax = theEvent.getController().getArrayValue(1); 
      recreateBookStore = true;
  }
  else
  if (name.equals("heightBooks"))
  {
      heightBooksMin = theEvent.getController().getArrayValue(0); 
      heightBooksMax = theEvent.getController().getArrayValue(1); 
      recreateBookStore = true;
  }
  else
  if (name.equals("gapBooks"))
  {
      gapBooksMin = theEvent.getController().getArrayValue(0); 
      gapBooksMax = theEvent.getController().getArrayValue(1); 
      recreateBookStore = true;
  }
  else
  if (name.equals("debug"))
  {
    __DEBUG__ = theEvent.getValue() == 0.0f ? false : true;
  }

}


