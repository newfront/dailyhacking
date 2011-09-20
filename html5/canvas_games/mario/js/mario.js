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
    this.running = false;
    // TODO: bind to Level Object, keep state within Level
    // keeps track of objects within the game
    this.elements = [];
    
    this.positions_cache = {};
  };
  
}());

// add a new game object
Mario.prototype.addElement = function(elem)
{
  this.elements.push(elem);
  // only draw when we call it, save ram
  
  
  if(elem.hasOwnProperty("name"))
  {
    console.log(elem.getId());
    console.log(elem.name);
    console.log(elem.type);
  }
  
  //this.draw();
  
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

Mario.prototype.getCanvasContext = function()
{
  return this.context;
}
/**
 * Set the Canvas Object
*/
Mario.prototype.setCanvas = function(canvas)
{
  this.canvas = canvas;
  this.context = this.canvas.getContext("2d");
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
  //console.log("level set");
  //console.log(this.getLevel());
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

// TODO: think about refreshing only the regions on the canvas that have chnaged...
Mario.prototype.clearCanvas = function()
{
  // clear background
  this.context.clearRect(0,0,this.canvas.width,this.canvas.height);
}

// update the rendered view
/* (Note * ) drawing to the buffered canvas, then applying the contents to the visible
 canvas makes or breaks your game. Great tip found at http://www.slideshare.net/ernesto.jimenez/5-tips-for-your-html5-games
*/

Mario.prototype.draw = function draw()
{
  this.clearCanvas();
  var objects = this.getElements();
  
  // create the buffered canvas
  var buffer = document.createElement('canvas');
  var images = this.getLevel().get_image_assets();
  // canvas = global canvas
  buffer.width = this.canvas.width;
  buffer.height = this.canvas.height;
  
  var buffer_context = buffer.getContext("2d");
  // context = this.context;
  
  for(var i=0; i < objects.length; ++i)
  {
    var xpos = objects[i].getXPos()*16;
    var ypos = objects[i].getYPos()*16;
    var img_ref;
    // if character, needs to override this method, add the ability to draw based off of current state based image ( walking, standing, running, jumping, crouching, dying)
    if(objects[i].getImg() === null)
    {
      img_ref = window.environment_db.elements[objects[i].type][objects[i].kind].img;
    }
    else
    {
      img_ref = objects[i].getImg();
      if(objects[i].object_type === "character")
      {
        objects[i].render();
      }
    }
    //console.log(images);
    buffer_context.drawImage(images[img_ref],xpos,ypos);
    delete xpos;
    delete ypos;
    delete img_ref;
  }
  // draw buffered canvas to main visible canvas
  this.context.drawImage(buffer,0,0);
  
  // delete one time use variables
  delete objects;
  delete buffer;
  delete buffer_context;
  delete images;
}

// hit test / collisions
// need to add method to test that Mario has collided with an element on the stage
// can use a hash dictionary from the draw method, can keep updating {"x":value,"ref":[obj.id,obj.id...]},{"y":value,"ref":[obj.id,obj.id...]}
// since a hash is an instant lookup, it would save on the computation time to test for collisions

Mario.prototype.store_positions = function(x,y,object)
{
  //this.positions_cache
  if(typeof this.positions_cache.x === "undefined")
  {
    this.positions_cache.x = {};
  }
  if(typeof this.positions_cache.y === "undefined")
  {
    this.positions_cache.y = {};
  }
}

// start Mario rendering engine
Mario.prototype.start = function()
{
  this.auto_draw();
}

Mario.prototype.stop = function()
{
  if(this.running)
  {
    clearTimeout(this.timer);
    this.timer = null;
    console.log("stopped");
  }
}

Mario.prototype.game_event = function game_event(event)
{
  //console.log("New Event: "+event.type);
  //console.log(this);
  //console.log(event.target);
  switch(event.type)
  {
    case "move":
      console.log("mario is moving. let's keep updating the canvas");
      //event.target.draw();
    break;
  }
}

// works but looks terrible, everything flashs. need to figure out how to get the canvas to update better
Mario.prototype.auto_draw = function()
{
  var scope = this;
  if(!this.running)
  {
    this.running = false;
    this.timer = setTimeout(function(){scope.do_draw();},100); // 15 fps = 15/1000 = 0.015 
  }
}

Mario.prototype.do_draw = function()
{
  this.running = false;
  this.draw();
  this.auto_draw();
}