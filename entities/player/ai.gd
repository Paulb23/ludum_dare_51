extends "res://entities/character.gd"

var hair_colours = [
	"red",
	"green",
	"blue",
	"purple",
	"yellow"
]

var skin_colours = [
	"white",
	"brown",
	"red",
	"green",
	"blue",
	"purple",
	"yellow"
]

var names = [
	"Aelia",
	"Alba",
	"Albina",
	"Antonia",
	"Aquila",
	"Augusta",
	"Aurelia",
	"Balbina",
	"Caecilia",
	"Camilla",
	"Cassia",
	"Claudia",
	"Cornelia",
	"Decima",
	"Domitia",
	"Fabia",
	"Fausta",
	"Flavia",
	"HadrianaHerminia",
	"Horatia",
	"Hortensia",
	"Julia",
	"Liviana",
	"Lucia",
	"Marcella",
	"Mariana",
	"Martina",
	"Octavia",
	"Valentina",
	"Valeria",
	"Ancient",
	"Cicero",
	"Marcellus",
	"Maximus",
	"Octavius",
	"Otho",
	"Porcius",
	"Regulus",
	"Rufus",
	"Sabinus",
	"Seneca",
	"Septimus",
	"Tatius",
	"Titus",
	"Vitus",
	"Valens",
	"Aelius",
	"Albanus",
	"Augustus",
	"Avitus",
	"Brutus",
	"Caesar",
	"Drusus",
	"Fabius",
	"Felix",
	"Festus",
	"Gallus",
	"Hilarius",
	"Junius"
]

# Should make this control behaviour as well
var build = ""
var builds = [
	"bare",
	"mage",
	"fast",
	"beast"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
	stats = character_stats.new()
	stats.name = names[rng.randi_range(0, names.size() - 1)]
	stats.hair_colour = hair_colours[rng.randi_range(0, hair_colours.size() - 1)]
	stats.skin_colour = skin_colours[rng.randi_range(0, skin_colours.size() - 1)]

	var build = builds[rng.randi_range(0, builds.size() - 1)]
	var points = PlayerProfile.stats.max_allocated_stats

	if build == "bare":
		stats.health = points * 0.2
		stats.stamina = points * 0.2
		stats.mana = points * 0.1
		stats.agility = points * 0.1
		stats.constitution = points * 0.1
		stats.strength = points * 0.1
		stats.wisdom = points * 0.1

	if build == "mage":
		stats.health = points * 0.2
		stats.stamina = points * 0.1
		stats.mana = points * 0.3
		stats.agility = points * 0.1
		stats.constitution = points * 0
		stats.strength = points * 0.01
		stats.wisdom = points * 0.3

	if build == "fast":
		stats.health = points * 0.2
		stats.stamina = points * 0.1
		stats.mana = points * 0.1
		stats.agility = points * 0.3
		stats.constitution = points * 0.1
		stats.strength = points * 0.01
		stats.wisdom = points * 0

	if build == "beast":
		stats.health = points * 0.3
		stats.stamina = points * 0.2
		stats.mana = points * 0.1
		stats.agility = points * 0.01
		stats.constitution = points * 0.1
		stats.strength = points * 0.3
		stats.wisdom = points * 0.01

	var weapons = [
		"res://entities/weapons/unarmed.tres"
	]

	# Allow short sword
	if points > 30:
		weapons.push_back("res://entities/weapons/short_sword.tres")

	# Allow long sword
	if points > 40:
		weapons.push_back("res://entities/weapons/long_sword.tres")

	# Allow staff and helm
	if points > 50:
		weapons.push_back("res://entities/weapons/staff.tres")

		if rng.randi_range(0, 1):
			stats.helm = load("res://entities/armour/iron_helm.tres")

	stats.main_weapon = load(weapons[rng.randi_range(0, weapons.size() - 1)])
	stats.secondary_weapon = load(weapons[rng.randi_range(0, weapons.size() - 1)])



func ready_up() -> void:
	super()

func _get_new_right_pos() -> int:
	return self.position.x - 100

func _get_new_left_pos() -> int:
	return self.position.x + 100

func do_turn(other : character) -> void:
	var scores = [0, 0, 0, 0, 0, 0, 0, 0, 0, -1]

	var _in_range := 1 if in_range(other) else 0
	var _swap_in_range := 1 if swap_in_range(other) else 0

	var _out_of_range = 0 if in_range(other) else 2
	_out_of_range += 1 if swap_in_range(other) else 0

	var _can_attack := 1 if enough_stamina_for_attack() else 0
	var _can_quick_attack := 1 if enough_stamina_for_quick_attack() else 0
	var _can_move := 1 if enough_stamina_for_move() else 0

	var action_can_do := 1 if _can_attack else 0
	action_can_do += 1 if _can_quick_attack else 0
	action_can_do += 1 if _can_move else 0

	var _will_kill := 1 if other.stats.health < _current_equiped.damage else 0

	# attack
	scores[0] = _in_range + _can_attack + _will_kill

	# quick attack
	scores[1] = _in_range + _can_quick_attack + _will_kill

	# swap
	scores[2] = _swap_in_range

	# heal
	scores[3] = 1 if stats.health == 1 else 0

	# powerup
	scores[4] = ((5 if build == "mage" else 1) if stats.mana < 1 else 0)

	# move left
	scores[5] = 0

	# move right
	scores[6] = _out_of_range

	# jump
	scores[7] = 0

	# rest
	scores[8] = 3 - action_can_do + 1 if stats.stamina == 0 else 0

	# run
	scores[9] = -1

	match scores.find(scores.max()):
		0:
			do_attack(other)
		1:
			do_quick_attack(other)
		2:
			do_swap(other)
		3:
			do_heal(other)
		4:
			do_powerup(other)
		5:
			do_move_left(other)
		6:
			do_move_right(other)
		7:
			do_jump(other)
		8:
			do_rest(other)
		9:
			do_run(other)
