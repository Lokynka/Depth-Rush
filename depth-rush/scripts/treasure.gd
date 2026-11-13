extends Area2D

@export var points := 10        # koľko bodov dá poklad
@export var lifetime := 10.0    # po koľkých sekundách zmizne

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var age := 0.0
var collected := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	if collected:
		return
	age += delta
	# posledné 3 sekundy poklad bliká
	if age > lifetime - 3.0:
		sprite.visible = int(age * 8) % 2 == 0
	if age >= lifetime:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if collected or body.name != "Player":
		return
	collected = true
	sprite.visible = true
	GameManager.add_treasure(points)
	# efekt zobratia: poklad vyletí hore a zmizne
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position:y", position.y - 12.0, 0.4)
	tween.tween_property(self, "modulate:a", 0.0, 0.4)
	tween.chain().tween_callback(queue_free)
