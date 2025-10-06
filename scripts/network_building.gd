@tool
class_name Network_Building extends Building

@onready var pattern_detector: PatternDetector = %PatternDetector

@export var pattern_resource: BuildingPatternResource = null:
	set(value):
		pattern_resource = value
		_setup_resource()

func _setup_resource() -> void:
	if building_resource == null:
		var key = pattern_resource.pattern.keys()[0]
		var value = pattern_resource.pattern[key]
		building_resource = value
		return
	if building_resource.size != Vector2i.ONE:
		printerr("network buildings only support 1x1 buildings")
		if pattern_resource != null:
			var keys = pattern_resource.pattern.keys()
			var default_key_index = keys.find_custom(func(p): p.is_default())
			var default_key = keys[default_key_index]
			var value = pattern_resource.pattern[default_key]
			if building_resource != value:
				building_resource = value.building
			return
	print("_setup_resource")
	super._setup_resource()

func _ready() -> void:
	super._ready()
	pattern_detector.pattern_changed.connect(func(pattern: PatternResource): _on_pattern_changed(pattern))

func _on_pattern_changed(pattern: PatternResource) -> void:
	print("_on_pattern_changed: ", pattern)
	var keys = pattern_resource.pattern.keys()
	var search_pattern_index = keys.find_custom(func(p): return p.is_equals(pattern))
	if search_pattern_index < 0:
		print("unknown pattern")
		search_pattern_index = keys.find_custom(func(p): return p.is_default())
		return
	var search_pattern = keys[search_pattern_index]
	var value = pattern_resource.pattern[search_pattern]
	building_resource = value.building
	if not pattern.is_default():
		building_rotation = value.rotation

func _handle_active() -> void:
	super._handle_active()
	pattern_detector.is_active = is_active
