// Element Global
// Used as foundation for all environment elements
var Element = (function(){
  var id = 0;
  
  return function()
  {
    this.id = ++id;
  };
}());

// set position
Element.prototype.setPosition = function setPosition(x,y)
{
  this.x = x;
  this.y = y;
}

// get current x position
Element.prototype.getXPos = function getXPos()
{
  return this.x
}
Element.prototype.getYPos = function getYPos()
{
  return this.y;
}

Element.prototype.getId = function getId()
{
  return this.id;
}
Element.prototype.setType = function setType(type)
{
  this.type = type;
}
Element.prototype.getType = function getType()
{
  return this.type;
}
Element.prototype.setKind = function setKind(kind)
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
  //console.log(img);
}