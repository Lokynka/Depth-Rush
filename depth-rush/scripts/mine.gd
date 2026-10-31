extends Area2D

@export var speed := 30.0      # rýchlosť pohybu doľava
@export var wobble := 4.0      # ako veľmi sa hojdá hore-dole

var time := 0.0
var start_y := 0.0

func _ready() -> void:
	start_y = position.y
	time = randf() * 10.0       # každá mína sa hojdá trochu inak
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	time += delta
	position.x -= speed * delta
	position.y = start_y + sin(time * 2.0) * wobble
	if position.x < -20:       # mimo obrazovky -> zmazať
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().call_deferred("reload_current_scene")
