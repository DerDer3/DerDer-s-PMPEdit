extends PopupMenu

@onready var game_selection = $GameSelection

var current_game: int = 2

func _ready():
	# Add an item that will open the game_selection
	add_submenu_item("Game Selection", "GameSelection")

	# Optionally: customize game_selection
	game_selection.add_item("OGWS Tennis")
	game_selection.set_item_as_radio_checkable(0, true)
	game_selection.add_item("OGWS Baseball")
	game_selection.set_item_as_radio_checkable(1, true)
	game_selection.add_item("OGWS Golf")
	game_selection.set_item_as_radio_checkable(2, true)
	game_selection.add_item("OGWS Bowling")
	game_selection.set_item_as_radio_checkable(3, true)
	game_selection.add_item("WSR Golf")
	game_selection.set_item_as_radio_checkable(4, true)
	game_selection.add_item("WSR Flyover")
	game_selection.set_item_as_radio_checkable(5, true)
	game_selection.add_item("WSR Ping Pong")
	game_selection.set_item_as_radio_checkable(6, true)
	game_selection.add_item("WSR Showdown")
	game_selection.set_item_as_radio_checkable(7, true)
	game_selection.add_item("Wii Fit")
	game_selection.set_item_as_radio_checkable(8, true)
	
	game_selection.set_item_checked(current_game, true)

func _on_game_selection_id_pressed(id: int) -> void:
	game_selection.set_item_checked(current_game, false)
	game_selection.set_item_checked(id, true)
