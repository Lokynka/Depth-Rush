extends Node2D

@export var mine_scene: PackedScene
@export var spawn_x := 170.0    # vpravo za okrajom obrazovky
@export var min_y := -100.0     # najvyššie (pod hladinou)
@export var max_y := 10.0       # najnižšie (nad dnom)

func _ready() -> void:
	$Timer.timeout.connect(_spawn_mine)

func _spawn_mine() -> void:
	var y := _find_free_y(spawn_x, min_y, max_y, 24.0)
	if is_nan(y):
		return
	var mine: Node2D = mine_scene.instantiate()
	mine.position = Vector2(spawn_x, y)
	add_child(mine)

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
