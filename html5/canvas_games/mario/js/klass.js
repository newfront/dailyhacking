var klass = function(Parent,props)
{
  var Child, F, i;
  
  // 1.
  // new constructor
  Child = function()
  {
    if (Child.uber && Child.uber.hasOwnProperty("__construct"))
    {
      Child.uber.__construct.apply(this,arguments);
    }
    if (Child.prototype.hasOwnProperty("__construct"))
    {
      Child.prototype.__construct.apply(this,arguments);
    }
  };
  
  // 2.
  // inherit
  Parent = Parent || Object;
  F = function(){};
  F.prototype = Parent.prototype;
  Child.prototype = new F();
  Child.uber = Parent.prototype;
  Child.prototype.constructor = Child;
  
  // 3.
  // add implementation methods
  for (i in props)
  {
    if (props.hasOwnProperty(i))
    {
      Child.prototype[i] = props[i];
    }
  }
  
  // return the "class"
  return Child;
}

/*
// Usage. 
var Character = klass(null,{
  __construct: function (name){
    this.name = name;
  },
  getName: function()
  {
    return this.name;
  }
});
*/