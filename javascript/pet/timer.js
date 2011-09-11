/**
 * Creates a Timer
 * @param (Boolean) repeats Toggles timer repeat mode
 * @param (Integer) interval Is the timer interval in seconds
 * @param (Function) callback function for timer based events
*/

function Timer(repeats,interval,callback,args)
{
  {
    this.repeats = repeats;
    this.callback = callback;
    this.interval = interval*60; // to seconds
    this.args = args;
  }
  
  this.timer_event = function() 
  {
    delete this.timeoutID;
    global.root.innerHTML += callback;
    //this.callback.apply(args);
  };
  
  this.setup = function() 
  {
    this.cancel();
    var self = this;
    this.timeoutID = global.setTimeout(function() {this.timer_event();}, this.interval);
  };
  
  this.cancel = function() 
  {
    if(typeof this.timeoutID == "number") {
      window.clearTimeout(this.timeoutID);
      delete this.timeoutID;
    }
  };
  
}