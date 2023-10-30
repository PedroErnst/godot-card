# This file contains just card definitions. See also `CardConfig.gd`

extends Reference

const SET = "Terrains"
const CARDS := {
	"Grassland": {
		"Type": "Terrain",
		"Tags": ["Terrain"],
		"Requirements": "",
		"Abilities": "Send scouts to explore grassland. Sometimes with forest.",
		"Cost": 1,
		"Power": 0,
	},
	"Hills": {
		"Type": "Terrain",
		"Tags": ["Terrain"],
		"Requirements": "",
		"Abilities": "Send scouts to explore hill terrain. Often with forest.",
		"Cost": 2,
		"Power": 0,
	},
	"Farm": {
		"Type": "Terrain",
		"Tags": ["Building"],
		"Requirements": "",
		"Abilities": "Must be adyacent to villages. Produces food.",
		"Cost": 2,
		"Power": 0,
	},
	"Logging Camp": {
		"Type": "Terrain",
		"Tags": ["Building"],
		"Requirements": "",
		"Abilities": "Must be on forest. Produces wood.",
		"Cost": 2,
		"Power": 0,
	},
}
