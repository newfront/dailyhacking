/**
 * Setup a new instance of the Mario Game
*/
var Mario = (function(){
  // what is the current level?
  var level = 1; // 1,2,3,4,5,6,7,8
  // mario's current lives
  var lives = 3;
  // mario's continues
  var continues = 3;
  // mario's points
  var points = 0;
  // mario's status
  var status = "alive";
  // keeps track of objects within the game
  var elements = new Array();
  // add a new game object
  addElement = function(elem)
  {
    elements.push(elem);
    draw();
  }
  // return a list of active objects
  getElements = function()
  {
    console.log(elements);
    return elements;
  }
  
  // protected methods
  /**
   * Get the Canvas Object
   * @return (Object) canvas The main canvas object
  */
  getCanvas = function()
  {
    return this.canvas;
  }
  
  setCanvas = function(canvas)
  {
    this.canvas = canvas;
  }
  /**
   * Set the Current Level in Mario
   * @param (Integer) level can be 1 to 8
  */
  setLevel = function(level)
  {
    level = level;
  }
  /**
   * Set the Current Available Lives
   * @param (Integer)
  */
  setLives = function(lives)
  {
    lives = lives;
  }
  
  /**
   * Increment Lives
  */
  incrementLives = function()
  {
    lives++;
  }
  
  /**
   * Decrement Lives, or if lives-- <= 0 = gameover
  */
  decrementLives = function()
  {
    if(lives-1 > 0)
    {
      lives--;
    }
    else
    {
      status = "dead";
      endGame();
    }
  }
  /**
   * End Game - Update Canvas to show End Game Screen with continues, or game over
  */
  endGame = function()
  {
    console.log("game over");
  }
  
  draw = function()
  {
    console.log(canvas);
    var objects = getElements();
    for(var i=0; i < objects.length; ++i)
    {
      // draw the objects on the screen
      objects[i].draw(canvas,5,5);
    }
  }
  
  return function()
  {
    this.setCanvas = function(canvas)
    {
      setCanvas(canvas);
    }
    this.getCanvas = function()
    {
      return getCanvas();
    }
    
    this.incrementLives = function()
    {
      incrementLives();
    }
    
    this.decrementLives = function()
    {
      decrementLives();
    }
    
    this.getElements = function()
    {
      this.elements = getElements();
      return this.elements;
    }
    
    this.addElement = function(elem)
    {
      addElement(elem);
    }
    
    this.draw = function()
    {
      console.log("calling private method draw()");
      draw();
    }
  };
}());