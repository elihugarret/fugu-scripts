

module(...,package.seeall)

local m = nil 
local counter = 0
local verts = nil
local thing = nil

function setup()
	m = cube()
	verts = vertexlist(m)
	thing = new_thing(m,choose(verts))
	fgu:add(meshnode(m))
end

function update(dt)
	counter = counter + dt
	if (counter > .5) then
		if (thing~=nil) then
			if (not thing:update(dt)) then
				thing = nil
				thing = new_thing(m,choose(verts))
			end
		end
		counter = 0
	end
end

function new_thing(m,v)
	local obj = {
		mesh = m,
		vertex = v,
		num_segments = 18,
		total_length = 11,
	}
	obj.profile = function(self,u,n)
		local len = step_function({
			{random(), random(.5,.8)},
			{.3,.001},
			{.6,-.2},
			{1.1,-.3}})(u)
		local ex = step_function({
			{random(.1, .3),random(1.1,1.4)},
			{.3,0.9},
			{.6,0.9},
			{.1,0.8}})(u)
		local d = nil
		if (len > 0) then d = n else d = n*-1 end
		return (abs(len)*self.total_length/self.num_segments), ex, d
	end
	
	obj.update = function(self,dt)
		if (not self.vertex.valid) then 
			return false
		end
		local n = self.vertex:getN()
		n:normalise()
		for k=1,self.num_segments do			
			local len,ex,dir = self:profile((k-1)/(self.num_segments-1),n)
			extrude_and_scale(self.mesh,self.vertex,dir,len,ex)
			m:sync()										
		end		
		return false
	end
	return obj
end
