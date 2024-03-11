#version 320 es

precision lowp float;
out vec4 fragColor;

uniform float iTime;
uniform float iScale;
uniform vec2 iOffset;
uniform vec2 iResolution;


mat2 rot (float angle)
{
    float c = cos(angle);
    float s = sin(angle);
    return mat2 (c,-s,s,c);
} 

float sphere (vec3 pos, float rad)
{return length(pos)-rad;}

float box (vec3 pos, vec3 corn)
{return length(max(abs(pos)-corn,0.));}


vec2 moda (vec2 pos, float period)
{
    float angle = atan(pos.y,pos.x);
    float len = length(pos.xy);
    angle = mod(angle-period/2., period)-period/2.;
    return vec2(sin(angle)*len,cos(angle)*len); 
    
}

float SDF (vec3 pos)
{
    float period_moda1 = (2.*3.14)/10.;
    float period_moda2 = (2.*3.14)/3.;
    vec3 offset = vec3(-0.5,0.5,0.5);
    pos.xy = moda(pos.xy, period_moda1);
    //pos.yz = moda(pos.yz, period_moda2);
    pos.xz *= rot(sin(iTime*2.));
   	pos -= offset;
    return max(-sphere(pos, 0.7), box(pos, vec3(0.5)));
}


vec3 norm (vec3 pos)
{
    vec2 eps = vec2(0.075,0.);
    return normalize(vec3(SDF(pos+eps.xyy)-(SDF(pos-eps.xyy)),
                          SDF(pos+eps.yxy)-(SDF(pos-eps.yxy)),
                          SDF(pos+eps.yyx)-(SDF(pos-eps.yyx))));
}

float lighting (vec3 norm, vec3 light)
{
    return dot(light, norm);
}

void main()
{
    
	vec2 uv = 2.*(gl_FragCoord.xy / iResolution.xy)-1.;
    uv.x *= iResolution.x/iResolution.y;
	uv /= iScale;
	uv -= iOffset;
    
    vec3 pos = vec3(0.001,0.001,-1.);
    vec3 dir = normalize(vec3(uv,1.));
    vec3 color = vec3(0.);
    
    vec3 light1 = vec3(0.0,0.1,1.25);
    vec3 light2 = vec3(0.0,0.5,-5);
    
    for (int i = 0; i<60; i++)
    {
        float d = SDF(pos);
        if (d<0.01) 
        {
            vec3 norml = norm(pos);
            color = vec3(lighting(norml, light1));
            //color += vec3(lighting(norml, light2));
        	break;
        }
        pos += d*dir;
    }
    
	fragColor = vec4(color*vec3(0.1,0.5,0.7)*2.,color);
}