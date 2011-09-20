/**
 * Character inherits from Element
 * a character has space in the Environment (World)
 * a character can be impacted by a collision, eg. when it's position collides with the position of another Entity
*/

/*
  CharacterAssets
  (action based) Image, Width, Height lookup table for Characters
*/
var CharacterAssets = {
  "mario":
  {
    small:
    {
      standing:
      {
        "img":"assets/hero/MarioStanding.png",
        "width":12,
        "height":16
      },
      walking:
      {
        "img":"assets/hero/Mario.gif",
        "width":15,
        "height":16
      },
      jumping:
      {
        "img":"assets/hero/MarioJumping.png",
        "width":16,
        "height":16
      },
      crouching:
      {
        "img":"",
        "width":16,
        "height":16
      },
      skidding:
      {
        "img":"assets/hero/MarioSkidding.png",
        "width":13,
        "height":16
      },
      running:
      {
        "img":"",
        "width":16,
        "height":16
      },
      dying:
      {
        "img":"",
        "width":16,
        "height":16
      }
    },
    "super":
    {
      
    }
  }
};

/*
  Character Actions Constant
*/
var CharacterState = 
{
  0:"standing",
  1:"walking",
  2:"jumping",
  3:"crouching",
  4:"skidding",
  5:"running",
  6:"dying"
};

var Character = (function(type,kind,posx,posy,speed)
{
  return function(type,kind,name,posx,posy,speed)
  {
    //this.oparent = new Element();
    //this.oparent.setType(type);
    //this.oparent.setKind(kind);
    //this.oparent.setPosition(posx,posy);
    //this.oparent.setXPos(posx);
    //this.oparent.setYPos(posy);
    var el = new Element();
    this.id = el.getId();
    delete el;
    this.setType(type);
    this.setKind(kind);
    this.setXPos(posx);
    this.setYPos(posy);
    
    this.name = kind;
    this.speed = speed;
    this.state = 0;
    this.size = "small"; // super
    this.x = posx;
    this.y = posy;
  };
}());

Character.prototype = Element.prototype;

Character.prototype.init = function init()
{
  var character = this;
  console.log("speed: "+character.speed);
  if(this.type == "hero")
  {
    // bind movements to keyboard keys
    // a = jump
    // s = crouch
    // key_left = move left
    // key_right = move right
    if(this.name.match(/mario/i))
    {
      // we can decorate Mario
      var drawable = CharacterAssets[this.name][this.size][this.getState(true)];
      console.log(drawable);
      console.log(drawable.img);
      this.setImg(drawable.img);
      this.setWidth(drawable.width);
      this.setHeight(drawable.height);
      console.log("mario now has drawable image, width and height");
      console.log(this.getImg());
    }
    // else could be enemy, etc
    
    if(typeof window != "undefined")
    {
      window.onkeydown = function(event)
      {
        if(event.keyCode == 37)
        {
          // left key
          character.move_left();
        }
        if(event.keyCode == 39)
        {
          // right key
          character.move_right();
        }
        if(event.keyCode == 65)
        {
          character.jump();
        }
        if(event.keyCode == 83)
        {
          character.squat();
        }
      }
    }
    else
    {
      console.log("you have no window object to work with...");
    }
  }
}

/*Character.prototype.getPId = function getPId()
{
  var object = this.oparent;
  console.log(object);
  //apply(this.oparent,getPId);
}
*/
Character.prototype.getImg = function getImg()
{
  return this.img;
}

Character.prototype.setState = function setState(state_id)
{
  this.state = state_id;
}

Character.prototype.getState = function getState(human_friendly)
{
  if(typeof human_friendly != "undefined" && human_friendly)
  {
    return CharacterState[this.state];
  }
  else
  {
    return this.state; 
  }
}

Character.prototype.jump = function jump()
{
  console.log("jump");
}

Character.prototype.squat = function()
{
  console.log("squat");
}

Character.prototype.move_right = function()
{
  console.log("move right: "+this.x);
  this.x += 1;
  
  if(typeof this.listener === "object")
  {
    console.log("new event occured.");
    //console.log(typeof this.listener.callback);
    this.listener.callback.call(null,{"type":"move","target":this.listener.scope});
  }
}

Character.prototype.move_left = function()
{
  console.log("move left");
  console.log("move left at a speed of "+this.getSpeed());
}

Character.prototype.getSpeed = function()
{
  return this.speed;
}

Character.prototype.setSpeed = function(speed)
{
  this.speed = speed;
}

Character.prototype.register_listener = function(scope,callback)
{
  console.log(scope);
  this.listener = {};
  this.listener.scope = scope;
  this.listener.callback = callback;
}

Character.prototype.remove = function()
{
  // remove the character from the display list, remove from memory
  // if the type is hero, remove triggers game_over for game singleton
}