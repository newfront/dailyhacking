var global = {};
var store;
function init()
{
  global.root = document.getElementById("main");
  // dog owner
  global.owner = {};
  global.owner.name = "Scott Haines";
  global.owner.wallet = 200.00;

  global.owner.pay = function(price)
  {
    if (global.owner.wallet > price)
    {
      global.owner.wallet -= price;
      return true;
    }
    else
    {
      return false;
    }
  };
  
  global.owner.balance = function()
  {
    return global.owner.wallet;
  };
  
  // make dog
  global.dog = new Dog(this,"Penny",3);
  global.dog.beginLife();
  global.dog.setOwner(global.owner);
  
  if(global.dog.checkForFleas())
  {
    global.root.innerHTML += "<p>"+global.dog.getName()+" has fleas</p>";
    // check store for good
  }
  else
  {
    global.root.innerHTML += "<p>"+global.dog.getName()+" doesn't have fleas</p>";
  }
  
  // buy flea medicine
  store = new Store("Petco");
  store.addCategory("Medicine");
  var product = new Product("Frontline","Flea Medicine",46.00,"990287333a",store.getCategory("Medicine"));
  console.log(product);
  store.addProduct(product,20);
  // list categories
  for(var k in global.store.getCategories())
  {
    global.root.innerHTML += "category: "+k+":"+global.store.getCategory(k);
  }
  
}

function notifyOwner(notice,elem)
{
  global.root.innerHTML += "<p>"+notice+"</p>";
}

function petIssues(type,elem)
{
  console.log("Type: "+type);
  switch(type)
  {
    case "fleas":
      console.log(store);
      if (store.findProduct("Frontline"))
      {
        var tmp = store.findProduct("Frontline");
        
        var p = store.getProduct(tmp);
        console.log(p);
        delete tmp;
      }
      else
      {
        console.log("no medicine");
      }
      break;
    default:
      console.log("switching on pet issue types");
    //
  }
}