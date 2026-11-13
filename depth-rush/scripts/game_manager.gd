extends Node

signal score_changed(score: int)
signal treasures_changed(collected: int, needed: int)
signal game_over_triggered

var score := 0
var best_score := 0
var treasures := 0
var treasures_needed := 5
var scroll_speed := 30.0
var is_game_over := false

func add_treasure(points: int) -> void:
	score += points
	treasures += 1
	score_changed.emit(score)
	treasures_changed.emit(treasures, treasures_needed)

func game_over() -> void:
	if is_game_over:
		return
	is_game_over = true
	best_score = max(best_score, score)
	game_over_triggered.emit()

func reset() -> void:
	score = 0
	treasures = 0
	is_game_over = false
	score_changed.emit(score)
	treasures_changed.emit(treasures, treasures_needed)
