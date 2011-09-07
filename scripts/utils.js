/**
 * 
 */

function loadScript() {
	
	// loadScript runs body onload
	
	// Make visible checked html_query_biotable divs
	for(i=0;i<document.getElementsByTagName("input").length;i++) {
		if(document.getElementsByTagName("input")[i].type == "checkbox") {
			//alert(document.getElementsByTagName("input")[i].checked)
			var chk = document.getElementsByTagName("input")[i];
			if(chk.checked == true) {
				var idx = chk.name.lastIndexOf("_");
				if (chk.name.substring(idx) == "_query") {
					var field = chk.name.substring(0,idx) + "_div";
					//alert(field);
					document.getElementById(field).style.display = 'block';
					//alert(div.id);
				}
			}
		}
	}
}