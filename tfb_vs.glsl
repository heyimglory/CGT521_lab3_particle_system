#version 440            

layout(location = 0) uniform mat4 PVM;
layout(location = 1) uniform float time;

layout(location = 0) in vec3 pos_attrib;
layout(location = 1) in vec3 vel_attrib;
layout(location = 2) in float age_attrib;

out vec3 out_pos;

layout(xfb_buffer = 0) out;

layout(xfb_offset = 0, xfb_stride = 28) out vec3 pos_out; 
layout(xfb_offset = 12, xfb_stride = 28) out vec3 vel_out; 
layout(xfb_offset = 24, xfb_stride = 28) out float age_out;


//Basic velocity field
vec3 v0(vec3 p);

//pseudorandom number
float rand(vec2 co);

void main(void)
{
	//Draw current particles
	gl_Position = PVM*vec4(pos_attrib, 1.0);
	gl_PointSize = 5.0 + 10.0 * abs(sin(3.2 * pos_attrib.x + 0.8 * pos_attrib.y - 2.3 * pos_attrib.z)); //point_size;

	//Compute particle attributes for next frame
	vel_out = v0(pos_attrib);
	pos_out = pos_attrib + 0.001 * vel_out;
	age_out = age_attrib - 0.8;

	out_pos = pos_attrib;

	//Reinitialize particles as needed
	if(age_out <= 0.0 || length(pos_out) > 3.0f)
	{
		vec2 seed = vec2(float(gl_VertexID), time); //seed for the random number generator

		age_out = 500.0 + 200.0 * rand(seed);
		//Pseudorandom position
		//pos_out = pos_attrib * 0.0002 + 0.5 * vec3(rand(seed.xx), rand(seed.yy) + 1.0, rand(seed.xy));
		pos_out = pos_attrib * 0.0002 + vec3(0.8 * cos(time + rand(seed.xx)), 0.3 * sin(rand(seed.yy)) + 0.5, 0.8 * cos(0.01 * time) * sin(rand(seed.yy)));
	}
}

vec3 v0(vec3 p)
{
	//return vec3(sin(p.y+time-10.0), -sin(p.x*6.0+3.0*time+10.0), +cos(2.4*p.z+2.0*time));
	return vec3(4.0 * sin(p.z * 10.0 + 0.2 * time), 0.1 * pow(p.y - 3.0, 3) - cos(time + 2.7 - p.z) * sin(p.x*6.0), 1.3 * cos(2.4 * p.x + 0.003 * time) + sin(3.0 * p.y));
}

float rand(vec2 co)
{
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

