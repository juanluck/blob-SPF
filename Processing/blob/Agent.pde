class Agent {
    
    int x = 0, y = 0;
    
    float a;

    Agent() {
        a = random(TWO_PI);
    }

    /** Force-move to a given position (no verification). */
    public void move_to(int x, int y) {
        this.x = x;
        this.y = y;
    }

    /** 
     * Advances the agent by one simulation tick: a sensory stage updates the heading from the three chemoattractant
     * sensors (front/left/right), then a motor stage attempts to step forward and deposit trail.
    */
    public void motor_step(Map map, Context ctx) {
        sense(map, ctx);
        move(map, ctx);
    }

    /** 
     * Sensory stage: reads the trail map at the F/FL/FR sensor positions and / rotates the heading according to Jones'
     * rule table. Differences below / ctx.sMin are treated as "no gradient, go straight". A uniform random / / /
     * reorientation happens with probability ctx.pCD regardless of sensor / readings, to avoid deterministic lock-in on
     * local optima.
    */
    private void sense(Map map, Context ctx) {

        if (random(1) < ctx.pCD) {
            a = random(TWO_PI);
            return;
        }

        float sa = radians(ctx.SA);
        float ra = radians(ctx.RA);

        float F  = sampleTrail(map, ctx, 0);
        float FL = sampleTrail(map, ctx, sa);
        float FR = sampleTrail(map, ctx, -sa);

        if (abs(F - FL) < ctx.sMin && abs(F - FR) < ctx.sMin) {
            // no significant gradient: keep heading
        } else if (F > FL && F > FR) {
            // already facing the strongest signal
        } else if (F < FL && F < FR) {
            a += (random(1) < 0.5) ? ra : -ra;
        } else if (FL < FR) {
            a -= ra;
        } else {
            a += ra;
        }
    }

    /**
     * Samples the trail map SO pixels away, at `angleOffset` radians from the current heading, averaged over an SW x SW
     * neighborhood around that point (SW=1 reduces to the previous single-pixel sample). Coordinates wrap toroidally so
     * agents near an edge still get a meaningful reading.
     */
    private float sampleTrail(Map map, Context ctx, float angleOffset) {

        int sx = (x + round(cos(a + angleOffset) * ctx.SO) + ctx.width) % ctx.width;
        int sy = (y + round(sin(a + angleOffset) * ctx.SO) + ctx.width) % ctx.width;

        int r = ctx.SW / 2;
        float sum = 0;

        for (int dy = -r; dy <= r; dy++) {
            for (int dx = -r; dx <= r; dx++) {
                int nx = (sx + dx + ctx.width) % ctx.width;
                int ny = (sy + dy + ctx.width) % ctx.width;
                sum += map.trailmap[ny][nx];
            }
        }

        return sum / (ctx.SW * ctx.SW);
    }

    /**
     * Motor stage: steps SS pixels forward along the (possibly just updated) heading. If the target cell is free, the
     * agent moves there and deposits depT chemoattractant. If occupied, the agent stays put and picks a new random
     * heading instead of pushing through another agent.
     */
    private void move(Map map, Context ctx) {

        int nx = (x + round(cos(a) * ctx.SS) + ctx.width) % ctx.width;
        int ny = (y + round(sin(a) * ctx.SS) + ctx.width) % ctx.width;

        if (map.datamap[ny][nx] == null) {
            map.datamap[y][x] = null;
            map.datamap[ny][nx] = this;
            move_to(nx, ny);
            map.trailmap[ny][nx] += ctx.depT;
        } else {
            a = random(TWO_PI);
        }
    }
}
