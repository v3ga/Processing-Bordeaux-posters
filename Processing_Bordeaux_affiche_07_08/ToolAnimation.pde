class ToolAnimation extends Tool
{
  int frame=0;
  boolean isPlaying = false;
  Timer timer;
  float periodChangeFrame = 0.5f; // seconds
  float timeChangeFrame=0.0f;  
  
  Slider sliderFrame;
  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  ToolAnimation(PApplet p)
  {
    super(p);
    timer = new Timer();
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  public String getId()
  {
    return "__ToolAnimation__";
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void initControls()
  {
    initTab("default", "Animation");

    //   cp5.begin(2, 25);
  cp5.setColorLabel(0xffffffff);
  cp5.setColorValue(0xff000000);
  cp5.setColorForeground(0xffFDEB34);
  cp5.setColorBackground(0xff000000);
  cp5.setColorActive(0xffFDEB34);

    DropdownList ddAnim = cp5.addDropdownList("animations").moveTo(tabName).addListener(this).setItemHeight(20).setBarHeight(20).setPosition(0, 44);
    ddAnim.captionLabel().style().marginTop = 5;
    ddAnim.captionLabel().style().marginLeft = 2;
    for (int i=0;i<frameAnimManager.size();i++)
    {
      FrameAnimation f = frameAnimManager.get(i);
      ddAnim.addItem(f.name, i);
    }

    sliderFrame = cp5.addSlider("frame").moveTo(tabName).addListener(this).setValue(frame).setPosition(100, 23).setHeight(20).setWidth(100).setRange(0, scanimation.getNumberFrames()-1).setNumberOfTickMarks(scanimation.getNumberFrames());
    cp5.addButton("play").addListener(this).setPosition(201,23).setHeight(20).setWidth(40);
    cp5.addButton("stop").addListener(this).setPosition(242,23).setHeight(20).setWidth(40);

    //    cp5.end();
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void select()
  {
//    frameAnimManager.showAnimationUI();
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void unselect()
  {
//    frameAnimManager.hideAnimationUI();
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void resetTimer()
  {
    timeChangeFrame = 0.0f;
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void update()
  {
    if (isPlaying) 
    {
      float dt = timer.update();
      timeChangeFrame+=dt;
      if (timeChangeFrame>=periodChangeFrame)
      {
        resetTimer();
        frame = (frame+1)%scanimation.getNumberFrames();
      }
      updateControls();
    }
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void updateControls()
  {
   sliderFrame.setValue(frame); 
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void draw()
  {
    background(255);
    PGraphics f = scanimation.getFrame(frame);
    if (f!=null)
      image(f, 0, 0, width, height);
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  public void controlEvent(ControlEvent theEvent)
  {
    String name = theEvent.getName();
    if (theEvent.isGroup())
    {
      int id = (int)theEvent.getGroup().getValue();
      frameAnimManager.setCurrent(id);
      scanimation.composeFinalFrame();
    }
    else
    {
      if (name.equals("frame")) frame = int(theEvent.getController().getValue());
      else if (name.equals("play")) {resetTimer();isPlaying = true;}
      else if (name.equals("stop")) isPlaying = false;
    }
  }
}

