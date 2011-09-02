/**
 * Query Type Entangled Bank Utilities
 */


	function queryTypeSearch() {
		document.getElementById('name_search').disabled=false;
	}

	function queryTypeQuery() {
		document.getElementById('name_search').disabled=true;
	}
	
	function showFind() {
		var div = document.getElementById('find_div');
		var chk = document.getElementById('find_hide');
		var msg = document.getElementById('find_msg');
		//alert(chk.checked);
		if (chk.value == 'Unhide'){
			div.style.display='block';
			msg.style.display='none';
			chk.value = 'Hide';
		} else {
			//elements[i].disabled=true;
			div.style.display='none';
			msg.style.display='block';
			chk.value = 'Unhide';
		}

	}
	
	function openSelect(entry) {
		div_id = entry + '_select_div';
		var div = document.getElementById(div_id);
		
		if (entry == 'biotree') {
			other_div_id = 'attribute_select_div';
		} else {
			other_div_id = 'biotree_select_div';
		}
		var other_div = document.getElementById(other_div_id);
		
		if (div.style.display == 'none') {
			div.style.display = 'block';
			other_div.style.display = 'none';
		} else {
			div.style.display = 'none';
		}
	}
	
	function submitform(entry)
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

	
	