extends Button

@onready var obj_holder = $"../../../PMP_Objects_Holder"
@onready var group_dropdown = $"../Group_Dropdown"
@onready var cur_obj_tree = $"../CurObjData"

func _on_pressed() -> void:
	var area = obj_holder.create_object(null)
	
	if area.has_meta("mesh_ref"):
		var mesh = area.get_meta("mesh_ref")
				
		# Reset previous highlight
		if obj_holder.last_selected_obj != null:
			var default_mat := StandardMaterial3D.new()
			default_mat.albedo_color = Color.PURPLE
			obj_holder.last_selected_obj.set_surface_override_material(0, default_mat)
			
		var highlight_mat = StandardMaterial3D.new()
		highlight_mat.albedo_color = Color.PURPLE
		highlight_mat.emission_enabled = true
		highlight_mat.emission = Color.DEEP_PINK * 1.5
		mesh.set_surface_override_material(0, highlight_mat)
		print("Clicked and highlighted: ", mesh.name)
				
		obj_holder.last_selected_obj = mesh
				
		cur_obj_tree.make_obj_tree(area)
