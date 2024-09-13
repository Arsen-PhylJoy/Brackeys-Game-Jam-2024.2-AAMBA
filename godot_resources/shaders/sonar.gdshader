shader_type canvas_item;

uniform float scrollSpeed = -4.0;
uniform vec4 sweepColor : source_color = vec4(0.3, 1.0, 0.6, 1.0); // Main sweep color
uniform vec4 edgeColor : source_color = vec4(1.0, 0.0, 0.0, 1.0); // Edge color
uniform float alphaMod = 1.0;
uniform float sonarWidth = 0.8; // Width of the main sweep
uniform float transitionWidth = 0.2; // Width of the transition from transparent to opaque
uniform float edgeWidth = 0.1; // Width of the edge area (increased for denser effect)

float when_lt(float x, float y) {
    return max(sign(y - x), 0.0);
}

float when_ge(float x, float y) {
    return 1.0 - when_lt(x, y);
}

void fragment() {
    vec4 old_color = COLOR;
    float scrollAmount = TIME * scrollSpeed + 0.2 * sin(TIME * 1.8);
    vec2 centerUV = UV * 2.0 - vec2(1.0);
    vec2 circUV = vec2(mod(atan(centerUV.y, centerUV.x) + TAU + scrollAmount, TAU) / TAU, length(centerUV));

    // Distance from the sweep boundary
    float distanceFromSweep = max(0.0, circUV.x - sonarWidth);
    
    // Alpha for the transition area (smooth step effect)
    float transitionAlpha = smoothstep(0.0, transitionWidth, distanceFromSweep);

    // Distance from the edge of the sweep
    float distanceFromEdge = max(0.0, edgeWidth - distanceFromSweep);
    
    // Alpha for the edge area (making the edge color more visible)
    float edgeAlpha = smoothstep(0.0, edgeWidth, distanceFromEdge) * 2.0; // Multiply for increased density

    // Choose the color based on the distance from the edge
    vec4 color = mix(edgeColor, sweepColor, transitionAlpha);

    // Final alpha considering both transition and edge alpha
    float alpha = when_ge(1.0, circUV.y) * alphaMod * max(transitionAlpha, edgeAlpha);

    COLOR = vec4(color.rgb, alpha);
}
