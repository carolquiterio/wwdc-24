#include <metal_stdlib>
using namespace metal;

struct Vertex {
    float4 position [[position]];
    float2 text_coord;
};

struct Uniforms {
    float4x4 scaleMatrix;
};

vertex Vertex vertex_render_target(constant Vertex *vertexes [[ buffer(0) ]],
                                   constant Uniforms &uniforms [[ buffer(1) ]],
                                   uint vid [[vertex_id]])
{
    Vertex out = vertexes[vid];
    out.position = uniforms.scaleMatrix * out.position;
    return out;
};



fragment float4 fragment_render_target(Vertex vertex_data [[ stage_in ]],
                                       texture2d<float> tex2d [[ texture(0) ]])
{
    constexpr sampler textureSampler(mag_filter::linear, min_filter::linear);
    float4 color = float4(tex2d.sample(textureSampler, vertex_data.text_coord));
    return color;
};


bool isRed(float4 color) {
    if (color[0] > (color[2] + 0.2) && color[0] > (color[1] + 0.2)) {
        return true;
    } else {
        return false;
    }
}

bool isGreen(float4 color) {
     if (color[1] > (color[0] + 0.2) && color[1] > (color[2])) {
        return true;
    } else {
        return false;
    }
}

fragment float4 red_and_green_fragment_render_target(Vertex vertex_data [[ stage_in ]],
                                            texture2d<float> tex2d [[ texture(0) ]])
{
    constexpr sampler textureSampler(mag_filter::linear, min_filter::linear);
    
    float2 uv = vertex_data.text_coord;
    float4 color = float4(tex2d.sample(textureSampler, vertex_data.text_coord));
    
    if (isGreen(color)) {

        float circleRadius = 0.02;
        float spacing = 0.02;

        float2 pattern = floor(uv / (circleRadius * 2.0 + spacing));

        float2 relativePosition = uv - pattern * (circleRadius * 2.0 + spacing);

        float distanceToCenter = length(relativePosition - circleRadius);

        if (distanceToCenter <= circleRadius) {
            color = float4(0.0, 0.0, 0.0, 1.0);
        }
        return color;
        
    } else if(isRed(color)) {

        float triangleSize = 0.04;
        float spacing = 0.02;

        float2 pattern = floor(uv / (triangleSize + spacing));

        float2 relativePosition = uv - pattern * (triangleSize + spacing);

        float halfHeight = triangleSize * sqrt(3.0) / 2.0;
        if (relativePosition.y < halfHeight) {
            float halfBase = (triangleSize / 2.0) * (halfHeight - relativePosition.y) / halfHeight;
            if (relativePosition.x > halfBase && relativePosition.x < triangleSize - halfBase) {
                color = float4(0.0, 0.0, 0.0, 1.0);
            }
        }
        return color;
    }
    
    return color;
}

