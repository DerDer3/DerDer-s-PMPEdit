extends Node3D

@onready var import_kcl = $CanvasLayer/Panel/MenuContainer/MenuBar/File/FileDialog
@onready var import_pmp = $CanvasLayer/Panel/MenuContainer/MenuBar/File/FileDialog2
@onready var save_as = $CanvasLayer/Panel/MenuContainer/MenuBar/File/FileDialog3
@onready var mesh_holder = $MeshHolder
@onready var obj_holder = $PMP_Objects_Holder
@onready var pnt_holder = $PMP_Points_Holder
@onready var rt_holder = $PMP_Route_Holder
@onready var group_dropdown = $CanvasLayer/Obj_Edit_Container/Group_Dropdown
@onready var pmp_tab_bar = $CanvasLayer/Options_holder/PMP_Options
@onready var cur_obj_tree = $CanvasLayer/Obj_Edit_Container/CurObjData
@onready var obj_list = $CanvasLayer/Obj_Edit_Container/ObjList
@onready var file = $CanvasLayer/Panel/MenuContainer/MenuBar/File

@onready var obj_container = $CanvasLayer/Obj_Edit_Container

@export var json_path := "user://kcl_tri_data.json"
@export var json_path2 := "user://pmp_data.json"
@export var WiiUtils = "../WiiUtils/WiiUtils.exe"


var last_selected_pnt: MeshInstance3D = null
var current_pmp = null

func _ready():
	var plane = PlaneMesh.new()
	plane.size = Vector2(2000, 2000)
	var base_mesh = MeshInstance3D.new()
	base_mesh.mesh = plane
	mesh_holder.add_child(base_mesh)
	
	file.add_item("Import PMP", 0)
	file.add_item("Import KCL", 1)
	file.add_item("", 2)
	file.set_item_as_separator(2, true)
	file.add_item("Save As       Ctrl + Shift + S", 3)
	file.add_item("Save            Ctrl + S", 4)
	
	obj_container.visible = 0
	
func _on_import_kcl_file_selected(path: String) -> void:
	print("User selected:", path)
	
	var out_path = ProjectSettings.globalize_path(json_path)
	
	var result = OS.execute(WiiUtils, ["-kd", path, out_path])
	
	if result == OK:
		print("Decoder finished")
		print(out_path)
		
		for child in mesh_holder.get_children():
			child.queue_free()
		
		var mesh = mesh_holder.build_mesh_from_json(json_path)
		var mesh_instance = MeshInstance3D.new()
		mesh_instance.mesh = mesh
		mesh_holder.add_child(mesh_instance)
		mesh_instance.translate(Vector3(0, 0, 0))
		mesh_instance.rotation_degrees = Vector3(0, 0, 0)
	else:
		print("Decoder Failed: ", result)

func _on_pmp_import_file_selected(path: String) -> void:
	print("User selected:", path)
	current_pmp = path

	var out_path = ProjectSettings.globalize_path(json_path2)
	
	var result = OS.execute(WiiUtils, ["-pd", path, out_path])
	
	if result == OK:
		print("Decoder finished")
		print(out_path)
		
	for child in obj_holder.get_children():
		child.queue_free()
	
	obj_holder.place_pmp_objects(json_path2)
	obj_list.make_item_tree()
	pnt_holder.place_pmp_points(json_path2)
	rt_holder.draw_routes(json_path2)
	load_pmp_tabs()
	pnt_holder.visible = 0
	rt_holder.visible = 0
	obj_container.visible = 1
	group_dropdown.load_pmp_object_tabs(json_path2)
	
func _on_save_as_file_selected(path: String) -> void:
	current_pmp = path
	encode_pmp()
	
func save_check():
	if current_pmp == null:
		save_as.popup_centered()
	else:
		encode_pmp()
	
func encode_pmp():
	var out_file = current_pmp
	var file_path = "user://pmp_encode.txt"
	var file = FileAccess.open(file_path, FileAccess.WRITE) 
	file.store_string(str(obj_holder.get_child_count()) + "\n")
	file.store_string("%d\n" % 0)
	file.store_string("%d\n" % 0)
	for c in obj_holder.get_children():
		print(c.get_meta("position")[0])
		file.store_string(str(int(c.get_meta("group_id"))) + "\n")
		file.store_string(str(int(c.get_meta("id"))) + "\n")
		file.store_string(str(int(c.get_meta("unknown_1"))) + "\n")
		file.store_string(str(c.get_meta("position")[0]) + "\n")
		file.store_string(str(c.get_meta("position")[1]) + "\n")
		file.store_string(str(c.get_meta("position")[2]) + "\n")
		file.store_string(str(c.get_meta("scale")[0]) + "\n")
		file.store_string(str(c.get_meta("scale")[1]) + "\n")
		file.store_string(str(c.get_meta("scale")[2]) + "\n")
		file.store_string(str(c.get_meta("transm_1")[0]) + "\n")
		file.store_string(str(c.get_meta("transm_1")[1]) + "\n")
		file.store_string(str(c.get_meta("transm_1")[2]) + "\n")
		file.store_string(str(c.get_meta("transm_2")[0]) + "\n")
		file.store_string(str(c.get_meta("transm_2")[1]) + "\n")
		file.store_string(str(c.get_meta("transm_2")[2]) + "\n")
		file.store_string(str(c.get_meta("transm_3")[0]) + "\n")
		file.store_string(str(c.get_meta("transm_3")[1]) + "\n")
		file.store_string(str(c.get_meta("transm_3")[2]) + "\n")
		file.store_string(str(int(c.get_meta("unknown_2"))) + "\n")
		var temp = c.get_meta("params")
		print("temp")
		for i in range(0, 16):
			file.store_string(str(int(temp[i])) + "\n")
	
	file.close()

	var infile = ProjectSettings.globalize_path(file_path)
	
	print(out_file)
	
	var result = OS.execute(WiiUtils, ["-pe", infile, out_file])
	current_pmp = out_file
	print(infile)
	
	if result == OK:
		print("Encoder finished")
	
func load_pmp_tabs() -> void:
	pmp_tab_bar.clear()
	pmp_tab_bar.add_item("Objects")
	pmp_tab_bar.add_item("Routes")
	
func _on_pmp_options_item_selected(index: int) -> void:
	print(index)
	if index == 0:
		obj_container.visible = 1
		obj_holder.visible = 1
		pnt_holder.visible = 0
		rt_holder.visible = 0
	if index == 1:
		obj_container.visible = 0
		obj_holder.visible = 0
		pnt_holder.visible = 1
		rt_holder.visible = 1

func _on_tab_bar_item_selected(index: int) -> void:
	var group_id = group_dropdown.get_item_metadata(index)
	print("Current tab: ", group_dropdown.get_item_metadata(index))
	print("Current tab index: ", index)
	for child in obj_holder.get_children():
		if group_id == -1:
			child.visible = 1
		elif child.get_meta("group_id") == group_id:
			child.visible = 1
			print("yes", group_id, " = ", child.get_meta("group_id"))
		else:
			child.visible = 0
			print("no", group_id, " != ", child.get_meta("group_id"))
	group_dropdown.current_tab = index
	
	obj_list.make_item_tree()

func _on_point_clicked(camera, event, click_position, clikc_normal, shape_id, area):
	if event is InputEventMouseButton and event.pressed:
		if area.has_meta("mesh_ref"):
			var mesh = area.get_meta("mesh_ref")
			
			# Reset previous highlight
			if last_selected_pnt != null:
				var default_mat := StandardMaterial3D.new()
				default_mat.albedo_color = Color.RED
				last_selected_pnt.set_surface_override_material(0, default_mat)
			
			var highlight_mat = StandardMaterial3D.new()
			highlight_mat.albedo_color = Color.RED
			highlight_mat.emission_enabled = true
			highlight_mat.emission = Color.ORANGE_RED * 1.5
			mesh.set_surface_override_material(0, highlight_mat)
			print("Clicked and highlighted: ", mesh.name)
			
			last_selected_pnt = mesh

func _on_obj_list_item_selected() -> void:
	var item = obj_list.get_selected()
	if item.has_meta("area"):
		var area = item.get_meta("area")
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


func _on_button_pressed() -> void:
	for p in obj_holder.get_children():
		print(p.get_meta("position"))

func _on_delete_pressed() -> void:
	var area = cur_obj_tree.get_meta("target_area")
	area.queue_free()
	obj_holder.remove_child(area)
	obj_list.make_item_tree()
	cur_obj_tree.clear()
