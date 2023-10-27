# This file contains just card definitions. See also `CardConfig.gd`

extends Reference

const SET = "Terrains"
const CARDS := {
	"Grassland": {
		"Type": "Terrain",
		"Tags": ["Terrain"],
		"Requirements": "",
		"Abilities": "Send scouts to explore grassland.",
		"Cost": 1,
		"Power": 0,
	},
	"Hills": {
		"Type": "Terrain",
		"Tags": ["Terrain"],
		"Requirements": "",
		"Abilities": "Send scouts to explore hill terrain.",
		"Cost": 2,
		"Power": 0,
	},
}
