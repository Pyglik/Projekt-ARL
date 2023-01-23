#version 120

uniform vec4 texelOffsets;

varying float depth;

void main()
{
  gl_Position = ftransform();
  // fix pixel / texel alignment
  gl_Position.xy += texelOffsets.zw * gl_Position.w;
  depth = gl_Position.w; // copied from old gazebo
}
