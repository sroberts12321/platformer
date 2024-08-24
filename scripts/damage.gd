extends Area2D

func _on_body_entered(body: Node2D) -> void:
	print("damage hit")
	body.get_node("../Player").bounce()
	get_parent().damage()
