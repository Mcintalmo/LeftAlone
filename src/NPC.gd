extends KinematicBody2D

enum AI {
	Idle,
	Wander,
	Spooked,
	Run,
}

export(int, 0, 96) var frame := 0 setget set_frame
export(AI) var ai_state: int = AI.Idle
export(int, 0, 100) var speed := 50
export(Vector2) var direction := Vector2(1 / sqrt(2), 1 / sqrt(2))
export(int) var max_spook := 100
export(int) var spook := 100


func _physics_process(delta):
	if ai_state == AI.Wander:
		var collision := move_and_collide(speed * direction * delta)
		if collision:
			direction = Vector2(randf() * 2 - 1, randf() * 2 - 1).normalized()


func spook(value: float) -> void:
	spook += value
	if spook >= max_spook:
		die()


func die() -> void:
	pass


func set_frame(value: int) -> void:
	frame = value
	$Template.frame = value
	$Shirt.frame = value
	$Shoes.frame = value
	$Skirt.frame = value
