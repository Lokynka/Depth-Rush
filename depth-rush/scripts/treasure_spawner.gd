extends Node2D

@export var treasure_scene: PackedScene
@export var spawn_x := 340.0
@export var min_y := 75.0
@export var max_y := 160.0
@export var min_interval := 4.0
@export var max_interval := 8.0

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.timeout.connect(_spawn_treasure)
	timer.start(2)

func _spawn_treasure() -> void:
	timer.start(randf_range(min_interval, max_interval))
	var y := _find_free_y(spawn_x, min_y, max_y, 24.0)
	if is_nan(y):
		return
	var treasure: Node2D = treasure_scene.instantiate()
	treasure.position = Vector2(spawn_x, y)
	treasure.points = 5 if y < 100 else (10 if y < 135 else 25)
	add_child(treasure)

	# nájde výšku, kde pri pravom okraji nič nie je; ak nenájde, vráti NAN
func _find_free_y(at_x: float, from_y: float, to_y: float, gap: float) -> float:
	for attempt in 10:
		var y := randf_range(from_y, to_y)
		var free := true
		for obj in get_tree().get_nodes_in_group("floating"):
			if absf(obj.position.x - at_x) < gap and absf(obj.position.y - y) < gap:
				free = false
				break
		if free:
			return y
	return NAN
