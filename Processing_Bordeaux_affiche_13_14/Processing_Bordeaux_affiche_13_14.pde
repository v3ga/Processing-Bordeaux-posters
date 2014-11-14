import processing.pdf.*;
import controlP5.*;
import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import java.util.Calendar;

// --------------------------------------------------------
boolean __DEBUG__ = false;

// --------------------------------------------------------
Canvas canvas;

// --------------------------------------------------------
boolean isExportPDF = false;
boolean isExportImage = false;

// --------------------------------------------------------
Triangle tri; 

// --------------------------------------------------------
int nbShelves = 5, nbShelvesNew = 5;
float hBookMax = 0.0;
boolean recreateBookStore = false;
float widthBooksMin = 8, widthBooksMax = 14;
float heightBooksMin = 0.6, heightBooksMax = 0.95;
float gapBooksMin = 2, gapBooksMax = 6;


// --------------------------------------------------------
PBox2D box2d;
ArrayList<Shelf> listShelves;
ArrayList<Boundary> listBoundaries;
Spring spring;
boolean pauseBox2d = false;


// --------------------------------------------------------
void setup()
{
  size(210*3, 287*3);
  frame.setTitle("Poster Processing Bordeaux #13 #14");

  canvas = new Canvas(this, 0.95);
  tri = new Triangle(canvas);
  createBookStore();
  spring = new Spring();
  initControls();
}

// --------------------------------------------------------
void draw()
{
  // update in sync here
  if (recreateBookStore){
    nbShelves = nbShelvesNew;
    createBookStore();
    recreateBookStore = false;
  }

  // Update Box2D
  if (box2d != null && !pauseBox2d)
    box2d.step();

  spring.update(mouseX, mouseY);

  // PDF
  if (isExportPDF) {
    beginRecord(PDF, "exports/pdf/"+timestamp()+"_export.pdf");
  }

  // Bakground
  background(255);
  rectMode(CORNER);

  // Canvas
  if (__DEBUG__) {
    canvas.draw();
  }
  // Shelves
  for (Shelf shelf: listShelves)
    shelf.display();

  if (__DEBUG__) {
    for (Boundary b:listBoundaries)
      b.display();
  }

  // Triangle
  if (__DEBUG__) {
    tri.draw();
  }

  // PDF
  if (isExportPDF) {
    isExportPDF = false;
    endRecord();
  }

  spring.display();
}

// --------------------------------------------------------
void createShelves()
{
  listShelves = new ArrayList<Shelf>();
  float stepShelf = canvas.height / (float) nbShelves;
  float y = canvas.y+canvas.height;
  float x = canvas.x+canvas.width/2;
  float w = canvas.width;
  float h = 5;
  hBookMax = stepShelf-h;

  for (int i=0;i<nbShelves;i++)
  {
    PVector ptEdge = tri.getPointForY(y);
    w = canvas.x+canvas.width-ptEdge.x;
    x = ptEdge.x+w/2;
    listShelves.add( new Shelf(x, y, w, h) );      
    y -= stepShelf;
  }
}

// --------------------------------------------------------
void createBooks()
{
  float wBookMax = 12;
  float wBook = 0, hBook=0;
  int nbBooks = 10;
  for (Shelf shelf : listShelves)
  {
    if (shelf.w>0)
    {
      wBook = shelf.w / float(nbBooks);
      //println(wBook+","+hBook);
      float xBook = shelf.x - 0.5*shelf.w;
      float yBook = 0;
      float yShelf = shelf.y-0.5*shelf.h;

      //for (int i=0;i<nbBooks;i++)
      while (xBook+wBook < shelf.x + 0.5*shelf.w)
      {
        wBook = random(widthBooksMax, widthBooksMax);
        hBook = random(heightBooksMin, heightBooksMax)*hBookMax;
        xBook += 0.5*wBook;
        yBook = yShelf - 0.5*hBook;
        Box b = new Box(xBook, yBook, wBook, hBook); 
        shelf.listBooks.add(b);
        xBook+=0.5*wBook+random(gapBooksMin, gapBooksMax);
      }
    }
    else
    {
      // Just one book on the floor
      wBook = random(widthBooksMax, widthBooksMax);
      hBook = random(heightBooksMin, heightBooksMax)*hBookMax;
      Box b = new Box(shelf.x-wBook/2, shelf.y - 0.5*hBook, wBook, hBook); 
      shelf.listBooks.add(b);
    }
  }
}

// --------------------------------------------------------
void createBookStore()
{
  box2d = null;
  
  box2d = new PBox2D(this);
  box2d.createWorld();
  box2d.setGravity(0, -10);

  createShelves();
  createBooks();
  createBoundaries();
}

// --------------------------------------------------------
void createBoundaries()
{
  float dBoundary = 20;

  listBoundaries = new ArrayList<Boundary>();
  listBoundaries.add( new Boundary(canvas.x+canvas.width+dBoundary/2, canvas.y+canvas.height/2, dBoundary, canvas.height) );
  listBoundaries.add( new Boundary(canvas.x-dBoundary/2, canvas.y+canvas.height/2, dBoundary, canvas.height) );
  listBoundaries.add( new Boundary(canvas.x+canvas.width/2, canvas.y+canvas.height+dBoundary/2, canvas.width, dBoundary) );
}

// --------------------------------------------------------
void keyPressed()
{
  if (key == ' ')
    pauseBox2d = !pauseBox2d;
}

// --------------------------------------------------------
void mousePressed()
{
  for (Shelf s : listShelves)
  {
    if (s.listBooks.size()>0)
    {
      for (Box b : s.listBooks) {
        //Box firstBook = s.listBooks.get(0);
        if (b.contains(mouseX, mouseY)) 
        {
          // And if so, bind the mouse location to the box with a spring
          spring.bind(mouseX, mouseY, b);
          break;
        }
      }
    }
  }
}

// --------------------------------------------------------
void mouseReleased() 
{
  spring.destroy();
}

