shader_type spatial;

// Function to generate pseudo-random values
float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
    // Simplified randomness based on fragment coordinates and time
    vec2 position = FRAGCOORD.xy / SCREEN_PIXEL_SIZE.xy;
    float randomValue = rand(position + TIME);

    float starThreshold = 0.995; // Adjust for more or fewer stars
    bool isStar = randomValue > starThreshold;

    // Star color and brightness
    vec3 starColor = isStar ? vec3(1.0, 1.0, 1.0) : vec3(0.0); // White stars or black space
    float brightness = isStar ? rand(position) : 0.0; // Random brightness for each star

    EMISSION = starColor * brightness * 2.0; // Make stars glow
    ALBEDO = starColor * brightness;
    ALPHA = isStar ? 1.0 : 0.0; // Ensure non-stars are transparent or fully transparent
}
