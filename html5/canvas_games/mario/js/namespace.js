/*
 Creates a Global Namespacer function
*/
var namespacer = function(scope,namespace)
{
  /*
   Check for properly defined non-optional arguments
  */
  if(typeof scope === "undefined")
  {
    throw("ArgumentError: scope is undefined");
  }
  if(typeof namespace === "undefined")
  {
    throw("ArgumentError: namespace of root element is undefined");
  }
  if(typeof namespace === "string")
  {
    scope[namespace] = {};
  }
  
  return function(ns_string)
  {
    if(typeof ns_string === "undefined")
    {
      throw("ArgumentError: ns_string must be supplied");
    }
    print(namespace);
    var parent = scope[namespace];
    print(parent);
    var parts = ns_string.split('.');
    var i;
    
    // string redundant leading global
    if(parts[0] === namespace)
    {
      parts = parts.slice(1);
    }
    for(i = 0; i < parts.length; ++i)
    {
      // create a property if it doesn't exist
      if (typeof parent[parts[i]] === "undefined")
      {
        parent[parts[i]] = {};
      }
      parent = parent[parts[i]];
    }
    return parent;
  };
};
/*
// Usage
var ns = namespacer(this,"Mario");
ns("Mario.modules.module1");
Mario.modules.module1.data = {a:1,b:2}

// Create a Namespace within object
var glob = {};
glob.namespacer = namespacer(glob,"Mario");
glob.namespacer("Mario.modules");
glob.Mario.modules.data = {a:2};

print(glob.Mario.modules.data.a);
*/