extends Node

var points = 0

@onready var points_label: Label = %PointsLabel

func add_point() -> void:
	points += 1
	
	points_label.text = "Points " + str(points)
