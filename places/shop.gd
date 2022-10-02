extends ColorRect

var armours = [
	preload("res://entities/armour/iron_helm.tres")
]

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
	$HBoxContainer/VBoxContainer/HBoxContainer/buy.mouse_entered.connect(AudioManager._play_hover)
	$HBoxContainer/VBoxContainer/HBoxContainer/equip.mouse_entered.connect(AudioManager._play_hover)
	$HBoxContainer/VBoxContainer/HBoxContainer/equip_seconday.mouse_entered.connect(AudioManager._play_hover)
	$close.mouse_entered.connect(AudioManager._play_hover)

	$HBoxContainer/VBoxContainer/HBoxContainer/buy.pressed.connect(self._buy_presed)
	$HBoxContainer/VBoxContainer/HBoxContainer/equip.pressed.connect(self._eqiup)
	$HBoxContainer/VBoxContainer/HBoxContainer/equip_seconday.pressed.connect(self._eqiup_secondary)
	$close.pressed.connect(self._close_shop)

func _close_shop():
	current = null
	AudioManager._play_click()
	self.visible = false

func load_shop(type : String) -> void:
	$HBoxContainer/VBoxContainer/name.text = ""
	$HBoxContainer/VBoxContainer/stats.text = ""

	for node in $HBoxContainer/GridContainer.get_children():
		$HBoxContainer/GridContainer.remove_child(node)

	if type == "weapons" || type == "magic":
		$HBoxContainer/VBoxContainer/HBoxContainer/equip_seconday.disabled = false
	else:
		$HBoxContainer/VBoxContainer/HBoxContainer/equip_seconday.disabled = true

	shop_type = type
	for item in weapons if type == "weapons" else magic if type == "magic" else armours:
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

	if !current:
		$HBoxContainer/VBoxContainer/HBoxContainer/equip_seconday.disabled = true
		$HBoxContainer/VBoxContainer/HBoxContainer/buy.disabled = true
		$HBoxContainer/VBoxContainer/HBoxContainer/equip.disabled = true

	$Panel/Label.text = str("Gold: ", PlayerProfile.stats.gold)

func item_hovered(res, tb) -> void:
	AudioManager._play_hover()
	tb.texture_normal = load(res.hover_icon) as Texture2D

	if current:
		if PlayerProfile.stats.brought_items.has(current.name):
			last_button.texture_normal = load(current.unlocked_icon) as Texture2D
		else:
			last_button.texture_normal = load(current.locked_icon) as Texture2D

	current = res
	last_button = tb

	$HBoxContainer/VBoxContainer/name.text = res.name

	var owns : bool = PlayerProfile.stats.brought_items.has(res.name)
	if shop_type == "weapons" || shop_type == "magic":
		var text = str("Gold: ", res.price, "\n\nDamage: ", res.damage, "\nRange: ", res.range)
		$HBoxContainer/VBoxContainer/stats.text = text

		$HBoxContainer/VBoxContainer/HBoxContainer/equip.disabled = !owns || PlayerProfile.stats.main_weapon.name == res.name
		$HBoxContainer/VBoxContainer/HBoxContainer/equip_seconday.disabled = !owns || PlayerProfile.stats.secondary_weapon.name == res.name
		$HBoxContainer/VBoxContainer/HBoxContainer/buy.disabled = owns || PlayerProfile.stats.gold < res.price

	if shop_type == "armour":
		var text = str("Gold: ", res.price, "\n\nArmour: ", res.armour)
		$HBoxContainer/VBoxContainer/stats.text = text

		if res.type == armour.types.helm:
			$HBoxContainer/VBoxContainer/HBoxContainer/equip.disabled = !owns || (PlayerProfile.stats.helm && PlayerProfile.stats.helm.name == res.name)
			$HBoxContainer/VBoxContainer/HBoxContainer/buy.disabled = owns || PlayerProfile.stats.gold < res.price

func _buy_presed() -> void:
	AudioManager._play_click()
	PlayerProfile.stats.brought_items.push_back(current.name)
	PlayerProfile.stats.gold -= current.price
	load_shop(shop_type)
	item_hovered(current, last_button)
	PlayerProfile.save_stats()

func _eqiup() -> void:
	AudioManager._play_click()
	if shop_type == "weapons" || shop_type == "magic":
		PlayerProfile.stats.main_weapon = current

	if shop_type == "armour":
		if current.type == armour.types.helm:
			PlayerProfile.stats.helm = current
	item_hovered(current, last_button)
	PlayerProfile.save_stats()

func _eqiup_secondary() -> void:
	AudioManager._play_click()
	PlayerProfile.stats.secondary_weapon = current
	PlayerProfile.save_stats()
	item_hovered(current, last_button)
