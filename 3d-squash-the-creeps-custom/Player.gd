extends KinematicBody

signal hit

export var speed := 14.0
export var jump_impulse := 20.0
export var fall_acceleration := 75.0
export var bounce_impulse := 16.0

var velocity = Vector3.ZERO

func _physics_process(delta):
  var horizontal_rotation = $CameraPivot/Horizontal.global_transform.basis.get_euler().y
  print("Horizontal rotation: ", horizontal_rotation)
  
  var direction = Vector3.ZERO
  if Input.is_action_pressed("move_right"):
    direction = Vector3.RIGHT
    direction = direction.rotated(Vector3.UP, horizontal_rotation).normalized()
  if Input.is_action_pressed("move_left"):
    direction = Vector3.LEFT
    direction = direction.rotated(Vector3.UP, horizontal_rotation).normalized()
  if Input.is_action_pressed("move_back"):
    direction = Vector3.BACK
    direction = direction.rotated(Vector3.UP, horizontal_rotation).normalized()
  if Input.is_action_pressed("move_forward"):
    direction = Vector3.FORWARD
    direction = direction.rotated(Vector3.UP, horizontal_rotation).normalized()

  if direction != Vector3.ZERO:
    direction = direction.normalized()
    $Pivot.look_at(translation + direction, Vector3.UP)
    $AnimationPlayer.playback_speed = 3.0
  else:
    $AnimationPlayer.playback_speed = 1.0
  
  velocity.x = direction.x * speed
  velocity.z = direction.z * speed
  
  if is_on_floor() and Input.is_action_pressed("jump"):
    velocity.y += jump_impulse
  
  velocity.y -= fall_acceleration * delta
  # Assign move_and_slide to velocity prevents the velocity from accumulating.
  velocity = move_and_slide(velocity, Vector3.UP)
  
  for index in get_slide_count():
    var collision = get_slide_collision(index)
    if collision.collider.is_in_group("mobs"):
      var mob = collision.collider
      
      if Vector3.UP.dot(collision.normal) > 0.1:
        mob.squash()
        velocity.y = bounce_impulse
  
  $Pivot.rotation.x = PI / 6.0 * velocity.y / jump_impulse

func die():
  emit_signal("hit")
  queue_free()

func _on_MobDetector_body_entered(body):
  die()
