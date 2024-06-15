# Code for a sample playspace, you're expected to provide your own ;)
extends Board

var is_picking_cards = false
var game_over = false
var turn_counter = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	counters = $Counters
	cfc.map_node(self)
	# We use the below while to wait until all the nodes we need have been mapped
	# "hand" should be one of them.
	# We're assigning our positions programmatically,
	# instead of defining them on the scene.
	# This way any they will work with any size of viewport in a game.
	# Discard pile goes bottom right
	# Fill up the deck for demo purposes
	if not cfc.ut:
		cfc.game_rng_seed = CFUtils.generate_random_seed()
		$SeedLabel.text = "Game Seed is: " + cfc.game_rng_seed
	loadInitialCards()
	$Counters.mod_counter("food", 20, true)
	$Counters.mod_counter("wood", 20, true)
		
	$TileRegister.setUp()
	
	startTurn()
	# warning-ignore:return_value_discarded
	$DeckBuilderPopup.connect('popup_hide', self, '_on_DeckBuilder_hide')

func endTurn() -> void:
	if game_over:
		return
	playSound(FRO.SWITCH)
	cfc.NMAP.hand.discardHand()
	$TileRegister.endTurn()
	if $TileRegister.allCitiesDestroyed():
		$GameOver.visible = true
		$GameOver.text = "Game over!! Your people survived for " + str(turn_counter) + " years."
		game_over = true
		return
	startTurn()
	turn_counter += 1


func incomePhase()-> void:
	for tile in $TileRegister.allTiles():
		if tile.building_type < 0:
			continue
		if tile.building_type == FRO.BUILDING_FARM:
			$Counters.mod_counter("food", 1)
		if tile.building_type == FRO.BUILDING_LOGGING_CAMP:
			$Counters.mod_counter("wood", 1)
	$Counters.mod_counter("credits", 3, true)

func onCardPlayComplete()-> void:
	$CardPicker.pickCards()

func startTurn() -> void:
	incomePhase()
	cfc.NMAP.hand.drawFromDeck(5)

func addCardPick(level: int)-> void:
	$CardPicker.addCardPick(level)
	
func pickCard(card: Card)->void:
	$CardPicker.pickCard(card)

# This function is to avoid relating the logic in the card objects
# to a node which might not be there in another game
# You can remove this function and the FancyMovementToggle button
# without issues
func _on_FancyMovementToggle_toggled(_button_pressed) -> void:
#	cfc.game_settings.fancy_movement = $FancyMovementToggle.pressed
	cfc.set_setting('fancy_movement', $FancyMovementToggle.pressed)


func _on_OvalHandToggle_toggled(_button_pressed: bool) -> void:
	cfc.set_setting("hand_use_oval_shape", $OvalHandToggle.pressed)
	for c in cfc.NMAP.hand.get_all_cards():
		c.reorganize_self()


# Reshuffles all Card objects created back into the deck
func _on_ReshuffleAllDeck_pressed() -> void:
	reshuffle_all_in_pile(cfc.NMAP.deck)


func _on_ReshuffleAllDiscard_pressed() -> void:
	reshuffle_all_in_pile(cfc.NMAP.discard)

func reshuffle_all_in_pile(pile = cfc.NMAP.deck):
	for c in get_tree().get_nodes_in_group("cards"):
		if c.get_parent() != pile and c.state != Card.CardState.DECKBUILDER_GRID:
			c.move_to(pile)
			yield(get_tree().create_timer(0.1), "timeout")
	# Last card in, is the top card of the pile
	var last_card : Card = pile.get_top_card()
	if last_card._tween.is_active():
		yield(last_card._tween, "tween_all_completed")
	yield(get_tree().create_timer(0.2), "timeout")
	pile.shuffle_cards()


# Button to change focus mode
func _on_ScalingFocusOptions_item_selected(index) -> void:
	cfc.set_setting('focus_style', index)


# Button to make all cards act as attachments
func _on_EnableAttach_toggled(button_pressed: bool) -> void:
	for c in get_tree().get_nodes_in_group("cards"):
		if button_pressed:
			c.attachment_mode = Card.AttachmentMode.ATTACH_BEHIND
		else:
			c.attachment_mode = Card.AttachmentMode.DO_NOT_ATTACH


func _on_Debug_toggled(button_pressed: bool) -> void:
	cfc._debug = button_pressed

func loadInitialCards() -> void:
	var defs = cfc.load_card_definitions()
	for cardName in defs:
		var def = defs[cardName]
		if "Starting Cards" in def:
			for n in def["Starting Cards"]:
				var card = cfc.instance_card(cardName)
				cfc.NMAP.deck.add_child(card)
				card._determine_idle_state()

	cfc.NMAP.deck.shuffle_cards(false)

func _on_DeckBuilder_pressed() -> void:
	cfc.game_paused = true
	$DeckBuilderPopup.popup_centered_minsize()

func _on_DeckBuilder_hide() -> void:
	cfc.game_paused = false


func _on_BackToMain_pressed() -> void:
	cfc.quit_game()
	get_tree().change_scene("res://src/custom/MainMenu.tscn")

func playSound(key: int) -> void:
	$Audio.playSound(key)
