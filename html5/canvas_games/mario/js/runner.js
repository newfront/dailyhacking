// Mario Stage
var canvas = document.getElementById("mario_game");
canvas.width = game_config.width;
canvas.height = game_config.height;
console.log(canvas);
fillRectWithColor(canvas,0,0,canvas.width,canvas.height,"#6490FE"); 
//function(canvas,level,lives,continues)
var game = new Mario(this.canvas,1,3,3);
// set drawing surface
game.setCanvas(canvas);
/*
 Build a single block
*/
var elem = new Element();
elem.setType("block");
elem.setKind("brick_brown");
elem.setPosition(10,11);
//console.log(elem.getId());

//add a block
game.addElement(elem);

/*
  add the first ground section to level 1
  69 blocks across by 2 high
*/
var gstart_x = 0;
var gstart_y = 17;
for(var j=0;j<20;++j)
{
  // can share an instance of image, rather than having one image per block
  this["ground"+j] = new Element();
  this["ground"+j].setType("block");
  this["ground"+j].setKind("ground_brown");
  this["ground"+j].setPosition(gstart_x,gstart_y);
  game.addElement(this["ground"+j]);
  gstart_x += 1;
}

// force a refresh of the screen
game.draw();