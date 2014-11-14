class Canvas
{
  float x,y,width,height;
  Canvas(PApplet p, float s)
  {
    width = s*float(p.width);
    height = s*float(p.height);
    x = (p.width-width)/2;
    y = (p.height-height)/2;
  }
  

  void draw()
  {
    pushStyle();
    noFill();
    stroke(200);
    rect(x,y,width,height);
    popStyle();
  }
  
}
