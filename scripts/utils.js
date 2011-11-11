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

function deleteAllOutputs() {
	var item = document.getElementById('stage');
	item.value = 'outputdeleteall';
	document.ebankform.submit();
}

function deleteAllQueries() {
	var item = document.getElementById('stage');
	item.value = 'querydeleteall';
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

function addBiotableOutput(id) {
	var item = document.getElementById('fields_add');
	for (var i = 0; i < item.length; i++) {
		item.options[i].selected = true;
	}
	document.ebankform.submit();
}

function editQuery(id) {
	// Opens query for editing
	var item = document.getElementById('stage');
	//alert(item.value);
	item.value = 'qedit';
	var item = document.getElementById('qedit_objid');
	item.value = id;
/*	    if(document.ebankform.onsubmit &&
    !document.ebankform.onsubmit())
    {
        return;
    }*/
 document.ebankform.submit();
	
}


function editOutput(id) {
	var item = document.getElementById('stage');
	item.value = 'setoutput';
	//alert (item.value);
	var item = document.getElementById('output_id');
	item.value = id;
	//alert (item.value);
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

function submitForm (id) {
	//alert(id);
	var stage = document.getElementById('stage');
	stage.value = id;
	document.ebankform.submit();
}

function submitQuery(id) {
	//alert(id);
	var qterm = document.getElementById('qterm');
	qterm.value = id;
	document.ebankform.submit();
}


function textareaFormat(id) {
	
	//	Adds/removes double quotes from textbox
	var item = document.getElementById(id);
	var str = item.value;
	//alert(id);
	
	switch (id) {
		case 'names_list':
			sel_item = 'names_format';
			break;
		case 'series_list':
			sel_item = 'series_format';
			break;
	} 
	
	var sel = document.getElementById(sel_item);
	
	switch (sel.value) {
		case '0':
			// commas to new line
			var rx = new RegExp( ',', "g" )
			str = str.replace(rx, "\n");
			rx = null;
			// remove quotes
			var rx = new RegExp( '"', "g" )
			str = str.replace(rx, "");
			break;
		case '1':
			// Delineate
			var rx = new RegExp( '"', "g" )
			str = str.replace(rx, "");			
			var rx = new RegExp( "\\n", "g" )
			str = str.replace(rx, "\"\n\"");
			str = '"' + str + '"';
			rx = null;
			// new line
			var rx = new RegExp( ',', "g" )
			str = str.replace(rx, "\n");
			break;
		case '2':
			// comma
			var rx = new RegExp( "\\n", "g" )
			str = str.replace(rx, ",");
			str = '"' + str + '"';
			rx = null;
			// remove quotes
			var rx = new RegExp( '"', "g" )
			str = str.replace(rx, "");
			break;
		case '3':
			// comma
			var rx = new RegExp( "\\n", "g" )
			str = str.replace(rx, ",");
			str = '"' + str + '"';
			rx = null;
			// delineate
			var rx = new RegExp( '"', "g" )
			str = str.replace(rx, "");
			rx = null;
			var rx = new RegExp( ",", "g" )
			str = str.replace(rx, "\",\"");
			str = '"' + str + '"';
			break;	
	
	}
	item.value = str;
}

/**
 * Utilities for html_query_tree
 */

function findSourceNames() {
	
	// Adds find names returns to names textarea
	//alert("!");
	var findval = document.getElementById('findval');
	var sources = document.getElementsByName('qsources[]');
	var n = document.getElementById('nsources');
	var op = document.getElementById('noperator');
	var names = document.getElementById('names');
	var ebpath = document.getElementById('eb_path');
	
	var sids = '';
	var str = '';
	var c = 0;
	//alert(ebpath);
	
	for (var i = 0; i <= sources.length - 1; i++) {
		if (sources[i].checked == true) {
			if (c > 0) {
				sids = sids + '+';
			}
			sids = sids + sources[i].value;
			c++;
		}
	}

	var url = ebpath.value + "api/sourcenames.php?sids=" + sids;
	url = url + '&query=' + findval.value + '&n=' + n.value + '&op=\'' + op.value + '\'';
	
	var request = new XMLHttpRequest();
	request.open("GET", url , false);
	request.send(null);
		
	if (request.status != 200) {
		alert("Error " + request.status + ": " + request.statusText);
	} else {
		var data = request.responseText;
		names.options.length = 0;
		var ret = JSON.parse(data);
		//alert(ret);
		if (ret.length > 0) {
			for (var i = 0; i <= ret.length - 1; i++) {
			label = ret[i].replace(/["']{1}/gi,"");
			label = label.substring(1, label.length - 1);
			names.options[i] = new Option(label, label);
			}
		}
		names.title = ret.length + " names found";
		document.getElementById('findval_label').innerHTML = ' - ' + ret.length + ' names found';
	}
	}


function checkAllNames() {
	//alert("!");
	
	if (document.getElementById("allnames").checked == true) {
		document.getElementById("taxa").disabled = true;
		if (document.getElementById("invalid_taxa")) document.getElementById("invalid_taxa").disabled = true;
		//alert(document.getElementById("names").disabled);
		document.getElementById("names").disabled = true;
		//alert(document.getElementById("names").disabled);
		document.getElementById("findval").disabled = true;
		document.getElementById("findbtn").disabled = true;
		document.getElementById("names_add").disabled = true;
		document.getElementById("names_clear").disabled = true;
	} else {
		document.getElementById("taxa").disabled = false;
		if (document.getElementById("invalid_taxa")) document.getElementById("invalid_taxa").disabled = false;
		document.getElementById("findval").disabled = false;
		document.getElementById("findbtn").disabled = false;
		document.getElementById("names").disabled = false;
		document.getElementById("names_add").disabled = false;
		document.getElementById("names_clear").disabled = false;
	}
}


function namesAdd() {
	var names = document.getElementById('names');
	var taxa = document.getElementById('taxa');
	var sel = new Array();
	
	for (var i = 0; i <= names.length - 1; i++) {
		if (names.options[i].selected == true) {
			sel.push(names.options[i].value);
		}
	}
	// Check if in taxa, add if not
	// Parse for commas
	if (taxa.value.length == 0) {
		for (var i = 0; i <= sel.length - 1; i++) {
			if (i > 0) taxa.value = taxa.value + '\n';
			taxa.value = taxa.value + sel[i];
		}
	} else {
		var in_taxa = taxa.value.split(',');
		for (var i = 0; i <= sel.length - 1; i++){
			var match = false;
			for (j = 0; j <= in_taxa.length -1; j++) {
				if (sel[i] == in_taxa[j]) match = true;
			}
			if (match == false) taxa.value = taxa.value + '\n' + sel[i];
		}
	}
}

function namesAddAll() {
	var names = document.getElementById('names');
	var taxa = document.getElementById('taxa');
	var sel = new Array();
	
	for (var i = 0; i <= names.length - 1; i++) {
			sel.push(names.options[i].value);
	}
	//alert(sel.length);
	// Check if in taxa, add if not
	// Parse for commas
	if (taxa.value.length == 0) {
		for (var i = 0; i <= sel.length - 1; i++) {
			if (i > 0) taxa.value = taxa.value + '\n';
			taxa.value = taxa.value + sel[i];
		}
	} else {
		var in_taxa = taxa.value.split(',');
		for (var i = 0; i <= sel.length - 1; i++){
			var match = false;
			for (j = 0; j <= in_taxa.length -1; j++) {
				if (sel[i] == in_taxa[j]) match = true;
			}
			if (match == false) taxa.value = taxa.value + '\n' + sel[i];
		}
	}
}


function namesClear(){
	document.getElementById('taxa').value = '';
}


function submitNamesQuery(id) {
	
	//alert(document.getElementById('taxa').value.length);
	//alert(document.getElementById('invalid_taxa' + ', ' + document.getElementById('invalid_taxa').value.length));
	
	//Check text in names
	if (document.getElementById('taxa').value.length != 0) {
		// Add lastaction values
		//alert('taxa length: ' + document.getElementById('taxa').value.length);
		document.getElementById('lastaction').value = 'run';
		document.getElementById('lastid').value = id;
		document.ebankform.submit();
	} else {
		if (document.getElementById('invalid_taxa')) {
			if (document.getElementById('invalid_taxa').value.length == 0) {
				document.getElementById('findval_label').innerHTML = 'No text to search on';
				return false;
			} else {
				//alert('taxa length: 0, invalid_taxa: ' + document.getElementById('invalid_taxa').value.length);
				document.getElementById('lastaction').value = 'run';
				document.getElementById('lastid').value = id;
				document.ebankform.submit();				
			}
		} else {
			//alert('taxa length: 0, no invalid_taxa');
			document.getElementById('findval_label').innerHTML = 'No text to search on';
			return false;
		}
	}
}

function submitTemporalQuery(id) {
	document.getElementById('lastaction').value = 'run';
	document.getElementById('lastid').value = id;
	document.ebankform.submit();	
}


function sqlDisplay() {
	
	//
	//alert(document.getElementById('sql'));
	// CHANGES SQL QUERY DISPLAYED 
	var idx = document.getElementById('sql').selectedIndex;
	//alert(idx);
	var val = document.getElementById('sql').options[idx].value;
	//alert(val);
	document.getElementById('sqltext').value = document.getElementById(val).value;
	//alert (document.getElementById('sqltext').text);
}
