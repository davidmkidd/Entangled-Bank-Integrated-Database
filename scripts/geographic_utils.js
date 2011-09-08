/**
 * 
 */
	 
    var map;
    var wgs84 = new OpenLayers.Projection("EPSG:4326");
    var vectors = new OpenLayers.Layer.Vector("Vector Layer");
    
    function mapinit(){
    	
    	
        map = new OpenLayers.Map('map');
//        var wms = new OpenLayers.Layer.WMS( "OpenLayers WMS",
//            "http://vmap0.tiles.osgeo.org/wms/vmap0?", {layers: 'basic'});
        var gphy = new OpenLayers.Layer.Google(
        	    "Google Physical",
        	    {type: google.maps.MapTypeId.TERRAIN}
        	    // used to be {type: G_PHYSICAL_MAP}
        	);
    	var gmap = new OpenLayers.Layer.Google(
    	    "Google Streets", // the default
    	    {numZoomLevels: 20}
    	    // default type, no change needed here
    	);
/*    	var ghyb = new OpenLayers.Layer.Google(
    	    "Google Hybrid",
    	    {type: google.maps.MapTypeId.HYBRID, numZoomLevels: 20}
    	    // used to be {type: G_HYBRID_MAP, numZoomLevels: 20}
    	);*/
    	var gsat = new OpenLayers.Layer.Google(
    	    "Google Satellite",
    	    {type: google.maps.MapTypeId.SATELLITE, numZoomLevels: 22}
    	    // used to be {type: G_SATELLITE_MAP, numZoomLevels: 22}
    	);
    	
    	map.addLayers([vectors, gphy, gmap ,gsat]);
        // Add data
        var q_geom = document.getElementById('q_geometry').value;

        if (q_geom.length != 0) {
        	var wkt = new OpenLayers.Format.WKT({
        		'internalProjection': map.baseLayer.projection,
                'externalProjection': wgs84   		
        	});
            var arr = new Array(wkt.read(q_geom));
            for (i = 0; i < arr.length; i++) 
            		vectors.addFeatures(arr[i]);
        }
       // map controls
        map.addControl(new OpenLayers.Control.MousePosition({displayProjection: wgs84}));
        map.addControl(new OpenLayers.Control.EditingToolbar(vectors));
        map.addControl(new OpenLayers.Control.LayerSwitcher());

        var bounds = new OpenLayers.Bounds(-180, -90, 180, 90);
        map.zoomToExtent(bounds.transform(wgs84, map.getProjectionObject()));
    }
    
    function serializeLayer() {
    	// checks form validity and if OK serialises geometries
    	//alert(document.getElementById('cancel_yes').checked);
    	//alert("!");
    	//if (document.getElementById('cancel_yes').checked == true) return true;
    	
    	// Have any geometries been added?
    	if (vectors.features.length == 0) {
    		alert('Add one or more geographical query features or cancel');
    		return false;
    	}
    	
    	var n = getNSourcesSelected();
    	if (n == 0) {
    		alert('Select one or more sources to query or cancel');
    		return false;
    	}
    	
    	// Is at least one layer selected?
    	
    	var wkt_format = new OpenLayers.Format.WKT({
    		'internalProjection': map.baseLayer.projection,
            'externalProjection': wgs84   		
    	});
    	//alert(vectors.features.length);
    	//alert(wkt_format.write(vectors.features));
    	
    	document.getElementById('q_geometry').value = wkt_format.write(vectors.features);
    	
    }
    
    function clearMap() {
    	
    	//deletes all features from map
    	vectors.destroyFeatures();
    	
    }
    
	function getNSourcesSelected() {
		
		var items = document.getElementsByName("qsources[]");
		//alert(items);
		var count = 0;
		for (var i = 0; i < items.length; i++) {
			if (items[i].checked == true) {
				count++;
			}
		}
		return count;
	}


    function addBoundingBox() {
    	
    	//Checks validity of BBox and adds to layer
    	var err = '';
    	var n = document.getElementById('bbnorth');
    	var s = document.getElementById('bbsouth');
    	var e = document.getElementById('bbeast');
    	var w = document.getElementById('bbwest');
    	
    	if (isNumber(n.value) != true || isNumber(s.value)!= true) {
    		err = 'n/s not numeric';
    	} else {
    		if (n.value > 90 || n.value < -90 || s.value > 90 || s.value < -90 || n.value <= s.value)
    			err = 'n/s out of range';
    	}
    	
    	if (isNumber(e.value) != true || isNumber(w.value) != true)  {
    		err = 'e/w not numeric';
    	} else {
    		if (e.value > 180 || e.value < -180 || w.value > 180 || w.value < -180)
    			err = 'e/w out of range';
    	}
    	
    	if (err.length == 0) {
    		//Add Bounding Box
    		if (s.value == -90) s.value = -89.999999;
    		var p1 = new OpenLayers.Geometry.Point(w.value, n.value);
    		var p2 = new OpenLayers.Geometry.Point(w.value, s.value);
    		var p3 = new OpenLayers.Geometry.Point(e.value, s.value);
    		var p4 = new OpenLayers.Geometry.Point(e.value, n.value);
    		//alert(p1);
    		p1.transform(wgs84, map.getProjectionObject());
    		p2.transform(wgs84, map.getProjectionObject());
    		p3.transform(wgs84, map.getProjectionObject());
    		p4.transform(wgs84, map.getProjectionObject());
    		//alert(p1);
    		var points = [];
    		points.push(p1);
    		points.push(p2);
    		points.push(p3);
    		points.push(p4);
    		points.push(p1);
    		//alert(points);
    		var linearRing = new OpenLayers.Geometry.LinearRing(points);
    		var poly_feature = new OpenLayers.Feature.Vector(
    				new OpenLayers.Geometry.Polygon([linearRing]), null, null);
    		//alert(poly_feature.geometry);
    		vectors.addFeatures([poly_feature]);

    	} else {
    		alert(err);
    	}
    }
    
    
    // preload images
    (function() {
        var roots = ["draw_point", "draw_line", "draw_polygon", "pan"];
        var onImages = [];
        var offImages = [];
        for(var i=0; i<roots.length; ++i) {
            onImages[i] = new Image();
            onImages[i].src = "../theme/default/img/" + roots[i] + "_on.png";
            offImages[i] = new Image();
            offImages[i].src = "../theme/default/img/" + roots[i] + "_on.png";
        }
    })();
    
    
