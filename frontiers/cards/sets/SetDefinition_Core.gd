# This file contains just card definitions. See also `CardConfig.gd`

extends Reference

const SET = "Terrains"
const CARDS := {
	"Grassland": {
		"Tags": ["Basic"],
		"Starting Cards": 4,
		"Requirements": "",
		"Abilities": "Send scouts to explore grassland.",
		"Cost": 1,
		"Resources": "",
		"script": {
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
		"Tags": [""],
		"Requirements": "",
		"Starting Cards": 1,
		"Abilities": "Send scouts to explore hill terrain.",
		"Cost": 2,
		"Resources": "",
		"script": {
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
		"Tags": ["Basic"],
		"Starting Cards": 2,
		"Requirements": "Must be adyacent to a city and on grassland.",
		"Abilities": "Produces food.",
		"Cost": 2,
		"Resources": "",
		"script": {
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
	"Chop Forest": {
		"Tags": ["Basic"],
		"Starting Cards": 1,
		"Requirements": "Must use on forest.",
		"Abilities": "Removes a forest to gain wood and space.",
		"Cost": 2,
		"Resources": "",
		"script": {
			"type": "place_tile",
			"tile": {
				"layer": "effect",
				"flora": -1,
				"resources": {
					"wood" : 5
				},
				"rules": {
					"flora_type": 9,
				},
			},
			"costs": {
				"credits": 2,
			},
		},
	},
	"Settler": {
		"Tags": [""],
		"Requirements": "Must not be adyacent to another city.",
		"Abilities": "Founds a city.",
		"Cost": 2,
		"Resources": "",
	},
	"Observatory": {
		"Tags": [""],
		"Requirements": "Must be on hills.",
		"Abilities": "Produces science.",
		"Cost": 1,
		"Resources": "Wood: 5",
	},
	"Grow City": {
		"Tags": ["Basic"],
		"Starting Cards": 1,
		"Requirements": "",
		"Abilities": "Grants new cards. Cost increases exponentially.",
		"Cost": 1,
		"Resources": "Food: X",
		"script": {
			"type": "place_tile",
			"tile": {
				"layer": "effect",
				"grow_city": true,
				"rules": {
					"city_size": 1,
					"food_available": true,
				},
			},
			"costs": {
				"credits": 1,
			},
		},
	},
}
