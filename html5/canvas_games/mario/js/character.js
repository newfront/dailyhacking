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
  return function(type,kind,posx,posy,speed)
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
    this.speed = speed/game_config.fps/1.8; // 2/15 = 7.5 every 1000
    console.log("speed: "+this.speed);
    this.state = 0;
    this.size = "small"; // super
    this.x = posx;
    this.y = posy;
    
    console.log("mario see's config?");
    //console.log(game_config);
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
      this.updateDrawable();
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
      window.onkeyup = function(event)
      {
        character.setState(0);
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
  console.log(drawable);
  console.log(drawable.img);
  this.setImg(drawable.img);
  this.setWidth(drawable.width);
  this.setHeight(drawable.height);
  delete drawable;
}

Character.prototype.jump = function jump()
{
  console.log("jump");
  // if this.getState(true) == "jumping"... ignore
  console.log(this.getState(true));
  if(this.getState(true) != "jumping")
  {
    // set character action state (jumping)
    this.setState(2);
    // start jump timer, 2 seconds of jump, updated in 200ms increments
    this.do_jump(this.y,this.y-10,2,true);
  }
}

Character.prototype.do_jump = function do_jump(start,finish,time,rewind)
{
  // animate on the y, from y.current to y.end, over time
  // if rewind, from y.current to y.end back to y.current, over time
  console.log("do_jump");
  this.jump_animate = new Animation();
  console.log(this.jump_animate);
  var scope = this;
  //target,props,runtime,callback
  // function(target,props,runtime,callback)
  this.jump_animate.init(scope,"y",time,this.jump_finished);
  this.jump_animate.start();
}

Character.prototype.jump_finished = function()
{
  console.log("jump finished");
}

Character.prototype.squat = function()
{
  console.log("squat");
}

Character.prototype.move_right = function()
{
  console.log("move right: "+this.x);
  var state = this.getState(true);
  
  if(state === "standing")
  {
    this.setState(1); // walking
  }
  
  if(this.x+this.speed <= 45)
  {
    this.x += this.speed;
  }
  console.log(this.getState(true));
  console.log(this.getImg());
  
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
  if(this.x-this.speed >= 0)
  {
    this.x -= this.speed;
  }
  if(typeof this.listener === "object")
  {
    console.log("new event occured.");
    //console.log(typeof this.listener.callback);
    this.listener.callback.call(null,{"type":"move","target":this.listener.scope});
  }
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

var Animation = (function()
{
  // props = {"y":this.y,"start":this.getYPos,"end":integer,"rewind":true}
  // callback occures when the animation finishes
  var id = 0;
  return function()
  {
    this.id = id++;
  }
}());

// Animation is terrible at this point
// Mario jumps for 2 seconds, he moves a total of 4 blocks up
// Mario needs to travel from mario.y - mario.y - 4 in 1 second, and back to mario.y in 1 second
Animation.prototype.init = function(target,props,runtime,callback)
{
  this.target = target;
  this.props = props;
  
  // 2 seconds = 2000 milliseconds, 
  // y.start = 16, y.end = 10 = frame_distance
  // frame_distance / fps = 
  
  this.runtime = runtime*1000; // 2 seconds = 2000 milliseconds 
  this.runlength = runtime*1000;
  this.callback = callback;
  this.running = false;
  this.interval = 200;
  console.log(this.runtime);
}

Animation.prototype.trigger_animation = function()
{
  console.log("trigger animation");
  
  this.runtime -= this.interval;
  this.running = false;
  
  if(this.props === "y")
  {
    //console.log("move in y");
    // if this.target.y == this.target.y_start (move up)
    // if this.target.y == this.targer.y_start + 4 (move down)
    console.log(this.runtime);
    console.log(this.runlength);
    if(this.runtime >= this.runlength / 2)
    {
      this.target.y -= .4;
      //console.log("runtime is greater than runlength");
      console.log(this.target.y)
    }
    else
    {
      //console.log("runtime is less than runlength");
      this.target.y += .4;
      console.log(this.target.y)
    }
    this.target.listener.callback.call(null,{"type":"move","target":this.target.listener.scope});
  }
  
  if(this.runtime > 0)
  {
    this.stop();
    this.start();
  }
  else
  {
    console.log("animation complete");
  }
}

Animation.prototype.start = function start()
{
  // move 6 pixels in this.runtime / 2 seconds, move back in this.runtime / 2 seconds
  var scope = this;
  if(!scope.running)
  {
    scope.running = true;
    //console.log(scope.runtime);
    //console.log(scope.interval);
    scope.y_start = scope.y;
    scope.timer = setTimeout(function(){scope.trigger_animation();},scope.interval);
  }
}

Animation.prototype.stop = function stop()
{
  clearTimeout(this.timer);
  this.timer = null;
  this.running = false;
}