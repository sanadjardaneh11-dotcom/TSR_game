class_name Weapon
extends Node
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

@export var WeaponName:String
@export var WeaponType:int
@export var mesh:Mesh
@export var AnimationType:Animation
@export var WeaponDamge:int
@export var WeaponSpeed:float
@export var WeaponReq:int
var wepondata

func _ready() -> void:
	wepondata = [WeaponName,WeaponType,mesh,AnimationType,WeaponDamge,WeaponSpeed,WeaponReq]
	mesh_instance_3d.mesh = mesh
	
