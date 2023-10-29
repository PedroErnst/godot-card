# See README.md
extends Reference

const scripts := {
	"Grassland": {
		"manual": {
			"type": "place_tile",
			"tile": {
				SP.TYPE: 2,
				SP.NAME: "Grassland",
			},
			"costs": {
				"credits": 1,
			},
		},
	},
	"Hills": {
		"manual": {
			"type": "place_tile",
			"tile": {
				SP.TYPE: 3,
				SP.NAME: "Hills",
			},
			"costs": {
				"credits": 2,
			},
		},
	},
}

# This fuction returns all the scripts of the specified card name.
#
# if no scripts have been defined, an empty dictionary is returned instead.
func get_scripts(card_name: String, get_modified = true) -> Dictionary:

	# We return only the scripts that match the card name and trigger
	return(scripts.get(card_name,{}))
