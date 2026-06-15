## FontInitializer - 字体初始化器
## 在游戏启动时加载和配置中文字体
extends Node

func _ready() -> void:
	# 延迟初始化字体（等待场景树加载完成）
	call_deferred("_init_fonts")

func _init_fonts() -> void:
	print("[FontInitializer] 开始初始化字体...")

	# 获取系统中文字体
	var font_path := _get_system_chinese_font()

	if font_path.is_empty():
		push_warning("[FontInitializer] 未找到系统中文字体，使用默认字体")
		return

	# 加载字体
	var font := FontFile.new()
	var error := font.load_dynamic_font(font_path)

	if error != OK:
		push_warning("[FontInitializer] 加载字体失败: " + font_path)
		return

	# 创建字体主题
	var theme := Theme.new()
	theme.default_font = font
	theme.default_font_size = 18

	# 设置各种控件的字体
	theme.set_font("font", "Label", font)
	theme.set_font("font", "Button", font)
	theme.set_font("font", "RichTextLabel", font)
	theme.set_font("font", "LineEdit", font)
	theme.set_font("font", "TextEdit", font)
	theme.set_font("font", "PopupMenu", font)
	theme.set_font("font", "MenuButton", font)
	theme.set_font("font", "OptionButton", font)
	theme.set_font("font", "SpinBox", font)
	theme.set_font("font", "TabBar", font)

	# 应用主题到场景树
	_apply_theme_to_scene_tree(theme)

	print("[FontInitializer] 字体初始化完成")

## 获取系统中文字体路径
func _get_system_chinese_font() -> String:
	# macOS 系统中文字体路径
	var mac_fonts := [
		"/System/Library/Fonts/STHeiti Light.ttc",
		"/System/Library/Fonts/STHeiti Medium.ttc",
		"/System/Library/Fonts/Hiragino Sans GB.ttc",
		"/System/Library/Fonts/PingFang.ttc",
		"/Library/Fonts/Arial Unicode.ttf"
	]

	# Windows 系统中文字体路径
	var windows_fonts := [
		"C:/Windows/Fonts/msyh.ttc",
		"C:/Windows/Fonts/simhei.ttf",
		"C:/Windows/Fonts/simsun.ttc"
	]

	# Linux 系统中文字体路径
	var linux_fonts := [
		"/usr/share/fonts/truetype/wqy/wqy-microhei.ttc",
		"/usr/share/fonts/truetype/wqy/wqy-zenhei.ttc",
		"/usr/share/fonts/noto-cjk/NotoSansCJK-Regular.ttc"
	]

	# 根据系统选择字体
	var os_name := OS.get_name()
	var fonts: Array

	match os_name:
		"macOS":
			fonts = mac_fonts
		"Windows":
			fonts = windows_fonts
		"Linux", "FreeBSD":
			fonts = linux_fonts
		_:
			fonts = mac_fonts

	# 查找存在的字体文件
	for font_path in fonts:
		if FileAccess.file_exists(font_path):
			print("[FontInitializer] 找到系统字体: ", font_path)
			return font_path

	# 如果找不到系统字体，返回空字符串
	return ""

## 应用主题到场景树
func _apply_theme_to_scene_tree(theme: Theme) -> void:
	# 获取场景根节点
	var root := get_tree().root
	if root:
		root.theme = theme
		print("[FontInitializer] 主题已应用到场景树")
