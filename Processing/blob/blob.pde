Simulation sim;
View view;
HUD hud;


void setup() {
    size(800, 400);
    noSmooth();
    sim  = new Simulation();
    view = new View(sim.ctx);
    hud  = new HUD(sim.ctx);
}


void draw() {
    sim.step();
    view.update(sim.map, sim.ctx);
    view.draw(sim.ctx);
    hud.draw();
}


void keyPressed() {
    if (key == TAB) hud.toggle();
    else             hud.handleKey(key);
}
