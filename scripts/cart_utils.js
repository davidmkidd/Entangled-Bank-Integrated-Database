/**
 * 
 */

function editQuery(id) {
	
	// Opens query for editing
	
	//alert(id);
	var item = document.getElementById('qterm');
	item.value = 'qedit';
	
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