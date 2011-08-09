var limit = 10;
var current = 0;

$(document).ready(function(){
  
  function debug(str){
    $("#debug").append("<p>" +  str); 
  };
  
  var user;
  var http;
  var ws_url;
  
  var data = {username:'rand',name:'Scott Haines'};
  var payload = JSON.stringify(data);
  
  ws_url = "ws://127.0.0.1:9000/"+data.username
  
  console.log(ws_url)
  
  http = new WebSocket(ws_url)
  
  http.onmessage = function(evt) { 
    console.log(evt)
    $("#loading").fadeOut();
    $("#msg").append(evt.data);
  };
  
  http.onclose = function() { 
    $("#msg").prepend("<p>socket server closed</p>"); 
  };
  
  http.onopen = function() {
    debug("WebSocket connected!");
    http.send(payload);
  };

/*$("#send_note").click(function(){
  tmp = JSON.stringify(['message',{value: $("#event_push").val(),uuid:'b9bd990e-cd4d-11de-af34-f3838005cf13'}]);
  http.send(tmp);
  })
*/
});