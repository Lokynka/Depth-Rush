extends Area2D

@export var points := 10
@export var wobble := 4.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var time := 0.0
var start_y := 0.0
var collected := false

func _ready() -> void:
	add_to_group("floating")
	start_y = position.y
	time = randf() * 10.0
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	if collected:
		return
	time += delta
	position.x -= GameManager.scroll_speed * delta
	position.y = start_y + sin(time * 2.0) * wobble
	if position.x < -20:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if collected or body.name != "Player":
		return
	collected = true
	GameManager.add_treasure(points)
	var tween := create_tween().set_parallel(true)
	tween.tween_property(self, "position:y", position.y - 12.0, 0.4)
	tween.tween_property(self, "modulate:a", 0.0, 0.4)
	tween.chain().tween_callback(queue_free)
