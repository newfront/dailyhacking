// Element Global
// Used as foundation for all environment elements
var Element = (function(scope,callback){
  var id = 0;
  
  return function()
  {
    this.id = ++id;
    this.x = 0;
    this.y = 0;
    this.height = 0;
    this.width = 0;
    this.type = "default";
    this.kind = "default";
    this.img = null;
    this.object_type = "element";
    this.has_weight = false;
    if(typeof callback != "undefined" && typeof scope != "undefined")
    {
      callback.apply(scope);
    }
  };
}());

/*
  Methods
  
  // Object Skin
  getImg()
  setImg(src)
  
  // Width / Height related
  // (Note *) You will use width and height of objects to do hit tests
  
  getWidth()
  setWidth(width)
  
  getHeight()
  setHeight(height)
  
  // Position Based Methods
  setPosition(x,y)
  getXPos()
  getYPos()
  setXPos()
  setYPos()
  
  // Object ID
  getId()
  
  // Object Type
  setType()
  getType()
  
  // Object Kind
  setKind()
  getKind()
  
  // Draw Element on Canvas
  draw()
*/

// get the current drawable image
Element.prototype.getImg = function getImg()
{
  return this.img;
}

// does this element have weight?
Element.prototype.hasWeight = function hasWeight()
{
  return this.has_weight;
}

// update an element to make it passable
Element.prototype.setWeight = function setWeight(weight)
{
  this.has_weight = weight;
}

// set the current drawable image
Element.prototype.setImg = function setImg(src)
{
  this.img = src;
}

// set the width
Element.prototype.setWidth = function setWidth(width)
{
  this.width = width;
}

// set the height
Element.prototype.setHeight = function setHeight(height)
{
  this.height = height;
}

// get the width
Element.prototype.getWidth = function getWidth()
{
  return this.width;
}

// get height
Element.prototype.getHeight = function getHeight()
{
  return this.height;
}

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
// get the current y position
Element.prototype.getYPos = function getYPos()
{
  return this.y;
}
// set the x position of the object
Element.prototype.setXPos = function setXPos(xpos)
{
  this.x = xpos;
}
// set the y position of the object
Element.prototype.setYPos = function setYPos(ypos)
{
  this.y = ypos;
}
// get the id of the object
Element.prototype.getId = function getId()
{
  return this.id;
}
// set the type of the object
Element.prototype.setType = function setType(type)
{
  this.type = type;
}
// get the type of the object
Element.prototype.getType = function getType()
{
  return this.type;
}
// set the object kind
Element.prototype.setKind = function setKind(kind)
{
  this.kind = kind;
}

// get the current object kind
Element.prototype.getKind = function getKind()
{
  return this.kind;
}