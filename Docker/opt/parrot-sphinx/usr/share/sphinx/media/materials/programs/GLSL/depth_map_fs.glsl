#version 120

uniform vec3 noise_offsets;
uniform float noise_mean;
uniform float noise_stddev;
uniform float coef;
uniform float maxdisp;
uniform sampler2D visualtex;
uniform float invalidpx_rate;
uniform vec3 invalidpx_color;

// param_named_auto
uniform vec4 viewportSize;
uniform float farClipDistance;

varying float depth;

#define PI 3.14159265358979323846264
#define INVALID_VEC3 vec3(-1.0, -1.0, -1.0)

// copied from gazebo
float rand(vec2 co)
{
  float r = fract(sin(dot(co.xy, vec2(12.9898,78.233))) * 43758.5453);
  if(r == 0.0)
    return 0.000000000001;
  else
    return r;
}

// copied from gazebo
float gaussrand(vec2 co)
{
  float U, V, R, Z;
  U = rand(co + vec2(noise_offsets.x, noise_offsets.x));
  V = rand(co + vec2(noise_offsets.y, noise_offsets.y));
  R = rand(co + vec2(noise_offsets.z, noise_offsets.z));

  if (R < 0.5)
    Z = sqrt(-2.0 * log(U)) * sin(2.0 * PI * V);
  else
    Z = sqrt(-2.0 * log(U)) * cos(2.0 * PI * V);

  return Z;
}

bool is_close_to_color(vec3 current, vec3 ref)
{
  float diff = 0.0;
  diff += abs(current.r - ref.r);
  diff += abs(current.g - ref.g);
  diff += abs(current.b - ref.b);

  return (diff < 0.5);
}

void main()
{
  float random_value = gaussrand(gl_FragCoord.xy);
  float disparity = 0.;

  // calculate disparity from depth value
  if (depth > 0.)
    disparity = coef / depth + random_value * noise_stddev + noise_mean;

  // handle saturation
  if (disparity > maxdisp)
    // compute random value in the interval [0,maxdisp]
    disparity = maxdisp * random_value;

  // round to the nearest value with a precision of 0.5
  disparity = floor(disparity * 2.0 + 0.5) / 2.0;

  // make sure disparity is in range [0, maxdisp]
  disparity = clamp(disparity, 0.0, maxdisp);

  // retrieve color value from regular rendering
  vec4 color = texture2D(visualtex, vec2(gl_FragCoord.x / viewportSize.x,
                                         gl_FragCoord.y / viewportSize.y));

  // if current color is close to forbidden color, invalidate pixel
  if (invalidpx_color.r >= 0.0
      && is_close_to_color(color.rgb, invalidpx_color))
    gl_FragColor = vec4(INVALID_VEC3, 1.0);

  // if depth saturates at far clip,
  // let us assume it is the sky -> invalidate pixel
  else if (invalidpx_color.r >= 0.0
      && farClipDistance > 0
      && depth >= farClipDistance)
    gl_FragColor = vec4(INVALID_VEC3, 1.0);

  // randomly invalidate pixel
  else if (rand(gl_FragCoord.xy + noise_offsets.xy) < invalidpx_rate)
    gl_FragColor = vec4(INVALID_VEC3, 1.0);

  else
    gl_FragColor = vec4(vec3(disparity), 1.0);
}
