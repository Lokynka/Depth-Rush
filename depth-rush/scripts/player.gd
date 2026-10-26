extends CharacterBody2D

@export var max_speed := 90.0
@export var acceleration := 250.0   # ako rýchlo sa rozbehne
@export var friction := 150.0       # ako rýchlo spomalí (zotrvačnosť vo vode)
@export var surface_y := -60.0      # výška hladiny

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	# plynulé zrýchľovanie a dobiehanie, aby to pôsobilo ako vo vode
	if dir != Vector2.ZERO:
		velocity = velocity.move_toward(dir * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	move_and_slide()

	# ponorka nesmie vyletieť nad hladinu
	if global_position.y < surface_y:
		global_position.y = surface_y
		velocity.y = max(velocity.y, 0.0)

	_update_animation(dir, delta)

func _update_animation(dir: Vector2, delta: float) -> void:
	# otočenie podľa smeru (sprite je nakreslený smerom doprava)
	if dir.x != 0:
		sprite.flip_h = dir.x < 0
	# vrtuľa sa točí rýchlejšie, keď ponorka ide rýchlo
	sprite.speed_scale = 0.3 + velocity.length() / max_speed
	# jemné naklonenie pri stúpaní a klesaní
	var tilt := velocity.y / max_speed * 0.25
	if sprite.flip_h:
		tilt = -tilt
	sprite.rotation = lerp(sprite.rotation, tilt, 8.0 * delta)
