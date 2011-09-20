var Loader = (function Loader(object,callback)
{
  return function(object,callback)
  {
    var loader = {};
    this.object = object;
    var assets = {
      size:0
    };
    this.callback = callback;
    this.status = "loading";
    
    this.parseObject = function(obj)
    {
      for(var item in obj)
      {
        if(item == "img")
        {
          if(typeof obj[item] == "string")
          {
            this.load(obj[item]);
          }
          else if(Array.isArray(obj[item]))
          {
            for(var j=0;j<obj[item].length;++j)
            {
              this.load(obj[item][j]);
            }
          }
        }
        else if(typeof obj[item] === "array" && item == "img")
        {
          for(var i=0;i < obj[itme].length;++i)
          {
            this.load(obj[item][i]);
          }
        }
        else if(typeof obj[item] == "object")
        {
          this.parseObject(obj[item]);
        }
      }
    },
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
      
      if(assets.size == 0)
      {
        this.status = "loaded";
        console.log("all images are loaded. game my commence");
        
        // trigger callback
        loader.callback.call();
      }
    }
    
    this.load = function(img_src)
    {
      var img = new Image();
      //console.log("loading: "+img_src);
      img.src = img_src;
      img.path(img_src);
      this.add_to_queue(img_src);
      img.setCallback(this.loaded);
      
      // update images hash for level
      this.callback(img_src,img);
      
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
    this.onLoaded = function(scope,callback)
    {
      loader.scope = scope;
      loader.callback = callback;
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

var Level = (function(number,assets,game){
  return function(number,assets,game)
  {
    var level = {};
    level.scope = this;
    level.current = number;
    level.game = game;
    level.assets = assets;
    level.img_assets = {};
    
    this.loadLevel = function()
    {
      var loader = new Loader(this.assets,this.collect_image_assets);
      loader.onLoaded(level.scope,level.scope.onLoaded);
      loader.parseObject(level.assets);
      delete loader;
    }
    
    this.collect_image_assets = function(img_src,img)
    {
      //console.log(typeof level.img_assets);
      level.img_assets[img_src] = img;
    }
    
    this.get_image_assets = function()
    {
      return level.img_assets;
    }
    
    // use this to paint the background of the canvas
    // alt. better use of memory, style canvas background with CSS
    this.paintBackground = function()
    {
      
      //"#6490FE"
      //var canvas = level.game.getCanvas();
      //fillRectWithColor(canvas,0,0,canvas.width,canvas.height,level.assets.level[level.current.toString()].background);
      //delete canvas;
      //level.scope.onLoaded();
    }
    
    this.setLoadedCallback = function(s,block)
    {
      level.callback_scope = s;
      level.callback = block;
    }
    
    /**
     * When the level has finished loading its assets. Trigger any callbacks.
    */
    this.onLoaded = function()
    {
      if(level.callback != undefined)
      {
        if(Array.isArray(level.callback))
        {
          for(var i=0;i<level.callback.length;++i)
          {
            level.callback[i].call();
          }
        }
        else
        {
          level.callback.call();
        }
      }
    }
  };
}());

// Usage
/*
var l = new Level(1,environment_db);
l.loadLevel();
*/