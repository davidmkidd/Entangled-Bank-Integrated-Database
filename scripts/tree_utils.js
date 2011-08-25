/**
 * Utilities for html_query_tree
 */

/*HTTP._factories = [
      function(){return new XMLHttpRequest(); },
      function(){return new ActiveXObject("Msxml2.XMLHTTP"); },
      function(){return new ActiveXObject("Microsoft.XMLHTTP"); }
];

HTTP._factory = null;

HTTP.newRequest = function() {
	alert("!");
    if (HTTP._factory != null) return HTTP._factory();

    for(var i = 0; i < HTTP._factories.length; i++) {
        try {
            var factory = HTTP._factories[i];
            var request = factory();
            if (request != null) {
                HTTP._factory = factory;
                return request;
            }
        }
        catch(e) {
            continue;
        }
    }

    // If we get here, none of the factory candidates succeeded,
    // so throw an exception now and for all future calls.
    HTTP._factory = function() {
        throw new Error("XMLHttpRequest not supported");
    }
    HTTP._factory(); // Throw an error
}*/



function findNodes() {
	// Adds search returns to tree select box
	
	var treeitems = document.getElementById('tree_items');
	var findval = document.getElementById('findval');
	var tree_id = document.getElementById('tree_id');
	//alert("tree: " + tree_id.value + " findval: " + findval.value);
	url = "http://localhost/entangled-bank/api/treelabels.php?tree=" + tree_id.value + "&query=" + findval.value;
	//alert(url);
	//var xmldoc = XML.newDocument();
	//xmldoc.async = false;
	//xmldoc.load(url);
	
	var request = new XMLHttpRequest();
	request.open("GET", url , false);
	request.send(null);
	
	//alert(request.status);
	if (request.status != 200) {
		alert("Error " + request.status + ": " + request.statusText);
	} else {
		var xmldoc = request.responseXML;
		alert(request.responseXML);
		var labels = xmldoc.getElementsByTagName("label");
	
		for (var i = 0; i <= labels.length - 1; i++) {
			//alert(treeval.value);
			tree_items.options[i] = labels[i].value;
		}
		//alert(request.responseText);
		
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
