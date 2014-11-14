import java.lang.reflect.*;

class Scanimation
{
  int nbFrames;
  PApplet applet;
  ArrayList<PGraphics> listFrames;
  ArrayList<PGraphics> listMaskedFrames;
  PGraphics compositionFrame;
  Method methodFrame;
  PGraphics maskFrame, maskFrameScreen, currentFrame;

  Scanimation(PApplet applet, int nbFrames)
  {
    this.applet = applet;
    this.nbFrames = nbFrames;
    createFrames();
    findMethodFrame();
  }

  Scanimation(PApplet applet)
  {
    this.applet = applet;
    this.nbFrames = 6;
    createFrames();
    findMethodFrame();
  }

  void createFrames()
  {
    listFrames = new ArrayList<PGraphics>();
    listMaskedFrames = new ArrayList<PGraphics>(); 
    for (int i=0;i<nbFrames;i++) {
      listFrames.add( createGraphics(applet.width, applet.height) );
      listMaskedFrames.add( createGraphics(applet.width, applet.height) );
    }
    
    compositionFrame = createGraphics(applet.width, applet.height);
    maskFrame = createGraphics(applet.width, applet.height);
    maskFrameScreen = createGraphics(applet.width, applet.height);

    maskFrame.beginDraw();
    maskFrame.background(255);
    drawMaskStripes(maskFrame);
    maskFrame.endDraw();

    maskFrameScreen.beginDraw();
    drawMaskStripes(maskFrameScreen);
    maskFrameScreen.endDraw();
  }
  
  void drawMaskStripes(PGraphics maskFrame)
  {
    maskFrame.rectMode(CORNER);
    maskFrame.noStroke();
    maskFrame.fill(0);

    int x = 0;
    while (x<applet.width) {
      maskFrame.rect(x+1, 0, nbFrames-1, applet.height);
      x+=nbFrames;
    }
  
  }
  
  int getNumberFrames()
  {
    return nbFrames;
  }

  PGraphics getFrame(int i)
  {
    return listFrames.get(i);
  }

  PGraphics getCompositionFrame()
  {
    return compositionFrame;
  }
  
  PGraphics getMaskFrame()
  {
    return maskFrame;
  }
  
  PGraphics getMaskFrameScreen()
  {
    return maskFrameScreen;
  }

  void findMethodFrame()
  {
    try 
    {
      this.methodFrame = applet.getClass().getMethod("drawScanimationFrame", new Class[] {
        PGraphics.class, Integer.TYPE, Integer.TYPE
      }
      );
      System.out.println("- \"findMethodFrame\" found.");
    } 
    catch (Exception e) 
    {
      System.out.println("- no \"findMethodFrame\" found.");
    }
  }

  void composeFinalFrame()
  {
    if (methodFrame != null)
    {

      // Draw Each Frame
      PGraphics frame, frameMasked;
      
      for (int i=0;i<nbFrames;i++) {
        beginFrame(i);
        try {
          frame = listFrames.get(i);
          frameMasked = listMaskedFrames.get(i);
          
          frame.pushMatrix();
          frame.background(255);
          frame.noStroke();
          frame.fill(0);  
          methodFrame.invoke( applet, new Object[] { 
            frame, i, nbFrames
          } 
          );
          frame.popMatrix();
          
          frameMasked.beginDraw();
          frameMasked.image(frame,0,0,frame.width,frame.height);
          frameMasked.endDraw();
          
          frameMasked.mask(maskFrame);
        }
        catch (Exception e) {
        }
        endFrame();
        
      }
    
      // Compose
      compositionFrame.beginDraw();
      compositionFrame.background(255);
      for (int i=0;i<nbFrames;i++) {
        frameMasked = listMaskedFrames.get(i);
        compositionFrame.blend(frameMasked,0,0,frameMasked.width,frameMasked.height, i,0,frameMasked.width,frameMasked.height,BLEND);
      }
      compositionFrame.endDraw();
    }
  }

  void beginFrame(int i)
  {
    if (i>=nbFrames) return;
    currentFrame = listFrames.get(i);
    currentFrame.beginDraw();
  }

  void endFrame()
  {
    if (currentFrame!=null)
      currentFrame.endDraw();
  }

};

