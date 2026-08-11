extends Node3D






func _on_area_3d_area_entered(area: Area3D) -> void:
	print("took damage from:"+area.name+", the child of:"+area.get_parent().name)
