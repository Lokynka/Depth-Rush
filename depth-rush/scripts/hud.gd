extends CanvasLayer

@onready var UkazovatelKyslika: ProgressBar = $UkazovatelKyslika

func _ready() -> void:
	var player = get_parent().get_node("Player")
	player.kyslik_zmeneny.connect(_on_oxygen_changed)

func _on_oxygen_changed(value: float, max_value: float) -> void:
	UkazovatelKyslika.max_value = max_value
	UkazovatelKyslika.value = value
