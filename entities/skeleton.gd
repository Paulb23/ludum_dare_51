extends Node2D

var band_color := Color("#f9dc65")
var hair_color := Color("#8a3d53")
var hair_color_shade := Color("#712a4a")

var skin_color := Color("#f5d1a9")
var skin_color_shade := Color("#f1ac7b")

func _ready() -> void:
	update_materials()

func set_hair_color(colour) -> void:
	if (colour == "red"):
		band_color = Color("#f9dc65")
		hair_color = Color("#8a3d53")
		hair_color_shade = Color("#712a4a")

	if (colour == "green"):
		band_color = Color("#f9dc65")
		hair_color = Color("#6ab25b")
		hair_color_shade = Color("#3c8b6c")

	if (colour == "blue"):
		band_color = Color("#f9dc65")
		hair_color = Color("#5ec1c7")
		hair_color_shade = Color("#4394b0")

	if (colour == "purple"):
		band_color = Color("#f9dc65")
		hair_color = Color("#6b3fa8")
		hair_color_shade = Color("#4d3384")

	if (colour == "yellow"):
		band_color = Color("#4d3384")
		hair_color = Color("#f9dc65")
		hair_color_shade = Color("#c0cb52")

	update_materials()

func set_skin_color(colour) -> void:
	if (colour == "white"):
		skin_color = Color("#f5d1a9")
		skin_color_shade = Color("#f1ac7b")

	if (colour == "brown"):
		skin_color = Color("#af5d5d")
		skin_color_shade = Color("#8a3d53")

	if (colour == "green"):
		skin_color = Color("#6ab25b")
		skin_color_shade = Color("#3c8b6c")

	if (colour == "red"):
		skin_color = Color("#ab3246")
		skin_color_shade = Color("#dc584a")

	if (colour == "blue"):
		skin_color = Color("#386d9b")
		skin_color_shade = Color("#334f88")

	if (colour == "purple"):
		skin_color = Color("#6b3fa8")
		skin_color_shade = Color("#4d3384")

	if (colour == "yellow"):
		skin_color = Color("#f9dc65")
		skin_color_shade = Color("#c0cb52")

	update_materials()

func update_materials() -> void:
	$skeleton/hipBone2D/torsoBone2D/neckBone2D/headBone2D/head/hair.material.set_shader_parameter("band_color", band_color)
	$skeleton/hipBone2D/torsoBone2D/neckBone2D/headBone2D/head/hair.material.set_shader_parameter("hair_color_shade", hair_color_shade)
	$skeleton/hipBone2D/torsoBone2D/neckBone2D/headBone2D/head/hair.material.set_shader_parameter("hair_color", hair_color)
	_update_skin_color(self)

func _update_skin_color(n) -> void:
	for node in n.get_children():
		if node is Sprite2D:
			if node.name in ["hair","eyes","mouth","eye_brows", "weapon","helm"]:
				continue
			node.material.set_shader_parameter("skin_color", skin_color)
			node.material.set_shader_parameter("skin_color_shade", skin_color_shade)
		else:
			_update_skin_color(node)

func _load_weapon(w : weapon) -> void:
	if w.sprite != "":
		$skeleton/hipBone2D/torsoBone2D/upper_arm_rightBone2D/lower_arm_rightBone2D/hand_rightBone2D/weapon.texture = load(w.sprite)
	else:
		$skeleton/hipBone2D/torsoBone2D/upper_arm_rightBone2D/lower_arm_rightBone2D/hand_rightBone2D/weapon.texture = null

func load_amour(w : armour) -> void:
	if w == null:
		return
	if w.type == armour.types.helm:
		if w.sprite != "":
			$skeleton/hipBone2D/torsoBone2D/neckBone2D/headBone2D/head/helm.texture = load(w.sprite)
			$skeleton/hipBone2D/torsoBone2D/neckBone2D/headBone2D/head/hair.visible = false
		else:
			$skeleton/hipBone2D/torsoBone2D/neckBone2D/headBone2D/head/helm.texture = null
			$skeleton/hipBone2D/torsoBone2D/neckBone2D/headBone2D/head/hair.visible = true
