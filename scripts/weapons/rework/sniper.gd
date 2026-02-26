class_name Sniper extends WeaponBase


@export var weapon_type : Weapons # Weapon Resource

@onready var _viewport_scope := $SubViewport
@onready var _viewport_scope_anker := $ViewportScopeAnker
@onready var mesh := $Mesh/SniperRifle
@onready var _fire_rate_timer := $FireRateTimer
@onready var _reload_timer := $ReloadTimer
@onready var _muzzle_flash := $Mesh/MuzzleFlash
@onready var _bullet_spawn := $BulletSpawn
@onready var _animation_player := $AnimationPlayer

var _bullet_scene = preload("res://scenes/Weapons/Bullet.tscn")

var _max_ammo : int # max ammo defined by weapon
var _max_magazine : int # max ammo that fits inside a magazine
var _current_total_ammo : int # current total ammo - magazine
var _current_magazine : int
var _attack_range : int
var _fire_rate : int
var _reload_time : float
var recoil_amount : Vector3
var recoil_snap_amount : float
var recoil_speed : float
var _spread : Vector3

var _scoped : bool = false

func _ready() -> void:
	_max_ammo = weapon_type.max_ammo
	_max_magazine = weapon_type.magazine_size
	_current_magazine = _max_magazine
	_current_total_ammo = _max_ammo - _max_magazine
	_attack_range = weapon_type.bullet_range
	_reload_time = weapon_type.reload_time
	recoil_amount = weapon_type.recoil_amount
	recoil_snap_amount = weapon_type.recoil_snap_amount
	recoil_speed = weapon_type.recoil_speed
	_spread = weapon_type.spread
	_fire_rate = weapon_type.fire_rate
	
	await get_tree().process_frame
	ammo_changed.emit(_current_magazine, _max_magazine, _current_total_ammo, _max_ammo)

	var viewport_texture = _viewport_scope.get_texture()
	
	var material = StandardMaterial3D.new()
	material.albedo_texture = viewport_texture
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	
	mesh.set_surface_override_material(4, material)


func _process(_delta: float) -> void:
	_viewport_scope.get_camera_3d().global_transform = _viewport_scope_anker.global_transform


func attack_primary():
	if _fire_rate_timer.is_stopped() and _current_magazine > 0 and _reload_timer.is_stopped():
		primary_attacked.emit()
		_muzzle_flash.add_muzzle_flash()
		_spawn_bullet()
		_current_magazine -= 1
		_fire_rate_timer.start(1.0 / _fire_rate)
		ammo_changed.emit(_current_magazine, _max_magazine, _current_total_ammo, _max_ammo)


func attack_secondary():
	if _reload_timer.is_stopped():
		if _scoped:
			_unscope()
		else:
			_scope()
		secondary_attacked.emit()


func reload():
	if _current_magazine < _max_magazine and _reload_timer.is_stopped():
		if _scoped:
			_unscope()
			secondary_attacked.emit()
		
		var start_basis = mesh.transform.basis
		var tween = create_tween()

		#kein ahnung mehr, möge gott euch beistehen
		tween.tween_method(
			func(value):
				var rot = Basis(Vector3.FORWARD, value)
				mesh.transform.basis = start_basis * rot,
			0.0,
			TAU,
			_reload_time
		).set_trans(Tween.TRANS_LINEAR)
		
		_current_total_ammo += _current_magazine
		_current_magazine = 0
		_reload_timer.start(_reload_time)
		await _reload_timer.timeout
		_current_magazine += clamp(_current_total_ammo,0,_max_magazine)
		_current_total_ammo -= _current_magazine
		ammo_changed.emit(_current_magazine, _max_magazine, _current_total_ammo, _max_ammo)


func _spawn_bullet() -> void:
	var bullet : RigidBody3D = _bullet_scene.instantiate()
	
	bullet.find_child("HitboxComponent").damage = weapon_type.damage
	
	bullet_spawned.emit(bullet)
	
	bullet.position = _bullet_spawn.global_position
	bullet.rotation = get_parent_node_3d().owner._camera_rotation + get_parent_node_3d().owner._player_rotation + current_rotation
	if !_scoped:
		bullet.rotation_degrees += Vector3(randf_range(-_spread.x,_spread.x),randf_range(-_spread.y,_spread.y),0)
	get_tree().current_scene.add_child(bullet)
	
	var forward : Vector3 = -bullet.global_transform.basis.z
	bullet.linear_velocity = forward * _attack_range


func _unscope():
	_scoped = false
	_animation_player.play("weapon_scope",-1,-1.0,true)
	

func _scope():
	_scoped = true
	_animation_player.play("weapon_scope",-1,1.0,false)
