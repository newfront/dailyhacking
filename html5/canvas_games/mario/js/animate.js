/*
  deprecated since we don't need another timer / event loop outside of our main Game loop
*/
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