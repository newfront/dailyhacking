var game_config = {
  width: 800,
  height: 288,
  fps: 30,
  stage: {
    height: 18,
    width: 244,
    visible_width: 16,
    visible_height: 16
  },
  magnifier : 16
}
  
  /*
    
  */
  window.environment_db = {
    elements:
    {
      /*
        Blocks are the basic building blocks in Mario. This is what you walk on (mostly), 
      */
      block: 
      {
        /*
          You walk on these
        */
        "ground_brown":{
          "img":"assets/environment/blocks/GroundBlockBrown.png",
          "width":16,
          "height":16
        },
        /*
          You jump up and break these
        */
        "brick_brown":{
          "img":"assets/environment/blocks/BrickBlockBrown.png",
          "width":16,
          "height":16
        },
        "brick_castle":{
          "img":"assets/environment/blocks/BrickBlockCastle.png",
          "width":16,
          "height":16
        },
        "brick_dark":{
          "img":"assets/environment/blocks/BrickBlockDark.png",
          "width":16,
          "height":16
        },
        "empty":{
          "img":"assets/environment/blocks/EmptyBlock.png",
          "width":16,
          "height":16
        },
        "empty_castle":{
          "img":"assets/environment/blocks/EmptyBlockCastle.png",
          "width":16,
          "height":16
        },
        "empty_dark":{
          "img":"assets/environment/blocks/EmptyBlockDark.png",
          "width":16,
          "height":16
        },
        /*
          You jump and connect with these to reveal coins or powerups
        */
        "question":{
          "img":"assets/environment/blocks/QuestionBlock.gif",
          "width":16,
          "height":16
        },
        "question_castle":{
          "img":"assets/environment/blocks/QuestionBlockCastle.gif",
          "width":16,
          "height":16
        },
        "question_dark":{
          "img":"assets/environment/blocks/QuestionBlockDark.gif",
          "width":16,
          "height":16
        }
      }
    }
  }
  