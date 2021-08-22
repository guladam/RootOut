extends HBoxContainer


onready var label := $Label

var enemy_counter: int
var boss_counter: int = 0
var enemies_killed: int = 0

var bosses: Array
var enemies: Array

func _ready() -> void:
	enemies = get_tree().get_nodes_in_group("crystals")
	bosses = get_tree().get_nodes_in_group("bosses")
	boss_counter = len(bosses)
	enemy_counter = len(enemies) + boss_counter
	set_text()
	
	for enemy in enemies:
		enemy.connect("crystal_destroyed", self, "_on_Crystal_destroyed")
		
	for boss in bosses:
		boss.connect("boss_destroyed", self, "_on_Boss_destroyed")


func set_text():
	label.text = str(enemies_killed) + "/" + str(enemy_counter)
	

func _on_Crystal_destroyed() -> void:
	increment_killed_enemies()


func _on_Boss_destroyed() -> void:
	increment_killed_enemies()
	

func increment_killed_enemies() -> void:
	# warning-ignore:narrowing_conversion
	enemies_killed += 1
	enemies_killed = clamp(enemies_killed, 0, enemy_counter)
	set_text()
