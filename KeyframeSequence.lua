--!native
--!strict

type AllowedTypes<T> = T & (number | Vector3 | Vector2 | Color3)

export type KeyframeSequence<T> = {
	Keyframes: {Keyframe<T>},
	LastUsedKeyframes: {Keyframe<T>},

	GetKeyframeAt: (self: KeyframeSequence<T>, t: number) -> (Keyframe<T>, Keyframe<T>),
	GetValueAt: (self: KeyframeSequence<T>, t: number) -> T,
	
	Destroy: (self: KeyframeSequence<T>) -> nil,
}

export type KeyframeArgData<T> = {
	Time: number,
	Value: AllowedTypes<T>,
	Envelope: number,

	EasingMode: (t: number) -> number,
}

export type Keyframe<T> = {
	Time: number,
	Value: AllowedTypes<T>,

	Envelope: number,
	Random: number,

	EasingMode: (t: number) -> number,
}

local KeyframeSequence = {}

@native @checked function KeyframeSequence.new<T>(keypoints: {KeyframeArgData<T>}): KeyframeSequence<T>
	local Keyframes: {Keyframe<T>} = {}

	for i, keyframe in keypoints do
		Keyframes[i] = {
			Time = keyframe.Time,
			Value = keyframe.Value,

			Envelope = keyframe.Envelope or 0,
			Random = 0,

			EasingMode = keyframe.EasingMode
		}
	end

	return {
		Keyframes = Keyframes,
		LastUsedKeyframes = {},

		GetKeyframeAt = KeyframeSequence.GetKeyframeAt,
		GetValueAt = KeyframeSequence.GetValueAt,
		
		Destroy = KeyframeSequence.Destroy,
	}
end

@native @checked function KeyframeSequence.GetKeyframeAt<T>(self: KeyframeSequence<T>, t: number): (Keyframe<T>, Keyframe<T>)
	for i = #self.Keyframes, 1, -1 do
		local keyframe = self.Keyframes[i]

		if t > keyframe.Time then
			return keyframe, self.Keyframes[i + 1] or self.Keyframes[1]
		end
	end

	return self.Keyframes[1], self.Keyframes[2]
end

@native @checked function KeyframeSequence.GetValueAt<T>(self: KeyframeSequence<T>, t: number): T
	local a, b = self:GetKeyframeAt(t)

	if not table.find(self.LastUsedKeyframes, a) then
		table.clear(self.LastUsedKeyframes)

		table.insert(self.LastUsedKeyframes, a)
		table.insert(self.LastUsedKeyframes, b)
		
		b.Random = (math.random() - math.random()) * b.Envelope
	end

	if a.Time ~= b.Time then
		t = (t - a.Time) / (b.Time - a.Time)
	end

	if type(a.Value) == 'number' and type(b.Value) == 'number' then
		a = a :: Keyframe<number>
		b = b :: Keyframe<number>

		local aValue = a.Value + a.Random
		local bValue = b.Value + b.Random

		return aValue + (bValue - aValue) * b.EasingMode(t)
	end

	if typeof(a.Value) == 'Vector3' and typeof(b.Value) == 'Vector3' then
		local aValue = a.Value + Vector3.new(a.Random, a.Random, a.Random)
		local bValue = b.Value + Vector3.new(b.Random, b.Random, b.Random)

		return aValue:Lerp(bValue, b.EasingMode(t))
	end

	if typeof(a.Value) == 'Vector2' and typeof(b.Value) == 'Vector2' then
		local aValue = a.Value + Vector3.new(a.Random, a.Random, a.Random)
		local bValue = b.Value + Vector3.new(b.Random, b.Random, b.Random)

		return aValue:Lerp(bValue, b.EasingMode(t))
	end

	if typeof(a.Value) == 'Color3' and typeof(b.Value) == 'Color3' then
		local aValue = Color3.new(a.Value.R + a.Random, a.Value.G + a.Random, a.Value.B + a.Random)
		local bValue = Color3.new(b.Value.R + b.Random, b.Value.G + b.Random, b.Value.B + b.Random)

		return aValue:Lerp(bValue, b.EasingMode(t))
	end

	return error()
end

function KeyframeSequence.Destroy<T>(self: KeyframeSequence<T>): nil
	table.clear(self.Keyframes)
	
	return nil
end

return KeyframeSequence
