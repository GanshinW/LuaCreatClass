--Lua Creat Class

classTable={}
function Class(classname, super)
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

Derive1 = Class("Derive1",Base)
Derive2 = Class("Derive2",Base)
function Derive2:Test()
	print(222)
end
GrandDerive = Class("GrandDerive",Derive1)

d1 = Derive1.new()
d2 = Derive2.new()
d3 = GrandDerive.new()

d1.Test() -- 666
d2.Test() -- 222
print(d2.__cname) --Derive2
print(d1.super.__cname) --Base
print(d2.super.__cname) --Base
print(d3.super.__cname) --Derive1

--test