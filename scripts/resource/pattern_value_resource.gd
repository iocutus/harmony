@tool
class_name PatternValueResource extends Resource

@export var building: AbstractBuildingResource:
	set(value):
		building = value
		_setup_name()
@export var rotation: BuildingsUtils.BuildingRotation:
	set(value):
		rotation = value
		_setup_name()

func _setup_name() -> void:
	if not building:
		return
	resource_name = building.name + " " + str(rotation)
