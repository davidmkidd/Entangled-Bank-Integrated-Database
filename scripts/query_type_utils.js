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

	
	