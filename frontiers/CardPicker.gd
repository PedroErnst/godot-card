extends Popup


var queued_picks = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func addCardPick(level: int)-> void:
	queued_picks.append(level)


func pickCards()-> void:
	if queued_picks.empty():
		return;
		
	yield(get_tree().create_timer(0.5), "timeout")
	cfc.NMAP.board.is_picking_cards = true
	popup_centered()
	addCardsToChoices()
	
func pickCard(card: Card)->void:
	for available_card in $CardChoices.get_all_cards():
		if available_card == card:
			card.move_to(cfc.NMAP.discard)
	resetAndClose()

func addCardsToChoices()-> void:
	var defs = cfc.load_card_definitions()
	var validOptions = []
	for cardName in defs:
		validOptions.append(cardName)	
	
	for item in 3:
		if validOptions.size() == 0:
			break
			
		yield(get_tree().create_timer(0.2), "timeout")
		var choice = randi() % validOptions.size()
		var chosenItem = validOptions[choice]
		validOptions.remove(choice)
		
		var card = cfc.instance_card(chosenItem)
		
		$ChoicePile.add_child(card)
		card._determine_idle_state()
		card.move_to($CardChoices)
		


func _on_SkipButton_pressed():
	resetAndClose()

func resetAndClose():
	for card in $ChoicePile.get_all_cards():
		$CardChoices.remove_child(card)
	cfc.NMAP.board.is_picking_cards = false
	queued_picks = []
	self.hide()
