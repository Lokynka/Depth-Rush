extends Area2D

@export var wobble := 4.0      # ako veľmi sa hojdá hore-dole

@onready var sprite: AnimatedSprite2D = $Sprite2D

var time := 0.0
var start_y := 0.0
var exploded := false

func _ready() -> void:
	add_to_group("floating")
	start_y = position.y
	time = randf() * 10.0
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	if exploded:
		return
	time += delta
	position.x -= GameManager.scroll_speed * delta
	position.y = start_y + sin(time * 2.0) * wobble
	if position.x < -20:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if exploded or not body.has_method("die"):
		return
	exploded = true
	body.die()
	sprite.play("explode")
	await sprite.animation_finished
	queue_free()
