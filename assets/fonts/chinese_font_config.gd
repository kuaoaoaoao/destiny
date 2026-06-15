## 中文字体配置
## 用于配置项目中的中文字体支持
class_name ChineseFontConfig

## 获取系统中文字体路径
static func get_system_chinese_font() -> String:
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
			return font_path

	# 如果找不到系统字体，返回空字符串
	return ""

## 创建字体资源
static func create_font_resource(font_size: int = 18) -> FontFile:
	var font_path := get_system_chinese_font()

	if font_path.is_empty():
		push_warning("[ChineseFontConfig] 未找到系统中文字体，使用默认字体")
		return null

	var font := FontFile.new()
	var error := font.load_dynamic_font(font_path)

	if error != OK:
		push_warning("[ChineseFontConfig] 加载字体失败: " + font_path)
		return null

	# 设置字体大小
	font.fixed_size = font_size

	return font

## 应用字体到主题
static func apply_font_to_theme(theme: Theme, font_size: int = 18) -> void:
	var font := create_font_resource(font_size)

	if font == null:
		return

	# 设置默认字体
	theme.default_font = font
	theme.default_font_size = font_size

	# 设置各种控件的字体
	theme.set_font("font", "Label", font)
	theme.set_font("font", "Button", font)
	theme.set_font("font", "RichTextLabel", font)
	theme.set_font("font", "LineEdit", font)
	theme.set_font("font", "TextEdit", font)

	print("[ChineseFontConfig] 字体已应用到主题")

## 初始化项目字体
static func init_project_fonts() -> void:
	# 加载主题资源
	var theme_path := "res://assets/ui/theme.tres"
	if FileAccess.file_exists(theme_path):
		var theme := load(theme_path) as Theme
		if theme:
			apply_font_to_theme(theme)
			print("[ChineseFontConfig] 项目字体初始化完成")
		else:
			push_warning("[ChineseFontConfig] 无法加载主题文件")
	else:
		push_warning("[ChineseFontConfig] 主题文件不存在: " + theme_path)
