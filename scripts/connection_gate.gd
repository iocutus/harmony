@tool
class_name ConnectionGate extends Area2D

@onready var shape: CollisionShape2D = %CollisionShape2D
@export var mode: Building.ConnectionType:
	set(value):
		mode = value
		if is_node_ready():
			_setup_mode()

@export var is_active: bool = false:
	set(value):
		is_active = value
		if is_node_ready():
			shape.disabled = not is_active

@export var tile_coordinate: Vector2i
@export var buffer_index: int

func _setup_mode() -> void:
	match mode:
			Building.ConnectionType.INPUT:
				shape.debug_color = Color(1.0, 0.0, 0.0, 0.392)
				collision_layer = 4 # input layer
				collision_mask = 8 # output layer
			Building.ConnectionType.OUTPUT:
				shape.debug_color = Color(0.0, 1.0, 0.0, 0.392)
				collision_layer = 8 # output layer
				collision_mask = 4 # input layer
			Building.ConnectionType.SNAP:
				shape.debug_color = Color(0.0, 0.0, 1.0, 0.392)
				collision_layer = 0 # none
				collision_mask = 12 # input = output layer

func _ready() -> void:
	shape.disabled = not is_active
	var parent = get_parent()
	_setup_mode()
	if parent is ConnectionManager:
		var manager = parent as ConnectionManager
		manager.setup.emit(self)
		return

func handover(payload: NoteResource) -> void:
	incoming.emit(self, payload)

signal incoming(gate: ConnectionGate, payload: NoteResource)
