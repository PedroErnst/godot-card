### Card Gaming Framework Global Config
extends Node

### BEGIN Behaviour Constants ###
### Change the below to change how all cards behave to match your game.


# The amount of distance neighboring cards are pushed during card focus
# It's based on the card width. Bigger percentage means larger push.
const neighbour_push := 0.75

# The scale of the card while on the play area
const play_area_scale := Vector2(0.8,0.8)

# The margin towards the bottom of the viewport on which to draw the cards.
# More than 0 and the card will appear hidden under the display area.
# Less than 0 and it will float higher than the bottom of the viewport
const bottom_margin_multiplier := 0.5

# Switch this off to disable fancy movement of cards during draw/discard
var fancy_movement := true

# The below vars predefine the position in your node structure to reach the nodes relevant to the cards
# Adapt this according to your node structure. Do not prepent /root in front, as this is assumed
const nodes_map := { # Optimally this should be moved to its own reference class and set in the autoloader
	'board': "Board",
	'hand': "Board/HandContainer/Hand",
	'deck': "Board/Deck/HostedCards",
	'discard': "Board/DiscardPile/HostedCards"
	}


### END Behaviour Constants ###