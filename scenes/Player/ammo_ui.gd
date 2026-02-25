extends VBoxContainer

@onready var magazineLabel: Label = $Magazine
@onready var totalLabel: Label = $Total

func _on_ammo_change(magazine: int, max_magazine: int, total: int, max_total: int) -> void:
	magazineLabel.text = "Magazine: %d / %d" % [magazine, max_magazine]
	totalLabel.text = "Ammo Pouch: %d / %d" % [total, max_total]
