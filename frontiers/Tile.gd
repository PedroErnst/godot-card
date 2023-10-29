extends Reference

var type : int
var name : String

func _init(definition: Dictionary):
	type = definition.type
	name = definition.name
