extends CanvasLayer

##################################################
var progress_bar_node: ProgressBar

##################################################
func _ready() -> void:
	progress_bar_node = $MarginContainer/ProgressBar

##################################################
func _process(delta: float) -> void:
	progress_bar_node.value = GM.get_fatigue()
	
	var current_time = Time.get_unix_time_from_system()
