classTable={}
function class(classname, super)
	local cls = {}
	if super then
		cls = {}
		for k,v in pairs(super) do cls[k] = v end
		cls.super = super
	else
		cls = {init = function() end}
	end

	cls.__cname = classname
	cls.__index = cls

	function cls.new(...)
		local instance = setmetatable({}, cls)
		local create
		create = function(c, ...)
			if c.super then -- 递归向上调用create
				create(c.super, ...)
			end
			if c.init then
				c.init(instance, ...)
			end
		end
		create(instance, ...)
		--        instance.class = cls
		return instance
	end
	function cls.clsName()
		return cls.__cname
	end
	function cls.isType(target)
		if target == nil then
			return false
		end
		if(target.__cname == cls.__cname) then
			return true
		end
		if cls.super and cls.super.isType(target) then
			return true
		end
		return false
	end
	classTable[classname]=cls.new
	return cls
end

function refelect(classname, ...)
	return classTable[classname](...)
end

--example
Base = Class("Base")
function Base:Test(  )
	print(666)
end

Derive = Class("Derive",Base)

d = Derive.new()

d.Test() -- 666
print(d.__cname)
print(d.isType(Base))
