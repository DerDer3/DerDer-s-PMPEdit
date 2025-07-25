extends OptionButton

var current_tab: int = 0

func load_pmp_object_tabs(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	var objects = data["objects"]

	var unique_groups := {}
	
	for obj in objects:
		var group_id = obj["group"]
		unique_groups[group_id] = true
	
	clear()
	
	var index = item_count
	
	add_item("All")
	set_item_metadata(index, -1) # -1 for no group
	
	for group_id in unique_groups.keys():
		index = item_count
		add_item("Group " + "%d" % group_id)
		set_item_metadata(index, group_id)
		
	file.close()
