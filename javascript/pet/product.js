/**
 * Can be any type of Product
 * @param (String) name Is the product name
 * @param (String) type Type of product
 * @param (Float) price Price of the product
 * @param (Category) category Category Object of product
*/

function Product(name,type,price,sku,category) 
{
  // using constructor pattern
  var that = {};
  that.name = name;
  that.type = type;
  that.price = price;
  that.sku = sku;
  that.category = category;
  
  // what kind of product is this
  that.describe = function()
  {
    return "<p>I am a product of type: "+this.type;
  };
  
  that.getName = function()
  {
    return that.name;
  };
  
  that.getPrice = function()
  {
    return that.price;
  };
  return that;
};