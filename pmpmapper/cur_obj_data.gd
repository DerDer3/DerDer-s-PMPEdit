extends Tree

func make_obj_tree(area):
	clear()
	set_column_title(0, "Col1")
	set_column_titles_visible(false)


	var pos: Vector3 = area.global_position
	var sca = area.get_meta("scale")
	
	var obj_root = create_item()
	obj_root.set_text(0, "Current Object")
	
	var id_title = create_item()
	id_title.set_text(0, "ID:")
	
	var id = create_item(id_title)
	id.set_text(0, str(area.get_meta("id")))
	id.set_editable(0, true)
	id.set_meta("item", "id")
	
	var obj_pos = create_item()
	obj_pos.set_text(0, "Position:")

	var x_item = create_item(obj_pos)
	x_item.set_text(0, str(pos.x))
	x_item.set_editable(0, true)
	x_item.set_meta("item", "x")

	var y_item = create_item(obj_pos)
	y_item.set_text(0, str(pos.y))
	y_item.set_editable(0, true)
	y_item.set_meta("item", "y")

	var z_item = create_item(obj_pos)
	z_item.set_text(0, str(pos.z))
	z_item.set_editable(0, true)
	z_item.set_meta("item", "z")
	
	var obj_scale = create_item()
	obj_scale.set_text(0, "Scale:")
	
	var x_scale = create_item(obj_scale)
	x_scale.set_text(0, str(sca[0]))
	x_scale.set_editable(0, true)
	x_scale.set_meta("item", "xs")

	var y_scale = create_item(obj_scale)
	y_scale.set_text(0, str(sca[1]))
	y_scale.set_editable(0, true)
	y_scale.set_meta("item", "ys")

	var z_scale = create_item(obj_scale)
	z_scale.set_text(0, str(sca[2]))
	z_scale.set_editable(0, true)
	z_scale.set_meta("item", "zs")

	# Store the area on the Tree itself for reference
	set_meta("target_area", area)

# func _on_tree_item_edited(item: TreeItem, column: int, new_text: String):


func _on_cur_obj_data_item_edited() -> void:
	print("Editing tree")

	var area = get_meta("target_area")
	if area == null:
		return
	
	var pos = area.global_position
	var value: TreeItem = get_edited()
	var item = value.get_meta("item")
	print(value.get_text(0))
#
	var new_float = float(value.get_text(0))
	match item:
		"x": 
			pos.x = new_float
			area.set_meta("position", [pos.x, pos.y, pos.z])
		"y": 
			pos.y = new_float
			area.set_meta("position", [pos.x, pos.y, pos.z])
		"z": 
			pos.z = new_float
			area.set_meta("position", [pos.x, pos.y, pos.z])
		"xs": 
			var sca = area.get_meta("scale")
			sca[0] = new_float
			area.set_meta("scale", sca)
		"ys": 
			var sca = area.get_meta("scale")
			sca[1] = new_float
			area.set_meta("scale", sca)
		"zs": 
			var sca = area.get_meta("scale")
			sca[2] = new_float
			area.set_meta("scale", sca)	

	area.global_position = pos
