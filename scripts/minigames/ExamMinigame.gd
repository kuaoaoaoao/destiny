## ExamMinigame - 高考答题小游戏
extends CanvasLayer

## 题目数据
var questions := [
	{"q": "1+1=?", "options": ["1", "2", "3", "4"], "answer": 1},
	{"q": "中国的首都是？", "options": ["上海", "北京", "广州", "深圳"], "answer": 1},
	{"q": "地球是第几颗行星？", "options": ["第三", "第四", "第五", "第六"], "answer": 0},
	{"q": "水的化学式是？", "options": ["CO2", "H2O", "O2", "N2"], "answer": 1},
	{"q": "光速大约是？", "options": ["30万km/s", "3万km/s", "300万km/s", "3000万km/s"], "answer": 0}
]

## 当前状态
var current_question: int = 0
var score: int = 0
var is_active: bool = false

## UI引用
@onready var question_label: Label = $UI/QuestionLabel
@onready var options_container: VBoxContainer = $UI/OptionsContainer
@onready var score_label: Label = $UI/ScoreLabel
@onready var result_label: Label = $UI/ResultLabel

func _ready() -> void:
	visible = false

func start_exam() -> void:
	visible = true
	is_active = true
	current_question = 0
	score = 0
	TimeManager.pause_time()
	show_question()

func show_question() -> void:
	if current_question >= questions.size():
		end_exam()
		return
	
	var q = questions[current_question]
	if question_label:
		question_label.text = "第%d题: %s" % [current_question + 1, q["q"]]
	if score_label:
		score_label.text = "得分: %d" % score
	
	# 清空选项
	for child in options_container.get_children():
		child.queue_free()
	
	# 添加选项
	for i in range(q["options"].size()):
		var btn = Button.new()
		btn.text = q["options"][i]
		btn.pressed.connect(_on_answer.bind(i))
		options_container.add_child(btn)

func _on_answer(answer_index: int) -> void:
	var q = questions[current_question]
	if answer_index == q["answer"]:
		score += 20
		if result_label:
			result_label.text = "正确！"
	else:
		if result_label:
			result_label.text = "错误！正确答案是: " + q["options"][q["answer"]]
	
	current_question += 1
	
	# 延迟显示下一题
	await get_tree().create_timer(1.0).timeout
	show_question()

func end_exam() -> void:
	is_active = false
	
	# 计算教育数值变化
	var education_change = int(score / 10.0)
	GameState.modify_stat("education", education_change)
	
	# 随机浮动
	var random_factor = randf_range(0.85, 1.15)
	education_change = int(education_change * random_factor)
	
	if result_label:
		result_label.text = "高考结束！得分: %d\n教育+%d" % [score, education_change]
	
	# 延迟关闭
	await get_tree().create_timer(2.0).timeout
	visible = false
	TimeManager.resume_time()
