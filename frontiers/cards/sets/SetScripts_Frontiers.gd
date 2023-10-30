# See README.md
extends Reference

const scripts := {
	"Grassland": {
		"manual": {
			"type": "place_tile",
			"tile": {
				"layer": "terrain",
				"type": 2,
				"name": "Grassland",
				"rules": {
					"terrain_type": -1,
				},
				"flora": {
					9: 30
				}
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
				"layer": "terrain",
				"type": 3,
				"name": "Hills",
				"rules": {
					"terrain_type": -1,
				},
				"flora": {
					9: 60
				}
			},
			"costs": {
				"credits": 2,
			},
		},
	},
	"Farm": {
		"manual": {
			"type": "place_tile",
			"tile": {
				"layer": "building",
				"type": 7,
				"name": "Farm",
				"rules": {
					"terrain_type": 2,
					"adyacent_to": {
						"type": "building",
						"id": 6
					},
				},
			},
			"costs": {
				"credits": 2,
			},
		},
	},
	"Logging Camp": {
		"manual": {
			"type": "place_tile",
			"tile": {
				"layer": "building",
				"type": 10,
				"name": "Logging Camp",
				"rules": {
					"flora_type": 9,
				},
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
