/**
 * Utilities for html_query_tree
 */

function treeNodeSelectAll() {
	
	// SELECTS ALL TREE NODE TYPES
	var nodefilter = document.getElementsByName('nodefilter[]');
	for (var i = 0; i <= nodefilter.length - 1; i++) {
		nodefilter[i].checked = true;
	}
	
}

function treeNodeSelectNone() {
	
	// UNSELECTS ALL TREE NODE TYPES
	var nodefilter = document.getElementsByName('nodefilter[]');
	for (var i = 0; i <= nodefilter.length - 1; i++) {
		nodefilter[i].checked = false;
	}
}


function findNodes() {
	// Adds search returns to tree select box
	
	var tree_items = document.getElementById('tree_items');
	var findval = document.getElementById('findval');
	var tree_id = document.getElementById('tree_id');
	var nodefilter = document.getElementsByName('nodefilter[]');
	var ebpath = document.getElementById('eb_path');
	var str = '';
	var n = 0;
	
	// GET NODE FILTERS
	for (var i = 0; i <= nodefilter.length - 1; i++) {
		if (nodefilter[i].checked == true) {
			str = str + nodefilter[i].value + '+';
			n++;
		}
	}

	if (n == 0) {
		alert('Find filter excluding all node type! Check one type at least.');
	} else {
		var str2 = str.substring(0, str.length-1);	
		
		url = ebpath.value + "api/treelabels.php?tree=" + tree_id.value + 
		"&query=" + findval.value + "&filter=" + str2;
	
		//alert(url);
		
		var request = new XMLHttpRequest();
		request.open("GET", url , false);
		request.send(null);
		
		//alert(request.status);
		if (request.status != 200) {
			alert("Error " + request.status + ": " + request.statusText);
		} else {
			//alert("!");
			tree_items.options.length = 0;
			var data = request.responseText;
			var ret = JSON.parse(data);
			//alert(data);
			if (ret.length > 0) {
				data = data.substring(1);
				data = data.substring(1, data.length - 1);
				//alert(data.length);
				if (data.length > 0) {
					//var labels = data.split(',');
					for (var i = 0; i <= ret.length - 1; i++) {
						label = ret[i].replace(/["']{1}/gi,"");
						tree_items.options[i] = new Option(label, label);
					}
				} else {
				}
				document.getElementById('findval_label').innerHTML = ' - ' + ret.length + ' names found';
				tree_items.title = ret.length + ' names found';
			}
		}
	}
}


function findNode(){
	
	// Finds values in tree select box
	//alert('!!!');
	var find = document.getElementById('findval');
	var findval = find.value;
	//alert(findval);
	var msg = document.getElementById('findmsg');
	var treeval = document.getElementById('treeval');
	var tree = document.getElementById('tree_items');
	//alert(tree);
	
	if (findval == '') {
		alert('search term required');
	} else {
		var loopval = 0;
		// if value in find then get idx
		if (treeval.value !== '') {
			// search value already found
			myregexp = new RegExp(treeval.value, 'i');
			var i = -1;
			while (loopval == 0) {
				i++;
				var idx = tree.options[i].value.search(myregexp)
				if (idx !== -1) loopval = 1;
			}	
		}
		
		if (loopval == 0) i = -1;
		
		var loopval = 0;
		myregexp = new RegExp(findval, 'i');
		
		//alert(tree.options[1].value.search(myregexp));
		while (loopval == 0) {
			i++;
			var idx = tree.options[i].value.search(myregexp)
			if (idx !== -1) loopval = 1;
			if (i == tree.length - 1) loopval = 2;
		}
	}
	
	
	switch (loopval) {
		case 1:
			// Value found so display in treeval
			treeval.value = tree.options[i].value;
			break;
			
		case 2:
			// Value not found display message
			alert("end of tree: 'find next' to repeat search");
			treeval.value = '';
			break;
	}
}

function add() {
	var treeval = document.getElementById('treeval');
	var taxa = document.getElementById('taxa_items');
	//alert(taxa);
	var match = 0;
	for (var i = 0; i <= taxa.length - 1; i++) {
		//alert(taxa.options[i]);
		//alert(treeval.value);
		if (taxa.options[i].value == treeval.value) match = 1;
	}
	if (treeval.value !== '' && match !== 1) {
			taxa.options[taxa.options.length] = new Option(treeval.value, treeval.value);
	}
}

function clear() {
	document.getElementById('treeval').value = '';
}

function treeAdd() {
	//alert('!!');
	var tree = document.getElementById('tree_items');
	var taxa = document.getElementById('taxa_items');
	// Get selected items
	var treesel = new Array();
	//alert(treesel.length);
	//alert(taxa);
	for (var i = 0; i <= tree.length - 1; i++) {
		if (tree.options[i].selected == true) {
			treesel.push(tree.options[i].value);
		}
	}
	//Check if in taxa, add if not
	c = 0;
	for (var i = 0; i <= treesel.length - 1; i++){
		var match = false;
		for (j = 0; j <= taxa.length -1; j++) {
			if (treesel[i] == taxa.options[j].value) match = true;
		}
		if (match == false) {
			taxa.options[taxa.options.length] = new Option(treesel[i], treesel[i]);
			c++;
		}
	}
	taxa.title = taxa.options.length + ' names in query';
}


function treeAll() {
	var tree = document.getElementById('tree_items');
	var taxa = document.getElementById('taxa_items');
	
	if (taxa.length !== 0) taxa.length = 0;
	//alert(tree.length);
	for (i = 0; i <= tree.length - 1; i++) {
		//alert(tree.options[i].value);
		taxa.options[taxa.options.length] = new Option(tree.options[i].value, tree.options[i].value);
	}
	taxa.title = taxa.options.length + ' names in query';
}

function treeDel (){
	var taxa = document.getElementById('taxa_items');
	for (i = 0; i <= taxa.length - 1; i++) {
		if (taxa.options[i].selected == true) taxa.remove(i);
	}
	taxa.title = taxa.options.length + ' names in query';
}

function treeDelAll() {
	var taxa = document.getElementById('taxa_items');
	taxa.length = 0;
	taxa.title = taxa.options.length + ' names in query';
}

function submitTreeQuery(id) {
	
	//alert('!');
	// CHECK TREE QUERY IS VALID
	// If valid selects all taxa for submission	
	
	// NODEFILTER
	var scope = document.getElementById('filterscope');
	//alert(scope.options[scope.selectedIndex].value);
	var n = 0;
	var ok = false;
	//alert(ok);
	if (scope.options[scope.selectedIndex].value == 'query') {
		var nf = document.getElementsByName('nodefilter[]');
		for (var i = 0; i <= nf.length - 1; i++) {
			//alert(nf[i]);
			if (nf[i].checked == true) ok = true;
		}
	}
	//alert('ok = ' + ok);
	if (ok == false) {
		alert('One or more node types must be selected when a query includes a node type filter');
		return false;
	}
	
	// No taxa
	var taxa = document.getElementById('taxa_items');
	//alert(taxa.length);
	if (taxa.length == 0) {
		document.FindElementById('findval_label').innerHTML = 'No names selected to query';
		//alert ('At least one taxa required in query');
		return false;
	} else {
		for (var i = 0; i <= taxa.length - 1; i++) {
			taxa.options[i].selected = true;
		}
		document.getElementById('lastaction').value = 'run';
		document.getElementById('lastid').value = id;
		document.ebankform.submit();
	}
}

function operatorChange() {
	
	//Disables find and names when all
	var item = document.getElementById('subtree');
	var all = false;
	if (item.value == 'all') all = true;
	if (all == true) {
		item = document.getElementById('filterscope');
		if (item.options[item.selectedIndex].value !== 'query') {
			item.options[0].selected = true;
		}
	}
	document.getElementById('filterscope').disabled = all;
	document.getElementById('findval').disabled = all;
	document.getElementById('findbtn').disabled = all;
	document.getElementById('tree_items').disabled = all;
	document.getElementById('taxa_items').disabled = all;
	document.getElementById('tree_add').disabled = all;
	document.getElementById('tree_all').disabled = all;
	document.getElementById('tree_del').disabled = all;
	document.getElementById('tree_delall').disabled = all;
}



