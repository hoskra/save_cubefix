extends Node2D

var selected_player = 0
@onready var cubelix = get_node('GUI/Display/HBoxContainer/VBoxContainer/NinePatchRect/cubelix')
@onready var cuberix = get_node('GUI/Display/HBoxContainer/VBoxContainer/NinePatchRect/cuberix')

var cubelix_not_selected = preload('res://Art/baner_cubelix.png')
var cuberix_not_selected = preload('res://Art/baner_cuberix.png')
var cubelix_selected = preload('res://Art/baner_cubelix_selected.png')
var cuberix_selected = preload('res://Art/baner_cuberix_selected.png')

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		print("print")
	if Input.is_action_just_pressed("switch_character"):
		print("switch_character")
		selected_player = (selected_player + 1) % 2
		if(selected_player == 0):
			cubelix.texture = cubelix_selected
			cuberix.texture = cuberix_not_selected
		elif(selected_player == 1):
			cubelix.texture = cubelix_not_selected
			cuberix.texture = cuberix_selected
	if Input.is_action_just_pressed("drink_potion"):
		print("drink_potion")
