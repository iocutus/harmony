@tool
class_name PatternResource extends Resource

@export var north: Building.ConnectionType = Building.ConnectionType.SNAP:
	set(value):
		north = value
		_setup_name()
@export var east: Building.ConnectionType = Building.ConnectionType.SNAP:
	set(value):
		east = value
		_setup_name()
@export var south: Building.ConnectionType = Building.ConnectionType.SNAP:
	set(value):
		south = value
		_setup_name()
@export var west: Building.ConnectionType = Building.ConnectionType.SNAP:
	set(value):
		west = value
		_setup_name()

func _setup_name() -> void:
	resource_name = str(north) + " " + str(east) + " " + str(south) + " " + str(west)

func is_equals(other: PatternResource) -> bool:
	if north != other.north:
		#print("not equals, north: ", resource_name, " | ", other.resource_name)
		return false
	if east != other.east:
		#print("not equals, east: ", resource_name, " | ", other.resource_name)
		return false
	if south != other.south:
		#print("not equals, south: ", resource_name, " | ", other.resource_name)
		return false
	if west != other.west:
		#print("not equals, west: ", resource_name, " | ", other.resource_name)
		return false
	return true
	
func is_default() -> bool:
	return north == 2 and east == 2 and south == 2 and west == 2
