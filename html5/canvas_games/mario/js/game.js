// Game Constant
var Game = {
  visible_pixel_multiplier:16,
  viewport:{
    width:16,
    height:16
  }
};

/*
  A Game needs to have a visible viewport (camera view)
  The viewport needs to move with the character, keeping her in the middle of the viewport at
  all times. 
  
  viewport = 16x16
  hero width = 16
  visible_range = viewport.width / 2 - hero.width / 2
*/