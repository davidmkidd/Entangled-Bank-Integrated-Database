/**
 * Names utility scripts for Entangled Bank
 */

	function checkAllNames() {
		if (document.getElementById("allnames").checked == true) {
			
			document.getElementById("taxa").disabled = true;
			document.getElementById("taxa2").disabled = true;
		} else {
			document.getElementById("taxa").disabled = false;
			document.getElementById("taxa2").disabled = false;
		}
	}
	
	
