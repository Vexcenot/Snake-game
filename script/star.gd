extends Node2D

var speed = 3200
var gravity = 400
var jumpSpeed = 180

func _physics_process(delta: float) -> void:
	# Apply gravity
	$CharacterBody2D.velocity.y += gravity * delta
	# Apply horizontal movement
	$CharacterBody2D.velocity.x = speed * delta
	#makes it actually moves
	$CharacterBody2D.move_and_slide()

# Jumps when touches ground
func jump():
	$CharacterBody2D.velocity.y = -jumpSpeed

#flips direction when touches side
func _on_side_body_entered(body: Node2D) -> void:
	if body is StaticBody2D:
		speed = -speed

func _on_bottom_body_entered(body: Node2D) -> void:
	if body is StaticBody2D:
		jump()


func _on_star_area_entered(area: Area2D) -> void:
	if area.name == "Head Area":
		queue_free()
