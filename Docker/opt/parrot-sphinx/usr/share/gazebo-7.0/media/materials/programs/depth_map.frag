varying float depth;

void main()
{
  // This returns the world position
  gl_FragColor = vec4(vec3(depth), 1.0);
}
