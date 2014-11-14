class Node
{
  int i=0,j=0;
  PVector pos;
  boolean active = false;
  boolean visited = false;
  float visitedTime = 0.0;
  
  Node(int i, int j, float x, float y)
  {
    this.i = i;
    this.j = j;
    this.pos = new PVector(x, y, 0);
  }
  
  void visit()
  {
    visitedTime = millis();
    visited = true;
  }
  
  void draw()
  {
    if (active){ 
      fill(0);
      rect(pos.x,pos.y,3,3);
    }

    if (visited){
      noFill();
      stroke(0);
      ellipse(pos.x,pos.y,6,6);
    }
  }
  
}
