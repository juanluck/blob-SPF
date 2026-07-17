class Map {

    /** Contains either null of the reference of an agent. */
    Agent[][] datamap;

    /** Chemoattractant levels. */
    float[][] trailmap;

    /** Scratch buffer holding the diffused+decayed result, swapped into
      * trailmap at the end of diffuse(). Allocated once to avoid per-frame
      * garbage.
      */
    float[][] trailmapNext;

    Map(Context ctx) {
        datamap      = new Agent[ctx.width][ctx.width];
        trailmap     = new float[ctx.width][ctx.width];
        trailmapNext = new float[ctx.width][ctx.width];
    }

    /** Diffuses and decays the trail map for one tick: each cell becomes the
      * mean of its diffK x diffK neighborhood in the current trailmap,
      * scaled by (1 - decayT). Boundaries wrap toroidally, consistent with
      * agent movement. O(width^2 * diffK^2).
      */
    public void diffuse(Context ctx) {

        int r = ctx.diffK / 2; // kernel radius; diffK assumed odd

        for (int y = 0; y < ctx.width; y++) {
            for (int x = 0; x < ctx.width; x++) {
                float sum = 0;

                for (int dy = -r; dy <= r; dy++) {
                    for (int dx = -r; dx <= r; dx++) {
                        int nx = (x + dx + ctx.width) % ctx.width;
                        int ny = (y + dy + ctx.width) % ctx.width;
                        sum += trailmap[ny][nx];
                    }
                }

                float mean = sum / (ctx.diffK * ctx.diffK);
                trailmapNext[y][x] = mean * (1 - ctx.decayT);
            }
        }

        float[][] tmp  = trailmap;
        trailmap       = trailmapNext;
        trailmapNext   = tmp;
    }
}
