class_name NewWeaponController extends Node3D

var weapon: WeaponBase = null
@export var player: Player

func _ready() -> void:
	if self.get_child_count() > 0:
		weapon = self.get_child(0)
		await player.ready
		connect_weapon(weapon)

func has_weapon() -> bool:
	return weapon != null

func set_weapon(new_weapon: WeaponBase) -> void:
	if self.get_child_count() > 0:
		var old_weapon: WeaponBase = self.get_child(0)
		old_weapon.queue_free()
	self.add_child(new_weapon)
	weapon = new_weapon
	connect_weapon(new_weapon)

func connect_weapon(new_weapon: WeaponBase) -> void:
	new_weapon.bullet_spawned.connect(player.add_collision_exception)
	new_weapon.secondary_attacked.connect(player.toggle_reticle)
	new_weapon.ammo_changed.connect(player.ammo_ui._on_ammo_change)

func attack_primary():
	if weapon:
		weapon.attack_primary()

func attack_secondary():
	if weapon:
		weapon.attack_secondary()

func reload():
	if weapon:
		weapon.reload()
