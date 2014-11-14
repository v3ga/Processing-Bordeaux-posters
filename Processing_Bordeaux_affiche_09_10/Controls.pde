ControlWindow cp5Window;
Slider sliderRes,sliderTimestep;
Toggle chkDrawGrid,chkDrawAutomate, chkDrawVoronoi,chkDrawDelaunay, chkIsAdditive;
Button btnExport;


// --------------------------------------------------------
void initControls()
{
  cp5 = new ControlP5(this);
  cp5.setColorLabel(0xff000000);
  cp5.setColorValue(0xffffffff);
  cp5.setColorForeground(0xffFDEB34);
  cp5.setColorBackground(0xff000000);
  cp5.setColorActive(0xffFDEB34);


  //
  //cp5Window = cp5.addControlWindow("controlP5window", 0, 0, 400, 300).hideCoordinates().setBackground(color(40));

  cp5.begin(width/2,0);
    sliderRes = cp5.addSlider("resolution").setRange(10, 30).setNumberOfTickMarks(30-10+1).setSize(200, 18).setValue(20).linebreak();
    sliderTimestep = cp5.addSlider("timestep").setRange(0.05, 0.2).setSize(200, 18).setValue(0.1f).linebreak();
    chkDrawGrid = cp5.addToggle("grid").setSize(18, 18).setValue(isDrawGrid ? 1.0f : 0.0f).linebreak();
    chkDrawAutomate = cp5.addToggle("automate").setSize(18, 18).setValue(isDrawAutomate ? 1.0f : 0.0f).linebreak();
    chkDrawVoronoi = cp5.addToggle("voronoi").setLabel("diagramme de Voronoi").setSize(18, 18).setValue(isDrawVoronoi ? 1.0f : 0.0f).linebreak(); 
    chkDrawDelaunay = cp5.addToggle("delaunay").setLabel("diagramme de Delaunay").setSize(18, 18).setValue(isDrawDelaunay ? 1.0f : 0.0f).linebreak(); 
    //chkIsAdditive = cp5.addToggle("additive").setSize(18, 18).setLabel("Mode additif").linebreak();
    btnExport = cp5.addButton("export").setLabel("Export").linebreak();
  cp5.end();
/*
  sliderRes.setWindow(cp5Window);
  sliderTimestep.setWindow(cp5Window);
  chkDrawGrid.setWindow(cp5Window);
  chkDrawAutomate.setWindow(cp5Window);
  chkDrawVoronoi.setWindow(cp5Window);
  chkDrawDelaunay.setWindow(cp5Window);
  btnExport.setWindow(cp5Window);
  if (chkIsAdditive!=null) chkIsAdditive.setWindow(cp5Window);
*/
}

// --------------------------------------------------------
void controlEvent(ControlEvent theEvent) 
{
  String name = theEvent.getName();
  if (name.equals("resolution"))
  {
     pf.setResolution(int(theEvent.getValue()));
     pf.start();
  }
  else if (name.equals("timestep"))
  {
    pf.periodStep = theEvent.getValue();
  }
  else if (name.equals("grid"))
  {
    isDrawGrid = (theEvent.getValue() == 1.0f);
  }
  else if (name.equals("automate"))
  {
    isDrawAutomate = (theEvent.getValue() == 1.0f);
  }
  else if (name.equals("voronoi"))
  {
    isDrawVoronoi = (theEvent.getValue() == 1.0f);
  }
  else if (name.equals("delaunay"))
  {
    isDrawDelaunay = (theEvent.getValue() == 1.0f);
  }
  else if (name.equals("additive"))
  {
    isAdditiveMode = (theEvent.getValue() == 1.0f);
  }
  else if (name.equals("export"))
  {
    isExport = true;
  }
}


