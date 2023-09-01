local KeyframeSequence = {}
KeyframeSequence.__index = KeyframeSequence

local EasingFunctions = require(script.Parent:WaitForChild('EasingFunctions'))

export type KeyframeSequence = {[number]: {Time: number, Value: number, EasingMode: number}}

KeyframeSequence.new = function(keyframes: KeyframeSequence)
	return setmetatable({
		Keyframes = keyframes
	}, KeyframeSequence)
end

KeyframeSequence.Keyframe = function(t: number, v: number, easingMode: number?)
	return {
		Time = t,
		Value = v,
		easingMode = easingMode
	}
end

function KeyframeSequence:GetKeyframesAt(t)
	local currentKeyframe, nextKeyframe
	
	for i, keyframe in ipairs(self.Keyframes) do
		if t < keyframe.Time then
			nextKeyframe = keyframe
			break
		else
			currentKeyframe = keyframe
		end
	end

	if not currentKeyframe then
		currentKeyframe = self.Keyframes[#self.Keyframes]
	end

	if not nextKeyframe then
		nextKeyframe = currentKeyframe
	end

	return currentKeyframe.Value, nextKeyframe.Value, currentKeyframe.Time, nextKeyframe.Time, nextKeyframe.EasingMode
end

function KeyframeSequence:GetValueAt(t)
	local a, b, ta, tb, easingMode = self:GetKeyframesAt(t)
	
	if ta ~= tb then
		t = (t - ta) / (tb - ta)
	end

	return EasingFunctions(a, b, t, easingMode or EasingFunctions.Modes.Linear)
end

function KeyframeSequence:GetKeyframes()
	return self.Keyframes
end

function KeyframeSequence:Destroy()
	table.clear(self.Keyframes)
	setmetatable(self, nil)
end

KeyframeSequence.EasingModes = EasingFunctions.Modes

return setmetatable(KeyframeSequence, {
	__call = function(_, keyframes: KeyframeSequence)
		return KeyframeSequence.new(keyframes)
	end,
})
