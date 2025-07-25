extends Node3D

func place_pmp_points(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	var points = data["points"]

	if points.size() != 0:
		print("First point:", points[0]["position"])
	
	var i = 0
	
	for p in points:
		var pos = p["position"]
		
		var mesh_instance = MeshInstance3D.new()
		var sphere = SphereMesh.new()
		sphere.radius = 10
		sphere.height = 20
		mesh_instance.mesh = sphere
		
		var collider = CollisionShape3D.new()
		var shape = SphereShape3D.new()
		shape.radius = 10
		collider.shape = shape
		collider.position = Vector3.ZERO
		
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color.RED  # RGB purple
		mesh_instance.set_surface_override_material(0, mat)
		
		mesh_instance.position = Vector3.ZERO
		mesh_instance.name = "Sphere_%d" % i
		
		var area = Area3D.new()
		area.input_ray_pickable = true
		area.connect("input_event", Callable(self, "_on_point_clicked").bind(area))
		area.add_child(mesh_instance)
		area.add_child(collider)
		area.set_meta("mesh_ref", mesh_instance)
		area.set_meta("col_ref", collider)
		
		area.set_meta("position", p["position"])
		area.set_meta("params", p["params"])
		
		area.global_position = Vector3(pos[0], pos[1], pos[2])
		
		add_child(area)
		i += 1
	
	file.close()
