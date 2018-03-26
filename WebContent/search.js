/*
 * CS 122B Project 4. Autocomplete Example.
 * 
 * This Javascript code uses this library: https://github.com/devbridge/jQuery-Autocomplete
 * 
 * This example implements the basic features of the autocomplete search, features that are 
 *   not implemented are mostly marked as "TODO" in the codebase as a suggestion of how to implement them.
 * 
 * To read this code, start from the line "$('#autocomplete').autocomplete" and follow the callback functions.
 * 
 */


/*
 * This function is called by the library when it needs to lookup a query.
 * 
 * The parameter query is the query string.
 * The doneCallback is a callback function provided by the library, after you get the
 *   suggestion list from AJAX, you need to call this function to let the library know.
 */

var queryMap = new HashMap();


function handleLookup(query, doneCallback) {

	// TODO: if you want to check past query results first, you can do it here
	if(queryMap.containsKey(query)) {
		var jsonData = queryMap.get(query);
		console.log("Using cached data in frontend. Current map size: " + queryMap.size());
		doneCallback( { suggestions: jsonData } );
		return
	}

	
	console.log("Sending AJAX request to backend Java Servlet")
	console.log("query: " + query)
	
	
	// sending the HTTP GET request to the Java Servlet endpoint hero-suggestion
	// with the query data
	jQuery.ajax({
		"method": "GET",
		// generate the request url from the query.
		// escape the query string to avoid errors caused by special characters 
		"url": "/cs122b-winter18-team-44/servlet/Search?query=" + escape(query),
		"success": function(data) {
			// pass the data, query, and doneCallback function into the success handler
			handleLookupAjaxSuccess(data, query, doneCallback) 
		},
		"error": function(errorData) {
			console.log("lookup ajax error")
			console.log(errorData)
		}
	})
}


/*
 * This function is used to handle the ajax success callback function.
 * It is called by our own code upon the success of the AJAX request
 * 
 * data is the JSON data string you get from your Java Servlet
 * 
 */
function handleLookupAjaxSuccess(data, query, doneCallback) {
	console.log("lookup ajax successful")
	console.log("data:" + data)
	console.log(query)
	// parse the string into JSON
	var jsonData = JSON.parse(data);
	console.log(jsonData)
	
	// TODO: if you want to cache the result into a global variable you can do it here	
	if(!queryMap.containsKey(query)) {
		queryMap.put(query, jsonData);
	}
	
	
	// call the callback function provided by the autocomplete library
	// add "{suggestions: jsonData}" to satisfy the library response format according to
	//   the "Response Format" section in documentation
	doneCallback( { suggestions: jsonData } );
}


/*
 * This function is the select suggestion handler function. 
 * When a suggestion is selected, this function is called by the library.
 * 
 * You can redirect to the page you want using the suggestion data.
 */
function handleSelectSuggestion(suggestion) {
	// TODO: jump to the specific result page based on the selected suggestion
	
	console.log("you select " + suggestion["value"])
//	console.log("----------------------")
//	console.log(suggestion["data"]["category"])
//	console.log(suggestion["data"]["ID"])
	
	var category = suggestion["data"]["category"]
	if(category == "Movies"){		
		var movieid = suggestion["data"]["ID"]
		window.location.href="/cs122b-winter18-team-44/singlemovie.jsp?movieid=" + movieid
	}else if(category == "Stars"){	
		var starid = suggestion["data"]["ID"]
		window.location.href="/cs122b-winter18-team-44/singlestar.jsp?starid=" + starid
	}else{
		console.log("Wrong category info")
	}

}


/*
 * This statement binds the autocomplete library with the input box element and 
 *   sets necessary parameters of the library.
 * 
 * The library documentation can be find here: 
 *   https://github.com/devbridge/jQuery-Autocomplete
 *   https://www.devbridge.com/sourcery/components/jquery-autocomplete/
 * 
 */
// $('#autocomplete') is to find element by the ID "autocomplete"
$('#autocomplete').autocomplete({
	// documentation of the lookup function can be found under the "Custom lookup function" section
    lookup: function (query, doneCallback) {
    		handleLookup(query, doneCallback)
    },
    onSelect: function(suggestion) {
    		handleSelectSuggestion(suggestion)
    },
    // set the groupby name in the response json data field
    groupBy: "category",
    // set delay time
    deferRequestBy: 300,
    // there are some other parameters that you might want to use to satisfy all the requirements
    // TODO: add other parameters, such as mininum characters
    minChars: 3,
    lookupLimit: 10,
});


/*
 * do normal full text search if no suggestion is selected 
 */
function handleNormalSearch(query) {
	console.log("doing normal search with query: " + query);
	// TODO: you should do normal search here
	
	if(query.length < 3) {
		console.log("Query length is less than three letters")
		return
	}
	
	jQuery.ajax({
		"method": "GET",
		// generate the request url from the query.
		// escape the query string to avoid errors caused by special characters 
		"url": "/cs122b-winter18-team-44/servlet/Search?query=" + escape(query),
		"success": function(data) {
			// jump to movielist page
			console.log(">>>>>>>>>>>>>>>>")
//			var category = data["data"]["category"] 
			if(query.length >= 3) {
				window.location.href="/cs122b-winter18-team-44/main.jsp?query=" + query
			}
		},
		"error": function(errorData) {
			console.log("lookup ajax error")
			console.log(errorData)
		}
	})
	
}

// bind pressing enter key to a hanlder function
$('#autocomplete').keypress(function(event) {
	// keyCode 13 is the enter key
	if (event.keyCode == 13) {
		// pass the value of the input box to the hanlder function
		handleNormalSearch($('#autocomplete').val())
	}
})

// TODO: if you have a "search" button, you may want to bind the onClick event as well of that button

function HashMap(){  
 
    var length = 0;   
    var obj = new Object();  
  
    /** 
    * check if size is 0
    */  
    this.isEmpty = function(){  
        return length == 0;  
    };  
  
    /** 
    * check if the map contains the key 
    */  
    this.containsKey=function(key){  
        return (key in obj);  
    };  
  
    /** 
    * check if the map contains the value 
    */  
    this.containsValue=function(value){  
        for(var key in obj){  
            if(obj[key] == value){  
                return true;  
            }  
        }  
        return false;  
    };  
  
    /** 
    *insert (key, value) pair
    */  
    this.put=function(key,value){  
        if(!this.containsKey(key)){  
            length++;  
        }  
        obj[key] = value;  
    };  
  
    /** 
    * return the value associated with key 
    */  
    this.get=function(key){  
        return this.containsKey(key)?obj[key]:null;  
    };  
  
    /** 
    * delete the value associated with the key 
    */  
    this.remove=function(key){  
        if(this.containsKey(key)&&(delete obj[key])){  
            length--;  
        }  
    };  
  
    /** 
    * return all the values 
    */  
    this.values=function(){  
        var _values= new Array();  
        for(var key in obj){  
            _values.push(obj[key]);  
        }  
        return _values;  
    };  
  
    /** 
    * return all the keys
    */  
    this.keySet=function(){  
        var _keys = new Array();  
        for(var key in obj){  
            _keys.push(key);  
        }  
        return _keys;  
    };  
  
    /** 
    * return the size of map 
    */  
    this.size = function(){  
        return length;  
    };  
  
    /** 
    * clear the map 
    */  
    this.clear = function(){  
        length = 0;  
        obj = new Object();  
    };  
}  

