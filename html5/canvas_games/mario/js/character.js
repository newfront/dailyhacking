/**
 * Character inherits from Element
 * a character has space in the Environment (World)
 * a character can be impacted by a collision, eg. when it's position collides with the position of another Entity
*/
var Character = (function(type,name,posx,posy,speed)
{
  return function(type,name,posx,posy,speed)
  {
    this.type = type;
    this.name = name;
    this.speed = speed;
    var character = this;
    if(type == "hero")
    {
      // bind movements to keyboard keys
      // a = jump
      // s = crouch
      // key_left = move left
      // key_right = move right
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
  };
}());

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
  console.log("move right");
}

Character.prototype.move_left = function()
{
  console.log("move left");
}

Character.prototype.getSpeed = function()
{
  console.log("getting speed");
}

Character.prototype.setSpeed = function()
{
  console.log("setting speed");
}

Character.prototype.remove = function()
{
  // remove the character from the display list, remove from memory
  // if the type is hero, remove triggers game_over for game singleton
}