extends Node

##################################################
const MIN_FATIGUE: int = 0
const MAX_FATIGUE: int = 100
# 최소 및 최대 피로도 값
const RECOVERY_SECONDS: float = 10.0
# 피로도 회복에 필요한 시간 (초)

var fatigue: int = MAX_FATIGUE
# 현재 피로도 값
var recovery_timer: Timer
# 피로도 회복을 위한 타이머

##################################################
func _ready() -> void:
	recovery_timer = Timer.new()
	# 타이머 생성 및 설정
	recovery_timer.wait_time = 1.0
	# 1초마다 실행
	recovery_timer.one_shot = false
	# 반복 실행
	recovery_timer.connect("timeout", Callable(self, "_on_recovery_timer_timeout"))
	# 타이머 이벤트 연결
	add_child(recovery_timer)
	# 타이머를 노드에 추가
	recovery_timer.start()
	# 타이머 시작
	
	fatigue = load_fatigue()
	# 저장된 피로도 값 불러오기

##################################################
func get_fatigue() -> int:
	return fatigue
	# 현재 피로도 반환

##################################################
func decrease_fatigue(value: int) -> void:
	fatigue = max(fatigue - value, MIN_FATIGUE)
	# 피로도가 최소값 이하로 내려가지 않도록 제한
	save_fatigue()
	# 변경된 피로도를 저장

##################################################
func _on_recovery_timer_timeout() -> void:
	save_fatigue()
	# 현재 피로도를 저장
	
	var current_time = Time.get_unix_time_from_system()
	# 현재 Unix 시간 가져오기
	if current_time - load_time() >= RECOVERY_SECONDS:
	# 마지막 회복된 시간과 비교하여 10.0초보다 작으면
		fatigue = MAX_FATIGUE
		# 피로도를 최대 값으로 회복
		save_time()
		# 회복된 시점 저장

##################################################
func save_time() -> void:
	var config = ConfigFile.new()
	config.set_value("game", "time", str(Time.get_unix_time_from_system()))
	# 현재 시간을 문자열 형태로 저장
	config.save("user://game_time_data.cfg")
	# 파일 저장

##################################################
func save_fatigue() -> void:
	var config = ConfigFile.new()
	config.set_value("game", "fatigue", fatigue)
	# 현재 피로도 저장
	config.save("user://game_fatigue_data.cfg")
	# 파일 저장

##################################################
func load_fatigue() -> int:
	var config = ConfigFile.new()
	if config.load("user://game_fatigue_data.cfg") == OK:
	# 파일을 성공적으로 불러왔을 때
		return int(config.get_value("game", "fatigue"))
		# 저장된 피로도 반환
	return MAX_FATIGUE
	# 파일이 없거나 오류 발생 시 최대 피로도 반환

##################################################
func load_time() -> float:
	var config = ConfigFile.new()
	if config.load("user://game_time_data.cfg") == OK:
	# 파일을 성공적으로 불러왔을 때
		return float(config.get_value("game", "time"))
		# 저장된 회복 시간 반환
	return 0
	# 파일이 없거나 오류 발생 시 기본값 반환
