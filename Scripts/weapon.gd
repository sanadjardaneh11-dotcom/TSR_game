class_name Weapon
extends Node
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

@export var WeaponName:String
@export var WeaponType:int
@export var mesh_glb:PackedScene
@export var AnimationType:Animation
@export var WeaponDamge:int
@export var WeaponSpeed:float
@export var WeaponReq:int
var weapondata

func _ready() -> void:
	var mesh = mesh_glb.instantiate()
	mesh = mesh.get_child(0).mesh
	weapondata = {"name":WeaponName,"type":WeaponType,"mesh":mesh,"animationtype":AnimationType,"damge":WeaponDamge,"speed":WeaponSpeed,"req":WeaponReq}
	mesh_instance_3d.mesh = mesh
	
