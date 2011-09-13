/**
 * Utilities for html_query_tree
 */

function findNodes() {
	// Adds search returns to tree select box
	
	var tree_items = document.getElementById('tree_items');
	var findval = document.getElementById('findval');
	var tree_id = document.getElementById('tree_id');
	var nodefilter = document.getElementsByName('nodefilter');
	
	var str = '';
	
	var n = 0;
	for (var i = 0; i <= nodefilter.length - 1; i++) {
		if (nodefilter[i].checked == true) {
			str = str + nodefilter[i].value + '+';
			n++;
		}
	}
	
	//alert(n);
	
	if (n == 0) {
		alert('Find filter excluding all node type! Check one type at least.');
	} else {
		var str2 = str.substring(0, str.length-1);	
		
		url = "http://localhost/entangled-bank/api/treelabels.php?tree=" + tree_id.value + 
		"&query=" + findval.value + "&filter=" + str2;
		
		// LINUX HARDCODE
		//url = "http://129.31.4.53/entangled-bank/api/treelabels.php?tree=" + tree_id.value + 
		//"&query=" + findval.value + "&filter=" + str2;
	
		//alert(url);
		
		var request = new XMLHttpRequest();
		request.open("GET", url , false);
		request.send(null);
		
		//alert(request.status);
		if (request.status != 200) {
			alert("Error " + request.status + ": " + request.statusText);
		} else {
			tree_items.options.length = 0;
			var data = request.responseText;
			//alert(data.substring(1));
			if (data !== '[]') {		
				data = data.substring(1);
				data = data.substring(1, data.length - 1);
				var labels = data.split(',');
				//alert(labels.length);
				for (var i = 0; i <= labels.length - 1; i++) {
					//alert(labels[i]);
					label = labels[i].replace(/["']{1}/gi,"");
					//alert(label);
					tree_items.options[i] = new Option(label, label);
				}
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
	for (var i = 0; i <= treesel.length - 1; i++){
		var match = false;
		for (j = 0; j <= taxa.length -1; j++) {
			if (treesel[i] == taxa.options[j].value) match = true;
		}
		if (match == false) taxa.options[taxa.options.length] = new Option(treesel[i], treesel[i]);
	}
}


function treeAll() {
	var tree = document.getElementById('tree_items');
	var taxa = document.getElementById('taxa_items');
	
	if (taxa.length !== 0) taxa.length = 0;
	//alert(tree.length);
	for (i = 0; i <= tree.length - 1; i++) {
		alert(tree.options[i].value);
		taxa.options[taxa.options.length] = new Option(tree.options[i].value, tree.options[i].value);
	}
}

function treeDel (){
	var taxa = document.getElementById('taxa_items');
	for (i = 0; i <= taxa.length - 1; i++) {
		if (taxa.options[i].selected == true) taxa.remove(i);
	}
}

function treeDelall() {
	var taxa = document.getElementById('taxa_items');
	taxa.length = 0;
}

function selAll() {
	// selects all taxa form submission
	var taxa = document.getElementById('taxa_items');
	for (var i = 0; i <= taxa.length - 1; i++) {
		taxa.options[i].selected = true;
		//alert(taxa.options[i].value);
	}
}
