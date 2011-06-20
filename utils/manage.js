	

	function writeSources(obj, level) {
		
		var level = 0;
		
		for(var a in obj) {
	        var type = typeof(obj[a]);
	        if(type == 'object')
	            writeSources(obj[a], (level + 1));
	        else
	        	for (var i = 0; i < level; i++) document.write("_");
	            document.write(type + ': ' + a + ' = ' +
	            obj[a] + '<br>');
		}
		document.write('___<br>');
	}

	function showObject(obj, level) {
	    var l = '';
	    var tmp = '';
	    for(var a = 0; a < level; a++)
	        l += '[_]';
	    for(var a in obj) {
	        var type = typeof(obj[a]);
	        if(type == 'object')
	            tmp += showObject(obj[a], (level + 1));
	        else
	            tmp += l + ' key: ' + a + ' = value: ' +
	            obj[a] + ' < ' + type + '\n';
	    }
	    return tmp;
	}
	