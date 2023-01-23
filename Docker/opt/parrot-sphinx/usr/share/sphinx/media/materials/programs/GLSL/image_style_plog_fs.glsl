#version 120

uniform sampler2D map;

void main()
{
  float gray = dot(texture2D(map, gl_TexCoord[0].xy).rgb, vec3(0.299, 0.587, 0.114));
  gl_FragColor = vec4(vec3(gray), 1.0);
}
