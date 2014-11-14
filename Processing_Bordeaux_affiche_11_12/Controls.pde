ControlP5 cp5;
ControlWindow cp5Window;
Slider sliderLevel,sliderResMotif,sliderRndSubdiv,sliderT;
Range rangeRnd,rangeStrokeW;
Toggle chkDrawLines,chkDrawBezier,chkDrawTriangles,chkDrawTriangle2;
Button btnExport,btnExportImage;



// --------------------------------------------------------
void initControls()
{
  cp5 = new ControlP5(this);
  //cp5Window = cp5.addControlWindow("controlP5window", 0, 0, 300, 320).hideCoordinates().setBackground(color(40));
  cp5.setColorLabel(0xff000000);
  cp5.setColorValue(0xffffffff);
  cp5.setColorForeground(0xffFDEB34);
  cp5.setColorBackground(0xff000000);
  cp5.setColorActive(0xffFDEB34);


  rangeRnd = cp5.addRange("random").setRange(0.1, 0.9).setRangeValues(0.5,0.6).setSize(200, 18).setPosition(width/2,height/2+10).linebreak();
  rangeStrokeW  = cp5.addRange("epaisseur").setRange(1, 10).setRangeValues(1,8).setSize(200, 18).setPosition(width/2,height/2+10+19).linebreak();

  cp5.begin(width/2,height/2+19*2+10);
    sliderLevel = cp5.addSlider("niveau").setRange(levelMin, levelMax).setSize(200, 18).setValue(6).linebreak();
    sliderRndSubdiv = cp5.addSlider("random subdiv").setRange(0.2, 1.0).setSize(200, 18).setValue(1.0f).linebreak();
    sliderT= cp5.addSlider("t").setRange(0.0, 1.0).setSize(200, 18).setValue(1.0f).linebreak();
    chkDrawTriangles = cp5.addToggle("dessin contour").setSize(18, 18).setValue(0.0f).linebreak();
    chkDrawLines = cp5.addToggle("dessin lignes").setSize(18, 18).setValue(1.0f).linebreak();
    chkDrawBezier = cp5.addToggle("dessin bezier").setSize(18, 18).setValue(0.0f).linebreak();
    chkDrawTriangle2 = cp5.addToggle("triangle2").setSize(18, 18).setValue(isDrawTriangle2 ? 1.0: 0.0).linebreak();
    btnExport = cp5.addButton("export PDF").setLabel("Export PDF").linebreak();
    btnExportImage = cp5.addButton("export Image").setLabel("Export Image").linebreak();
  cp5.end();
/*
  sliderLevel.setWindow(cp5Window);
  sliderRndSubdiv.setWindow(cp5Window);
  sliderT.setWindow(cp5Window);
  rangeRnd.setWindow(cp5Window);
  rangeStrokeW.setWindow(cp5Window);
  chkDrawTriangles.setWindow(cp5Window);
  chkDrawLines.setWindow(cp5Window);
  chkDrawBezier.setWindow(cp5Window);
  chkDrawTriangle2.setWindow(cp5Window);
  btnExport.setWindow(cp5Window);
  btnExportImage.setWindow(cp5Window);
  */
}

// --------------------------------------------------------
void controlEvent(ControlEvent theEvent) 
{
  boolean update = false;
  String name = theEvent.getName();
  if (name.equals("niveau"))
  {
    update = true;
    config.levelMax = int(theEvent.getValue());
  }
  else if (name.equals("random"))
  {
    update = true;
    config.rndMin = theEvent.getController().getArrayValue(0); 
    config.rndMax = theEvent.getController().getArrayValue(1);
  }  
  else if (name.equals("epaisseur"))
  {
    config.strokeWmin = (int)theEvent.getController().getArrayValue(0); 
    config.strokeWmax = (int)theEvent.getController().getArrayValue(1);
  }  

  else if (name.equals("random subdiv"))
  {
    update = true;
    config.rndSubdivide = theEvent.getValue();
  }
  else if (name.equals("t"))
  {
    config.t = theEvent.getValue();
  }
  else if (name.equals("motif"))
  {
    config.resMotif = int(theEvent.getValue());
  }
  else if (name.equals("dessin contour"))
  {
    config.isDrawContour = int(theEvent.getValue()) == 1.0 ? true : false;
  }
  else if (name.equals("dessin lignes"))
  {
    config.isDrawLignes = int(theEvent.getValue()) == 1.0 ? true : false;
  }
  else if (name.equals("dessin bezier"))
  {
    config.isDrawBezier = int(theEvent.getValue()) == 1.0 ? true : false;
  }
  else if (name.equals("triangle2"))
  {
    doUpdateTriangles = true;
    isDrawTriangle2 = int(theEvent.getValue()) == 1.0 ? true : false;
  }
  else if (name.equals("export PDF"))
  {
    isExportPDF = true;
  }
  else if (name.equals("export Image"))
  {
    isExportImage = true;
  }
  
  if (update) 
  {
    doUpdateTriangles = true;
  }
}


