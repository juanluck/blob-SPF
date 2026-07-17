/** Binds get/set access to a single Context field so Param can manipulate it generically. */
interface ParamAccessor {
    float get();
    void set(float v);
}

/** A single live-tunable parameter: a labeled value with an increase/decrease hotkey pair
  * (lowercase increases, Shift+key decreases), a step size, and clamping bounds.
  */
class Param {
    String label, unit;
    char key;
    float step, min, max;
    ParamAccessor accessor;

    Param(String label, char key, float step, float min, float max, String unit, ParamAccessor accessor) {
        this.label    = label;
        this.key      = key;
        this.step     = step;
        this.min      = min;
        this.max      = max;
        this.unit     = unit;
        this.accessor = accessor;
    }

    void adjust(float sign) {
        accessor.set(constrain(accessor.get() + sign * step, min, max));
    }

    String format() {
        return String.format("%-22s %6.2f %-3s (%c/%c)",
            label, accessor.get(), unit, Character.toUpperCase(key), key);
    }
}

/** On-screen overlay listing live-tunable Context parameters and their hotkeys. Toggled with TAB.
  * Only parameters that don't require reinstantiating Simulation (population count / grid size
  * stay fixed) are exposed here.
  */
class HUD {

    boolean visible = false;
    Param[] params;

    HUD(Context ctx) {
        params = new Param[] {
            new Param("SA  sensor angle",    'q', 1f,    0, 180, "deg", new ParamAccessor() {
                float get()        { return ctx.SA; }
                void  set(float v) { ctx.SA = v; }
            }),
            new Param("RA  rotation angle",  'w', 1f,    0, 180, "deg", new ParamAccessor() {
                float get()        { return ctx.RA; }
                void  set(float v) { ctx.RA = v; }
            }),
            new Param("SO  sensor offset",   'e', 1f,    1, 50,  "px",  new ParamAccessor() {
                float get()        { return ctx.SO; }
                void  set(float v) { ctx.SO = round(v); }
            }),
            new Param("decayT  trail decay", 'd', 0.01f, 0, 1,   "",    new ParamAccessor() {
                float get()        { return ctx.decayT; }
                void  set(float v) { ctx.decayT = v; }
            }),
            new Param("diffK  diff. kernel", 'f', 2f,    1, 15,  "px",  new ParamAccessor() {
                float get()        { return ctx.diffK; }
                void  set(float v) { ctx.diffK = round(v); }
            }),
            new Param("depT  deposition",    'g', 0.5f,  0, 50,  "",    new ParamAccessor() {
                float get()        { return ctx.depT; }
                void  set(float v) { ctx.depT = v; }
            }),
        };
    }

    void toggle() {
        visible = !visible;
    }

    /** Dispatches a key press to whichever Param it matches, if any. Case selects direction. */
    void handleKey(char k) {
        for (Param p : params) {
            if (k == p.key)                             p.adjust(1);
            else if (k == Character.toUpperCase(p.key)) p.adjust(-1);
        }
    }

    void draw() {
        if (!visible) return;

        fill(0, 180);
        noStroke();
        rect(0, 0, 300, 20 + params.length * 16);

        fill(255);
        textFont(createFont("Monospaced", 12));
        textAlign(LEFT, TOP);

        text("TAB to hide", 8, 4);
        for (int i = 0; i < params.length; i++) {
            text(params[i].format(), 8, 20 + i * 16);
        }
    }
}
