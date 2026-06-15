## 高考小游戏
## 限时选择题，基于教育数值决定难度
extends CanvasLayer

# ===== 配置 =====
const TOTAL_QUESTIONS := 8
const TIME_PER_QUESTION := 15.0  # 每题秒数
const BASE_SCORE_PER_CORRECT := 10

# ===== 题库 =====
var questions := [
	{
		"subject": "语文",
		"question": "《静夜思》的作者是谁？",
		"options": ["李白", "杜甫", "白居易", "王维"],
		"correct": 0,
		"difficulty": 1
	},
	{
		"subject": "数学",
		"question": "1 + 1 = ?",
		"options": ["1", "2", "3", "11"],
		"correct": 1,
		"difficulty": 1
	},
	{
		"subject": "英语",
		"question": "Apple 的中文意思是？",
		"options": ["苹果", "香蕉", "橘子", "葡萄"],
		"correct": 0,
		"difficulty": 1
	},
	{
		"subject": "语文",
		"question": "床前明月光的下一句是？",
		"options": ["疑是地上霜", "举头望明月", "低头思故乡", "春眠不觉晓"],
		"correct": 0,
		"difficulty": 2
	},
	{
		"subject": "数学",
		"question": "三角形内角和是多少度？",
		"options": ["90", "180", "270", "360"],
		"correct": 1,
		"difficulty": 2
	},
	{
		"subject": "历史",
		"question": "中华人民共和国成立于哪一年？",
		"options": ["1945", "1949", "1950", "1952"],
		"correct": 1,
		"difficulty": 2
	},
	{
		"subject": "地理",
		"question": "中国最长的河流是？",
		"options": ["黄河", "长江", "珠江", "淮河"],
		"correct": 1,
		"difficulty": 2
	},
	{
		"subject": "物理",
		"question": "光速约为多少千米/秒？",
		"options": ["3万", "30万", "300万", "3000万"],
		"correct": 1,
		"difficulty": 3
	},
	{
		"subject": "化学",
		"question": "水的化学式是？",
		"options": ["H2O", "CO2", "NaCl", "O2"],
		"correct": 0,
		"difficulty": 2
	},
	{
		"subject": "数学",
		"question": "圆的面积公式是？",
		"options": ["2πr", "πr²", "πd", "4πr²"],
		"correct": 1,
		"difficulty": 3
	},
	{
		"subject": "英语",
		"question": "How are you 的正确回答是？",
		"options": ["I'm fine", "Yes, I am", "No, thanks", "How are you"],
		"correct": 0,
		"difficulty": 1
	},
	{
		"subject": "政治",
		"question": "我国的根本政治制度是？",
		"options": ["人民代表大会制度", "多党合作制", "民族区域自治", "基层群众自治"],
		"correct": 0,
		"difficulty": 3
	}
]

# ===== 状态 =====
var current_question_index: int = 0
var correct_count: int = 0
var time_left: float = 0.0
var is_active: bool = false
var selected_questions: Array = []

# ===== 节点引用 =====
@onready var question_label: Label = $VBoxContainer/QuestionLabel
@onready var subject_label: Label = $VBoxContainer/SubjectLabel
@onready var timer_label: Label = $VBoxContainer/TimerLabel
@onready var progress_label: Label = $VBoxContainer/ProgressLabel
@onready var options_container: VBoxContainer = $VBoxContainer/OptionsContainer
@onready var timer: Timer = $Timer
@onready var result_panel: PanelContainer = $ResultPanel
@onready var result_label: Label = $ResultPanel/VBoxContainer/ResultLabel
@onready var score_label: Label = $ResultPanel/VBoxContainer/ScoreLabel

# ===== 信号 =====
signal minigame_finished(score: int, passed: bool)

func _ready() -> void:
	hide()
	timer.timeout.connect(_on_timer_tick)

func _process(delta: float) -> void:
	if not is_active:
		return
	time_left -= delta
	if timer_label:
		timer_label.text = "剩余时间: %.1f 秒" % maxf(0, time_left)
	if time_left <= 0:
		_on_time_up()

# ===== 开始游戏 =====
func start_minigame() -> void:
	is_active = true
	correct_count = 0
	current_question_index = 0
	# 根据教育数值选择题目难度
	var education: int = GameState.get_stat("education")
	_select_questions(education)
	# 显示界面
	show()
	result_panel.visible = false
	_show_question()
	# 暂停游戏时间
	TimeManager.pause_time()
	GameState.modify_stat("psychology", -5)

func _select_questions(education: int) -> void:
	# 根据教育数值决定题目难度分布
	var easy_count: int
	var medium_count: int
	var hard_count: int
	if education >= 60:
		easy_count = 2
		medium_count = 3
		hard_count = 3
	elif education >= 40:
		easy_count = 3
		medium_count = 3
		hard_count = 2
	else:
		easy_count = 4
		medium_count = 3
		hard_count = 1
	# 按难度分类
	var easy := questions.filter(func(q): return q["difficulty"] == 1)
	var medium := questions.filter(func(q): return q["difficulty"] == 2)
	var hard := questions.filter(func(q): return q["difficulty"] == 3)
	# 随机选取
	easy.shuffle()
	medium.shuffle()
	hard.shuffle()
	selected_questions.clear()
	selected_questions.append_array(easy.slice(0, mini(easy_count, easy.size())))
	selected_questions.append_array(medium.slice(0, mini(medium_count, medium.size())))
	selected_questions.append_array(hard.slice(0, mini(hard_count, hard.size())))
	selected_questions.shuffle()
	selected_questions = selected_questions.slice(0, TOTAL_QUESTIONS)

# ===== 显示题目 =====
func _show_question() -> void:
	if current_question_index >= selected_questions.size():
		_end_minigame()
		return
	var q: Dictionary = selected_questions[current_question_index]
	if subject_label:
		subject_label.text = "科目: %s" % q["subject"]
	if question_label:
		question_label.text = q["question"]
	if progress_label:
		progress_label.text = "第 %d / %d 题" % [current_question_index + 1, selected_questions.size()]
	# 清空选项
	for child in options_container.get_children():
		child.queue_free()
	# 创建选项按钮
	for i in q["options"].size():
		var btn := Button.new()
		btn.text = "%s. %s" % [char(65 + i), q["options"][i]]
		btn.add_theme_font_size_override("font_size", 20)
		btn.pressed.connect(_on_answer_selected.bind(i))
		options_container.add_child(btn)
	# 开始计时
	time_left = TIME_PER_QUESTION

func _on_answer_selected(answer_index: int) -> void:
	var q: Dictionary = selected_questions[current_question_index]
	if answer_index == q["correct"]:
		correct_count += 1
	current_question_index += 1
	_show_question()

func _on_time_up() -> void:
	# 超时算错
	current_question_index += 1
	_show_question()

func _on_timer_tick() -> void:
	pass

# ===== 结束 =====
func _end_minigame() -> void:
	is_active = false
	# 计算分数
	var total_questions: int = selected_questions.size()
	var score: int = int(float(correct_count) / total_questions * 100)
	# 根据分数调整教育数值
	var education_change: int = 0
	if score >= 80:
		education_change = 15
	elif score >= 60:
		education_change = 10
	elif score >= 40:
		education_change = 5
	else:
		education_change = -5
	GameState.modify_stat("education", education_change)
	# 随机发挥因素（命运不可控）
	var luck_factor: float = randf_range(0.85, 1.15)
	score = int(score * luck_factor)
	score = clampi(score, 0, 100)
	# 显示结果
	_show_result(score, education_change)
	# 恢复游戏时间
	TimeManager.resume_time()

func _show_result(score: int, education_change: int) -> void:
	result_panel.visible = true
	if result_label:
		var grade: String
		if score >= 90:
			grade = "超常发挥！"
		elif score >= 75:
			grade = "正常发挥"
		elif score >= 60:
			grade = "勉强及格"
		else:
			grade = "发挥失常"
		result_label.text = "高考结束\n\n%s\n\n正确率: %d%%\n教育数值变化: %+d" % [
			grade, score, education_change
		]
	if score_label:
		score_label.text = "得分: %d" % score
	# 3秒后自动关闭
	await get_tree().create_timer(3.0).timeout
	hide()
	minigame_finished.emit(score, score >= 60)
