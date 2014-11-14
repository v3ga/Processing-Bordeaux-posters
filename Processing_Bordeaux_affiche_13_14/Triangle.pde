class Triangle
{
  PVector A,B,C;
  
  Triangle(Canvas c)
  {  
    this.A = new PVector(canvas.x, canvas.y);
    this.B = new PVector(canvas.x+canvas.width, canvas.y);
    this.C = new PVector(canvas.x+canvas.width, canvas.y+canvas.height);
  }
  
  void draw()
  {
    pushStyle();
    noFill();
    stroke(200,0,0);
    triangle(A.x,A.y,B.x,B.y,C.x,C.y);
    popStyle();
  }
  
  PVector getPointForY(float y)
  {
    float t = map(y,canvas.y,canvas.y+canvas.height,0,1);
    return new PVector(lerp(canvas.x,canvas.x+canvas.width,t), y);
  }

}
