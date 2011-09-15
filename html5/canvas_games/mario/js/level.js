var Loader = (function Loader(object)
{
  return function(object)
  {
    this.object = object;
    var assets = {
      size:0
    };
    this.status = "loading";
    
    this.parseObject = function(obj)
    {
      for(var item in obj)
      {
        if(typeof obj[item] == "string" && item == "img")
        {
          //console.log("found image");
          this.load(obj[item]);
        }
        
        if(typeof obj[item] == "object")
        {
          this.parseObject(obj[item]);
        }
      }
    }
    
    this.add_to_queue = function(img_src)
    {
      assets[img_src] = "loading";
      assets.size += 1;
      //console.log(assets);
    }
    
    var remove_from_queue = function(img_src)
    {
      delete assets[img_src];
      assets.size -= 1;
      /*console.log(assets);
      console.log(assets.size);
      console.log(typeof assets.size);
      */
      if(assets.size == 0)
      {
        this.status = "loaded";
        console.log("all images are loaded. game my commence");
        // trigger callback
      }
    }
    
    this.load = function(img_src)
    {
      var img = new Image();
      img.src = img_src;
      img.path(img_src);
      this.add_to_queue(img_src);
      img.setCallback(this.loaded);
      img.onload = function()
      {
        this.triggerCallback(this);
      }
    }
    
    this.loaded = function(img)
    {
      //console.log(img.src+" has finished loading");
      remove_from_queue(img.path);
    }
  };
}());
/*
  extend Image
*/
Image.prototype.setCallback = function setCallback(callback)
{
  //console.log("registered callback");
  this.callback = callback;
}

Image.prototype.triggerCallback = function triggerCallback(scope)
{
  if(scope != "undefined")
  {
    this.callback(scope);
  }
  else
  {
    this.callback();
  }
}

Image.prototype.path = function(path)
{
  this.path = path;
  return this.path;
}

var Level = (function(number,assets){
  return function(number,assets)
  {
    this.level = number;
    this.assets = assets;
    this.loadLevel = function()
    {
      this.loader = new Loader(this.assets);
      this.loader.parseObject(this.assets);
    }
  };
}());

// Usage
/*
var l = new Level(1,environment_db);
l.loadLevel();
*/