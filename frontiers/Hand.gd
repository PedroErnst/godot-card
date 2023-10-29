extends Hand

signal interaction_complete

func _ready() -> void:
	# warning-ignore:return_value_discarded
	$Control/ManipulationButtons/DiscardRandom.connect("pressed",self,'_on_DiscardRandom_Button_pressed')

func playCard(card: Card, definition: Dictionary) -> void:
	if not canPayCosts(definition):
		return
	
	interactWithUser(definition)
	var interactionSuccess = yield(self, "interaction_complete")
	if not interactionSuccess:
		return

	payCosts(definition)
	card.move_to(cfc.NMAP.discard)

func interactWithUser(definition: Dictionary)-> bool:
	var success = true
	if definition.type == "place_tile":
		var place_tile_dialog = cfc.NMAP.board.get_node("PlaceTile")
		place_tile_dialog.askToPlaceTile(definition.tile)
		success = yield(place_tile_dialog, "tile_placement_exited")

	emit_signal("interaction_complete", success)
	return success


func canPayCosts(definition: Dictionary) -> bool:
	var counter = cfc.NMAP.board.get_node("Counters")
	for type in definition.costs:
		if counter.get_counter(type) < definition.costs[type]: 
			return false

	return true

func payCosts(definition: Dictionary) -> void:
	var counter = cfc.NMAP.board.get_node("Counters")
	for type in definition.costs:
		counter.mod_counter(type, -definition.costs[type])
