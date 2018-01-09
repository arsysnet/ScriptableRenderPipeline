#ifndef UNITY_FILTERING_INCLUDED
#define UNITY_FILTERING_INCLUDED

// Cardinal (interpolating) B-Spline of the 2nd degree (3rd order). Support = 3x3.
// The fractional coordinate of each part is assumed to be in the [0, 1] range (centered on 0.5).
// https://www.desmos.com/calculator/47j9r9lolm
real2 BSpline2IntLeft(real2 x)
{
    return 0.5 * x * x;
}

real2 BSpline2IntMiddle(real2 x)
{
    return (1 - x) * x + 0.5;
}

real2 BSpline2IntRight(real2 x)
{
    return (0.5 * x - 1) * x + 0.5;
}

// Compute weights & offsets for 4x bilinear taps for the biquadratic B-Spline filter.
// The fractional coordinate should be in the [0, 1] range (centered on 0.5).
// Inspired by: http://vec3.ca/bicubic-filtering-in-fewer-taps/
void BiquadraticFilter(real2 fracCoord, out real2 weights[2], out real2 offsets[2])
{
    real2 l = BSpline2IntLeft(fracCoord);
    real2 m = BSpline2IntMiddle(fracCoord);
    real2 r = 1 - l - m;

    // Compute offsets for 4x bilinear taps for the quadratic B-Spline reconstruction kernel.
    // 0: lerp between left and middle
    // 1: lerp between middle and right
    weights[0] = l + 0.5 * m;
    weights[1] = r + 0.5 * m;
    offsets[0] = -0.5 + 0.5 * m * rcp(weights[0]);
    offsets[1] =  0.5 + r * rcp(weights[1]);
}

#endif // UNITY_FILTERING_INCLUDED
