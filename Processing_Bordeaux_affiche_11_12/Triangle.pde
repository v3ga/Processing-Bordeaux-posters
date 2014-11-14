
class TriangleConfig
{
  float perimeter = 200; // DEPRECATED
  int levelMax = 6;
  float rndMin = 0.45;
  float rndMax = 0.55;
  float rndSubdivide = 0.85;
  int resMotif = 10;
  boolean isDrawContour = false;
  boolean isDrawLignes = true;
  boolean isDrawBezier = false;
  float t = 1.0f;
  int strokeWmin = 1;
  int strokeWmax = 1;
}


class Triangle
{
  PVector A, B, C, G;
  PVector M_AB, M_BC, M_CA;
  PVector GA, GB, GC;
  PVector P,PAni;
  Triangle parent;
  Triangle[] children;
  boolean isMotif = false;
  boolean isAnimating = false;
  int level=0;
  Ani aniSubdivide;
  float tSubdivide = 0.0f;
  float rnd = 0.5f;

  // ------------------------------------------------
  Triangle(Triangle parent_, float Ax_, float Ay_, float Bx_, float By_, float Cx_, float Cy_)
  {
    this.parent = parent_;
    this.A = new PVector(Ax_, Ay_);
    this.B = new PVector(Bx_, By_);
    this.C = new PVector(Cx_, Cy_);
    computeMiddle();
  }

  // ------------------------------------------------
  Triangle(Triangle parent_, PVector A_, PVector B_, PVector C_)
  {
    this.parent = parent_;
    this.A = new PVector(); 
    this.A.set(A_);
    this.B = new PVector(); 
    this.B.set(B_);
    this.C = new PVector(); 
    this.C.set(C_);
    if (parent == null) {
      configDefault = new TriangleConfig();
      config = configDefault;
    }
    computeMiddle();
  }

  // ------------------------------------------------
  void reset()
  {
    tSubdivide=0;
    children = null;
    isAnimating = false;
  }

  // ------------------------------------------------
  void computeMiddle()
  {
    M_AB = new PVector((A.x+B.x)/2, (A.y+B.y)/2);
    M_BC = new PVector((C.x+B.x)/2, (C.y+B.y)/2);
    M_CA = new PVector((A.x+C.x)/2, (A.y+C.y)/2);

    G = new PVector((A.x+B.x+C.x)/3, (A.y+B.y+C.y)/3);
    GA = PVector.sub(A, G);
    GB = PVector.sub(B, G);
    GC = PVector.sub(C, G);
  }

  // ------------------------------------------------
  int getStrokeWeight(int level)
  {
    return max(1, (int)map(level+1, levelMin, levelMax, config.strokeWmax, config.strokeWmin));
  }

  // ------------------------------------------------
  float getGreyColor(int level)
  {
    return max(0, (int)map(level+1, levelMin, levelMax, 0, 200));
  }

  // ------------------------------------------------
  void draw()
  {
    if (level == 0)
    {
      if (config.isDrawContour) {
        strokeWeight(getStrokeWeight(level));
        triangle(A.x, A.y, B.x, B.y, C.x, C.y);
      }
    }    
    
    if (children !=null)
    {
      strokeWeight(getStrokeWeight(level));
      if (isAnimating)
      {
        PAni = PVector.lerp(A,P,tSubdivide);
        line(A.x,A.y,PAni.x,PAni.y);
      }
      else
      {
        line(A.x,A.y,P.x,P.y);
        children[0].draw();
        children[1].draw();
      }
    }
  }
  
  // ------------------------------------------------
  void beginAnimSubdivide()
  {
    //println("beginAnimSubdivide");
    aniSubdivide = new Ani(this, random(0.5,1.5), "tSubdivide", 1, Ani.LINEAR, "onEnd:endAnimSubdivide");  
    aniSubdivide.start();
    isAnimating = true;
  }
  
  // ------------------------------------------------
  void endAnimSubdivide(Ani theAni)
  {
    //println("endAnimSubdivide");
    isAnimating = false;
    if (children !=null)
    {
      children[0].subdivide(level+1,-1);
      children[1].subdivide(level+1,-1);
    }
  }

  // ------------------------------------------------
  void subdivide(int l, float rndForced)
  {
    this.level = l; 
    if (level>=config.levelMax) 
      return;

    if (random(1) <= config.rndSubdivide || level==0)
    {

      float rndMin = config.rndMin;
      float rndMax = config.rndMax;
      rnd = random(rndMin, rndMax);
      if (rndForced>0)
        rnd = rndForced;
      P = PVector.lerp(B, C, rnd);


      children = new Triangle[2];
      children[0] = new Triangle(this, P, A, B);
      children[1] = new Triangle(this, P, A, C);

      this.beginAnimSubdivide();
    }
  }
}

