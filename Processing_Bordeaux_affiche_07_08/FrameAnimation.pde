// ---------------------------------------------------------
class FrameAnimation
{
  String name;
  FrameAnimation(String name)
  {
    this.name = name;
  }
  void setup(){}
  void draw(PGraphics pg, int frame, int nbFrames){}
}

// ---------------------------------------------------------
class FrameAnimationUI implements ControlListener
{
  ControlGroup cp5Group;
  FrameAnimation animation;
  
  FrameAnimationUI(String name, String toolName)
  {
    cp5Group = cp5.addGroup(name).setPosition(0,46);
    cp5Group.moveTo(toolName);
    cp5Group.hideBar();
  }
  
  void show()
  {
    cp5Group.show();
  }
  
  void hide()
  {
    cp5Group.hide();
  }
  
  void setAnimation(FrameAnimation animation){this.animation = animation;}
  FrameAnimation getAnimation(){return animation;}
  public void controlEvent(ControlEvent theEvent){}
}


// ---------------------------------------------------------
class FrameAnimationManager extends ArrayList<FrameAnimation>
{
  FrameAnimation current;
  FrameAnimationUI currentUI;
  ArrayList<FrameAnimationUI> listFrameAnimationUI;
  
  FrameAnimationManager()
  {
    listFrameAnimationUI = new ArrayList<FrameAnimationUI>();
  }
  
  void addAnimationUI(FrameAnimationUI fUI)
  {
    listFrameAnimationUI.add(fUI);
  }
  
  void addAnimation(FrameAnimation f)
  {
    add(f);
    current = f;  
  }

  void addAnimationUI(int indexAnimation, FrameAnimationUI fUI)
  {
    addAnimationUI(fUI);
    fUI.setAnimation(get(indexAnimation));
    fUI.hide();
  }

/*
  void addAnimationWithUI(FrameAnimation f, FrameAnimationUI fUI)
  {
    add(f);
    addAnimationUI(fUI);
    fUI.setAnimation(f);
    
    current = f;  
    currentUI = fUI;
  }
*/

  void showAnimationUI()
  {
    if (currentUI != null)
      currentUI.show();
  }

  void hideAnimationUI()
  {
    if (currentUI != null)
      currentUI.hide();
  }
  

  
  FrameAnimation setCurrent(int i)
  {
    if (i<size()){
      current = get(i);    
    }
    current.setup();

    if (currentUI!=null)
      currentUI.hide();
      
    FrameAnimationUI fUI = getUIForAnimation(current);
    if (fUI != null)
      fUI.show();
    currentUI = fUI;

    return current;
  }
  
  FrameAnimationUI getUIForAnimation(FrameAnimation f)
  {
   for (FrameAnimationUI fUI : listFrameAnimationUI)
   {
     if (f == fUI.getAnimation())
       return fUI;
   }
   return null;
  }
  
  FrameAnimation getCurrent(){return current;}
}

// ---------------------------------------------------------
class FrameTrianglePB07_01 extends FrameAnimation
{
  float scaleFactor = 0.9;
  float rotation = 0.9;
  
  FrameTrianglePB07_01(String name){
    super(name);
  }

  void draw(PGraphics pg, int frame, int nbFrames)
  {
      pg.translate(pg.width,pg.height);
      pg.rotate( map(frame, 0, nbFrames-1, 0,radians(rotation)) );
      pg.scale( map(frame, 0, nbFrames-1, 1,scaleFactor) );
      pg.noStroke();
      pg.triangle(0,-pg.height, 0, 0, -pg.width, 0);
  }

}

class FrameTrianglePB07_01_UI extends FrameAnimationUI
{
  FrameTrianglePB07_01_UI()
  {
    super("PB07_01_UI", "default");

    cp5Group.setBackgroundHeight(50);
    cp5Group.setPosition(0, height-50);
    cp5.addSlider("scale").setGroup(cp5Group).setPosition(0,0).setHeight(20).addListener(this).setRange(0.2, 1);
    cp5.addSlider("rotation").setGroup(cp5Group).setPosition(0,24).setHeight(20).addListener(this).setRange(0, 90);
  }


  public void controlEvent(ControlEvent theEvent)
  {
    FrameTrianglePB07_01 anim = (FrameTrianglePB07_01)this.animation;
    if (anim == null) return;
    
    String name = theEvent.getName();
    if (theEvent.isGroup()){
    }
    else{
      
      if (name.equals("scale")) anim.scaleFactor = theEvent.getController().getValue();    
      if (name.equals("rotation")) anim.rotation = theEvent.getController().getValue();    
      
      scanimation.composeFinalFrame();
    }
  }
}


// ---------------------------------------------------------
class FrameTrianglePB07_02 extends FrameAnimation
{
  PVector A,B,C;
  int levelMax = 6;
  FrameTrianglePB07_02(String name){
    super(name);
    A = new PVector();
    B = new PVector();
    C = new PVector();
  }

  void draw(PGraphics pg, int frame, int nbFrames)
  {
      pg.translate(pg.width,pg.height);
//      pg.rotate( map(frame, 0, nbFrames-1, 0,radians(80)) );
      pg.scale( map(frame, 0, nbFrames-1, 1,0.9) );
      pg.noStroke();

      A.set(0,-pg.height,0);
      B.set(0, 0, 0);
      C.set(-pg.width, 0, 0);

      drawTriangle(pg,A,B,C,0, map(frame,0,nbFrames-1,0.5,0.7) );
  }
  
  void drawTriangle(PGraphics pg, PVector A, PVector B, PVector C, int level, float amount)
  {
    if (level == levelMax) return;
    
    PVector A_ = new PVector(lerp(A.x,B.x,amount), lerp(A.y,B.y,amount),0);
    PVector B_ = new PVector(lerp(B.x,C.x,amount), lerp(B.y,C.y,amount),0);
    PVector C_ = new PVector(lerp(C.x,A.x,amount), lerp(C.y,A.y,amount),0);
  
    pg.fill(level%2==1 ? 255 : 0);
    pg.triangle(A.x,A.y, B.x, B.y, C.x, C.y);
    
    drawTriangle(pg,A_,B_,C_,++level,amount);
    
  }

}

// ---------------------------------------------------------
class FrameTrianglePB07_03 extends FrameAnimation
{
  FrameTrianglePB07_03(String name){
    super(name);
  }

  void draw(PGraphics pg, int frame, int nbFrames)
  {
/*
      pg.translate(pg.width,pg.height);
      pg.rotate( map(frame, 0, nbFrames-1, 0,radians(80)) );
      pg.scale( map(frame, 0, nbFrames-1, 1,0.9) );
      pg.noStroke();
      pg.triangle(0,-pg.height, 0, 0, -pg.width, 0);
*/
     pg.stroke(0);
     pg.strokeWeight(2);
     pg.translate(0,pg.height);
     pg.rotate(-atan(float(pg.height)/float(pg.width)));
     //pg.line(0,0,dist(0,pg.height,pg.width,0),0);
     float nbPeriodes = 2;
     int nbSamples = 200;
     float amplitude = 45;
     
     float angleStep = 360.0*nbPeriodes/float(nbSamples-1);
     float angle=0.0f;
     float x=0.0f;
     float y = 0.0f;
     float d = dist(0,pg.height,pg.width,0);
     float w = d/float(nbSamples-1);
     float h = 0.5*d/10;
     pg.rectMode(CORNER);
     for (int i=0;i<nbSamples;i++)
     {
//       float m = sin(radians(angle/nbPeriodes));
       float m = 1.3*noise(0.04*radians(angle/nbPeriodes));
       float y1 = -amplitude*m*sin(radians(angle)-map(frame,0,nbFrames-1,0,2*PI));
       float y2 = -amplitude*m*sin(radians(angle+angleStep)-map(frame,0,nbFrames-1,0,2*PI));
//       float y2 = -sin(radians(angle+angleStep));

       //pg.rect(x,y1,w,y1+d);   
       for (int j=0;j<50;j++)
       {
         //pg.rect(x,j*10+y1,2,2);
         //pg.rect(x,y1,2,2);
         pg.line(x,j*10+y1,x+w,j*10+y2);
       }
       angle+=angleStep;
       x+=w;
       y+=h;
       
     }
  }

}


// ---------------------------------------------------------
class FrameRectangle extends FrameAnimation
{
  FrameRectangle(String name){
    super(name);
  }

  void draw(PGraphics pg, int frame, int nbFrames)
  {
    pg.rectMode(CENTER);

    pg.translate(pg.width/2,pg.height/2);
    pg.rotate( map( float(frame)/float(nbFrames),0,1,0,PI/2) );
    pg.rect(0,0,height-200,height-200);
  }
}

// ---------------------------------------------------------
class FrameRectangle2 extends FrameAnimation
{
  int nbRect = 5;
  float angleStep = PI/10;
  float scaleFactor = 1.0;
  
  FrameRectangle2(String name){
    super(name);
  }

  void setup()
  {
    scaleFactor = 1.0;
  }

  void draw(PGraphics pg, int frame, int nbFrames)
  {
    pg.rectMode(CENTER);

    pg.translate(pg.width/2,pg.height/2);
    pg.rotate( map( float(frame)/float(nbFrames),0,1,0,PI/2) );
    for (int i=0;i<nbRect;i++)
    {
      pg.pushMatrix();
      pg.scale(scaleFactor);
      pg.rect(0,0,height-200,height-200);
      pg.popMatrix();
      rotate(angleStep);
      scaleFactor *= 0.93;
    }
  }
}
