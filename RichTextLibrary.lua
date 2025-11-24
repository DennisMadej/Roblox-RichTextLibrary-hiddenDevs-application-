--[[ Infos
	This library allows you to quickly implement rich text features and combine them more easily.
	
	Made by GameFlame232
]]

local module = {}

export type ColorInput = string | Color3 | BrickColor

----------------------------------------------------
-- Helper Methods
----------------------------------------------------

local function Color3ToHex(color: Color3)
	return string.format("%02X%02X%02X", color.R * 255, color.G * 255, color.B * 255)
end

local function ColorInputToHex(color: ColorInput)
	local converters = {
		BrickColor = function(color)
			return color.Color
		end,
		string = function(color)
			return Color3.fromHex(color)
		end,
	}:: {(ColorInput) -> (Color3)}
	
	-- Convert the color to a color3
	if converters[typeof(color)] then
		color = converters[typeof(color)](color)
	end
	
	-- Check if input color was valid
	if typeof(color) ~= "Color3" then
		warn("Input color was not one of the valid types!")
		return
	end
	
	return Color3ToHex(color)
end

----------------------------------------------------
-- Formatter
----------------------------------------------------

module.Formatter = {}
module.Formatter.__index = module.Formatter

export type WrapperFunc = (text: string, ...any) -> string
export type WrapperEntry = {
	Func: WrapperFunc,
	Args: {any},
}

export type Formatter = {
	_wrappers: {WrapperEntry},

	Add: (self: Formatter, func: WrapperFunc, ...any) -> Formatter,
	Remove: (self: Formatter, func: WrapperFunc) -> Formatter,
	Apply: (self: Formatter, text: string) -> string,
	Clone: (self: Formatter) -> Formatter,
	Has: (self: Formatter, func: WrapperFunc) -> boolean
}

-- Constructor
function module.Formatter.new(): Formatter
	return setmetatable({
		_wrappers = {} -- An array of formatting functions
	}, module.Formatter)
end

-- Adds a new wrapper function
function module.Formatter:Add(func: WrapperFunc, ...): Formatter
	self:Remove(func) -- Make sure there will be no copies of the same WrapperEntry type
	
	table.insert(self._wrappers, {
		Func = func, 
		Args = table.pack(...)
	})
	return self
end

-- Removes a wrapper function of the formatter
function module.Formatter:Remove(func: WrapperFunc): Formatter
	for i, wrapper in self._wrappers do
		if wrapper.Func == func then
			table.remove(self._wrappers, i)
			break
		end
	end
	return self
end

-- Applies all formatters to the text
function module.Formatter:Apply(text: string): string
	for _, wrapper in self._wrappers do
		text = wrapper.Func(text, unpack(wrapper.Args))
	end
	return text
end

-- Checks if the formatter has a specific wrapper function
function module.Formatter:Has(func: WrapperFunc): boolean
	for _, wrapper in self._wrappers do
		if wrapper.Func == func then return true end
	end
	return false
end

-- Clones the Formatter returning a brand new one
function module.Formatter:Clone(): Formatter
	local newFormatter = module.Formatter.new()
	for _, wrapper in self._wrappers do
		table.insert(newFormatter._wrappers, {
			Func = wrapper.Func,
			Args = table.pack(table.unpack(wrapper.Args))
		})
	end
	return newFormatter
end

----------------------------------------------------
-- Presets
----------------------------------------------------

module.Presets = {}

module.Presets.Title = function(text: string): string
	return module.Bold(module.Size(text, 36))
end

module.Presets.Subtitle = function(text: string): string
	return module.Italic(module.Size(text, 24))
end

module.Presets.Highlight = function(text: string): string
	return module.Mark(module.Bold(text), Color3.fromRGB(255, 255, 0))
end

module.Presets.Colored = function(text: string, color: Color3): string
	return module.Stroke(module.Color(text, color), module.Utils.Darken(color, .4))
end

----------------------------------------------------
-- Utils
----------------------------------------------------

module.Utils = {}

function module.Utils.Lighten(color: Color3, factor: number): Color3
	local h, s, v = color:ToHSV()
	v = math.clamp(v * factor, 0, 1)
	return Color3.fromHSV(h, s, v)
end

function module.Utils.Darken(color: Color3, factor: number): Color3
	local h, s, v = color:ToHSV()
	v = math.clamp(v / factor, 0, 1)
	return Color3.fromHSV(h, s, v)
end

----------------------------------------------------
-- Main Methods
----------------------------------------------------

-- Changes the color of the given text
function module.Color(text: string, color: ColorInput): string
	local hexColor = ColorInputToHex(color)
	return `<font color="#{hexColor}">{text}</font>`
end

-- Changes the size of the given  text
function module.Size(text: string, size: number): string
	return `<font size="{size}">{text}</font>`
end

-- Changes the font of the given text
function module.Font(text: string, font: string | Enum.Font): string
	local fontName = font
	if typeof(font) == "EnumItem" then
		fontName = font.Name
	end
	
	return `<font face="{fontName}">{text}</font>`
end

-- Changes the thickness of the given text
function module.Weight(text: string, weight: number | Enum.FontWeight): string
	local fontWeight = weight
	if typeof(weight) == "EnumItem" then
		fontWeight = weight.Name
	end
	return `<font weight="{fontWeight}">{text}</font>`
end

-- Changes the transparency of the given text
function module.Transparency(text: string, transparency: number): string
	return `<font transparency="{transparency}">{text}</font>`
end

-- Adds a outline to the text
function module.Stroke(text: string, color: ColorInput, thickness: number): string
	local hexColor = ColorInputToHex(color)
	return `<stroke color="#{hexColor}" thickness="{thickness}">{text}</stroke>`
end

-- Makes the text bold
function module.Bold(text: string): string
	return `<b>{text}</b>`
end

-- Makes the text italic
function module.Italic(text: string): string
	return `<i>{text}</i>`
end

-- Underlines the text
function module.Underline(text: string): string
	return `<u>{text}</u>`
end

-- Applies a strikethrough
function module.Strikethrough(text: string): string
	return `<s>{text}</s>`
end

-- Inserts a line break
function module.LineBreak(): string
	return "<br/>"
end

-- Makes all text uppercase
function module.UpperCase(text: string): string
	return `<uc>{text}</uc>`
end

-- Converts text to small caps
function module.SmallCaps(text: string): string
	return `<sc>{text}</sc>`
end

-- Highlights the text
function module.Mark(text: string, color: ColorInput?): string
	if color then
		local hexColor = ColorInputToHex(color)
		return `<mark color="#{hexColor}">{text}</mark>`
	end

	return `<mark>{text}</mark>`
end

return module
