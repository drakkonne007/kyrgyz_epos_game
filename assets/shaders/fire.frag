#version 320 es

#define ITERATIONS 12
#define SPEED 10.0
#define DISPLACEMENT 0.05
#define TIGHTNESS 10.0
#define YOFFSET 0.1
#define YSCALE 0.25
#define FLAMETONE vec3(50.0, 5.0, 1.0)



precision lowp float;
out vec4 fragColor;

uniform float iTime;
uniform float iScale;
uniform vec2 iOffset;
uniform vec2 iResolution;

float shape(in vec2 pos) // a blob shape to distort
{
	return clamp( sin(pos.x*3.1416) - pos.y+YOFFSET, 0.0, 1.0 );
}

float noise(vec2 x) // iq noise function
{
	vec3 i = floor(x);
    vec3 f = fract(x);

    vec3 u = f*f*(3.0-2.0*f);

    return mix( mix( dot( random2(i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ),
                     dot( random2(i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), u.x),
                mix( dot( random2(i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ),
                     dot( random2(i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), u.x), u.y);
}

void main() 
{
	vec2 uv = gl_FragCoord.xy / iResolution.xy;
	uv /= iScale;
	uv -= iOffset;
	float nx = 0.0;
	float ny = 0.0;
	for (int i=1; i<ITERATIONS+1; i++)
	{
		float ii = pow(float(i), 2.0);
		float ifrac = float(i)/float(ITERATIONS);
		float t = ifrac * iTime * SPEED;
		float d = (1.0-ifrac) * DISPLACEMENT;
		nx += noise( vec2(uv.x*ii-iTime*ifrac, uv.y*YSCALE*ii-t)) * d * 2.0;
		ny += noise( vec2(uv.x*ii+iTime*ifrac, uv.y*YSCALE*ii-t)) * d;
	}
	float flame = shape( vec2(uv.x+nx, uv.y+ny) );
	vec3 col = pow(flame, TIGHTNESS) * FLAMETONE;
    
    // tonemapping
    col = col / (1.0+col);
    col = pow(col, vec3(1.0/2.2));
    col = clamp(col, 0.0, 1.0);
	
	fragColor = vec4(col, 1.0);
}