// encapsulate the level builder
var levelbuilder = {}
levelbuilder.buildBlocks = function(){
    /*
     Build a single block
    */
    var elem = new Element();
    elem.setType("block");
    elem.setKind("brick_brown");
    elem.setPosition(12,12);
    //add a block
    game.addElement(elem);
};
levelbuilder.buildGround = function(){
  /*
  add the first ground section to level 1
  69 blocks across by 2 high
  */
  var gstart_x = 0;
  var gstart_y = 17;
  for(var j=0;j<45;++j)
  {
    // can share an instance of image, rather than having one image per block
    this["ground"+j] = new Element();
    this["ground"+j].setType("block");
    this["ground"+j].setKind("ground_brown");
    this["ground"+j].setPosition(gstart_x,gstart_y);
    game.addElement(this["ground"+j]);
    gstart_x += 1;
    delete this["ground"+j];
  }
  /*
  //empty_castle
  for(var j=0;j<20;++j)
  {
    // can share an instance of image, rather than having one image per block
    this["ground"+j] = new Element();
    this["ground"+j].setType("block");
    this["ground"+j].setKind("empty_castle");
    this["ground"+j].setPosition(gstart_x,gstart_y);
    game.addElement(this["ground"+j]);
    gstart_x += 1;
  }
  */
  // force a refresh of the screen
  game.draw();
};

levelbuilder.addHero = function()
{
  var mario = new Character("hero","mario",0,1,16);
  // mario.addCallback...
  // mario.init()
  //game.addElement(mario);
  mario.init();
  //console.log(mario.getImg());
  game.addElement(mario);
  game.draw();
  
  mario.register_listener(game,game.game_event);
}

// Mario Stage
var canvas = document.getElementById("mario_game");
canvas.width = game_config.width;
canvas.height = game_config.height;
//console.log(canvas); 
//function(canvas,level,lives,continues)
var game = new Mario(1,3,3);
console.log(game);
// set drawing surface
game.setCanvas(canvas);

var l = new Level(1,window.environment_db,game);
l.setLoadedCallback(this,[levelbuilder.buildBlocks,levelbuilder.buildGround,levelbuilder.addHero]);
l.loadLevel();
