extends Node3D

@onready var single_fish_scene = preload("res://li_fish.tscn")
@export var tanksize : Vector3 = Vector3(4,0.8,4)

var single_fish

func _ready():

	single_fish = single_fish_scene.instantiate()
	add_child(single_fish)
	single_fish.init(tanksize.x,tanksize.y,tanksize.z)

func _process(delta):
	single_fish.transform.origin += delta * single_fish.velocity
