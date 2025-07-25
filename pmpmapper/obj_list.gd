extends Tree

@onready var group_dropdown = $"../Group_Dropdown"
@onready var obj_holder = $"../../../PMP_Objects_Holder"

func make_item_tree():
	clear()
	set_column_title(0, "Items")
	set_column_titles_visible(false)
	
	var item_root = create_item()
	item_root.set_text(0, "Items")
	
	if group_dropdown.current_tab == 0:
		for p in obj_holder.get_children():
			var i: TreeItem = create_item(item_root)
			i.set_text(0, "%d" % int(p.get_meta("id")))
			i.set_meta("area", p)
	else:
		var group_id = group_dropdown.get_item_metadata(group_dropdown.current_tab)
		for p in obj_holder.get_children():
			if group_id == p.get_meta("group_id"):
				var i: TreeItem = create_item(item_root)
				i.set_text(0, "%d" % int(p.get_meta("id")))
				i.set_meta("area", p)
