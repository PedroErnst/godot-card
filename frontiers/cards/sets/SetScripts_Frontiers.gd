# See README.md
extends Reference

const scripts := {
	"Grassland": {
		"manual": {
			"hand": [
				{
					"is_cost": true,
					"name": "mod_counter",
					"modification": -1,
					"counter_name":  "credits",
					SP.FILTER_PER_COUNTER: {
						SP.KEY_COUNTER_NAME: "credits",
						SP.KEY_COMPARISON: "ge",
						SP.FILTER_COUNT: 1,
					},
					SP.KEY_FAIL_COST_ON_SKIP: true,
				},
				{
					"name": "move_card_to_container",
					"subject": "self",
					"dest_container": "discard",
				},
			]
		},
	},
	"Hills": {
		"manual": {
			"hand": [
				{
					"is_cost": true,
					"name": "mod_counter",
					"modification": -2,
					"counter_name":  "credits",
					SP.FILTER_PER_COUNTER: {
						SP.KEY_COUNTER_NAME: "credits",
						SP.KEY_COMPARISON: "ge",
						SP.FILTER_COUNT: 2,
					},
					SP.KEY_FAIL_COST_ON_SKIP: true,
				},
				{
					"name": "move_card_to_container",
					"subject": "self",
					"dest_container": "discard",
				},
			]
		},
	},
}

# This fuction returns all the scripts of the specified card name.
#
# if no scripts have been defined, an empty dictionary is returned instead.
func get_scripts(card_name: String, get_modified = true) -> Dictionary:

	# We return only the scripts that match the card name and trigger
	return(scripts.get(card_name,{}))
