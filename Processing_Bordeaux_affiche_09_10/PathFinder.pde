class PathFinder
{
  Node[][] arrayNodes;
  int resxNodes=0, resyNodes=0;

  ArrayList<Node> listNodesVisited;
  Node currentNode;

  ArrayList<PathFinderMode> listPFModes;
  PathFinderMode currentPFMode;
  

  float periodStep = 0.1f;
  Timer timer;
  float time=0;
  boolean stopped = false;
  String strStopped = "stopped";


  int MODE_RANDOM = 0;


  PathFinder(int res)
  {
    setResolution(res);
    setStartNode(0,0);
  }
  
  void setResolution(int res)
  {
    timer = new Timer();
    
    listNodesVisited = new ArrayList<Node>();
    createNodes(res, res);

    listPFModes = new ArrayList<PathFinderMode>();
    listPFModes.add( new PathFinderModeRandom() );
    currentPFMode = listPFModes.get(0);

    stopped = true;
  }
  
  void setStartNode(int i, int j)
  {
    currentNode = arrayNodes[i][j];
    currentNode.visited = true;
    listNodesVisited.add(currentNode);
  }
  
  void reset()
  {
    setResolution(resxNodes);
  }
  
  void start()
  {
    stopped = false;
  }

  Node getNode(int i, int j)
  {
    if (i>=0 && i<resxNodes && j>=0 && j<resyNodes)
      return arrayNodes[i][j];
    return null;
  }
  
  Node getNodeNeighbour(Node n)
  {
    if (currentPFMode !=null)
      return currentPFMode.getNodeNeighbour(this,n);
    return null;
  }

  void step()
  {
    Node n = getNodeNeighbour(currentNode);
    if (n!=null)
    {
      // n.visited = true;
      listNodesVisited.add(n);

      currentNode = n;
      //println("> nb nodes visited = "+listNodesVisited.size());
    }
    else {
      println("> stop");
      stopped = true;
    }
  }

  void update()
  {
    if (!stopped)
    {
      time += timer.dt();
      if (time>=periodStep) {
        time = 0.0f;
        step();
      }
    }
  }

  void createNodes(int resx, int resy)
  {
    resxNodes = resx;
    resyNodes = resy;
    arrayNodes = new Node[resx][resy];
    int iActive = 0;
    for (int j=0;j<resy;j++)
    {
      for (int i=0;i<resx;i++)
      {
        arrayNodes[i][j] = new Node(i, j, i*float(width)/float(resx-1), j*float(height)/float(resy-1) );
        arrayNodes[i][j].active = (i<=iActive) ? true : false;
      }
      iActive++;
    }
  }

  void draw()
  {
    int nbNodes = listNodesVisited.size();
    if (nbNodes>=2)
    {
      Node A,B;
      for (int i=0;i<nbNodes-1;i++)
      {
        A = listNodesVisited.get(i);
        B = listNodesVisited.get(i+1);
        line(A.pos.x,A.pos.y,B.pos.x,B.pos.y);
      }
    }
  }

  void drawNodes()
  {
    noStroke();
    rectMode(CENTER);
    Node n;
    for (int j=0;j<resyNodes;j++)
    {
      for (int i=0;i<resxNodes;i++)
      {
        n = arrayNodes[i][j];
        n.draw();
      }
    }
  }

  void drawGrid()
  {
    noFill();
    Node n0, n1, n2, n3;
    for (int j=0;j<resyNodes-1;j++)
    {
      for (int i=0;i<resxNodes-1;i++)
      {
        n0 = arrayNodes[i][j];
        n1 = arrayNodes[i+1][j];
        n2 = arrayNodes[i+1][j+1];
        n3 = arrayNodes[i][j+1];

        if (n0.active && n1.active) line(n0.pos.x, n0.pos.y, n1.pos.x, n1.pos.y);
        if (n0.active && n2.active) line(n0.pos.x, n0.pos.y, n2.pos.x, n2.pos.y);
        if (n0.active && n3.active) line(n0.pos.x, n0.pos.y, n3.pos.x, n3.pos.y);
        if (n1.active && n3.active) line(n1.pos.x, n1.pos.y, n3.pos.x, n3.pos.y);
      }
    }
  }
}

