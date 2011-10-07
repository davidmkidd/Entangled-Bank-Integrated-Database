/**
 * 
 */

function loadScript() {
	
	// loadScript runs body onload
	
	// Make visible checked html_query_biotable divs
	
	for(i=0;i<document.getElementsByTagName("input").length;i++) {
		if(document.getElementsByTagName("input")[i].type == "checkbox") {
			//alert(document.getElementsByTagName("input")[i].checked)
			var chk = document.getElementsByTagName("input")[i];
			if(chk.checked == true) {
				var idx = chk.name.lastIndexOf("_");
				if (chk.name.substring(idx) == "_query") {
					var field = chk.name.substring(0,idx) + "_div";
					//alert(field);
					document.getElementById(field).style.display = 'block';
					//alert(div.id);
				}
			}
		}
	}
}

function newSingleSourceQuery(entry)
{
	//alert(entry);
	var qterm = document.getElementById('qterm');
	qterm.value = entry;
	
/*	    if(document.ebankform.onsubmit &&
    !document.ebankform.onsubmit())
    {
        return;
    }*/
 document.ebankform.submit();
}


function newOutput() {
	var item = document.getElementById('stage');
	item.value = "newoutput";
	//var qterm = document.getElementById('qterm');
	//qterm.value = entry;
	
/*	    if(document.ebankform.onsubmit &&
    !document.ebankform.onsubmit())
    {
        return;
    }*/
 document.ebankform.submit();
}

function deleteOutput(id) {
	var item = document.getElementById('stage');
	item.value = 'outputdelete';
	document.ebankform.submit();
}

function cancelOutput(id) {
	var item = document.getElementById('stage');
	item.value = 'outputcancel';
	document.ebankform.submit();
}

function addOutput(id) {
	document.ebankform.submit();
}

function editOutput(id) {
	var item = document.getElementById('stage');
	item.value = 'setoutput';
	var item = document.getElementById('output_id');
	item.value = id;
	document.ebankform.submit();
}

function returnOutput(n) {
	// RETURNS DATA
	//alert(n);
	if (n == 0) {
		var x=window.confirm("Do you really want all data for outputs? If not, add some queries.")
		if (x) {
			var item = document.getElementById('stage');
			item.value = 'write';
			document.ebankform.submit();
		} else {
			return false;
		}
	} else {
		var item = document.getElementById('stage');
		item.value = 'write';
		document.ebankform.submit();
	}
	

}