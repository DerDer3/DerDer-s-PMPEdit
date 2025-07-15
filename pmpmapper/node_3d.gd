extends Node3D

@onready var file_dialog = $CanvasLayer/Panel/HBoxContainer/MenuBar/File/FileDialog
@onready var file_dialog2 = $CanvasLayer/Panel/HBoxContainer/MenuBar/File/FileDialog2
@onready var file_dialog3 = $CanvasLayer/Panel/HBoxContainer/MenuBar/File/FileDialog3
@onready var mesh_holder = $MeshHolder
@onready var pmp_holder = $PMP_Objects_Holder
@onready var pnt_holder = $PMP_Points_Holder
@onready var tab_bar = $CanvasLayer/VBoxContainer/TabBar
@onready var pmp_tab_bar = $CanvasLayer/Options_holder/PMP_Options
@onready var cur_obj_tree = $CanvasLayer/VBoxContainer/CurObjData
@onready var item_tree = $CanvasLayer/VBoxContainer/ObjList
@onready var file = $CanvasLayer/Panel/HBoxContainer/MenuBar/File

@onready var obj_container = $CanvasLayer/VBoxContainer

@export var json_path := "user://kcl_tri_data.json"
@export var json_path2 := "user://pmp_data.json"
@export var WiiUtils = "../WiiUtils/WiiUtils.exe"

var current_tab = 0
var last_selected_obj: MeshInstance3D = null
var last_selected_pnt: MeshInstance3D = null
var current_pmp

func _ready():
	file_dialog.file_selected.connect(_on_file_dialog_file_selected)
	file_dialog2.file_selected.connect(_on_file_dialog_2_file_selected)
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
	
	# cur_obj_tree.item_edited.connect(_on_tree_item_edited)
	# print("Connected:", cur_obj_tree.is_connected("item_edited", Callable(self, "_on_tree_item_edited")))
	
	# var cam = Camera3D.new()
	# cam.current = true
	# cam.position = Vector3(0, 0, 1000)
	# cam.look_at(Vector3(0, 0, 0), Vector3(0, 0, -1))
	# cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	# cam.projection = Camera3D.PROJECTION_PERSPECTIVE
	# cam.size = 5000
	# add_child(cam)
	
	
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
	
func place_pmp_objects(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	var objects = data["objects"]
	
	if objects.size() != 0:
		print("First object:", objects[0]["position"])
	
	var i = 0
	
	for o in objects:
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
		mesh_instance.name = "Sphere_%d" % i
		
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
		
		pmp_holder.add_child(area)
		i += 1
	
	file.close()
	make_item_tree()
	
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
		
		pnt_holder.add_child(area)
		i += 1
	
	file.close()

func _on_file_id_pressed(id: int) -> void:
	match id:
		0:
			file_dialog2.popup_centered()
		1:
			file_dialog.popup_centered()
		3:
			file_dialog3.popup_centered()
		4:
			encode_pmp(current_pmp)
	
func _on_file_dialog_file_selected(path: String) -> void:
	print("User selected:", path)
	
	var out_path = ProjectSettings.globalize_path(json_path)
	
	var result = OS.execute(WiiUtils, ["-kd", path, out_path])
	
	if result == OK:
		print("Decoder finished")
		print(out_path)
		
		for child in mesh_holder.get_children():
			child.queue_free()
		
		var mesh = build_mesh_from_json(json_path)
		var mesh_instance = MeshInstance3D.new()
		mesh_instance.mesh = mesh
		mesh_holder.add_child(mesh_instance)
		mesh_instance.translate(Vector3(0, 0, 0))
		mesh_instance.rotation_degrees = Vector3(0, 0, 0)
	else:
		print("Decoder Failed: ", result)

func _on_file_dialog_2_file_selected(path: String) -> void:
	print("User selected:", path)
	current_pmp = path

	var out_path = ProjectSettings.globalize_path(json_path2)
	
	var result = OS.execute(WiiUtils, ["-pd", path, out_path])
	
	if result == OK:
		print("Decoder finished")
		print(out_path)
		
	for child in pmp_holder.get_children():
		child.queue_free()
	
	place_pmp_objects(json_path2)
	place_pmp_points(json_path2)
	load_pmp_tabs()
	pnt_holder.visible = 0
	obj_container.visible = 1
	load_pmp_object_tabs(json_path2)
	
func encode_pmp(out_file: String):
	var file_path = "user://pmp_encode.txt"
	var file = FileAccess.open(file_path, FileAccess.WRITE) 
	file.store_string(str(pmp_holder.get_child_count()) + "\n")
	file.store_string("%d\n" % 0)
	file.store_string("%d\n" % 0)
	for c in pmp_holder.get_children():
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
		
	
func _on_file_dialog_3_file_selected(path: String) -> void:
	encode_pmp(path)
	
func load_pmp_tabs() -> void:
	pmp_tab_bar.add_item("Objects")
	pmp_tab_bar.add_item("Routes")
	
func _on_pmp_options_item_selected(index: int) -> void:
	print(index)
	if index == 0:
		obj_container.visible = 1
		pmp_holder.visible = 1
		pnt_holder.visible = 0
	if index == 1:
		obj_container.visible = 0
		pmp_holder.visible = 0
		pnt_holder.visible = 1
	
func load_pmp_object_tabs(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	var objects = data["objects"]

	var unique_groups := {}
	
	for obj in objects:
		var group_id = obj["group"]
		unique_groups[group_id] = true
	
	tab_bar.clear()
	
	var index = tab_bar.item_count
	
	tab_bar.add_item("All")
	tab_bar.set_item_metadata(index, -1) # -1 for no group
	
	for group_id in unique_groups.keys():
		index = tab_bar.item_count
		tab_bar.add_item("Group " + "%d" % group_id)
		tab_bar.set_item_metadata(index, group_id)
		
	file.close()


func _on_tab_bar_item_selected(index: int) -> void:
	var group_id = tab_bar.get_item_metadata(index)
	print("Current tab: ", tab_bar.get_item_metadata(index))
	print("Current tab index: ", index)
	for child in pmp_holder.get_children():
		if group_id == -1:
			child.visible = 1
		elif child.get_meta("group_id") == group_id:
			child.visible = 1
			print("yes", group_id, " = ", child.get_meta("group_id"))
		else:
			child.visible = 0
			print("no", group_id, " != ", child.get_meta("group_id"))
	current_tab = index
	
	make_item_tree()


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
			
			make_obj_tree(area)

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

func make_obj_tree(area):
	cur_obj_tree.clear()
	cur_obj_tree.set_column_title(0, "Col1")
	cur_obj_tree.set_column_titles_visible(false)


	var pos: Vector3 = area.global_position
	var sca = area.get_meta("scale")
	
	var obj_root = cur_obj_tree.create_item()
	obj_root.set_text(0, "Current Object")
	
	var id_title = cur_obj_tree.create_item()
	id_title.set_text(0, "ID:")
	
	var id = cur_obj_tree.create_item(id_title)
	id.set_text(0, str(area.get_meta("id")))
	id.set_editable(0, true)
	id.set_meta("item", "id")
	
	var obj_pos = cur_obj_tree.create_item()
	obj_pos.set_text(0, "Position:")

	var x_item = cur_obj_tree.create_item(obj_pos)
	x_item.set_text(0, str(pos.x))
	x_item.set_editable(0, true)
	x_item.set_meta("item", "x")

	var y_item = cur_obj_tree.create_item(obj_pos)
	y_item.set_text(0, str(pos.y))
	y_item.set_editable(0, true)
	y_item.set_meta("item", "y")

	var z_item = cur_obj_tree.create_item(obj_pos)
	z_item.set_text(0, str(pos.z))
	z_item.set_editable(0, true)
	z_item.set_meta("item", "z")
	
	var obj_scale = cur_obj_tree.create_item()
	obj_scale.set_text(0, "Scale:")
	
	var x_scale = cur_obj_tree.create_item(obj_scale)
	x_scale.set_text(0, str(sca[0]))
	x_scale.set_editable(0, true)
	x_scale.set_meta("item", "xs")

	var y_scale = cur_obj_tree.create_item(obj_scale)
	y_scale.set_text(0, str(sca[1]))
	y_scale.set_editable(0, true)
	y_scale.set_meta("item", "ys")

	var z_scale = cur_obj_tree.create_item(obj_scale)
	z_scale.set_text(0, str(sca[2]))
	z_scale.set_editable(0, true)
	z_scale.set_meta("item", "zs")

	# Store the area on the Tree itself for reference
	cur_obj_tree.set_meta("target_area", area)

# func _on_tree_item_edited(item: TreeItem, column: int, new_text: String):


func _on_cur_obj_data_item_edited() -> void:
	print("Editing tree")

	var area = cur_obj_tree.get_meta("target_area")
	if area == null:
		return
	
	var pos = area.global_position
	var value: TreeItem = cur_obj_tree.get_edited()
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

func make_item_tree():
	item_tree.clear()
	item_tree.set_column_title(0, "Items")
	item_tree.set_column_titles_visible(false)
	var group_id = tab_bar.get_item_metadata(current_tab)
	
	var item_root = item_tree.create_item()
	item_root.set_text(0, "Items")
	
	if current_tab == 0:
		for p in pmp_holder.get_children():
			var i: TreeItem = item_tree.create_item(item_root)
			i.set_text(0, "%d" % int(p.get_meta("id")))
			i.set_meta("area", p)
	else:
		for p in pmp_holder.get_children():
			if group_id == p.get_meta("group_id"):
				var i: TreeItem = item_tree.create_item(item_root)
				i.set_text(0, "%d" % int(p.get_meta("id")))
				i.set_meta("area", p)
		

func _on_obj_list_item_selected() -> void:
	var item = item_tree.get_selected()
	if item.has_meta("area"):
		var area = item.get_meta("area")
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
				
			make_obj_tree(area)


func _on_button_pressed() -> void:
	for p in pmp_holder.get_children():
		print(p.get_meta("position"))


func _on_add_pressed() -> void:
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
	mesh_instance.name = "Sphere_%d" % (int(pmp_holder.get_child_count()) + 1)
	
	var area = Area3D.new()
	area.input_ray_pickable = true
	area.connect("input_event", Callable(self, "_on_object_clicked").bind(area))
	area.add_child(mesh_instance)
	area.add_child(collider)
	area.set_meta("mesh_ref", mesh_instance)
	area.set_meta("col_ref", collider)
	
	area.set_meta("group_id", tab_bar.get_item_metadata(current_tab))
	area.set_meta("id", 0)
	area.set_meta("unknown_1", 0)
	area.set_meta("position", [0, 0, 0])
	area.set_meta("scale", [1, 1, 1])
	area.set_meta("transm_1", [0, 0, 1])
	area.set_meta("transm_2", [0, 1, 0])
	area.set_meta("transm_3", [1, 0, 0])
	area.set_meta("unknown_2", 0)
	area.set_meta("params", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
	
	area.global_position = Vector3(0, 0, 0)
	
	pmp_holder.add_child(area)
	
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
				
		make_obj_tree(area)


func _on_delete_pressed() -> void:
	var area = cur_obj_tree.get_meta("target_area")
	area.queue_free()
	pmp_holder.remove_child(area)
	make_item_tree()
	cur_obj_tree.clear()
