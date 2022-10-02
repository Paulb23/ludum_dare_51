extends ColorRect

var magic = [
	preload("res://entities/weapons/staff.tres")
]

var weapons = [
	preload("res://entities/weapons/unarmed.tres"),
	preload("res://entities/weapons/short_sword.tres"),
	preload("res://entities/weapons/long_sword.tres")
]

var last_button
var current
var shop_type = "weapons"

func _ready() -> void:
	$HBoxContainer/VBoxContainer/HBoxContainer/buy.pressed.connect(self._buy_presed)
	$HBoxContainer/VBoxContainer/HBoxContainer/equip.pressed.connect(self._eqiup)
	$HBoxContainer/VBoxContainer/HBoxContainer/equip_seconday.pressed.connect(self._eqiup_secondary)
	$close.pressed.connect(self._close_shop)

func _close_shop():
	self.visible = false

func load_shop(type : String) -> void:
	$HBoxContainer/VBoxContainer/name.text = ""
	$HBoxContainer/VBoxContainer/stats.text = ""

	for node in $HBoxContainer/GridContainer.get_children():
		$HBoxContainer/GridContainer.remove_child(node)

	if type == "weapons" || type == "magic":
		$HBoxContainer/VBoxContainer/HBoxContainer/equip_seconday.disabled = false
		shop_type = type

		for item in weapons if type == "weapons" else magic:
			if item.unlocked_icon == "":
				continue
			var tb = TextureButton.new()
			if PlayerProfile.stats.brought_items.has(item.name):
				tb.texture_normal = await Filesystem.load_resource(item.unlocked_icon) as Texture2D
			else:
				tb.texture_normal = await Filesystem.load_resource(item.locked_icon) as Texture2D
			if item.hover_icon != "":
				tb.texture_hover = await Filesystem.load_resource(item.hover_icon) as Texture2D

			tb.mouse_entered.connect(self.item_hovered.bind(item, tb))
			$HBoxContainer/GridContainer.add_child(tb)
	else:
		$HBoxContainer/VBoxContainer/HBoxContainer/equip_seconday.disabled = true

	$Panel/Label.text = str("Gold: ", PlayerProfile.stats.gold)

func item_hovered(res, tb) -> void:
	tb.texture_normal = load(res.hover_icon) as Texture2D

	if current:
		if PlayerProfile.stats.brought_items.has(current.name):
			last_button.texture_normal = load(current.unlocked_icon) as Texture2D
		else:
			last_button.texture_normal = load(current.locked_icon) as Texture2D

	current = res
	last_button = tb

	$HBoxContainer/VBoxContainer/name.text = res.name

	if shop_type == "weapons" || shop_type == "magic":
		var text = str("Gold: ", res.price, "\n\nDamage: ", res.damage, "\nRange: ", res.range)
		$HBoxContainer/VBoxContainer/stats.text = text

		$HBoxContainer/VBoxContainer/HBoxContainer/equip.disabled = !PlayerProfile.stats.brought_items.has(res.name) || PlayerProfile.stats.main_weapon.name == res.name
		$HBoxContainer/VBoxContainer/HBoxContainer/equip_seconday.disabled = !PlayerProfile.stats.brought_items.has(res.name) || PlayerProfile.stats.secondary_weapon.name == res.name
		$HBoxContainer/VBoxContainer/HBoxContainer/buy.disabled = PlayerProfile.stats.brought_items.has(res.name) || PlayerProfile.stats.gold < res.price

func _buy_presed() -> void:
	PlayerProfile.stats.brought_items.push_back(current.name)
	PlayerProfile.stats.gold -= current.price
	load_shop(shop_type)
	item_hovered(current, last_button)

func _eqiup() -> void:
	if shop_type == "weapons" || shop_type == "magic":
		PlayerProfile.stats.main_weapon = current
	item_hovered(current, last_button)

func _eqiup_secondary() -> void:
	PlayerProfile.stats.secondary_weapon = current
	item_hovered(current, last_button)
