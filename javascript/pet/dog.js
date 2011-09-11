// Dog
function Dog(global,name,age)
{
  var glob = global;
  var name = name;
  var fleas = false;
  var age = age;
  var cycles = 0;
  var flea_cycle = 0;
  var timer;
  var self = this;
  
  // begin life for the dog
  this.beginLife = function()
  {
    timer.setup(true,1000,this.live,["from dog"]);
  };
  
  // dog finds an owner
  this.setOwner = function(owner)
  {
    this.owner = owner;
  };
  
  // what's the dogs name?
  this.getName = function()
  {
    return name;
  };
  
  // have dog talk
  this.speak = function()
  {
    return "Bark...";
  };
  
  // does dog have fleas
  this.checkForFleas = function()
  {
    return fleas;
  };
  
  // get rid of fleas
  this.applyFleaMedicine = function()
  {
    fleas = false;
    flea_cycle = 0;
  };
  
  
  // life events
  this.live = function(mess)
  {
    console.log("I'm Living Life : "+mess+" "+self.getName());
    console.log(self.getName());
    if(flea_cycle > 4 && !fleas)
    {
      fleas = true;
      age += 1;
      if(self.checkForFleas())
      {
        // send information up to GUI.....
        window.notifyOwner("Clean "+self.getName()+". You must buy flea medicine to fix this issue.",self);
        window.petIssues("fleas",self);
        timer.setRepeats(false);
      }
    }
    // dog has lived a good life....
    if(cycles > 900)
    {
      timer.setRepeats(false);
      console.log("done");
      console.log(timer);
    }
    cycles++;
    flea_cycle++;
  };
  
  // Timer
  timer = {
    tEvent : function() 
    {
      this.cancel();
      delete this.timeoutID;
      
      if(this.callback != undefined)
      {
        this.callback(this.args[0]);
      }
      if(this.repeats)
      {
        this.setup(this.repeats,this.interval,this.callback,this.args);
      }
    },
    setRepeats : function(repeats)
    {
      this.repeats = repeats;
    },
    setup : function(repeats,interval,callback,args) 
    {
      this.cancel();
      /*
      delete this.repeats;
      delete this.interval;
      delete this.callback;
      delete this.args;
      */
      this.repeats = repeats;
      this.interval = interval;
      this.callback = callback;
      this.args = args;
      var self = this;
      
      this.timeoutID = window.setTimeout(function() {self.tEvent();}, this.interval);
    },
    cancel : function() 
    {
      if(typeof this.timeoutID == "number") {
        window.clearTimeout(this.timeoutID);
        delete this.timeoutID;
      }
    }
  };
  
}