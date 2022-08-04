extends Node

export (AudioStream) var map_music

func _ready() -> void:
  GameState.play_music(map_music)
  GameState.RetryCamera = $RetryCamera
  GameState.Grass = get_node("%GreenPlatformGrass")
  GameState.update_grass()

func _on_Player_hit() -> void:
  GameState.UserInterface.retry()

func _on_RedButton_pressed() -> void:
  $Map/MovingPlatforms/Manual.move_platforms()

func _on_SprintTutorial_body_entered(_body: Node) -> void:
  get_node("%SprintTutorial").get_node("AnimationPlayer").play("show_sprint_label")
