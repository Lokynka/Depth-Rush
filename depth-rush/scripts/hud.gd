extends CanvasLayer

@onready var UkazovatelKyslika: ProgressBar = $UkazovatelKyslika
@onready var skore_label: Label = $SkoreLabel
@onready var poklady_label: Label = $PokladyLabel
@onready var ukazovatel_stitu: ProgressBar = $UkazovatelStitu

func _ready() -> void:
	var player = get_parent().get_node("Player")
	player.kyslik_zmeneny.connect(_on_oxygen_changed)
	player.stit_zmeneny.connect(_on_stit_zmeneny)
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.treasures_changed.connect(_on_treasures_changed)

func _on_oxygen_changed(value: float, max_value: float) -> void:
	UkazovatelKyslika.max_value = max_value
	UkazovatelKyslika.value = value

func _on_score_changed(score: int) -> void:
	skore_label.text = "Skóre: %d" % score

func _on_treasures_changed(collected: int, needed: int) -> void:
	poklady_label.text = "Poklady: %d/%d" % [collected, needed]

func _on_stit_zmeneny(aktivny: bool, hodnota: float) -> void:
	ukazovatel_stitu.value = hodnota * 100.0
	if aktivny:
		ukazovatel_stitu.modulate = Color(0.6, 1.0, 1.0)		#štít beží
	elif hodnota >= 1.0:
		ukazovatel_stitu.modulate = Color.WHITE					#pripravený
	else:
		ukazovatel_stitu.modulate = Color(0.5, 0.5, 0.5)		#nabíja sa
