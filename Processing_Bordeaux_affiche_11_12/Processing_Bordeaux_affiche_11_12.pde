import processing.pdf.*;
import controlP5.*;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import java.util.Calendar;

// --------------------------------------------------------
Triangle root;
Triangle root2;
TriangleConfig configDefault;
TriangleConfig config;
int levelMin=2;
int levelMax=12;


Canvas canvas;



// --------------------------------------------------------
boolean doUpdateTriangles = false;
boolean isExportPDF = false;
boolean isExportImage = false;
boolean isDrawTriangle2 = false;

// --------------------------------------------------------
void setup()
{
  size(210*3, 287*3);
  Ani.init(this);
  strokeCap(ROUND);
//  canvas = new Canvas(this,0.95);
  canvas = new Canvas(this,1.0);
  //root = new Triangle(null,canvas.x,canvas.y, canvas.x+canvas.width,canvas.y, canvas.x,canvas.y+canvas.height);
  //root2 = new Triangle(null,canvas.x+canvas.width,canvas.y+canvas.height,canvas.x+canvas.width,canvas.y, canvas.x,canvas.y+canvas.height);
  configDefault = new TriangleConfig();
  config = configDefault;

  initControls();
  doUpdateTriangles = true;
}

// --------------------------------------------------------
void draw()
{
  if (doUpdateTriangles)
  {
    doUpdateTriangles = false;
    updateTriangles();
  }
  
  if (isExportPDF)
  {
    beginRecord(PDF, "exports/pdf/"+timestamp()+"_export.pdf");
  }

//  background(254,237,1);
  background(255);
  noFill();
  root.draw();
  if(isDrawTriangle2) 
    root2.draw();

  if (isExportPDF)
  {
    isExportPDF = false;
    endRecord();
  }

    
  if (isExportImage)
  {
    isExportImage = false;
    saveFrame("exports/images/img"+timestamp()+".png");
  }
}

// --------------------------------------------------------
void updateTriangles()
{
  root = new Triangle(null,canvas.x,canvas.y, canvas.x+canvas.width,canvas.y, canvas.x,canvas.y+canvas.height);
  root.subdivide(0,-1);
  if(isDrawTriangle2)
  {
    root2 = new Triangle(null,canvas.x+canvas.width,canvas.y+canvas.height,canvas.x+canvas.width,canvas.y, canvas.x,canvas.y+canvas.height);
    root2.subdivide(0, root.rnd);
  }
}
