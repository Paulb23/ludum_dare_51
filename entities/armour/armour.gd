extends Resource
class_name armour

@export var name : String = ""

enum types {
	helm = 0,
	body = 1,
	upper_arm = 2,
	hands = 3,
	legs = 4,
	feet = 5
}

@export_enum("helm:0", "body:1", "upper_arm:2", "hands:2", "legs:2", "feet:2") var type : int = 0

@export var price : int = 1

@export var armour : int = 1

@export_file("*.png") var sprite : String

@export_file("*.png") var locked_icon : String
@export_file("*.png") var unlocked_icon : String

@export_file("*.png") var hover_icon : String
