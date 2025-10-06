@tool
class_name PatternDetector extends Node2D

@onready var north: ConnectionGate = %North
@onready var east: ConnectionGate = %East
@onready var south: ConnectionGate = %South
@onready var west: ConnectionGate = %West

signal setup(connection_gate: ConnectionGate)

@export var north_state: Building.ConnectionType = Building.ConnectionType.SNAP:
	set(value):
		north_state = value
		_calculate_pattern()

@export var east_state: Building.ConnectionType = Building.ConnectionType.SNAP:
	set(value):
		east_state = value
		_calculate_pattern()
@export var south_state: Building.ConnectionType = Building.ConnectionType.SNAP:
	set(value):
		south_state = value
		_calculate_pattern()
@export var west_state: Building.ConnectionType = Building.ConnectionType.SNAP:
	set(value):
		west_state = value
		_calculate_pattern()

@export var current_pattern: PatternResource

@export var is_active: bool = false:
	set(value):
		is_active = value
		if is_node_ready():
			_handle_active()


func _ready() -> void:
	_handle_active()
	_on_setup(north)
	_on_setup(east)
	_on_setup(south)
	_on_setup(west)

func _on_setup(connection_gate: ConnectionGate) -> void:
	print("_on_setup: ", connection_gate)
	connection_gate.area_entered.connect(func(area: Area2D): _add_connection(connection_gate, area))
	connection_gate.area_exited.connect(func(area: Area2D): _remove_connection(connection_gate, area))
	connection_gate.body_entered.connect(func(body: Node2D): _add_connection(connection_gate, body))
	connection_gate.body_exited.connect(func(body: Node2D): _remove_connection(connection_gate, body))

func _add_connection(source: ConnectionGate, body: Node2D) -> void:
	if body is ConnectionGate:
		if get_parent() == body.get_parent().get_parent():
			return # yes very dirty hack to not detect itself...
		var connection_gate = body as ConnectionGate
		if connection_gate.mode == Building.ConnectionType.SNAP:
			return
		#print("_add_connection: ", source, " ", body)
		match source:
			north:
				north_state = connection_gate.mode
			east:
				east_state = connection_gate.mode
			south:
				south_state = connection_gate.mode
			west:
				west_state = connection_gate.mode

func _remove_connection(source: ConnectionGate, body: Node2D) -> void:
	#print("_add_connection: ", source, " ", body)
	if body is ConnectionGate:
		if get_parent() == body.get_parent().get_parent():
			return # yes very dirty hack to not detect itself...
		var connection_gate = body as ConnectionGate
		if connection_gate.mode == Building.ConnectionType.SNAP:
			return
		#print("_add_connection: ", source, " ", body)
		match source:
			north:
				north_state = Building.ConnectionType.SNAP
			east:
				east_state = Building.ConnectionType.SNAP
			south:
				south_state = Building.ConnectionType.SNAP
			west:
				west_state = Building.ConnectionType.SNAP

func _calculate_pattern() -> void:
	var pattern = PatternResource.new()
	pattern.north = north_state
	pattern.east = east_state
	pattern.south = south_state
	pattern.west = west_state
	
	if current_pattern == null or not current_pattern.is_equals(pattern):
		print("pattern: ", pattern.resource_name)
		current_pattern = pattern
		pattern_changed.emit(pattern)

signal pattern_changed(pattern: PatternResource)

func _handle_active() -> void:
	north.is_active = is_active
	east.is_active = is_active
	south.is_active = is_active
	west.is_active = is_active
