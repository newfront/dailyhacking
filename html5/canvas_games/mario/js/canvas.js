// Basic HTML5 Canvas Functions
function fillRectWithColor(canvas,x,y,w,h,hex)
{
  var context = canvas.getContext("2d");
  context.fillStyle = hex;
  context.fillRect(x,y,w,h);
  // will add a stroke around the rectangle
  //strokeRect(x, y, width, height)
  delete context;
}

// will clear pixels in a specific region
// clearRect(x, y, width, height)

/*
 Working with Paths
 //Note: Browser can't display true 1px pixels, you need to do x = 1.5,y to x = 1.5,y+3, to get 1 px line 
 var context = canvas.getContext("2d");
 context.moveTo(x,y);
 context.lineTo(x,y);
 context.strokeStyle = "#hex-color";
 context.stroke(); // will fill it in
*/
function drawPath(a_canvas,x1,y1,x2,y2,stroke_hex,render)
{
  var context = canvas.getContext("2d");
  context.moveTo(x1,y1);
  context.lineTo(x2,y2);
  context.strokeStyle = stroke_hex;
  context.stroke();
  delete context;
}

//drawPath(canvas,50,canvas.height,100,50,200,"#000000",true);

// Fonts
// no box model, can be added at any point
function placeText(canvas,text,x,y,font)
{
  var context = canvas.getContext("2d");
  context.font = "bold #000000 12px sans-serif";
  context.fillText("( 0 , 0 )", 8, 5);
  console.log(context.fillText("scott",0,200));
  delete context;
}

// doesn't seem to work in safari5
//placeText(canvas,"mario game",50,90,"bold 12px sans-serif");

function buildGradient(canvas)
{
  var context = canvas.getContext("2d");
  var my_gradient = context.createLinearGradient(0, 0, 0, 225);
  my_gradient.addColorStop(0, "black");
  my_gradient.addColorStop(1, "white");
  context.fillStyle = my_gradient;
  context.fillRect(0, 0, 300, 225);
}
//buildGradient(canvas);

//drawImage(image, dx, dy)
//drawImage(image, dx, dy, dw, dh)
//drawImage(image, sx, sy, sw, sh, dx, dy, dw, dh)
/*function draw(canvas,path_with_image,x,y)
{
  var context = canvas.getContext("2d");
  var img = new Image();
  img.src = path_with_image;
  img.onload = function()
  {
    context.drawImage(img,x,y);
  }
  delete context;
  delete img;
  console.log(img);
}
*/
