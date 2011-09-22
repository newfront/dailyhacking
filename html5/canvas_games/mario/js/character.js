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
        img:["assets/hero/Mario-Walking-1.png","assets/hero/Mario-Walking-2.png"],
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
  return function(type,kind,posx,posy,speed)
  {
    // used to grab element id for Character and 
    // increment global counter
    
    var el = new Element();
    this.id = el.getId();
    delete el;
    
    this.object_type = "character";
    // 
    this.setType(type);
    this.setKind(kind);
    this.setXPos(posx);
    this.setYPos(posy);
    
    this.name = kind;
    this.setSpeed(speed); // 2/15 = 7.5 every 1000
    this.state = 0;
    this.size = "small"; // super
    this.x = posx;
    this.y = posy;
    
    // animation based variables
    this.interval = 0;
    this.anim_sequence = 0;
    
    // jumping
    this.jumping = false;
    this.jump_speed = 0;
    this.jump_velocity = 20; // needs to be whole even number.
    this.fall_speed = 0;
    
    // walking
    this.walking = false;
    
    // crouching
    this.crouching = false;
    
    // running
    this.running = false;
    
    // standing
    this.standing = true;
    
    // dying
    this.dying = false;
    
    // track collisions
    this.current_collisions = {};

  };
}());

Character.prototype = Element.prototype;

Character.prototype.init = function init()
{
  var character = this;
  if(this.type == "hero")
  {
    if(this.name.match(/mario/i))
    {
      // add event listeners
      add_event_listener(character,character.eventListener);
      // we can decorate Character
      this.updateDrawable();
    }
    // can be enemy, or CPU based companion, or web-socket friend playing with you.
  }
}

// registered callback in Character.init()
// can now react to global events
Character.prototype.eventListener = function eventListener(event)
{
  var character = this;
  switch(event.type)
  {
    case "keyup":
      // walking
      if(!this.jumping)
      {
        // if mario was walking, but then jumped, we need to keep mario walking after he lands
        // this is expected by users
        character.setState(0);
      }
    break;
    
    case "keydown":
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
    break;
  }
}

// get the current drawable image
Character.prototype.getImg = function getImg()
{
  return this.img;
}

// set the characters current state
Character.prototype.setState = function setState(state_id)
{
  if(state_id === 0)
  {
    this.walking = false;
    this.standing = true;
  }
  this.state = state_id;
  this.updateDrawable();
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

// Update Mario's drawable image
Character.prototype.updateDrawable = function updateDrawable()
{
  var drawable = CharacterAssets[this.name][this.size][this.getState(true)];
  //console.log(drawable);
  var state = this.getState(true);
  
  if(state === "walking")
  {
    //console.log(drawable.img[this.anim_sequence]);
    //console.log(this.anim_sequence);
    this.setImg(drawable.img[this.anim_sequence]);
    if(this.anim_sequence === 0)
    {
      this.anim_sequence = 1;
    }
    else
    {
      this.anim_sequence = 0;
    }
  }
  else
  {
    this.setImg(drawable.img);
  }
  this.setWidth(drawable.width);
  this.setHeight(drawable.height);
  delete drawable;
}

Character.prototype.jump = function jump()
{
  if(!this.jumping && !this.falling)
  {
    this.jumping = true;
    // set character action state (jumping)
    this.setState(2);
    this.jump_speed = this.jump_velocity/game_config.tile_height;
    this.fall_speed = 0;
  }
}

// Used to render animations based on the current activity by character
Character.prototype.render = function render()
{
  // add walking logic here
  // add crouching logic here
  // add running logic here
  // add jumping logic here
  
  // update rendering
  var state = this.getState(true);
  this.updateDrawable();
  
  // character can jump
  if(this.jumping){
    //console.log("character is jumping");
    this.setPosition(this.x,this.y - this.jump_speed);
    this.jump_speed -= game_config.gravity;
    
    if(this.jump_speed <= 0)
    {
      //console.log("jump_speed is 0");
      this.jumping = false;
      this.falling = true;
      this.fall_speed = 1;
    }
  }
  
  // gravity saves us here!
  if(this.falling)
  {
    // if the object.y is less than canvas.height/multiplier-ground_height-object.height/multiplier
    if(this.y < game_config.height/16-2-1)
    {
      
      this.setPosition(this.x,this.y + this.fall_speed);
      this.fall_speed += game_config.gravity;
    }
    else
    {
      this.setYPos(game_config.height/16-2);
      this.falling = false;
      this.fall_speed = 0;
      if(this.walking)
      {
        this.setState(1);
      }
      else
      {
        this.setState(0);
      }
    }
  }
  
  switch(state)
  {
    case "jumping":
      
    break;
    
    case "walking":
      // mario is walking
      //console.log("mario is walking");
    break;
    
    case "standing":
      // mario is standing
    break;
    
    case "crouching":
     // mario is crouching
    break;
    
    case "running":
      // mario is running
    break;
  }
  
  if(this.walking)
  {
    //console.log("mario is walking");
    if(this.direction == "right")
    {
      if(this.x+this.speed <= 45)
      {
        this.x += this.speed;
      }
    }
    else if(this.direction == "left")
    {
      if(this.x-this.speed >= 0)
      {
        this.x -= this.speed;
      }
    }
  }
  
}

Character.prototype.squat = function()
{
  console.log("squat");
}

Character.prototype.move_right = function()
{
  if(this.getState(true) === "standing")
  {
    this.setState(1);
  }
  this.walking = true;
  this.direction = "right";
  this.standing = false;
  
  //this.triggerEvent(this.listener.scope,this.listener.callback,[{"type":"move","target":this.listener.scope}]);
}

// Trigger an event
Character.prototype.triggerEvent = function(scope,callback,params)
{
  if(typeof callback === "function")
  {
    callback.apply(scope,params);
  }
}

// move character to the left
Character.prototype.move_left = function()
{
  if(this.getState(true) === "standing")
  {
    this.setState(1);
  }
  this.walking = true;
  this.direction = "left";
  this.standing = false;
}

// get the characters current speed
Character.prototype.getSpeed = function()
{
  return this.speed;
}
// set the characters current speed
Character.prototype.setSpeed = function(speed)
{
  //speed/game_config.fps/1.8
  // we want to attempt to move mario less than a pixel per refresh
  // so that means if we want to move mario at 2 frames a second
  // we would need to move mario at 2/game_config.fps on each interval (0.2)
  console.log("speed: "+speed);
  console.log("tile_based_speed: "+speed/game_config.fps);
  this.speed = speed/game_config.fps;
}

Character.prototype.register_listener = function(scope,callback)
{
  //console.log(scope);
  this.listener = {};
  this.listener.scope = scope;
  this.listener.callback = callback;
}

Character.prototype.remove = function()
{
  // remove the character from the display list, remove from memory
  // if the type is hero, remove triggers game_over for game singleton
}

// override collision method
// collision
Character.prototype.collision = function collision(hit,obj)
{
  if(hit)
  {
    
    if(this.jumping)
    {
      this.jump_speed = 0;
      this.jumping = false;
      this.falling = true;
    }
    
    // check character y vs element/enemy/particle y
    if(obj.by > obj.ay)
    {
      console.log("(collision y above character)");
      this.jump_speed = 0;
      this.jumping = false;
      this.walking = false;
      this.standing = true;
    }
    else if(obj.by == obj.ay)
    {
      console.log("(collision y at character,element y)");
    }
    else
    {
      console.log("(collision y below character)");
      if(this.falling)
      {
        console.log("character is falling. so stop and set y to value of collided object");
        console.log(this);
        this.setYPos(obj.ay-(this.height/game_config.magnifier));
        this.falling = false;
        this.fall_speed = 0;
      }
    }

    // check character x vs element/enemy/particle x
    if(obj.bx < obj.ax)
    {
      console.log("collision to right of character");
    }
    else if(obj.bx == obj.ax)
    {
      console.log("collision occured in middle of character and object");
    }
    else
    {
      console.log("collision occured to the left or middle of character");
    }
  } else if(!hit)
  {
    // let the character fall
    if(!this.jumping)
    {
      if(!this.walking)
      {
        this.falling = true;
      }
    }
  }
}