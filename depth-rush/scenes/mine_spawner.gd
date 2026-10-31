extends Node2D

@export var mine_scene: PackedScene
@export var spawn_x := 170.0    # vpravo za okrajom obrazovky
@export var min_y := -100.0     # najvyššie (pod hladinou)
@export var max_y := 10.0       # najnižšie (nad dnom)

func _ready() -> void:
	$Timer.timeout.connect(_spawn_mine)

func _spawn_mine() -> void:
	var mine: Node2D = mine_scene.instantiate()
	mine.position = Vector2(spawn_x, randf_range(min_y, max_y))
	add_child(mine)
