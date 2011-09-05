/**
 * Names utility scripts for Entangled Bank
 */

	function checkAllNames() {
		if (document.getElementById("allnames").checked == true) {
			
			document.getElementById("taxa").disabled = true;
			document.getElementById("invalid_taxa").disabled = true;
		} else {
			document.getElementById("taxa").disabled = false;
			document.getElementById("invalid_taxa").disabled = false;
		}
	}
	
	
