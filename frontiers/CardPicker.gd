extends PopupPanel


var queued_picks = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func addCardPick(level: int)-> void:
	queued_picks.append(level)


func pickCards()-> void:
	if queued_picks.empty():
		return;
		
	popup_centered()
	return
	addCardsToChoices()

func addCardsToChoices()-> void:
	var defs = cfc.load_card_definitions()
	var validOptions = []
	for cardName in defs:
		validOptions.append(cardName)	
	
	for item in 3:
		if validOptions.size() == 0:
			break
		var choice = randi() % validOptions.size()
		var chosenItem = validOptions[choice]
		validOptions.remove(choice)
		
		var card = cfc.instance_card(chosenItem)
		$CardChoices.add_child(card)
		card._determine_idle_state()
		
