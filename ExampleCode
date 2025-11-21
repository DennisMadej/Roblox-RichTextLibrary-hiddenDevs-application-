local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RTL = require(ReplicatedStorage.RichTextLibrary)

local Label = script.Parent

-- Example of quick code implementation
Label.Text = `{RTL.Size(RTL.Stroke("This text is made", Color3.new(1, .5, 0), 1.5), 20)} {RTL.Color("using the main methods.", BrickColor.new("Gold"))}`

task.wait(5)

-- Example of using the formatting class
local formatter = RTL.Formatter
	.new()
	:Add(RTL.Color, Color3.new(1, 0.6, 0))
	:Add(RTL.Stroke, Color3.new(.3,.3, 1), 3)
	:Add(RTL.Font, Enum.Font.GothamBold)
	:Add(RTL.Size, 20)
	:Add(RTL.Underline)

Label.Text = formatter:Apply(`Formatting Class example`)

task.wait(5)

-- Example of using more formatter methods
local clonedFormatter = formatter:Clone()

if clonedFormatter:Has(RTL.Underline) then
	clonedFormatter
		:Remove(RTL.Underline)
		:Remove(RTL.Size)
end

Label.Text = clonedFormatter:Apply(`Formatting Class example 2.{RTL.LineBreak()}After wrappers got removed.`)

task.wait(5)

Label.Text = RTL.Presets.Highlight(`This text was made using the "Highlight" preset.`)
