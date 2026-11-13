extends CharacterBody2D

@export var min_x := 16.0
@export var max_x := 120.0
@export var max_speed := 90.0
@export var acceleration := 250.0
@export var friction := 150.0       # zotrvačnosť
@export var surface_y := 60.0      # výška hladiny

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

signal kyslik_zmeneny(value: float, max_value: float)

@export var max_kyslik := 100.0
@export var kyslik_uberanie := 6.0
@export var kyslik_doplenie := 40.0

var kyslik := 0.0
var dead := false

func _ready() -> void:
	kyslik = max_kyslik

func _physics_process(delta: float) -> void:
	var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	# plynulé zrýchľovanie a dobiehanie
	if dir != Vector2.ZERO:
		velocity = velocity.move_toward(dir * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	move_and_slide()
	
	global_position.x = clamp(global_position.x, min_x, max_x)
	
	# limity 
	if global_position.y < surface_y:
		global_position.y = surface_y
		velocity.y = max(velocity.y, 0.0)
		
	_update_kyslik(delta)	
	_update_animation(dir, delta)

func _update_animation(dir: Vector2, delta: float) -> void:
	if dead:
		return
	if velocity.length() > 5.0:
		sprite.play("move")
	else:
		sprite.play("idle")
	# otočenie podľa smeru 
	if dir.x != 0:
		sprite.flip_h = dir.x < 0
	# zrychľovanie vrtule pri väčšej akcelerácii
	# sprite.speed_scale = 0.3 + velocity.length() / max_speed
	# jemné naklonenie pri stúpaní a klesaní
	var tilt := velocity.y / max_speed * 0.25
	if sprite.flip_h:
		tilt = -tilt
	sprite.rotation = lerp(sprite.rotation, tilt, 8.0 * delta)

func _update_kyslik(delta: float) -> void:
	if global_position.y <= surface_y + 1.0:
		kyslik = min(kyslik + kyslik_doplenie * delta, max_kyslik)
	else:
		kyslik = max(kyslik - kyslik_uberanie * delta, 0.0)
	kyslik_zmeneny.emit(kyslik, max_kyslik)
	
	if kyslik > 0.0 and kyslik < max_kyslik * 0.25:
		var blink := int(Time.get_ticks_msec() / 200.0) % 2 == 0
		sprite.modulate = Color(1, 0.5, 0.5) if blink else Color.WHITE
	else:
		sprite.modulate = Color.WHITE
		
	if kyslik <= 0.0:
		_out_of_kyslik()
		
func _out_of_kyslik() -> void:
	die()
	
func die() -> void:
	if dead:
		return
	dead = true
	set_physics_process(false)                              # ponorka sa prestane hýbať
	$CollisionShape2D.set_deferred("disabled", true)        # už do ničoho nenarazí
	sprite.modulate = Color.WHITE
	sprite.rotation = 0.0
	sprite.play("explode")
	await sprite.animation_finished
	sprite.visible = false
	GameManager.game_over()
