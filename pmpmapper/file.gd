extends PopupMenu

@onready var import_pmp = $ImportPMP
@onready var import_kcl = $ImportKCL
@onready var save_as = $SaveAs
@onready var scene_root = get_tree().root.get_child(0)

func _on_id_pressed(id: int) -> void:
	match id:
		0:
			import_pmp.popup_centered()
		1:
			import_kcl.popup_centered()
		3:
			save_as.popup_centered()
		4:
			scene_root.save_check()
