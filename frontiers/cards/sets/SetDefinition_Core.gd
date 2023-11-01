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
	},
	"Hills": {
		"Tags": [""],
		"Requirements": "",
		"Abilities": "Send scouts to explore hill terrain.",
		"Cost": 2,
		"Resources": "",
	},
	"Farm": {
		"Tags": ["Basic"],
		"Starting Cards": 2,
		"Requirements": "Must be adyacent to a city and on grassland.",
		"Abilities": "Produces food.",
		"Cost": 2,
		"Resources": "",
	},
	"Logging Camp": {
		"Tags": [""],
		"Requirements": "Must be on forest.",
		"Abilities": "Produces wood.",
		"Cost": 2,
		"Resources": "",
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
		"Abilities": "Grants new cards. Costs equal to the city size + the total amount of cities.",
		"Cost": 1,
		"Resources": "Food: X",
	},
}
