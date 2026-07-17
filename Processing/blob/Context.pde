class Context {

    /** Size of the simulation (pixels). */
    int width = 200;

    /** Population as percentage of the image area. */
    float p = 10;

    /** Diffusion kernel size (pixels). */
    int diffK = 3;

    /** Trial-map chemoattractant diffsion decay factor. */
    float decayT = 0.1;

    /** Pre pattern stimuli projection weight. */
    float wProj = 0.01;

    /** FL and FR sensor angles (degrees). */
    float SA = 22.5;

    /** Agent rotation angle (degrees). */
    float RA = 45.0;

    /** Sensor offset distance (pixels). */
    int SO = 9;

    /** Sensor width (pixels). */
    int SW = 1;

    /** Step size */
    int SS = 1;

    /** Chemoattractant deposition per step. */
    float depT = 5.0;

    /** Probability of random change of direction. */
    float pCD = 0.0;

    /** Sensitivity threshold. */
    float sMin = 0.0;
}
