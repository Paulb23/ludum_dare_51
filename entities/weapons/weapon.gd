extends Resource
class_name weapon

@export var name : String = ""

enum types {
	meele = 0,
	range = 1,
	magic = 2
}

@export_enum("meele:0", "range:1", "magic:2") var type : int = 0

@export var price : int = 1

@export var damage : int = 1

@export var range : int = 1

@export_file("*.png") var sprite : String

@export_file("*.png") var locked_icon : String
@export_file("*.png") var unlocked_icon : String

@export_file("*.png") var hover_icon : String
@export_file("*.png") var clicked_icon : String
