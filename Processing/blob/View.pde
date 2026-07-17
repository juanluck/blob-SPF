class View {

    /** Rendering scale factor applied to each simulation cell (pixels per cell). */
    static final int SCALE = 2;

    /** Off-screen buffer for the agent occupancy map (black dot on white). */
    PImage datamapImg;

    /** Off-screen buffer for the chemoattractant trail map (grayscale). */
    PImage trailmapImg;

    View(Context ctx) {
        datamapImg  = createImage(ctx.width, ctx.width, RGB);
        trailmapImg = createImage(ctx.width, ctx.width, RGB);
    }

    /** Rewrites both buffers from the current simulation state. O(width^2). */
    void update(Map map, Context ctx) {

        float maxTrail = 0;
        
        for (int y = 0; y < ctx.width; y++)
            for (int x = 0; x < ctx.width; x++)
                maxTrail = max(maxTrail, map.trailmap[y][x]);

        datamapImg.loadPixels();
        trailmapImg.loadPixels();

        for (int y = 0; y < ctx.width; y++) {
            for (int x = 0; x < ctx.width; x++) {
                int i = y * ctx.width + x;

                datamapImg.pixels[i] = (map.datamap[y][x] != null) ? color(0) : color(255);

                float t = (maxTrail > 0) ? map.trailmap[y][x] / maxTrail : 0;
                trailmapImg.pixels[i] = color(255 * t);
            }
        }

        datamapImg.updatePixels();
        trailmapImg.updatePixels();
    }

    /** Draws both maps side by side, each scaled by SCALE. */
    void draw(Context ctx) {
        image(datamapImg,  0,                     0, ctx.width * SCALE, ctx.width * SCALE);
        image(trailmapImg, ctx.width * SCALE,     0, ctx.width * SCALE, ctx.width * SCALE);
    }
}
