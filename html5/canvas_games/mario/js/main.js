/*
 Attach Main Event Listener to div #game
*/
//var event_region = document.getElementById("game");
window.addEventListener("keyup",eventHandler,false);
window.addEventListener("keydown",eventHandler,true);
window.addEventListener("click",eventHandler,false);

// store event listeners
var event_listeners = [];
// {"object":object,"callback":callback}

// register callbacks
function add_event_listener(object,callback)
{
  var listener = {};
  listener.object = object;
  listener.callback = callback;
  event_listeners.push(listener);
  delete listener;
}

// remove callbacks
function remove_event_listener(object)
{
  // loop through event_listeners and remove object where "object" == object
}

// single eventHandler method for all keyboard events / clicks
function eventHandler(event)
{
  if (event_listeners.length > 0)
  {
    for(var i=0;i<event_listeners.length;++i)
    {
      var obj = event_listeners[i].object;
      event_listeners[i].callback.call(obj,event);
      //event_listeners[i].callback(event);
    }
  }
}

var Game = {
  dependencies: {
    "path":"js",
    "files":["config","canvas","level","mario","element","character"]
  },
  autoload: true,
  loading:[],
  require: function(file,callback)
  {
    var script = document.createElement("script");
    script.src = file;
    //var first_script = document.getElementsByTagName('script')[0];
    //first_script.parentNode.insertBefore(script, first_script);
    var loadable = document.getElementById("loadable");
    if(typeof loadable != "undefined")
    {
      loadable.appendChild(script);
    }
    else
    {
      document.documentElement.firstChild.prependChild(script);
    }
    
    script.onload = function()
    {
      callback(script.src);
    };
    
  },
  loadHandler: function(elem)
  {
    //console.log(elem);
    var file = elem;
    file = file.replace(/.*\//,'');
    //console.log(file);
    for(var i=0; i < Game.loading.length;++i)
    {
      if(Game.loading[i] == file.toString())
      {
        //console.log("found it");
        Game.loading.splice(i,1);
      }
    }
    if(Game.loading.length === 0)
    {
      Game.loadComplete();
    }
  },
  onLoadComplete: function(callback)
  {
    Game.init = callback;
  },
  loadComplete: function()
  {
    //console.log("load complete");
    //console.log(Game.init);
    Game.init();
  }
}

if (Game.autoload)
{
  Game.onLoadComplete(initGame);
  for(var i = 0; i < Game.dependencies.files.length;++i)
  {
    var dep = Game.dependencies;
    //console.log("dependencies");
    //console.log(dep.files[i]);
    Game.loading.push(dep.files[i]+".js");
    Game.require(dep.path+"/"+dep.files[i]+".js",Game.loadHandler);
  }
  // test config
}



function initGame()
{
  console.log("magic begins");
  // Mario Stage
  Game.canvas = document.getElementById("mario_game");
  Game.canvas.width = game_config.width;
  Game.canvas.height = game_config.height;

  Game.context = Game.canvas.getContext("2d");

  var tgame = document.getElementById("game");
  tgame.addEventListener('click',clickHandler,false);

  function clickHandler(event)
  {
    console.log(event);
    // altKey = false
    // bubbles = true
    // button = 0
    // cancelBubble = false
    // cancelable = true
    //charCode = 0
    // clientX = px
    // clientY = px
    // ctrlKey = true,false
    // currentTarget = null
    // layerX
    // layerY
    // offsetX
    // offsetY
    // pageX
    // pageY
    // screenX
    // screenY
    // shiftKey = false
    // metaKey = command key (apple key on apple)
  }

  // encapsulate the level builder
  Game.levelbuilder = {}
  Game.levelbuilder.buildBlocks = function(){
      /*
       Build a single block
      */
      var elem = new Element();
      elem.setType("block");
      elem.setKind("brick_brown");
      elem.setPosition(12,game_config.height/16-4);
      //add a block
      Game.game.addElement(elem);
  };
  
  Game.levelbuilder.buildGround = function(){
    var gstart_x = 0;
    var gstart_y = 17;
    for(var j=0;j<45;++j)
    {
      // can share an instance of image, rather than having one image per block
      this["ground"+j] = new Element();
      this["ground"+j].setType("block");
      this["ground"+j].setKind("ground_brown");
      this["ground"+j].setPosition(gstart_x,gstart_y);
      Game.game.addElement(this["ground"+j]);
      gstart_x += 1;
      delete this["ground"+j];
    }
    // force a refresh of the screen
    //Game.game.draw();
  };

  Game.levelbuilder.addHero = function()
  {
    //type,kind,posx,posy,speed
    var mario = new Character("hero","mario",0,game_config.height/16-2,2);
    // mario.addCallback...
    // mario.init()
    //game.addElement(mario);
    mario.init();
    //console.log(mario.getImg());
    Game.game.addElement(mario);
    //Game.game.draw();

    mario.register_listener(Game.game,Game.game.game_event);
    Game.game.draw();
  }

  Game.game = new Mario(1,3,3);
  //console.log(Game.game);
  // set drawing surface
  Game.game.setCanvas(Game.canvas);
  // level
  Game.level = new Level(1,window.environment_db,game);
  Game.level.setLoadedCallback(this,[Game.levelbuilder.buildBlocks,Game.levelbuilder.buildGround,Game.levelbuilder.addHero]);

  Game.game.setLevel(Game.level);
  Game.level.loadLevel();
  
  // start rendering
  Game.game.auto_draw();
}