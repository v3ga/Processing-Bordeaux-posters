class Shelf extends Boundary
{
  ArrayList<Box> listBooks;


  Shelf(float x_,float y_, float w_, float h_)
  {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    listBooks = new ArrayList<Box>();
    define();
  }

  void display() 
  {
    if (w>0){
      fill(0);
      stroke(0);
      rectMode(CENTER);
      rect(x,y,w,h);
    }
    for (Box book : listBooks)
      book.display();
  }

}
