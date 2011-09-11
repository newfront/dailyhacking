/**
 * Store can be of any type.
 * @param (String) name Store Name
*/

function Store(name){

  var name = name;
  var products = [];
  var searched_cache = {};
  
  // add a good to the store
  this.addProduct = function(product,quantity)
  {
    console.log("Adding Product");
    console.log(product);
    var tmp = {};
    tmp.product = product;
    tmp.quantity = quantity;
    products.push(tmp);
    // can index shelves
  };
  
  // get store name
  this.getName = function()
  {
    return name;
  };
  
  // Index items in the store
  this.indexShelves = function()
  {
    for(var j = 0; j < products.length;++j)
    {
      var tName = products[j].product.getName();
      var tPrice = products[j].product.getPrice();
      this.cache(tName,j);
      delete tName;
      delete tPrice;
    }
    
  };
  
  this.getProduct =  function(index)
  {
    console.log(index);
    return products[index];
  };
  
  // search for items on the Shelves
  // if item has partial match to search word, add to index
  this.findProduct = function(search_word)
  {
    console.log("check for product: "+search_word);
    console.log(searched_cache);
    // check index first
    if(searched_cache[search_word] != "undefined")
    {
      return searched_cache[search_word];
    }
    else
    {
      return 0;
    }
  };
  
  // cache the index of the item in our Store
  // this will help in repeated lookups
  this.cache = function(name,price,index)
  {
    if(searched_cache.name != undefined)
    {
      console.log("in cache:"+searched_cache.name);
    }
    else
    {
      // if item is not in cache, add it and append the search index
      // of the item to indexes Array of object property
      searched_cache.name = index;
      console.log("added to cache: "+searched_cache.name);
    }
  };
  
}

// Add new methods to Store for Catgories
Store.prototype = (function()
{
  // return categories 
  var categories = {};
  var category_index = 0;
  
  this.getCategory = function(name)
  {
    if(categories[name] == undefined)
    {
      return false;
    }
    else
    {
      categories[name];
      return (categories[name]);
    }
  };
  
  return {
    addCategory: function(name)
    {
      if(getCategory(name) == false)
      {
        // category needs to be added
        categories[name] = category_index;
        //return this.categories[name];
      }
      // category already created
      return categories[name];
    },
    getCategories: function()
    {
      return categories;
    },
    getCategory: function(name)
    {
      return categories[name];
    },
    updateIndex: function()
    {
      category_index++;
    }
  };
  
}());