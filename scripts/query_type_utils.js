/**
 * Query Type Entangled Bank Utilities
 */


	function queryTypeSearch() {
		document.getElementById('name_search').disabled=false;
	}

	function queryTypeQuery() {
		document.getElementById('name_search').disabled=true;
	}
	
	function showNameSearch() {
		var div = document.getElementById('name_search_div');
		var chk = document.getElementById('name_search_chk');
		//alert(chk.checked);
		if (chk.checked == false){
			div.style.display='block';
		} else {
			//elements[i].disabled=true;
			div.style.display='none';
		}
		
	}