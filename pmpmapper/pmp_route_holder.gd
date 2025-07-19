extends Node3D

# Thickness of the cylinder lines
const LINE_RADIUS = 2

func draw_routes(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	var routes = data["routes"]
	var points = data["points"]
	
	for r in routes:
		var p_arr: Array[Vector3]
		for i in range(r["index"], r["index"] + r["point_count"]):
			var pos: Vector3 = Vector3(points[i]["position"][0], points[i]["position"][1], points[i]["position"][2])
			p_arr.push_back(pos)
		print(p_arr)
		draw_route_as_cylinders(p_arr)

func draw_route_as_cylinders(points: Array[Vector3]):
	var route = Area3D.new()
	
	for i in range(points.size() - 1):
		var start = points[i]
		var end = points[i + 1]
		draw_cylinder_between(start, end, route)
		
	add_child(route)

func draw_cylinder_between(start: Vector3, end: Vector3, route: Area3D):
	var direction = end - start
	var length = direction.length()
	var center = (start + end) * 0.5

	var mesh := CylinderMesh.new()
	mesh.top_radius = LINE_RADIUS
	mesh.bottom_radius = LINE_RADIUS
	mesh.height = length
	mesh.radial_segments = 8

	var material := StandardMaterial3D.new()
	material.albedo_color = Color.RED
	mesh.material = material

	var instance := MeshInstance3D.new()
	instance.mesh = mesh

	# Create transform basis to align with the direction vector
	var up = direction.normalized()
	var right = up.cross(Vector3.UP)
	if right.length() < 0.01:
		right = up.cross(Vector3.FORWARD)  # Handle edge case if up is near Vector3.UP
	var forward = right.cross(up)

	var basis = Basis(right.normalized(), up, forward.normalized())
	instance.global_transform = Transform3D(basis, center)

	route.add_child(instance)
