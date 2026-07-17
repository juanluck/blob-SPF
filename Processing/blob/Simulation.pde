class Simulation {
 
    /** Global values (parameters). */
    Context ctx;

    /** All the agents. */
    Agent[] agents;

    /** Agents location and chemoattractant levels. */
    Map map;

    Simulation() {

        //randomSeed(0);  // Fixed seed to reproduce.

        ctx    = new Context();
        var n  = int(ctx.width * ctx.width * ctx.p / 100.0);
        agents = new Agent[n];
        map    = new Map(ctx);

        println(n + " agents for a "+ctx.width+"x"+ctx.width+" grid");

        for(int i=0; i<n; i++) {
            
            var x = int(random(ctx.width));
            var y = int(random(ctx.width));
            var a = new Agent();
        
            while (map.datamap[y][x] != null) {
                x = int(random(ctx.width));
                y = int(random(ctx.width));
            }

            map.datamap[y][x] = a;
            a.move_to(x, y);
            agents[i] = a;
        }
    }

    public void step() {

        // Random permutation.

        for (int i = agents.length - 1; i > 0; i--) {
            int j = int(random(i + 1));
            Agent tmp  = agents[i];
            agents[i]  = agents[j];
            agents[j]  = tmp;
        }

        for (Agent a : agents) {
            a.motor_step(map, ctx);
        }

        map.diffuse(ctx);
    }

}
