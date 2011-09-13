/**
 * 
 */

function validate_date (entry){
	//Function validates date from and to selections
	var field = entry.name;

}


function noFinish () {
	
	// Enable/Disable FINISH OPERATOR
	var item = document.getElementById("t_to_overlay");
	if (item.disabled == false) {
		item.disabled = true;
	} else {
		item.disabled = false;
	}
	
	var item = document.getElementById("to_day");
	if (item.disabled == false) {
		item.disabled = true;
	} else {
		item.disabled = false;
	}

	var item = document.getElementById("to_month");
	if (item.disabled == false) {
		item.disabled = true;
	} else {
		item.disabled = false;
	}
	
	var item = document.getElementById("to_year");
	if (item.disabled == false) {
		item.disabled = true;
	} else {
		item.disabled = false;
	}
	

	
}