local EasingFunctionsEnum = {
	Linear = 1,
	
	EaseInQuad = 2,
	EaseOutQuad = 3,
	EaseInOutQuad = 4,
	
	EaseInCubic = 5,
	EaseOutCubic = 6,
	EaseInOutCubic = 7,
	
	EaseInQuart = 8,
	EaseOutQuart = 9,
	EaseInOutQuart = 10,
	
	EaseInQuint = 11,
	EaseOutQuint = 12,
	EaseInOutQuint = 13,
}

local EasingFunctions = {
	[EasingFunctionsEnum.Linear] = function(t)
		return t
	end,
	
	-- Quad --
	
	[EasingFunctionsEnum.EaseInQuad] = function(t)
		return t * t
	end,
	
	[EasingFunctionsEnum.EaseOutQuad] = function(t)
		return t * (2 - t)
	end,
	
	[EasingFunctionsEnum.EaseInOutQuad] = function(t)
		t = t * 2
		if t < 1 then
			return 0.5 * t * t
		else
			t = t - 1
			return -0.5 * (t * (t - 2) - 1)
		end
	end,
	
	-- Cubic --
	
	[EasingFunctionsEnum.EaseInCubic] = function(t)
		return t * t * t
	end,
	
	[EasingFunctionsEnum.EaseOutCubic] = function(t)
		t = t - 1
		return t * t * t + 1
	end,
	
	[EasingFunctionsEnum.EaseInOutCubic] = function(t)
		t = t * 2
		if t < 1 then
			return 0.5 * t * t * t
		else
			t = t - 2
			return 0.5 * (t * t * t + 2)
		end
	end,
	
	-- Quart --
	
	[EasingFunctionsEnum.EaseInQuart] = function(t)
		return t * t * t * t
	end,
	
	[EasingFunctionsEnum.EaseOutQuart] = function(t)
		t = t - 1
		return 1 - t * t * t * t
	end,
	
	[EasingFunctionsEnum.EaseInOutQuart] = function(t)
		t = t * 2
		if t < 1 then
			return 0.5 * t * t * t * t
		else
			t = t - 2
			return -0.5 * (t * t * t * t - 2)
		end
	end,
	
	-- Quint --
	
	[EasingFunctionsEnum.EaseInQuint] = function(t)
		return t * t * t * t * t
	end,
	
	[EasingFunctionsEnum.EaseOutQuint] = function(t)
		t = t - 1
		return t * t * t * t * t + 1
	end,
	
	[EasingFunctionsEnum.EaseInOutQuint] = function(t)
		t = t * 2
		if t < 1 then
			return 0.5 * t * t * t * t * t
		else
			t = t - 2
			return 0.5 * (t * t * t * t * t + 2)
		end
	end,
	
} :: {(t: number)->number}

return setmetatable({Functions = EasingFunctions, Modes = EasingFunctionsEnum}, {
	__call = function(_, a: number, b: number, t: number, easingMode: number)
		return a + (b - a) * EasingFunctions[easingMode](t)
	end,
} :: {__call: (_:any, a: number, b: number, t: number, easingMode: number)->number})
