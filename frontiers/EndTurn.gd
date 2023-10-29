extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_EndTurn_button_down():
	disabled = true
	cfc.NMAP.board.endTurn()
	yield(get_tree().create_timer(3.0), "timeout")
	disabled = false
