// Element Global
// Used as foundation for all environment elements
var Element = (function(){
  var id = 0;
  
  return function()
  {
    this.id = ++id;
    // set position
    this.setPosition = function(x,y)
    {
      this.x = x;
      this.y = y;
    }
    
    // get current x position
    this.getXPos = function()
    {
      return this.x
    }
    this.getYPos = function()
    {
      return this.y;
    }
  };
}());
Element.prototype.getId = function()
{
  return this.id;
}
Element.prototype.setType = function(type)
{
  this.type = type;
}
Element.prototype.getType = function()
{
  return this.type;
}
Element.prototype.setKind = function(kind)
{
  this.kind = kind;
}
// draw the element on the screen
Element.prototype.draw = function(canvas,x,y)
{
  var context = canvas.getContext("2d");
  var img = new Image();
  var xpos = this.getXPos()*16;
  var ypos = this.getYPos()*16;
  img.src = window.environment_db.elements[this.type][this.kind].img;
  img.onload = function()
  {
    context.drawImage(img,xpos,ypos);
  }
  delete context;
  delete img;
  console.log(img);
}