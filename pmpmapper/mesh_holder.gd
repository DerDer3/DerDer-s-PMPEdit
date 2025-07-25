extends Node3D

func build_mesh_from_json(path: String) -> ArrayMesh:
	var file = FileAccess.open(path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	var triangles = data["triangles"]
	
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	# Define vertices in triangle
	for tri in triangles:
		var verts = tri["vertices"]
		verts.reverse()
		var surface_id = tri["surface"]
		var normal = Vector3(tri["normal"][0], tri["normal"][1], tri["normal"][2])
		
		var color
		
		match surface_id:
			"0x1": color = Color.GREEN
			"0x2": color = Color.WEB_GREEN
			"0x3": color = Color.SANDY_BROWN
			"0x4": color = Color.DARK_GREEN
			"0x5": color = Color.DARK_GREEN
			"0x6": color = Color.GREEN_YELLOW
			"0x7": color = Color.BLUE
			"0x9": color = Color.LAWN_GREEN
			"0xA": color = Color.GRAY
			"0xB": color = Color.SILVER
			"0xC": color = Color.BROWN
			"0xD": color = Color.DARK_GREEN
			"0xE": color = Color.GRAY
			"0xF": color = Color.GREEN
			"0x101": color = Color.GREEN
			"0x102": color = Color.WEB_GREEN
			"0x103": color = Color.SANDY_BROWN
			"0x104": color = Color.DARK_GREEN
			"0x105": color = Color.DARK_GREEN
			"0x106": color = Color.GREEN_YELLOW
			"0x107": color = Color.BLUE
			"0x109": color = Color.LAWN_GREEN
			"0x10A": color = Color.GRAY
			"0x10B": color = Color.SILVER
			"0x10C": color = Color.BROWN
			"0x10D": color = Color.DARK_GREEN
			"0x10E": color = Color.BLUE
			"0x10F": color = Color.GREEN
			_: color = Color.GRAY
		
		# Define vertices in triangle
		for v in verts:
			if tri["surface"] != "0x10E" and tri["surface"] != "0xE":
				st.set_color(color)
				st.set_normal(normal)
				st.add_vertex(Vector3(v[0], v[1], v[2]))
			
	print("Triangle count:", triangles.size())
	print("First Triangle vertices:", triangles[0]["vertices"])
			
	var mat = StandardMaterial3D.new()
	mat.vertex_color_use_as_albedo = true
	# mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	st.set_material(mat)
	
	file.close()

	return st.commit()
