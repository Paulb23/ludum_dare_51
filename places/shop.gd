extends ColorRect

var weapons = [
	preload("res://entities/weapons/unarmed.tres"),
	preload("res://entities/weapons/short_sword.tres")
]

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
	for node in $HBoxContainer/GridContainer.get_children():
		$HBoxContainer/GridContainer.remove_child(node)

	if type == "weapons":
		$HBoxContainer/VBoxContainer/HBoxContainer/equip_seconday.disabled = false
		shop_type = "weapons"

		for item in weapons:
			if item.unlocked_icon == "":
				continue
			var tb = TextureButton.new()
			tb.texture_normal = await Filesystem.load_resource(item.unlocked_icon) as Texture2D

			tb.mouse_entered.connect(self.item_hovered.bind(item))
			$HBoxContainer/GridContainer.add_child(tb)
	else:
		$HBoxContainer/VBoxContainer/HBoxContainer/equip_seconday.disabled = true

	$Panel/Label.text = str("Gold: ", PlayerProfile.stats.gold)

func item_hovered(res) -> void:
	current = res

	$HBoxContainer/VBoxContainer/name.text = res.name

	if shop_type == "weapons":
		var text = str("Gold: ", res.price, "\n\nDamage: ", res.damage, "\nRange: ", res.range)
		$HBoxContainer/VBoxContainer/stats.text = text

		$HBoxContainer/VBoxContainer/HBoxContainer/equip.disabled = !PlayerProfile.stats.brought_items.has(res.name) || PlayerProfile.stats.main_weapon.name == res.name
		$HBoxContainer/VBoxContainer/HBoxContainer/equip_seconday.disabled = !PlayerProfile.stats.brought_items.has(res.name) || PlayerProfile.stats.secondary_weapon.name == res.name
		$HBoxContainer/VBoxContainer/HBoxContainer/buy.disabled = PlayerProfile.stats.brought_items.has(res.name) || PlayerProfile.stats.gold < res.price

func _buy_presed() -> void:
	PlayerProfile.stats.brought_items.push_back(current.name)
	PlayerProfile.stats.gold -= current.price
	load_shop("weapons")
	item_hovered(current)

func _eqiup() -> void:
	if shop_type == "weapons":
		PlayerProfile.stats.main_weapon = current
	item_hovered(current)

func _eqiup_secondary() -> void:
	PlayerProfile.stats.secondary_weapon = current
	item_hovered(current)
