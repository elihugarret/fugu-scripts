module(...,package.seeall)

local m, vs, col
function setup()
	m = iso(32, function(x,y,z)
  	return x*y + noise(x,y,z) + z*z*z - .25
	end)
	fgu:add(meshnode(m))
	vs = vertexlist(m)
end

function update(dt)
	for i=#vs, 10, -2 do
		local v = vs[i]
		local vp = v.p
		v.p = v.p + get_flux(tan(vp.z), atan2(vp.z, math.pi), atan(vp.z), fgu.t)
	end
	each(vs, function(v)
		pos = v:getPos()
		v.c = col(pos.x,pos.y,pos.z,fgu.t)
	end)
end

col = function(x,y,z,t) 
	return vec3(1, 1, 1)
end

get_flux = function(x,y,z,t)
	return vec3(
		noise (x*tan(t), y, tan(z+t)),
		0,
		noise (tan(x), tan(x+t), tan(z)))*(cos(t)/80)
end
