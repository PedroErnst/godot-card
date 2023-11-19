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
				"food_distance": true,
				"type": FRO.TERRAIN_GRASS,
				"name": "Grassland",
				"rules": {
					"terrain_type": FRO.TERRAIN_NONE,
				},
				"flora": {
					FRO.FLORA_FOREST: 30
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
		"Cost": 1,
		"Resources": "",
		"script": {
			"type": "place_tile",
			"tile": {
				"layer": "terrain",
				"food_distance": true,
				"type": FRO.TERRAIN_HILLS,
				"name": "Hills",
				"rules": {
					"terrain_type": FRO.TERRAIN_NONE,
				},
				"flora": {
					FRO.FLORA_FOREST: 60
				}
			},
			"costs": {
				"credits": 1,
			},
		},
	},
	"Mountains": {
		"Tags": ["WIP"],
		"Requirements": "",
		"Abilities": "Send scouts to explore mountain terrain.",
		"Cost": 2,
		"Resources": "",
		"script": {
			"type": "place_tile",
			"tile": {
				"layer": "terrain",
				"food_distance": true,
				"type": FRO.TERRAIN_MOUNTAIN,
				"name": "Mountains",
				"rules": {
					"terrain_type": FRO.TERRAIN_NONE,
				},
			},
			"costs": {
				"credits": 2,
			},
		},
	},
	"Lake": {
		"Tags": ["WIP"],
		"Requirements": "",
		"Abilities": "Send scouts to explore a lake.",
		"Cost": 1,
		"Resources": "",
		"script": {
			"type": "place_tile",
			"tile": {
				"layer": "terrain",
				"food_distance": true,
				"type": FRO.TERRAIN_WATER,
				"name": "Lake",
				"rules": {
					"terrain_type": FRO.TERRAIN_NONE,
				},
			},
			"costs": {
				"credits": 1,
			},
		},
	},
	"Swamp": {
		"Tags": ["WIP"],
		"Requirements": "",
		"Abilities": "Send scouts to explore a swamp.",
		"Cost": 1,
		"Resources": "",
		"script": {
			"type": "place_tile",
			"tile": {
				"layer": "terrain",
				"food_distance": true,
				"type": FRO.TERRAIN_MARSH,
				"name": "Swamp",
				"rules": {
					"terrain_type": FRO.TERRAIN_NONE,
				},
			},
			"costs": {
				"credits": 1,
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
				"food_distance": true,
				"type": FRO.BUILDING_FARM,
				"name": "Farm",
				"rules": {
					"terrain_type": FRO.TERRAIN_GRASS,
					"flora_type": FRO.FLORA_NONE,
					"adyacent_to": {
						"type": "building",
						"id": FRO.BUILDING_CITY
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
				"food_distance": true,
				"flora": FRO.TERRAIN_NONE,
				"resources": {
					"wood" : 5
				},
				"rules": {
					"flora_type": FRO.FLORA_FOREST,
				},
			},
			"costs": {
				"credits": 2,
			},
		},
	},
	"Settler": {
		"Tags": ["WIP"],
		"Requirements": "Must not be adyacent to another city.",
		"Abilities": "Founds a city.",
		"Cost": 2,
		"Resources": "",
	},
	"Observatory": {
		"Tags": ["WIP"],
		"Requirements": "Must be on hills.",
		"Abilities": "Produces science.",
		"Cost": 1,
		"Resources": "Wood: 5",
	},
	"Windmill": {
		"Tags": ["WIP"],
		"Requirements": "Must be adyacent to farms.",
		"Abilities": "Produces 1 food for each adyacent farm.",
		"Cost": 1,
		"Resources": "Wood: 10",
		"script": {
			"type": "place_tile",
			"tile": {
				"layer": "building",
				"food_distance": true,
				"type": FRO.BUILDING_WINDMILL,
				"name": "Farm",
				"rules": {
					"terrain_type": FRO.TERRAIN_GRASS,
					"flora_type": FRO.FLORA_NONE,
					"adyacent_to": {
						"type": "building",
						"id": FRO.BUILDING_FARM
					},
				},
			},
			"costs": {
				"credits": 1,
			},
		},
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
	"Militia Attack": {
		"Tags": ["Basic"],
		"Starting Cards": 1,
		"Requirements": "Must use on an enemy.",
		"Abilities": "Rally the town militia for an attack.",
		"Cost": 3,
		"Resources": "",
		"script": {
			"type": "place_tile",
			"tile": {
				"layer": "effect",
				"food_distance": true,
				"damage": 1,
				"rules": {
					"enemy_unit": true,
				},
			},
			"costs": {
				"credits": 3,
			},
		},
	},
	"Trained Militia Attack": {
		"Tags": ["WIP"],
		"Requirements": "Must use on an enemy.",
		"Abilities": "Rally the trained town militia for an attack.",
		"Cost": 2,
		"Resources": "",
		"script": {
			"type": "place_tile",
			"tile": {
				"layer": "effect",
				"food_distance": true,
				"damage": 1,
				"rules": {
					"enemy_unit": true,
				},
			},
			"costs": {
				"credits": 2,
			},
		},
	},
	"Spearmen Militia Attack": {
		"Tags": ["WIP"],
		"Requirements": "Must use on an enemy.",
		"Abilities": "Militia equipped with spears are deadlier.",
		"Cost": 2,
		"Resources": "",
		"script": {
			"type": "place_tile",
			"tile": {
				"layer": "effect",
				"food_distance": true,
				"damage": 2,
				"rules": {
					"enemy_unit": true,
				},
			},
			"costs": {
				"credits": 2,
			},
		},
	},
}
