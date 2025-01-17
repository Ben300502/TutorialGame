extends CharacterBody2D

const GRAVITATION = 400
const JUMP_POWER = 100
const SPEED = 10

var richtung = 1
var jump_speed = 0
var is_alive = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("laufen")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not is_alive:
		return
	
	if is_on_floor():
		if $AnimatedSprite2D.animation == "sprung":
			on_landing()
		elif is_on_wall() or is_on_abyss():
			jump()
	
	velocity.y += GRAVITATION * delta
	velocity.x = SPEED * richtung + jump_speed
			
	move_and_slide()
		
func is_on_abyss():
	if velocity.x < 0:
		$RayCast2DLinks.force_raycast_update()
		return $RayCast2DLinks.get_collider() == null
	else:
		$RayCast2DRechts.force_raycast_update()
		return $RayCast2DRechts.get_collider() == null
	
func on_stomp():
	$AnimatedSprite2D.play("sterben")
	is_alive = false
	
func on_landing():
	jump_speed = 0
	$AnimatedSprite2D.play("laufen")
	if is_on_wall():
		turn()

func turn():
	$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h
	richtung = -richtung

func jump():
	$AnimatedSprite2D.play("sprung")
	velocity.y = -JUMP_POWER
	jump_speed = 30 * richtung

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "sterben":
		queue_free()
	

