extends Node3D

@onready var obj_data = $"../CanvasLayer/Obj_Edit_Container/CurObjData"
@onready var group_dropdown = $"../CanvasLayer/Obj_Edit_Container/Group_Dropdown"

var last_selected_obj: MeshInstance3D = null

var default_obj = {
	"group": 0,
	"id": 0,
	"unknown_1": 1,
	"position": [0, 0, 0],
	"scale": [1, 1, 1],
	"transformation_matrix_1": [0, 0, 1],
	"transformation_matrix_2": [0, 1, 0],
	"transformation_matrix_3": [1, 0, 0],
	"unknown_2": 0,
	"params": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
}

func place_pmp_objects(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	var objects = data["objects"]
	
	if objects.size() != 0:
		print("First object:", objects[0]["position"])
	
	var i = 0
	
	for o in objects:
		create_object(o)
	
	file.close()
	
	
func create_object(o):
	if o == null:
		o = default_obj
		o["group"] = group_dropdown.get_item_metadata(group_dropdown.current_tab)
		
	var pos = o["position"]
		
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
	mat.albedo_color = Color.PURPLE  # RGB purple
	mesh_instance.set_surface_override_material(0, mat)
	
	mesh_instance.position = Vector3.ZERO
	mesh_instance.name = "Sphere_%d" % (get_child_count() + 1)
		
	var area = Area3D.new()
	area.input_ray_pickable = true
	area.connect("input_event", Callable(self, "_on_object_clicked").bind(area))
	area.add_child(mesh_instance)
	area.add_child(collider)
	area.set_meta("mesh_ref", mesh_instance)
	area.set_meta("col_ref", collider)
	
	area.set_meta("group_id", o["group"])
	area.set_meta("id", o["id"])
	area.set_meta("unknown_1", o["unknown_1"])
	area.set_meta("position", o["position"])
	area.set_meta("scale", o["scale"])
	area.set_meta("transm_1", o["transformation_matrix_1"])
	area.set_meta("transm_2", o["transformation_matrix_2"])
	area.set_meta("transm_3", o["transformation_matrix_3"])
	area.set_meta("unknown_2", o["unknown_2"])
	area.set_meta("params", o["params"])
	
	area.global_position = Vector3(pos[0], pos[1], pos[2])
	
	add_child(area)
	
	return area

func _on_object_clicked(camera, event, click_position, click_normal, shape_id, area):
	if event is InputEventMouseButton and event.pressed:
		if area.has_meta("mesh_ref"):
			var mesh = area.get_meta("mesh_ref")
			
			# Reset previous highlight
			if last_selected_obj != null:
				var default_mat := StandardMaterial3D.new()
				default_mat.albedo_color = Color.PURPLE
				last_selected_obj.set_surface_override_material(0, default_mat)
			
			var highlight_mat = StandardMaterial3D.new()
			highlight_mat.albedo_color = Color.PURPLE
			highlight_mat.emission_enabled = true
			highlight_mat.emission = Color.DEEP_PINK * 1.5
			mesh.set_surface_override_material(0, highlight_mat)
			print("Clicked and highlighted: ", mesh.name)
			
			last_selected_obj = mesh
			
			obj_data.make_obj_tree(area)
