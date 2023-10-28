# Pops up a dialogie for the player to enter an integer.
# Typically called by a card script that needs that player
# to provide a value
extends Control

signal tile_placement_exited

var number: int

func _ready() -> void:
	$IntegerLineEdit.connect("int_changed_ok", self, "_switch_green")
	# warning-ignore:return_value_discarded
	$IntegerLineEdit.connect("int_changed_nok", self, "_switch_red")
	# warning-ignore:return_value_discarded
	$IntegerLineEdit.connect("int_entered", self, "_on_number_entered")


# Prepares the window to request the integer from the player
# in the correct range and bring the popup to the front.
func prep(title_reference: String, min_req: int, max_req : int) -> void:
		$IntegerLineEdit.placeholder_text = \
				"Enter number between " + str(min_req) + " and " + str(max_req)
		$IntegerLineEdit.minimum = min_req
		$IntegerLineEdit.maximum = max_req
		#$LineEdit.text = str(minimum)
		cfc.NMAP.board.add_child(self)
		# One again we need two different Panels due to
		# https://github.com/godotengine/godot/issues/32030
		# Adjustments below are to make the highlight fit over the whole window
		# including its decoration.
		var highlight_offset = Vector2(8, 27)
		$HorizontalHighlights.rect_size = rect_size + highlight_offset
		$VecticalHighlights.rect_size = rect_size + highlight_offset
		$HorizontalHighlights.rect_position = -highlight_offset + Vector2(3.5, 3.5)
		$VecticalHighlights.rect_position = -highlight_offset + Vector2(3.5, 3.5)
		_switch_red()
		#print($HorizontalHighlights.rect_size)
		# We spawn the dialogue at the middle of the screen.


func _on_number_entered(new_text: int) -> void:
		number = new_text
		hide()


func _switch_red() -> void:
	$HorizontalHighlights.modulate = Color(1.4,0,0)
	$VecticalHighlights.modulate = Color(1.2,0,0)


func _switch_green() -> void:
	$HorizontalHighlights.modulate = Color(0,1.6,0)
	$VecticalHighlights.modulate = Color(0,1.4,0)


func _on_AskInteger_confirmed() -> void:
	$IntegerLineEdit._on_IntegerLineEdit_text_entered($IntegerLineEdit.text)


func _on_Cancel_pressed():
	emit_signal("tile_placement_exited", self)
	hide()
