module(...,package.seeall)

local m, vs, col

function setup()
	m = iso(32, function(x, y, z)
	   return noise(x, x, x) - y / noise(cos(x),y,sin(z)) + z * z * z - sqrt(.25)
	end)
	fgu:add(meshnode(m))
	vs = vertexlist(m)
end

function update(dt)
	for i = #vs, 10, -2 do
		local v = vs[i]
		local vp = v.p
		v.p = v.p + get_flux(tan(vp.z), atan2(vp.x, math.pi), atan(vp.y), cos(fgu.t))
	end
end

function get_flux(x, y, z, t)
	return vec3(
		noise(x * tan(t), y, tan(z + t)),
		noise(sin(x + t), cos(y - t), tan(z * t) ),
		noise(tan(x), tan(x + t), tan(z))
  ) * (sin(t) / 80)
end
