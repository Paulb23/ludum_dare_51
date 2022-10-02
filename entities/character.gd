extends Node
class_name character

@export var stats : character_stats

var max_health = 1
var max_mana = 1
var max_stamina = 1

var _using_main := true
var _current_equiped : weapon
var rng = RandomNumberGenerator.new()

func ready_up() -> void:
	rng.randomize()

	_current_equiped = stats.main_weapon
	_using_main = true

	max_health = stats.health
	max_stamina = stats.stamina
	max_mana = stats.mana

	$skeleton.set_hair_color(stats.hair_colour)
	$skeleton.set_skin_color(stats.skin_colour)
	$skeleton._load_weapon(_current_equiped)
	$skeleton.load_amour(stats.helm)


func do_attack(other : character) -> void:
	if (stats.stamina < 2):
		return
	var distance = abs(self.global_position - other.global_position).x

	var damage = 0
	if distance < _current_equiped.range:
		var chance = 0
		if _current_equiped.type == weapon.types.meele:
			chance =  ((stats.strength * (1.5 + (stats.luck * 0.01))) - (other.stats.agility + (other.stats.luck * 0.01))) * 100
		if _current_equiped.type == weapon.types.magic:
			chance = ((stats.wisdom * (1.5 + (stats.luck * 0.01))) - (other.stats.agility + (other.stats.luck * 0.01))) * 100

		if (rng.randi_range(0, 100) < abs(chance)):
			damage = max(1, _current_equiped.damage - stats.constitution)

	stats.stamina -= 2
	other.take_hit(damage)

	if _current_equiped.type == weapon.types.meele:
		await $skeleton.animation_play("meele_attack")
	else:
		await $skeleton.animation_play("magic_attack")

func do_quick_attack(other : character) -> void:
	if (stats.stamina < 1):
		return

	var damage = 0
	if in_range(other):
		var chance = 0
		if _current_equiped.type == weapon.types.meele:
			chance =  ((stats.strength * (1.7 + (stats.luck * 0.01))) - (other.stats.agility + (other.stats.luck * 0.01))) * 100
		if _current_equiped.type == weapon.types.magic:
			chance = ((stats.wisdom * (1.7 + (stats.luck * 0.01))) - (other.stats.agility + (other.stats.luck * 0.01))) * 100

		if (rng.randi_range(0, 100) < abs(chance)):
			damage = max(1, round(_current_equiped.damage / 2) - stats.constitution)

	if other.stats.helm:
		damage -= 2

	stats.stamina -= 1
	other.take_hit(damage)

	if _current_equiped.type == weapon.types.meele:
		await $skeleton.animation_play("meele_attack")
	else:
		await $skeleton.animation_play("magic_attack")

func do_swap(other : character) -> void:
	if _using_main:
		_current_equiped = stats.secondary_weapon
		_using_main = false
		$skeleton._load_weapon(_current_equiped)
		await $skeleton.animation_play("swap")
		return

	_current_equiped = stats.main_weapon
	_using_main = true
	await $skeleton.animation_play("swap")
	$skeleton._load_weapon(_current_equiped)

func do_heal(other : character) -> void:
	stats.health = min(max_health, stats.health + 1)
	await $skeleton.animation_play("heal")

func do_powerup(other : character) -> void:
	stats.mana = min(max_mana, stats.mana + 1)
	await $skeleton.animation_play("mana")

func do_move_right(other : character) -> void:
	if (stats.stamina < 1):
		return
	var tween := get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(_get_new_right_pos(), 0), 0.5)
	stats.stamina -= 1
	await $skeleton.animation_play("move")

func do_move_left(other : character) -> void:
	if (stats.stamina < 1):
		return
	var tween := get_tree().create_tween()

	tween.tween_property(self, "position", Vector2(_get_new_left_pos(), 0), 0.5)
	stats.stamina -= 1
	await $skeleton.animation_play("move")

func do_jump(other : character) -> void:
	if (stats.stamina < 2):
		return
	var tween := get_tree().create_tween()
	if _get_new_right_pos() != self.position.x:
		tween.tween_property(self, "position", Vector2(_get_new_right_pos() + 50, 0), 0.5)
	stats.stamina -= 2
	await $skeleton.animation_play("move")

func do_rest(other : character) -> void:
	stats.stamina = min(max_stamina, stats.stamina + 3)
	await $skeleton.animation_play("rest")

func do_run(other : character) -> void:
	pass

func _get_new_right_pos() -> int:
	var target = self.position.x + 100
	if (abs(target - %ai.position.x) > 700):
		target = self.position.x
	return target

func _get_new_left_pos() -> int:
	var target = self.position.x - 100
	if (target <= -300):
		target = self.position.x
	return target

func take_hit(damage : int) -> void:
	stats.health -= damage
	if (damage > 0):
		await $skeleton.animation_play("hit")
	else:
		await $skeleton.animation_play("block")

func in_range(other : character) -> bool:
	return abs(self.global_position - other.global_position).x < _current_equiped.range

func swap_in_range(other : character) -> bool:
	if _using_main:
		return abs(self.global_position - other.global_position).x < stats.main_weapon.range
	return abs(self.global_position - other.global_position).x < stats.secondary_weapon.range

func enough_stamina_for_attack() -> bool:
	return stats.stamina > 1

func enough_stamina_for_quick_attack() -> bool:
	return stats.stamina > 0

func enough_stamina_for_move() -> bool:
	return stats.stamina > 0

func enough_stamina_for_jump() -> bool:
	return stats.stamina > 1

func at_max_health() -> bool:
	return stats.health == max_health

func at_max_stamina() -> bool:
	return stats.stamina == max_stamina

func at_max_mana() -> bool:
	return stats.mana == max_mana

func death() -> void:
	await $skeleton.animation_play("death")
