/**
 * Setup a new instance of the Mario Game
*/
var Mario = (function Mario(level,lives,continues){
  // mario's points
  var points = 0;
  // mario's status
  var status = "alive";
  
  return function(level,lives,continues)
  {
    // what is the current level?
    this.level = level;
    // mario's current lives
    this.lives = lives;
    // mario's continues
    this.continues = continues;
    this.points = points;
    this.status = status;
    // TODO: bind to Level Object, keep state within Level
    // keeps track of objects within the game
    this.elements = [];
  };
  
}());

// add a new game object
Mario.prototype.addElement = function(elem)
{
  this.elements.push(elem);
  this.draw();
}
// return a list of active objects
Mario.prototype.getElements = function getElements()
{
  //console.log(this.elements);
  return this.elements;
}

/**
 * Get the Canvas Object
 * @return (Object) canvas The main canvas object
*/
Mario.prototype.getCanvas = function()
{
  return this.canvas;
}
/**
 * Set the Canvas Object
*/
Mario.prototype.setCanvas = function(canvas)
{
  this.canvas = canvas;
}

Mario.prototype.getLevel = function getLevel()
{
  return this.level;
}

/**
 * Set the Current Level in Mario
 * @param (Integer) level can be 1 to 8
*/
Mario.prototype.setLevel = function setLevel(level)
{
  this.level = level;
}
/**
 * Set the Current Available Lives
 * @param (Integer)
*/
Mario.prototype.setLives = function setLives(lives)
{
  this.lives = lives;
}

/**
 * Increment Lives
*/
Mario.prototype.incrementLives = function incrementLives()
{
  this.lives++;
}

/**
 * Decrement Lives, or if lives-- <= 0 = gameover
*/
Mario.prototype.decrementLives = function decrementLives()
{
  if(this.lives-1 > 0)
  {
    this.lives--;
  }
  else
  {
    this.status = "dead";
    endGame();
  }
}
/**
 * End Game - Update Canvas to show End Game Screen with continues, or game over
*/
Mario.prototype.endGame = function endGame()
{
  console.log("game over");
}

Mario.prototype.draw = function draw()
{
  //console.log(this.getCanvas());
  var objects = this.getElements();
  for(var i=0; i < objects.length; ++i)
  {
    // draw the objects on the screen
    if(objects[i].hasOwnProperty("type"))
    {
      //console.log("object has property 'type'");
    }
    if(objects[i].hasOwnProperty("kind"))
    {
      //console.log("object has property kind");
    }
    objects[i].draw(this.canvas);
    //console.log(objects[i]);
  }
  delete objects;
}

Mario.prototype.game_event = function game_event(event)
{
  console.log("New Event: "+event.type);
  console.log(this);
  console.log(event.target);
  switch(event.type)
  {
    case "move":
      console.log("mario is moving. let's keep updating the canvas");
      event.target.draw();
    break;
  }
}