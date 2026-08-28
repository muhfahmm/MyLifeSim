------------------------
   1    #version 300 es
   2
   3    uniform highp vec2 u_skRTFlip;
   4    precision mediump float;
   5    precision mediump sampler2D;       
   6    out mediump vec4 sk_FragColor;     
   7    uniform highp vec4 uinnerRect_S1;  
   8    uniform mediump vec2
   uradiusPlusHalf_S1;
   9    in highp vec4 vinCircleEdge_S0;    
  10    in mediump vec4 vinColor_S0;       
  11    void main() {
  12    highp     vec4 sk_FragCoord =      
  vec4(gl_FragCoord.x, u_skRTFlip.x +      
  u_skRTFlip.y * gl_FragCoord.y,
  gl_FragCoord.z, gl_FragCoord.w);
  13    highp vec4 circleEdge =
  vinCircleEdge_S0;
  14    mediump vec4 outputColor_S0 =      
  vinColor_S0;
  15    highp float d = length(circleEdge.xy);
  16    mediump float distanceToOuterEdge =
  circleEdge.z * (1.0 - d);
  17    mediump float edgeAlpha =
  clamp(distanceToOuterEdge, 0.0, 1.0);    
  18    mediump vec4 outputCoverage_S0 =   
  vec4(edgeAlpha);
  19    highp vec2 _0_dxy0 = uinnerRect_S1.xy
  - sk_FragCoord.xy;
  20    highp vec2 _1_dxy1 = sk_FragCoord.xy -
  uinnerRect_S1.zw;
  21    highp vec2 _2_dxy = max(max(_0_dxy0,
  _1_dxy1), 0.0);
  22    mediump float _3_alpha =
  clamp(uradiusPlusHalf_S1.x -
  length(_2_dxy), 0.0, 1.0);
  23    _3_alpha = 1.0 - _3_alpha;
  24    mediump vec4 output_S1 =
  outputCoverage_S0 * _3_alpha;
  25    {
  26    sk_FragColor = outputColor_S0 *    
  output_S1;
  27    }
  28    }
  29
Errors:
(unknown error)
Shader compilation error
------------------------
   1    #version 300 es
   2
   3    precision mediump float;
   4    precision mediump sampler2D;       
   5    out mediump vec4 sk_FragColor;     
   6    uniform sampler2D
   uTextureSampler_0_S0;
   7    in highp vec2 vTextureCoords_S0;   
   8    in highp float vTexIndex_S0;       
   9    in mediump vec4 vinColor_S0;       
  10    void main() {
  11    mediump vec4 outputColor_S0 =      
  vinColor_S0;
  12    mediump vec4 texColor =
  texture(uTextureSampler_0_S0,
  vTextureCoords_S0, -0.475).xxxx;
  13    mediump vec4 outputCoverage_S0 =   
  texColor;
  14    {
  15    sk_FragColor = outputColor_S0 *    
  outputCoverage_S0;
  16    }
  17    }
  18
Errors:
(unknown error)
Attempting to load countries.json...
Successfully loaded 207 countries.
Successfully loaded names from asia for
indonesia
