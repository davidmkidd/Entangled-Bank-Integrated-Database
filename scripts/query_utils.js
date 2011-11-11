/**
 * 
 */

function checkObjName() {
	// checks query has name and no spaces
	//alert("!");
	var name = document.getElementById('objname');
	//alert(name.value.length);
	if (name.value.length == 0) {
		name.value = "query_name_required";
	} else {
		name.value = name.value.replace(/ /g,"_");
	}
}

function is_int(value){ 
	  if((parseFloat(value) == parseInt(value)) && !isNaN(value)){
	      return true;
	  } else { 
	      return false;
	  } 
	}

function isNumber(n) {
	  return !isNaN(parseFloat(n)) && isFinite(n);
	}

function deleteQuery(id) {
	//alert(id);
	//var item = document.getElementById('qobjid');
	//item.value = id;
	var item = document.getElementById('qobjid');
	item.value = id;
	var item = document.getElementById('stage');
	item.value = 'qdelete';
	document.ebankform.submit();
}


function cancelQuery(id) {
	//alert(id);
	//var item = document.getElementById('qobjid');
	//item.value = id;
	var item = document.getElementById('stage');
	//alert(item.value);
	item.value = 'qcancel';
	//alert(item.value);
	document.ebankform.submit();
}