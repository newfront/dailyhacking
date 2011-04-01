var local_storage = get_local_storage();
var your_name = '';
var html_text = '';

// find localStorage object
function get_local_storage()
{
	try
	{
		return 'localStorage' in window && window['localStorage'] !== null;
	} catch(e) {
		// use this in your script to tell a user they have an old browser
		return false;
	}	

}

// set any key:value pair into a localObject
function set_value_in_local_storage(key,value)
{
	if(key == null || value == null)
	{
		return false;
	}
	
	try
	{
		if ($("#"+value).val() != null)
		{
			value = $("#"+value).val();
			
		}
		else if($("#"+value).html() != null)
		{
			value = $("#"+value).html();
			
		}
		// save value in localStorage Object
		localStorage.setItem(key,value);
		
		// update current page cache of var your_name
		your_name = get_value_from_local_storage("name");
		update_message('Name Saved as ('+your_name+')','form_ok');
		
		return true;
	} catch(e)
	{
		return false;
		update_message('Failed to Save your name','form_error');
	}
}

// get any value back from a localStorage key
function get_value_from_local_storage(key)
{
	try
	{
		return localStorage.getItem(key);
	} catch(e)
	{
		return false;
	}
}

// unset, or remove object from localStorage
function unset_value_from_local_storage(key)
{
	try
	{
		localStorage.removeItem(key);
		window.location = window.location;
	}catch(e)
	{
		alert("Error. "+e);
	}
}

// update the message output
function update_message(message,css_class)
{
	$("#message_output").html(message);
	$("#message_output").removeClass().addClass(class);
}

// once dom is available...
$(document).ready(function()
{
	try
	{
		your_name = get_value_from_local_storage("name");
	} catch(e)
	{
		html_text = '<div class="alt_container"><span id="message_output"></span></div>';
		$("#elem_set_name").html(html_text);
		update_message("Looks like HTML5 LocalStorage is not enabled in your Browser. Please Update to a modern Browser like Firefox 4, Chrome, or Safari, and now even IE9.","form_error");
	}
	
	// if "Check Your Name" is clicked...
	$("#check_name").click(function()
	{
		// check for localStorage object
		// if exists, show name in span #your_name
		// else prompt user to set their name
		//alert("test: your_name="+your_name);
		
		if(your_name != null)
		{
			// localStorage Object was found with value
			html_text = '<div class="alt_container"><span id="message_output"></span><form class="input_gui"><input type="text" id="input_set_your_name" placeholder="update your name" value=""/><input type="submit" onclick="set_value_in_local_storage(\'name\',\'input_set_your_name\'); return false;"/></form></div>';
			$("#elem_set_name").html(html_text);
			update_message("Welcome Back "+your_name+" <a href='javascript:unset_value_from_local_storage(\"name\");'>delete object</a>","form_ok");
		} 
		else
		{
			// prompt user for name, no value found
			html_text = '<div class="alt_container"><span id="message_output"></span><form class="input_gui"><input type="text" id="input_set_your_name" placeholder="set your name" value=""/><input type="submit" onclick="set_value_in_local_storage(\'name\',\'input_set_your_name\'); return false;"/></form></div>';
			
			$("#elem_set_name").html(html_text);
			update_message("There is no local storage object saved with your name.","form_error");
		}
	});
});