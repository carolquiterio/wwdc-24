#include <metal_stdlib>
using namespace metal;

bool isRed(half4 cor) {
    if (cor.r > (cor.b + 0.1) && cor.r > (cor.g + 0.3)) {
        return true;
    } else {
        return false;
    }
}

bool isGreen(float4 cor) {
    if (cor.g > (cor.r + 0.1) && cor.g > (cor.b + 0.1)) {
        return true;
    } else {
        return false;
    }
}

kernel void circleFilter(texture2d<half, access::read>  inputTexture  [[ texture(0) ]],
                         texture2d<half, access::write> outputTexture [[ texture(1) ]],
                         uint2 gid [[thread_position_in_grid]])
  {
      if ((gid.x >= inputTexture.get_width()) || (gid.y >= inputTexture.get_height())) {
          return;
      }


      half4 inputColor = inputTexture.read(gid);
      
     // half gray = dot(inputColor.rgb, kRec709Luma);
      
      outputTexture.write(half4(inputColor.r, inputColor.g, inputColor.b, 1.0), gid);


      // Set the output color to the input color, excluding the green component.
   //   half4 outputColor = half4(inputColor.r, 0.0, inputColor.b, 1.0);

     // return inputColor;

     // outputTexture.write(inputColor,gid);
  }
/*
(texture2d<float, access::read> inputTexture [[texture(0)]],
                         texture2d<float, access::write> outputTexture [[texture(1)]],
                         uint2 gid [[thread_position_in_grid]]) {

   /* int squareSize = 100;
    int circleRadius = 40;
    
    int squareX = gid.x / squareSize;
    int squareY = gid.y / squareSize;
    

    bool isEvenRow = squareY % 2 == 0;
    bool isEvenColumn = squareX % 2 == 0;
    
    // Determina se a cor do pixel deve ser branca ou preta
    float intensity = (isEvenRow && isEvenColumn) || (!isEvenRow && !isEvenColumn) ? 1.0 : 0.0;
    
    // Se a coluna for preta, desenhe um círculo
    if (!isEvenColumn) {
        // Calcule o centro do círculo
        float2 center = float2((squareX * squareSize) + squareSize / 2, (squareY * squareSize) + squareSize / 2);
        
        // Calcule a distância do pixel ao centro do círculo
        float distanceToCenter = distance(float2(gid), center);
        
        // Se a distância for menor que o raio do círculo, pinte o pixel de preto
        if (distanceToCenter <= circleRadius) {
            intensity = 0.0;
        }
    }
    */
    // Atribui a cor ao pixel
  /*  float4 color = float4(intensity, intensity, intensity, 1.0);
    
    float4 currentColor = inputTexture.read(gid);
    
    if(!isGreen(currentColor)) {
        color = inputTexture.read(gid);
    } else {
        outputTexture.write(currentColor, gid);
    }
    float4 currentColor = inputTexture.read(gid);
    outputTexture.write(currentColor, gid);
}
   */
