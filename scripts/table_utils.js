/**
 * Utility scripts for Entangled Bank
 */


	function validateRangeField(entry) {
		
		// VALIDATES RANGE FIELD ENTRIES
		
		// Checks entry is numeric and from less than to
		
		var item = entry.substring(0, entry.length - 4);
		//alert(item);
		var min_item = document.getElementById(item + "_min");
		var max_item = document.getElementById(item + "_max");
		//alert(!isNumber(min_item.value) || !isNumber(max_item.value));
		
		if (!isNumber(min_item.value) || !isNumber(max_item.value)) {
			alert ("Query values must be numeric!");
			return null;
		}
		
		if (min_item.value > max_item.value) {
			alert ("'From' value must be smaller than 'To' value!");
			return null;
		}
	}



	function showfield(entry) {
		var field = entry.name;
		field = field.substring(0,field.length - 6);
		var div = document.getElementById(field + "_div");
		var field_min = document.getElementById(field + "_min");
		var field_max = document.getElementById(field + "_max");
		var boxes = document.getElementsByName(field);
		if (entry.checked == true){
			//elements[i].disabled=false;
			div.style.display='block';
			//alert(boxes);
			if (field_min) {
				field_min.disabled=false;
				field_max.disabled=false;
			}
			for (var i = 0; i < boxes.length; i++) {
				boxes[i].disabled=false;
				}
		} else {
			//elements[i].disabled=true;
			div.style.display='none';
			if (field_min) {
				field_min.disabled=true;
				field_max.disabled=true;				
			}
			for (var i = 0; i < boxes.length; i++) {
				boxes[i].disabled=true;
			}
		}		
	}

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

		field = field + "_add";
		var addbox = document.getElementById(field);

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

		field = field + "_add";
		var addbox = document.getElementById(field);
		
		for (var i = 0; i < selected.length; i++) {
			try {
				addbox.add(new Option(selected[i], selected_vals[i]), null); // standards compliant; doesn't work in IE
			} catch(ex) {
				addbox.add(selected[i].value); // IE only NOT WORKING
			}
		}
	}
	
	function rem_sel(entry) {
		// Remove selected from field_add select
		var field = entry.id;
		field = field.substring(0,field.length - 7) + "_add";
		var box = document.getElementById(field);
		for (var i = 0; i < box.options.length; i++) {
			if (box.options[i].selected == true) {
				box.remove(i); 
			}
		}
		
	}	
	
	function rem_all(entry) {
		// Remove all from field_add select
		var field = entry.id;
		field = field.substring(0,field.length - 7) + "_add";
		var box = document.getElementById(field);
		for (var i = 0; i < box.options.length; i++) {
			box.length = 0;
		}
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
	
	
	