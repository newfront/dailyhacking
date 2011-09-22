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
    
    this.weighted_elements = {};
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
  
  // test for collisions before drawing
  this.find_collisions();
  
  for(var i=0; i < objects.length; ++i)
  {
    var xpos = objects[i].getXPos()*16;
    var ypos = objects[i].getYPos()*16;
    var img_ref;
    // if character, needs to override this method, add the ability to draw based off of current state based image ( walking, standing, running, jumping, crouching, dying)
    if(objects[i].hasWeight())
    {
      // if width hasn't been set
      if(objects[i].width === 0)
      {
        objects[i].setWidth(window.environment_db.elements[objects[i].type][objects[i].kind].width);
      }
      // if height hasn't been set
      if(objects[i].height === 0)
      {
        objects[i].setHeight(window.environment_db.elements[objects[i].type][objects[i].kind].height);
      }
      
      if(typeof this.weighted_elements[objects[i].getId()] === "undefined")
      {
        // try just adding the object's that have weight
        this.weighted_elements[objects[i].getId()] = objects[i];
      }
    }
    if(objects[i].getImg() === null)
    {
      img_ref = window.environment_db.elements[objects[i].type][objects[i].kind].img;
    }
    else
    {
      img_ref = objects[i].getImg();
      if(objects[i].object_type === "character")
      {
        
        //console.log(objects[i].hasWeight());
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

// 
Mario.prototype.find_collisions = function find_collisions()
{
  var character_notified = false;
  for(var collidable in this.weighted_elements)
  {
    var obja = this.weighted_elements[collidable];    
    // hit test each element with each element on the screen
    // if collision, call callback on element
    
    for(var col in this.weighted_elements)
    {
      var objb = this.weighted_elements[col];
      if(obja === objb)
      {
        //console.log("objects are the same");
      }
      else
      {
        var didHit = this.hitTest(obja,objb);
        if(didHit.result && !character_notified)
        {
          //console.log("collision detected");
          //console.log(didHit);
          if(objb.object_type === "character")
          {
            console.log("notifying character");
            objb.collision(true,didHit);
          }
          character_notified = true;
        }
        else
        {
          objb.collision(false,didHit);
        }
      }
    }
    
  }
}

Mario.prototype.hitTest = function hitTest(obja,objb)
{
  // obja : obja.x, obja.y, obja.width, obja.height
  // objb : objb.x, objb.y, objb.width, objb.height
  
  // test that obja is touching objb
  
  var hitX = false;
  var hitY = false;
  var hitAreaNoise = .085;
  
  //{"name":"mario","x":x,"y":y,"width":width,"height":height}
  var stat1 = {};
  stat1.name = obja.kind;
  stat1.x = obja.x;
  stat1.y = obja.y;
  stat1.width = obja.width;
  stat1.height = obja.height;
  
  var stat2 = {};
  stat2.name = obja.kind;
  stat2.x = obja.x;
  stat2.y = obja.y;
  stat2.width = obja.width;
  stat2.height = obja.height;
  
  //update_stats(stat1);
  //update_stats(stat2);
  
  var htests = {};
  // x (low)
  htests.lowx = "type";
  htests.obja_lrx = Math.floor(obja.x)+hitAreaNoise; //right
  htests.objb_lrx = Math.floor(objb.x)+hitAreaNoise; //right
  htests.obja_llx = Math.floor(obja.x)-hitAreaNoise; //left
  htests.objb_llx = Math.floor(objb.x)-hitAreaNoise; //left
  
  htests.highx = "type";
  htests.obja_hrx = Math.ceil(obja.x)+hitAreaNoise;
  htests.objb_hrx = Math.ceil(objb.x)+hitAreaNoise;
  htests.obja_hlx = Math.ceil(obja.x)-hitAreaNoise;
  htests.objb_hlx = Math.ceil(objb.x)-hitAreaNoise;
   
  htests.x = "type";
  htests.objax = Math.floor(obja.x);
  htests.objbx = Math.floor(objb.x);
  // y
  htests.lowy = "type";
  htests.obja_lry = Math.floor(obja.y)+hitAreaNoise;
  htests.objb_lry = Math.floor(objb.y)+hitAreaNoise;
  htests.obja_lly = Math.floor(obja.y)-hitAreaNoise;
  htests.objb_lly = Math.floor(objb.y)-hitAreaNoise;
  
  htests.highy = "type";
  htests.obja_hry = Math.ceil(obja.y)+hitAreaNoise;
  htests.objb_hry = Math.ceil(objb.y)+hitAreaNoise;
  htests.obja_hly = Math.ceil(obja.y)-hitAreaNoise;
  htests.objb_hly = Math.ceil(objb.y)-hitAreaNoise;
  
  htests.y = "type"
  htests.objay = Math.floor(obja.y);
  htests.objby = Math.floor(objb.y);
  
  //update_stats(htests);
  var hit_result = {};
  if(htests.obja_lrx == htests.objb_lrx)
  {
    hitX = true;
    hit_result.x = "(floor) right (add)";
  } else if(htests.obja_llx == htests.objb_llx)
  {
    hitX = true; 
    hit_result.x = "(floor) left (minus)";
  } else if(htests.obja_hrx == htests.objb_hrx)
  {
    hitX = true;
    hit_result.x = "(ceil) right (add)";
  } else if(htests.obja_hlx == htests.objb_hlx)
  {
    hitX = true;
    hit_result.x = "(ceil) left (minus)";
  } else if(htests.objax === htests.objbx)
  {
    hitX = true;
    hit_result.x = "(floor) match";
  }
  else
  {
    hitX = false;
  }
  
  if(htests.obja_lry == htests.objb_lry)
  {
    hitY = true;
    hit_result.y = "(floor) right (add)";
  } 
  else if(htests.obja_lly == htests.objb_lly)
  {
    hitY = true;
    hit_result.y = "(floor) left (minus)";
  }
  else if(htests.obja_hly == htests.objb_hry)
  {
    hitY = true;
    hit_result.y = "(ceil) left (add)";
  } 
  else if(htests.obja_hly == htests.objb_hly)
  {
    hitY = true;
    hit_result.y = "(ceil) left (minus)";
  } 
  else if(htests.objay === htests.objby)
  {
    //console.log("hity equals");
    hitY = true;
    hit_result.y = "(floor) match";
  }
  else
  {
    hitY = false;
  }
  
  /*
  (0,0)                    (x+width,0)
  +----------------------------------+
  |                                  |
  |                                  |
  |                                  |
  |                                  |
  |                                  |
  |            Hit Area              |
  |                                  |
  |                                  |
  |                                  |
  |                                  |
  +----------------------------------+
  (0,y+height)             (x+width,y+height)
  */
  
  
  if(hitX && hitY)
  {
    update_stats(htests);
    console.log("x");
    console.log("obja.x: "+obja.x);
    console.log("objb (x+w) "+(objb.x + objb.width));
    console.log("objb.x: "+objb.x);
    console.log("obja (x+w) "+(obja.x + obja.width));
    console.log("y");
    console.log("obja.y: "+obja.y);
    console.log("objb (y+h) "+(objb.y + objb.height));
    console.log("objb.y: "+objb.y);
    console.log("obja (y+h) "+(obja.y + obja.height));
    return {"result":true,"atype":obja.object_type,"ax":obja.x,"ay":obja.y,"btype":objb.object_type,"bx":objb.x,"by":objb.y,"info":hit_result};
  }
  else
  {
    return {"result":false};
  }
  
  
  /*
  if (obja.x < objb.x + objb.width && obja.x + obja.width > objb.x && obja.y < objb.y + objb.height && obja.y + obja.height > objb.y)
  {
    console.log("obja.x "+obja.x +"< objb.x + objb.width "+objb.x + objb.width);
    console.log("obja.x + obja.width "+(obja.x + obja.width)+ " > "+objb.x);
    console.log("obja.y "+obja.y+ " < objb.y + objb.height "+(objb.y + objb.height));
    console.log("obja.y + obja.height " + obja.y + obja.height + " > "+ objb.y);
    return true;
  }
  return false;
  */
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
  console.log("New Event: "+event.type);
  //console.log(this);
  //console.log(event.target);
  switch(event.type)
  {
    case "move":
      //console.log("mario is moving. let's keep updating the canvas");
      event.target.draw();
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