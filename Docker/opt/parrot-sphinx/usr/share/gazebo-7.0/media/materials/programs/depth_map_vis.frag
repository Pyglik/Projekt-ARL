uniform float pNear;
uniform float pFar;

varying float depth;

void main()
{
  // This normalizes the depth value
  gl_FragColor = vec4(vec3(depth / (pFar - pNear)), 1.0);
}