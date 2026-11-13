extends Node

signal score_changed(score: int)
signal treasures_changed(collected: int, needed: int)

var score := 0
var treasures := 0
var treasures_needed := 5
var scroll_speed := 30.0

func add_treasure(points: int) -> void:
	score += points
	treasures += 1
	score_changed.emit(score)
	treasures_changed.emit(treasures, treasures_needed)
	print("Poklady: ", treasures, "/", treasures_needed, "   Skóre: ", score)

func reset() -> void:
	score = 0
	treasures = 0
	score_changed.emit(score)
	treasures_changed.emit(treasures, treasures_needed)
