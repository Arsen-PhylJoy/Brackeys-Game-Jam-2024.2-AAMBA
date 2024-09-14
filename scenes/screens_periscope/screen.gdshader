shader_type spatial;

uniform sampler2D visual; // Base texture (e.g., environment)
uniform sampler2D visual_monster; // Top texture (monster)
uniform bool has_monster; // Toggle to render monster or not

void fragment() {
    // Fetch colors from base and top textures
    vec4 baseColor = texture(visual, UV);
    vec4 topColor = texture(visual_monster, UV);

    // Check if we should render the monster
    if (has_monster) {
        // Only draw the top texture where it's not transparent
        // If the top texture has alpha > 0, draw it; otherwise, use the base texture
        if (topColor.a > 0.5) {
            ALBEDO = topColor.rgb;
        } else {
            ALBEDO = baseColor.rgb;
        }
    } else {
        // Render only the base texture if there's no monster
        ALBEDO = baseColor.rgb;
    }
}