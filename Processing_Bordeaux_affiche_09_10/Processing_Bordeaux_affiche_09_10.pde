import megamu.mesh.*;
import processing.pdf.*;
import controlP5.*;
import java.util.Calendar;

// --------------------------------------------------------
ControlP5 cp5;
PathFinder pf;
Node closestNode;

// --------------------------------------------------------
Voronoi pfVoronoi;
Delaunay pfDelaunay;

// --------------------------------------------------------
boolean isDrawGrid = true;
boolean isDrawVoronoi = true;
boolean isDrawAutomate = true;
boolean isDrawDelaunay = false;
boolean isExport = false;
boolean isAdditiveMode = false;

// --------------------------------------------------------
void setup()
{
  // Window
  size(210*3, 287*3);
  smooth();
  // Data
  pf = new PathFinder(20);
  pf.start();

  // Controls
  initControls();
}

// --------------------------------------------------------
void draw()
{
  // ----------------------------
  pf.update();

  // ----------------------------
  if (isExport)
  {
    beginRecord(PDF, "export/"+timestamp()+"_export.pdf");
  }
  background(255);

  // ----------------------------
  if (isDrawGrid)
  {
    stroke(200);
    strokeWeight(1);
    pf.drawGrid();
  }

  if (isDrawVoronoi)
  {
    stroke(0);
    strokeWeight(3);
    drawVoronoi();
  }

  if (isDrawDelaunay)
  {
    stroke(0);
    strokeWeight(3);
    drawDelaunay();
  }


  // ----------------------------
  //fill(0);
  //pf.drawNodes();

  // ----------------------------
  if (isDrawAutomate)
  {
    stroke(0);
    pf.draw();
  }
  
  if (isExport)
  {
    isExport = false;
    endRecord();
  }


  // ----------------------------
  int mx = int( map(mouseX, 0, width, 0, pf.resxNodes-1) );
  int my = int( map(mouseY, 0, height, 0, pf.resyNodes-1) );

  closestNode = null;
  Node intNode = pf.getNode(mx, my);
  if (intNode != null && intNode.active)
  {
    Node n[] = {
      pf.getNode(mx+1, my), pf.getNode(mx+1, my+1), pf.getNode(mx, my+1)
    };
    float dClosest = dist(mouseX, mouseY, intNode.pos.x, intNode.pos.y);
    closestNode = intNode;
    float d = 1000.0f;
    for (int i=0;i<n.length;i++)
    {
      if (n[i]!=null)
      {
        d = dist(mouseX, mouseY, n[i].pos.x, n[i].pos.y);
        if (d<dClosest) {
          dClosest = d;
          closestNode = n[i];
        }
      }
    }

    if (closestNode != null && closestNode.active)
    {
      noFill();
      stroke(0, 200, 0);
      ellipse(closestNode.pos.x, closestNode.pos.y, 10, 10);
    }
  }


  // ----------------------------
  fill(0);
  if (pf.stopped)
  {
    text(pf.strStopped, width-textWidth(pf.strStopped)-10, 10);
  }
}

// --------------------------------------------------------
void mousePressed()
{
  if (isAdditiveMode == false)
    pf.reset();

  if (closestNode!=null) {
    pf.setStartNode(closestNode.i, closestNode.j);
  }
  else
    pf.setStartNode(0, 0);

  pf.start();
}

// --------------------------------------------------------
Voronoi makeVoronoi(PathFinder pf)
{
  if (pf.listNodesVisited.size()>1)
  {
    float[][] points = new float[pf.listNodesVisited.size()][2];
    int i=0;
    for (Node n:pf.listNodesVisited)
    {
      points[i][0] = n.pos.x;
      points[i][1] = n.pos.y;
      i++;
    }

    return new Voronoi(points);
  }

  return null;
}

// --------------------------------------------------------
void drawVoronoi()
{
    if (!pf.stopped)
      pfVoronoi = makeVoronoi(pf);
    if (pfVoronoi != null)
    {
      float[][] myEdges = pfVoronoi.getEdges();

      for (int i=0; i<myEdges.length; i++)
      {
        float startX = myEdges[i][0];
        float startY = myEdges[i][1];
        float endX = myEdges[i][2];
        float endY = myEdges[i][3];
        line( startX, startY, endX, endY );
      }
    }
}

// --------------------------------------------------------
Delaunay makeDelaunay(PathFinder pf)
{
  if (pf.listNodesVisited.size()>1)
  {
    float[][] points = new float[pf.listNodesVisited.size()][2];
    int i=0;
    for (Node n:pf.listNodesVisited)
    {
      points[i][0] = n.pos.x;
      points[i][1] = n.pos.y;
      i++;
    }

    return new Delaunay(points);
  }

  return null;
}

// --------------------------------------------------------
void drawDelaunay()
{
    if (!pf.stopped)
      pfDelaunay = makeDelaunay(pf);
    if (pfDelaunay != null)
    {
      float[][] myEdges = pfDelaunay.getEdges();

      for (int i=0; i<myEdges.length; i++)
      {
        float startX = myEdges[i][0];
        float startY = myEdges[i][1];
        float endX = myEdges[i][2];
        float endY = myEdges[i][3];
        line( startX, startY, endX, endY );
      }
    }
}


