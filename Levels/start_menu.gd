extends Node2D

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Levels/game_level.tscn")	

func _on_info_pressed():
	$menu.visible = false;
	$info.visible = true;

func _on_quit_pressed():
	get_tree().quit()

func _on_back_pressed():
	$info.visible = false;
	$menu.visible = true;
