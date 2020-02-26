#version 430

layout(location = 1) uniform float time;

layout(location = 0) out vec4 fragcolor;

in vec3 out_pos;
 
void main(void)
{  
	vec2 coord = gl_PointCoord.xy - vec2(0.5);
	float angle = acos(dot(normalize(coord), vec2(cos(time), sin(time))));
	float r = length(coord);
	if(mod(floor(angle/0.6283), 2)==0)
	{
		if(r > 0.5 - 0.3 * ((angle - 0.6283 * floor(angle/0.62830))/0.6283))
		{
			discard;
		}
	}
	else
	{
		if(r > 0.2 + 0.3 * ((angle - 0.6283 * floor(angle/0.62830))/0.6283))
		{
			discard;
		}
	}
	
	fragcolor = vec4(0.6 + 0.4 * sin(0.7 * time + 3.1 * out_pos.x), 0.6 + 0.4 * sin(2.9 * time + 2.4 * out_pos.y), 0.6 + 0.4 * sin(1.3 * time + 1.3 * out_pos.z), 0.2);
}




















