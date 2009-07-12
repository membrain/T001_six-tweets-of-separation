/*--------------------------------------------------------------------
  This object declares a namespace in which all the one-off scripts 
  required by the application.
--------------------------------------------------------------------*/

// This is the application object.
var app  = {}


// This function forces focus to the first field of the search form.
app.setFocus = function() {
	var field = $("tweeter1")
	if (field) {
		field.focus();
	}
}



/*--------------------------------------------------------------------
  This call establishes event connections between user actions
  and javascript event handlers.
--------------------------------------------------------------------*/

Event.observe(window, "load", function() {
	
	// Get dom references
	var button = $("commit");
	var result = $("ResultContainer");
	
	// Listen for events from search button
	var fn = function() {
		result.innerHTML = "Loading . . .";
	}
	button.observe("click", fn);
	
	// set initial focus to search field
	app.setFocus();
});
