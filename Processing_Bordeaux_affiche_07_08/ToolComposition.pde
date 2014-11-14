import processing.pdf.*;
// https://forum.processing.org/topic/toxiclibs-storing-polygon2d-objects-as-pdf-or-svg


class ToolComposition extends Tool
{
  boolean useMask = false;
  boolean exportCompo = false;

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  ToolComposition(PApplet p)
  {
    super(p);
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  public String getId()
  {
    return "__ToolComposition__";
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void initControls()
  {
    initTab("Composition", "Composition");

    cp5.begin(0, 24);
    Toggle tgUseMask = cp5.addToggle("useMask").moveTo(tabName).addListener(this).setSize(20, 20).linebreak();
    cp5.addButton("exportCompo").addListener(this).moveTo(tabName).setLabel("export compo").setHeight(20);
    cp5.addButton("exportGrid").addListener(this).moveTo(tabName).setLabel("export grid").setHeight(20);

    cp5.end();
  }




  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void update()
  {
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void draw()
  {
    PGraphics composition = scanimation.getCompositionFrame();

    if (exportCompo)
    {
      exportCompo = false;

      String time = timestamp();
      beginRecord(PDF, time+"_export.pdf");
      strokeCap(SQUARE);
      stroke(0, 255);
      strokeWeight(2);

      composition.loadPixels();
      boolean isBeginLine = false;
      int r = 0, i=0, j=0, jbegin=0;

      for (i=0;i<composition.width;i++)
      {
        isBeginLine = false;
        for (j=0;j<composition.height;j++)
        {
          r = (int)red( composition.get(i, j) );
          if (isBeginLine)
          {
            if (r>=254) {
              isBeginLine = false;
              line(i, jbegin, i, j-1);
              println("colonne end "+i+";j="+j);
            }
          }
          else
          {
            if (r<=5) {
              isBeginLine = true;
              jbegin = j;
              println("colonne begin "+i+";j="+j);
            }
          }
        }

        if (isBeginLine)
        {
          line(i, jbegin, i, composition.height);
        }
      }



      endRecord();

      composition.save(time+"_export.png");
    }

    image(composition, 0, 0, width, height);


    if (useMask)
      blend(scanimation.getMaskFrameScreen(), 0, 0, width, height, mouseX-width/2, 0, width, height, BLEND);
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  public void controlEvent(ControlEvent theEvent)
  {
    String name = theEvent.getName();
    if (name.equals("useMask")) useMask = theEvent.getController().getValue() == 1.0f;
    else
      if (name.equals("exportCompo")) exportCompo = true;
  }
}

