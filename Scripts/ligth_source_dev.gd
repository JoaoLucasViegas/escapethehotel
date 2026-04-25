class_name LightSource
extends MeshInstance3D

@onready var light = ResourceLoader.load("res://Prefabs/components/normal_light.tscn")
@onready var light_mesh = ResourceLoader.load("res://Mesh/light_mesh.tres")
@onready var light_material = ResourceLoader.load("res://Materials/hallway_light_colour.tres")

#var is_dynamic = false
var is_static = false

func _ready() -> void:
	#is_dynamic = Global.is_dynamic
	is_static = Global.is_static
	makeLightsDynamic()

func _physics_process(_delta: float) -> void:
	#if is_dynamic and is_static:
	#if is_static:
		#makeLightsMixed()
	#else:
		##makeLightsMixed()
		##makeLightsStatic()
		#makeLightsDynamic()
	pass

func makeLightsDynamic():
	self.mesh = null
	self.material_override = null
	if self.get_child_count() <= 0:
		self.add_child(light.instantiate())

func makeLightsStatic():
	self.mesh = light_mesh
	self.material_override = light_material
	if self.get_children().size() >= 1:
		self.get_child(0).queue_free()

func makeLightsMixed():
	self.mesh = light_mesh
	self.material_override = light_material
	if self.get_child_count() <= 0:
		self.add_child(light.instantiate())
