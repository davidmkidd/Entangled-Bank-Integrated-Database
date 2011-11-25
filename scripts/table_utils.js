/**
 * Utility scripts for Entangled Bank
 */

//--------------------------------------------------------------------------------------------

	function validateRangeField(entry) {
		
		// VALIDATES RANGE FIELD ENTRIES
		// Checks entry is numeric and from less than to
		
		var item = entry.substring(0, entry.length - 4);
		var val_item = document.getElementById(item + "_value");
		var op_item = document.getElementById(item + "_opertator");
		
		if (!isNumber(val_item.value)) {
			alert ("Value for " + item + " must be numeric!");
			return null;
		}
		
	}
	
//--------------------------------------------------------------------------------------------
	
	
function showNumericField(entry) {
		
		// OPENS AND ACTIVATES FIELD DIALOG DIV
		
		var field = entry.name;
		field = field.substring(0,field.length - 6);
		var div = document.getElementById(field + "_div");
		var type = document.getElementById(field + "_type").value;
		var sid = document.getElementById('sid').value;
		var objInput = document.getElementById(field + "_operator");
		
		if (!objInput) {
			
			var objSelect = document.createElement("select");
			objSelect.name = field + "_operator";
			objSelect.id = field + "_operator";
			
			if(field == 'nseries') {
				var items = [">=","=","<="];
			} else {
				var items = [">",">=","<","<="];
			}

			for (var i=0; i <= items.length - 1; i++) {
				var objOption = document.createElement("option");
				objOption.text = items[i];
				objOption.value = items[i];
				objSelect.add(objOption);
			}
			
			var ftype = getFieldType(sid, field);
			//alert(ftype);
			var val = getNumericField(sid, field, 'no');
			var val_names = getNumericField(sid, field, 'yes');
			
			var objInput = document.createElement("input");
			objInput.name = field + "_value";
			objInput.id = field + "_value";
			var input = (Number(val[0]) + Number(val[1])) /2;
			if (ftype.ftype == 'integer')  {
				input = Math.round(input);
			}
			objInput.value = input;
			objInput.text = input;
			
			var objLabel = document.createElement("label");
			var str = "&nbsp;";
			if (Number(val[0]) != Number(val_names[0])) {
				str = str + "[" + val_names[0] + "]";
			}
			str = str + val[0] + "&nbsp;-&nbsp;" + val[1];
			if (Number(val[1]) != Number(val_names[1])) {
				str = str + "[" + val_names[1] + "]";
			}

			objLabel.innerHTML = str;
			objLabel.id = field + "_label";
			
			div.appendChild(objSelect);
			div.appendChild(objInput);
			div.appendChild(objLabel);
		}

		if (entry.checked == true){
			div.style.display='block';
			if (objInput) {
				objInput.disabled=false;
				objInput.disabled=false;
			}
		} else {
			div.style.display='none';
			if (objSelect) {
				objSelect.disabled=true;
				objSelect.disabled=true;				
			}
		}		
	}
	
//--------------------------------------------------------------------------------------------


function showCatagoryField(entry) {
		
		// OPENS AND ACTIVATES FIELD DIALOG DIV
		
		var field = entry.name;
		field = field.substring(0,field.length - 6);
		var div = document.getElementById(field + "_div");
		var type = document.getElementById(field + "_type").value;
		var sid = document.getElementById('sid').value;
		var selOptions = document.getElementById(field + "_add");
		
		if (!selOptions) {
			
			// FILTER
			var ftable = document.createElement("table");
			var frow = document.createElement("tr");
			var fcell = new Array();
			fcell[0] =	document.createElement("td");
			var find = document.createElement('input');
			find.id = field + "_findval";
			find.className = 'eb';
			fcell[0].appendChild(find);
			
			fcell[1] =	document.createElement("td");
			var findButton = document.createElement('input');
			findButton.id = field + "_findbtn";
			findButton.type = 'button';
			findButton.value = 'Filter';
			findButton.className = 'button-standard';
			findButton.onclick = function(){addSourceFieldValues(field);}; 
			fcell[1].appendChild(findButton);
			
			fcell[2] =	document.createElement("td");
			var findLabel = document.createElement('label');
			findLabel.id = field + "_findval_label";
			findLabel.innerHTML = "&nbsp;&nbsp;0 found | 0 in query";
			fcell[2].appendChild(findLabel);
			
			for (i = 0; i <= fcell.length - 1; i++) {
				frow.appendChild(fcell[i]);
			}
			
			ftable.appendChild(frow);
			div.appendChild(ftable)		
			
			// SELECT VALUES
			var table = document.createElement("table");
			var row = document.createElement('tr');
			
			var selOptions = document.createElement("select");
			selOptions.id = field;
			selOptions.className = 'query_options';
			selOptions.multiple = true;
			selOptions.size = 8;
					
			var cell = new Array();
			cell[0] = document.createElement('td');
			cell[0].appendChild(selOptions);
			
			//BUTTONS
			cell[1] = document.createElement('td');
			var buttonId = ['_____in','__allin','_allout','____out'];
			var buttonText = ['>','>>','<<','<'];
			for (i = 0; i <= buttonId.length - 1; i++) {
				var btn = document.createElement('input');
				btn.id = field + buttonId[i];
				btn.type = 'button'
				btn.value = buttonText[i];
				switch (buttonId[i]) {
					case '_____in':
						btn.onclick = function(){add_sel(this);};
						break;
					case '__allin':
						btn.onclick = function(){add_all(this);};
						break;
					case '_allout':
						btn.onclick = function(){rem_all(this);};
						break;
					case '____out':
						btn.onclick = function(){rem_sel(this);};
						break;
				}
				
				btn.className = 'button-standard';
				cell[1].appendChild(btn);
				cell[1].appendChild(document.createElement('br'));
			}
			
			// SELECT_ADD
			var selAdd = document.createElement("select");
			selAdd.id = field + "_add";
			selAdd.name = field + "_add[]";
			selAdd.className = 'query_options';
			selAdd.multiple = true;
			selAdd.size = 8;
			cell[2] = document.createElement('td');
			cell[2].appendChild(selAdd);
			
			for (i = 0; i <= cell.length - 1; i++) {
				row.appendChild(cell[i]);
			}
			table.appendChild(row);
			div.appendChild(table);
		}

		// VISIBILITY
		if (entry.checked == true){
			div.style.display='block';
			if (selOptions) {
				selOptions.disabled=false;
				selAdd.disabled=false;
			}
		} else {
			div.style.display='none';
			if (objSelect) {
				selOptions.disabled=true;
				selAdd.disabled=true;				
			}
		}		
	}


//--------------------------------------------------------------------------------------------

	function getNumericField(sid, field, names) {
		
		if (!names) names = 'no';
		if (names != 'yes') names = 'no';
		
		//Returns Maximum and Minimum for numeric fields
		
		//var findval = document.getElementById(field + '_findval');
		var ebpath = document.getElementById('eb_path');
		
		url = ebpath.value + "api/source_numericfield_range.php?sid=" + sid + 
		"&field=" + field + "&names=" + names;
	
		alert(url);
		var request = new XMLHttpRequest();
		request.open("GET", url , false);
		request.send(null);
		
		//alert(request.status);
		if (request.status != 200) {
			alert("Error " + request.status + ": " + request.statusText);
			return false;
		} else {
			var data = request.responseText;
			var ret = JSON.parse(data);
			return ret;
		}
		
	}

//--------------------------------------------------------------------------------------------

	function getFieldType(sid, field) {
	
		//FIELD TYPE
		var ebpath = document.getElementById('eb_path');
		url = ebpath.value + "api/source_field_type.php?sid=" + sid + 
		"&field=" + field;
		//alert(url);
		var request = new XMLHttpRequest();
		request.open("GET", url , false);
		request.send(null);
		
		//alert(request.status);
		if (request.status != 200) {
			alert("Error " + request.status + ": " + request.statusText);
			return false;
		} else {
			var data = request.responseText;
			var ret = JSON.parse(data);
			return ret;
		}
	}

//--------------------------------------------------------------------------------------------
	
	function updateInfo(field) {
		
		// UPDATES FIELD INFO
		var lab = document.getElementById(field + "_findval_label");
		var found = document.getElementById(field).length;
		var query = document.getElementById(field + "_add").length;
		lab.innerHTML = '&nbsp;' + found + ' found | ' + query + ' in query';
	}

//--------------------------------------------------------------------------------------------


function addSourceFieldValues(field) {
	
	// ADDS FILTER RESULTS
	cursor_wait();
	items = getSourceFieldValues(field);
	var field_element = document.getElementById(field);
	field_element.length = 0;
	for (i=0; i <= items.length - 1; i++ ) {
		var objOption = document.createElement("option");
		objOption.text = items[i];
		objOption.value = items[i];
		field_element.add(objOption);
	}
	updateInfo(field);
	cursor_clear();
	return;
	
}

//--------------------------------------------------------------------------------------------

function getSourceFieldValues(field) {
	
		//alert(field);
		//RETURNS DISTINCT NAMES IN A FIELD
		var ebpath = document.getElementById('eb_path');
		var sid = document.getElementById('sid').value;
		var findval = document.getElementById(field + '_findval').value;
		
		url = ebpath.value + "api/source_catagoryfield_values.php?sid=" + sid + 
		"&field=" + field + "&query=" + findval;
	
		//alert(url);
		var request = new XMLHttpRequest();
		request.open("GET", url , false);
		request.send(null);
		
		//alert(request.status);
		if (request.status != 200) {
			alert("Error " + request.status + ": " + request.statusText);
			return false;
		} else {
			var data = request.responseText;
			var ret = JSON.parse(data);
			return ret;
		}
}
	
//--------------------------------------------------------------------------------------------

	
	function checkfield(entry) {
		// enables-disables field items in html_table_query2
		var field = entry.name;
		field = field.substring(0,field.length - 6);
		
		var field_min = document.getElementById(field + "_min");
		var field_max = document.getElementById(field + "_max");
		
		if (entry.checked == true){
			field_min.disabled=false;
			field_max.disabled=false;
		} else {
			field_min.disabled=true;
			field_max.disabled=true;
		}
	}
	
	
	
	function checkboxes(entry) {
		// enables-disables checkbox items in html_table_query2
		var field = entry.name;
		field = field.substring(0,field.length - 6) + "_chk";
		var boxes = document.getElementsByName(field);
		
		if (entry.checked == true){
			for (var i = 0; i < boxes.length; i++) {
			boxes[i].disabled=false;
			}
		} else {
			for (var i = 0; i < boxes.length; i++) {
			boxes[i].disabled=true;
			}
		}
	}
	
	function checkselect(entry) {
		// enables/disables select option items in html_table_query2
		var field = entry.name;
		field = field.substring(0,field.length - 6);
		var elements = document.getElementsByName(field);
		alert(field + "_div");
		var div = document.getElementById(field + "_div");
		
		for (var i = 0; i < elements.length; i++) {
				if (entry.checked == true){
					elements[i].disabled=false;
					div.style.visibility="visible";
				} else {
					elements[i].disabled=true;
					div.style.visibility="collapse";
				}
			}
	}
	
	function add_sel(entry) {
		
		// Pushes from field select to field_add select
		var field = entry.id;
		//alert(field);
		field = field.substring(0,field.length - 7);
		var box = document.getElementById(field);
		var selected = new Array();
		var selected_vals = new Array();
		for (var i = 0; i < box.options.length; i++) {
			if (box.options[ i ].selected) {
		    	selected_vals.push(box.options[ i ].value);
		    	selected.push(box.options[ i ].innerHTML);
		    	//alert("pushed" + box.options[ i ].innerHTML);
		    }
		}

		field_add = field + "_add";
		var addbox = document.getElementById(field_add);

		//Get entries in add box
		var existing = new Array();
		for (var i = 0; i < addbox.options.length; i++) {
			existing.push(addbox.options[ i ].value);
			//alert("adding " + addbox.options[ i ].values);
		}
		
		for (var i = 0; i < selected.length; i++) {
		  //alert(selected[i]);
			if (isValueInArray(existing, selected_vals[i]) == false){
				try {
					addbox.add(new Option(selected[i], selected_vals[i]), null); // standards compliant; doesn't work in IE
				} catch(ex) {
					addbox.add(selected[i].value); // IE only NOT WORKING
				}
			}
		}
		updateInfo(field)
	}
	
	function add_all(entry) {
		
		// Pushes from field select to field_add select
		var field = entry.id;
		field = field.substring(0,field.length - 7);
		var box = document.getElementById(field);
		var selected = new Array();
		var selected_vals = new Array();
		for (var i = 0; i < box.options.length; i++) {
			selected_vals.push(box.options[ i ].value);
		    selected.push(box.options[ i ].innerHTML);
		    box.options[i]
		  }

		field_add = field + "_add";
		var addbox = document.getElementById(field_add);
		
		for (var i = 0; i < selected.length; i++) {
			try {
				addbox.add(new Option(selected[i], selected_vals[i]), null); // standards compliant; doesn't work in IE
			} catch(ex) {
				addbox.add(selected[i].value); // IE only NOT WORKING
			}
		}
		updateInfo(field)
	}
	
	function rem_sel(entry) {
		// Remove selected from field_add select
		var field = entry.id;
		field = field.substring(0,field.length - 7);
		field_add = field + "_add";
		var box = document.getElementById(field_add);
		for (var i = 0; i < box.options.length; i++) {
			if (box.options[i].selected == true) {
				box.remove(i); 
			}
		}
		updateInfo(field)
	}	
	
	function rem_all(entry) {
		// Remove all from field_add select
		var field = entry.id;
		field = field.substring(0,field.length - 7);
		field_add = field + "_add";
		var box = document.getElementById(field_add);
		for (var i = 0; i < box.options.length; i++) {
			box.length = 0;
		}
		updateInfo(field)
	}
	
	
	function show_nseries(entry) {
		var element = document.getElementById("nseries_div")
		if (entry.checked == true) {
			document.getElementById("nseries_div").style.display='block';
			} else {
			document.getElementById("nseries_div").style.display='none';
			}
	}
	
	function isValueInArray(arr, val) { for (i = 0; i < arr.length; i++) if (val == arr[i]) return true; return false; }
	
	
	function getElementsByClass(searchClass,node,tag) {

		//alert(searchClass);
		var classElements = new Array();

		if ( node == null )
			node = document;

		if ( tag == null )
			tag = '*';

		var els = node.getElementsByTagName(tag);
		var elsLen = els.length;
		var pattern = new RegExp("(^|\\s)"+searchClass+"(\\s|$)");

		for (i = 0, j = 0; i < elsLen; i++) {
			if ( pattern.test(els[i].className) ) {
				classElements[j] = els[i];
				j++;
			}

		}
		return classElements;
	}
	
	
	