@tool
extends MeshInstance3D


func _ready():
	# TODO: Get editor camera and hide itself if the distance is over 300m
#	var view := get_window().find_world_3d()
#	print(view.get_path())
#	view.print_tree_pretty()
	pass

func _process(_delta: float) -> void:
	var cam := get_viewport().get_camera_3d()

	var cam_pos := cam.get_global_position()
	var self_pos := get_global_position()
	const min_show_distance := 300
	if not Engine.get_process_frames() & (2 << 6) - 1: # 1.06 seconds for 60 fps
		hide() if cam_pos.distance_squared_to(self_pos) > min_show_distance ** 2 else show()
