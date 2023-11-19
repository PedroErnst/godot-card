extends Node

func playSound(key: int) -> void:
	if key == FRO.SWOOSH:
		$Swoosh.play()
	if key == FRO.SWITCH:
		$Switch.play()
	if key == FRO.FAIL:
		$Fail.play()
