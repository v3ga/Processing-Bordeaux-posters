import java.util.Calendar;

Scanimation scanimation;
FrameAnimationManager frameAnimManager;
ToolManager toolManager;
ToolAnimation toolAnimation;
ToolComposition toolComposition;

// --------------------------------------------------------------------
// setup
// --------------------------------------------------------------------
void setup()
{
  size((int)(210*3),(int)(287*3));
    
  frameAnimManager = new FrameAnimationManager();
  frameAnimManager.addAnimation( new FrameTrianglePB07_01("TrianglePB07 #01"));
  frameAnimManager.addAnimation( new FrameTrianglePB07_02("TrianglePB07 #02") );
  frameAnimManager.addAnimation( new FrameTrianglePB07_03("TrianglePB07 #03") );
  frameAnimManager.addAnimation( new FrameRectangle("Rectangle") );
  frameAnimManager.addAnimation( new FrameRectangle2("Rectangle2") );
  frameAnimManager.setCurrent(0);

  scanimation = new Scanimation(this);
  scanimation.composeFinalFrame();

  toolManager = new ToolManager(this);
  toolManager.initControls();
    
  toolAnimation = new ToolAnimation(this);
  toolComposition = new ToolComposition(this);
  toolManager.addTool( toolAnimation ); 
  toolManager.addTool( toolComposition ); 

  // UI for animations
  frameAnimManager.addAnimationUI(0, new FrameTrianglePB07_01_UI());

  // Set up tools
  toolManager.setup();
  toolManager.initControls();
}

// --------------------------------------------------------------------
// draw
// --------------------------------------------------------------------
void draw()
{
  toolManager.update();
  toolManager.draw();
}

// --------------------------------------------------------------------
// mousePressed()
// --------------------------------------------------------------------
void mousePressed()
{
  toolManager.mousePressed();
}


// --------------------------------------------------------------------
// keyPressed
// --------------------------------------------------------------------
void keyPressed()
{
  toolManager.keyPressed();
  saveFrame();
}

// --------------------------------------------------------------------
// mouseDragged
// --------------------------------------------------------------------
void mouseDragged()
{
  toolManager.mouseDragged();
}

// --------------------------------------------------------------------
// mouseReleased
// --------------------------------------------------------------------
void mouseReleased()
{
  toolManager.mouseReleased();
}

// --------------------------------------------------------------------
// drawScanimationFrame
// --------------------------------------------------------------------
void drawScanimationFrame(PGraphics pg, int frame, int frameNb)
{
  FrameAnimation fa = frameAnimManager.getCurrent();
  if (fa!=null){
    fa.draw(pg,frame,frameNb);
  }
}

// --------------------------------------------------------------------
// controlEvent
// --------------------------------------------------------------------
void controlEvent(ControlEvent theEvent)
{
  if (theEvent.isTab()) {
    toolManager.select(theEvent.tab().id());
  }
}

