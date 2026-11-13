extends CanvasLayer

@onready var score_label: Label = %SkoreLabel
@onready var best_label: Label = %NajlepsieLabel
@onready var retry_button: Button = %ZnovaButton
@onready var menu_button: Button = %MenuButton

func _ready() -> void:
	visible = false
	GameManager.game_over_triggered.connect(_on_game_over)
	retry_button.pressed.connect(_on_retry)
	menu_button.pressed.connect(_on_menu)
	menu_button.disabled = true   # zapneme, keď bude hotové hlavné menu

func _on_game_over() -> void:
	score_label.text = "Skóre: %d" % GameManager.score
	best_label.text = "Najlepšie: %d" % GameManager.best_score
	visible = true
	get_tree().paused = true      # zastaví míny, poklady aj kyslík
	retry_button.grab_focus()     # dá sa potvrdiť aj Enterom

func _on_retry() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu() -> void:
	get_tree().paused = false
	# get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
