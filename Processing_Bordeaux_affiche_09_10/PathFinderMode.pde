interface PathFinderMode
{
  Node getNodeNeighbour(PathFinder pf, Node n);
}

class PathFinderModeRandom implements PathFinderMode
{
  int directions[][]= 
  {
    {
      0, -1
    }
    , {
      1, -1
    }
    , {
      1, 0
    }
    , {
      1, 1
    }
    , {
      0, 1
    }
    , {
      -1, 1
    }
    , {
      -1, 0
    }
    , {
      -1, -1
    }
  };

  Node getNodeNeighbour(PathFinder pf, Node n)
  {
    Node neighbour = null;
    boolean isFound = false;
    int i, j;
    int nbTries=0;

    while (!isFound && nbTries<100)
    {     
      int dirRandom = int(random(0, directions.length));
      int direction[] = this.directions[dirRandom];
      i = n.i + direction[0];
      j = n.j + direction[1];
      if (i>=0 && j>=0 && i<pf.resxNodes && j<pf.resyNodes)
      {
        neighbour = pf.arrayNodes[i][j];
        if (!neighbour.visited && neighbour.active) {
            // println("> going to ("+i+","+j+")");
          neighbour.visit();
          isFound = true;
        }
      }
      nbTries++;
    }
    if (nbTries == 100) neighbour = null;
    return neighbour;
  }
}

