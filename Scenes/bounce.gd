extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Global.bouncevision == true:
		$TextureRect.visible = true
	else:
		$TextureRect.visible = false
	pass


func _on_body_shape_entered(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int):
	if _body.name == "diver":
		Global.bounce = true
	pass # Replace with function body.
