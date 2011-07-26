/**
 * Query_sources utils
 */
	function checkAll(field) {
		//alert('Hi!');	
		for (i = 0; i < field.length; i++)
			field[i].checked = true;
		document.getElementById("nsources").value = i;
	}
			
	function uncheckAll(field) {
		for (i = 0; i < field.length; i++)
			field[i].checked = false;
		document.getElementById("nsources").value = 0;
	}
	
	function checkCount() {
		
		var items = document.getElementsByName("qsources[]");
		var count = 0;
		for (var i = 0; i < items.length; i++) {
			if (items[i].checked == true) {
				count++;
			}
		}
		var nsource = document.getElementById("nsources");
		if (nsource.value != count) {
			nsource.value = count;
		}
	}
	
	function changeNSources() {
		//Checks postive integer not great
		var nsource = document.getElementById("nsources");
		// number of boxes checked
		var items = document.getElementsByName("qsources[]");
		var count = 0;
		for (var i = 0; i < items.length; i++) {
			if (items[i].checked == true) {
				count++;
			}
		}
		
		if (is_int(nsource.value)) {
			if (nsource.value > count)
				nsource.value = count;
			if (nsource.value < 1)
				nsource.value = 1;
		} else {
			nsources.value = count;
		}
	}
	
