extends "res://entities/character.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stats = character_stats.new()

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
	scores[3] = 0

	# powerup
	scores[4] = 0

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

	print(scores)

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
