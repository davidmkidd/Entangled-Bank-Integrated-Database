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

	var field = entry.name;
	field = field.substring(0,field.length - 6);
	var div = document.getElementById(field + "_div");
	
	if (entry.checked == false) {
		div.style.display='none';
		if (objSelect) {
			op.disabled=true;
			value.disabled=true;				
		}
	} else {
	
		// OPENS AND ACTIVATES FIELD DIALOG DIV

		var type = document.getElementById(field + "_type").value;
		var sid = document.getElementById('sid').value;
		var ftable = document.getElementById(field + "_table");
		var op = document.getElementById(field + "_operator");
		
		
		if (!ftable) {

			// CREATES ROW IN TABLE BELOW GROUP
			// ORDERED BY FIELD LIST
			
			var ftype = getFieldType(sid, field);
			var color = getFieldColor(sid, ftype.group);
			var ftable = document.createElement("table");
			ftable.id = field + '_table';
			ftable.className = 'field_table';

			var row = document.createElement("tr");
			var cell = new Array();
			
			// FIELD NAME
			cell[0] = document.createElement("td");
			//cell[0].className = 'field_title';
			cell[0].style.backgroundColor = color;
			var textNode = document.createTextNode(ftype.alias);
			cell[0].appendChild(textNode);		
			
			// OPERATION
			var op = document.createElement("select");
			op.name = field + "_operator";
			op.id = field + "_operator";
			
			var items = [">",">=","=","<","<="];
			for (var i=0; i <= items.length - 1; i++) {
				var opt = document.createElement("option");
				opt.text = items[i];
				opt.value = items[i];
				op.add(opt);
			}

			// VALUE
			var val = getNumericField(sid, field, 'no');
			var val_null = getNumericFieldNull(sid, field, 'no');
			
			var value = document.createElement("input");
			value.name = field + "_value";
			value.id = field + "_value";
			value.className = 'eb_range_input';
			var input = (Number(val[0]) + Number(val[1])) /2;
			if (ftype.ftype == 'integer')  {
				input = Math.round(input);
			}
			value.value = input;
			value.text = input;
			
			if (val_null == true) {
				var nullvals = document.createElement("input");
				nullvals.name = field + "_null";
				nullvals.id = field + "_null";
				nullvals.type = 'checkbox';
				nullvals.title = 'Check to return with NULL values';
				var textNull = document.createTextNode(' nulls');
			}

			cell[1] = document.createElement("td");	
			cell[1].style.backgroundColor = color;
			cell[1].className = 'query_field_values';
			cell[1].appendChild(op);
			cell[1].appendChild(value);
			
			if (textNull) {
				//cell[1].appendChild(textNull);
				cell[1].appendChild(nullvals);
			}
			
			// ERR LABEL
			var errlabel = document.createElement("label");
			errlabel.id = field + "_errlabel";
			errlabel.className = 'error';
			errlabel.innerHTML = '';
			//alert(errlabel);
			cell[1].appendChild(errlabel);
			
			// LABEL
			cell[2] = document.createElement("td");		
			var label = document.createElement("label");
			var str = 'from ' + val[0] + "&nbsp;to&nbsp;" + val[1];
			label.innerHTML = str;
			label.id = field + "_label";
			cell[2].appendChild(label);
			
			row.appendChild(cell[0]);
			row.appendChild(cell[1]);
			row.appendChild(cell[2]);
			ftable.appendChild(row);
			div.appendChild(ftable);
		}
		
		// DISABLED
		div.style.display='block';
		if (op) {
			op.disabled=false;
			value.disabled=false;
		}
	}	
}
	
//--------------------------------------------------------------------------------------------


function showCatagoryField(entry) {
		
	// ADDS CATAGORY FIELD DIALOG
	
	var field = entry.name;
	field = field.substring(0,field.length - 6);
	var div = document.getElementById(field + "_div");
	
	if (entry.checked == false) {
		div.style.display='none';
		if (objSelect) {
			selOptions.disabled=true;
			selAdd.disabled=true;				
		}
	
	} else {
	
		// OPENS AND ACTIVATES FIELD DIALOG DIV
		var type = document.getElementById(field + "_type").value;
		var sid = document.getElementById('sid').value;
		var selOptions = document.getElementById(field + "_add");
		var table = document.getElementById(field + "_table");
		
		if (!table) {
			
			var ftype = getFieldType(sid, field);
			var color = getFieldColor(sid, ftype.group);
			
			// FIELD NAME
			var table = document.createElement("table");
			table.id = field + '_table';
			table.className = 'field_table';
			table.style.backgroundColor = color;
			//table.style.borderTop = '1px solid grey';
			
			var row = document.createElement("tr");
			var th = document.createElement("th");
			th.innerHTML = ftype.alias;
			th.rowSpan = '2';
			th.className = 'field_title';
			th.style.backgroundColor = color;
			row.appendChild(th);
			
			// FIND ROW
			var cell = new Array();
			cell[0] = document.createElement("td");
			cell[0].className = 'eb'
			var find = document.createElement('input');
			find.id = field + "_findval";
			find.className = 'eb_find';
			cell[0].appendChild(find);
			
			var null_vals = document.createElement('input');
			null_vals.id = field + "_null";
			null_vals.type = 'checkbox';
			
			null_vals.title = 'include nulls';
			var val_null = getCatagoryFieldNull(sid, field, 'no');
			//alert(val_null);
			if (val_null == 't') {
				null_vals.checked = true;
				null_vals.disabled = false;
			} else {
				null_vals.checked = false;
				null_vals.disabled = true;			
			}

			cell[0].appendChild(null_vals);
			
			
			cell[1] = document.createElement("td");
			var findButton = document.createElement('input');
			findButton.id = field + "_findbtn";
			findButton.type = 'button';
			findButton.value = 'Find';
			findButton.className = 'button-standard';
			findButton.onclick = function(){addCatagoryFieldValues(field);}; 
			cell[1].appendChild(findButton);

			cell[2] = document.createElement("td");
			cell[2].className = "findval_label";
			var findLabel = document.createElement('label');
			findLabel.id = field + "_findval_label";
			findLabel.innerHTML = "&nbsp;&nbsp;0 found | 0 in query";
			cell[2].appendChild(findLabel);
			
			for (i = 0; i <= cell.length - 1; i++) {
				row.appendChild(cell[i]);
			}
			
			// SELECT VALUES
			var srow = document.createElement('tr');
			
			var selOptions = document.createElement("select");
			selOptions.id = field;
			selOptions.className = 'query_options';
			selOptions.multiple = true;
			selOptions.size = 6;
					
			var scell = new Array();
			scell[0] = document.createElement('td');
			//scell[0].style.border = '1px solid grey';
			scell[0].appendChild(selOptions);
			
			// BUTTONS
			scell[1] = document.createElement('td');
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
				scell[1].appendChild(btn);
				scell[1].appendChild(document.createElement('br'));
			}
			
			// SELECT_ADD
			var selAdd = document.createElement("select");
			selAdd.id = field + "_add";
			selAdd.name = field + "_add[]";
			selAdd.className = 'query_options';
			selAdd.multiple = true;
			selAdd.size = 6;
			scell[2] = document.createElement('td');
			scell[2].appendChild(selAdd);
			
			for (i = 0; i <= scell.length - 1; i++) {
				srow.appendChild(scell[i]);
			}
			
			table.appendChild(row);
			table.appendChild(srow);
			div.appendChild(table);
		}
		
		// VISIBILITY
		div.style.display='block';
		if (selOptions) {
			selOptions.disabled=false;
			selAdd.disabled=false;
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

	function getNumericFieldNull(sid, field, names) {
		
		if (!names) names = 'no';
		if (names != 'yes') names = 'no';
		
		//Returns Maximum and Minimum for numeric fields
		
		//var findval = document.getElementById(field + '_findval');
		var ebpath = document.getElementById('eb_path');
		
		url = ebpath.value + "api/source_numericfield_null.php?sid=" + sid + 
		"&field=" + field + "&names=" + names;
	
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

	function getFieldColor(sid, group) {
	
		//FIELD TYPE
		var ebpath = document.getElementById('eb_path');
		url = ebpath.value + "api/source_field_groups.php?sid=" + sid + 
		"&group=" + group;
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


function addCatagoryFieldValues(field) {
	
	// ADDS FILTER RESULTS
	document.body.style.cursor = 'wait';
	items = getCatagoryFieldValues(field);
	var field_element = document.getElementById(field);
	field_element.length = 0;
	// If lookupfield then key-value array, else 
	//alert("!");
	//alert(items.length);
	if (items.length) {
		//alert("!");
		for (i=0; i <= items.length - 1; i++ ) {
			var objOption = document.createElement("option");
			objOption.text = items[i];
			objOption.value = items[i];
			field_element.add(objOption);
		}
	} else {
		//
        for(var item in items) {
			var objOption = document.createElement("option");
			//alert(item + " : " + items[item]);
			if (!items[item]) items[item] = 'NULL';
			objOption.text = items[item];
			objOption.value = item;
			field_element.add(objOption);
        }
	}
	updateInfo(field);
	document.body.style.cursor = 'default';
	return;
	
}

//--------------------------------------------------------------------------------------------


function getCatagoryFieldNull(sid, field, names) {
	
	if (!names) names = 'no';
	if (names != 'yes') names = 'no';
	
	// RETURNS TRUE IF NULLS IN FIELD ELSE FALSE
	
	//var findval = document.getElementById(field + '_findval');
	var ebpath = document.getElementById('eb_path');
	
	url = ebpath.value + "api/source_catagoryfield_null.php?sid=" + sid + 
	"&field=" + field + "&names=" + names;

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

function getCatagoryFieldValues(field) {
	
		//alert(field);
		//RETURNS DISTINCT NAMES IN A FIELD
		var ebpath = document.getElementById('eb_path');
		var sid = document.getElementById('sid').value;
		var findval = document.getElementById(field + '_findval').value;
		var nulls = document.getElementById(field + '_null').checked;

		url = ebpath.value + "api/source_catagoryfield_values.php?sid=" + sid + 
		"&field=" + field + "&query=" + findval;
		
		if (nulls) {
			url = url + "&null=y";
		} else {
			url = url + "&null=n";
		}
		//alert(url);
		
		var request = new XMLHttpRequest();
		request.open("GET", url , false);
		request.send(null);
		
		if (request.status != 200) {
			alert("Error " + request.status + ": " + request.statusText);
			return false;
		} else {
			var data = request.responseText;
			//alert(data);
			var ret = JSON.parse(data);
			//alert(ret);
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
	
//--------------------------------------------------------------------------------------------

	
/*	function checkboxes(entry) {
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
	
	//--------------------------------------------------------------------------------------------

	
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
	}*/
	
//--------------------------------------------------------------------------------------------

	
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
	
	//--------------------------------------------------------------------------------------------

	
	function add_all(entry) {
		
		// Pushes from field select to field_add select
		var field = entry.id;
		field = field.substring(0,field.length - 7);
		var box = document.getElementById(field);
		var selected = new Array();
		var selected_vals = new Array();
		var field_add = field + "_add";
		var addbox = document.getElementById(field_add);
		//alert(field_add.options.length)
		for (var i = 0; i < box.options.length; i++) {
			selected_vals.push(box.options[i].value);
		    selected.push(box.options[i].innerHTML);
		  }
		
		addbox.options.length = 0;
		
		for (var i = 0; i < selected.length; i++) {
			try {
				addbox.add(new Option(selected[i], selected_vals[i]), null); // standards compliant; doesn't work in IE
			} catch(ex) {
				addbox.add(selected[i].value); // IE only NOT WORKING
			}
		}
		updateInfo(field)
	}
	
	//--------------------------------------------------------------------------------------------

	
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
	
	//--------------------------------------------------------------------------------------------

	
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
	
	//--------------------------------------------------------------------------------------------

/*	function show_nseries(entry) {
		var element = document.getElementById("nseries_div")
		if (entry.checked == true) {
			document.getElementById("nseries_div").style.display='block';
			} else {
			document.getElementById("nseries_div").style.display='none';
			}
	}*/
	
	//--------------------------------------------------------------------------------------------

	function isValueInArray(arr, val) { for (i = 0; i < arr.length; i++) if (val == arr[i]) return true; return false; }
	
	//--------------------------------------------------------------------------------------------

/*	
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
	}*/
	
	
	