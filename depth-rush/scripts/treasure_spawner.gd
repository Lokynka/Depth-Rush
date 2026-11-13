extends Node2D

@export var treasure_scene: PackedScene
@export var min_x := 30.0       # najviac vľavo
@export var max_x := 290.0      # najviac vpravo
@export var floor_y := 162.0    # výška dna (truhlica leží na piesku)
@export var max_treasures := 3  # koľko pokladov môže byť naraz

func _ready() -> void:
	$Timer.timeout.connect(_spawn_treasure)

func _spawn_treasure() -> void:
	# get_child_count() počíta aj Timer, preto - 1
	if get_child_count() - 1 >= max_treasures:
		return
	var treasure: Node2D = treasure_scene.instantiate()
	treasure.position = Vector2(randf_range(min_x, max_x), floor_y)
	add_child(treasure)
