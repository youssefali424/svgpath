// Copyright (c) 2016, SlickTech. All rights reserved. Use of this source code
// is governed by a MIT license that can be found in the LICENSE file.

import 'dart:math';
import 'dart:math' as math;

// import 'package:m/math.dart' as math;

// Convert an arc to a sequence of cubic bézier curves

const tau = math.pi * 2;

// Calculate an angle between two vectors
double vectorAngle(double ux, double uy, double vx, double vy) {
  var sign = (ux * vy - uy * vx) < 0 ? -1 : 1;
  var umag = sqrt(ux * ux + uy * uy);
  var vmag = sqrt(vx * vx + vy * vy);
  var dot = ux * vx + uy * vy;
  var div = dot / (umag * vmag);

  // rounding errors, e.g. -1.0000000000000002 can screw up this
  if (div > 1.0) {
    div = 1.0;
  }
  if (div < -1.0) {
    div = -1.0;
  }

  return sign * acos(div);
}

// Convert from endpoint to center parameterization,
// see http://www.w3.org/TR/SVG11/implnote.html#ArcImplementationNotes
//
// Return [cx, cy, theta1, delta_theta]
List<double> getArcCenter(
    double x1,
    double y1,
    double x2,
    double y2,
    double? fa,
    double? fs,
    double rx,
    double ry,
    double sin_phi,
    double cos_phi) {
  // Step 1.
  //
  // Moving an ellipse so origin will be the middle point between our two
  // points. After that, rotate it to line up ellipse axes with coordinate
  // axes.
  //
  var x1p = cos_phi * (x1 - x2) / 2 + sin_phi * (y1 - y2) / 2;
  var y1p = -sin_phi * (x1 - x2) / 2 + cos_phi * (y1 - y2) / 2;

  var rx_sq = rx * rx;
  var ry_sq = ry * ry;
  var x1p_sq = x1p * x1p;
  var y1p_sq = y1p * y1p;

  // Step 2.
  //
  // Compute coordinates of the centre of this ellipse (cx', cy')
  // in the new coordinate system.
  //
  double radicant = (rx_sq * ry_sq) - (rx_sq * y1p_sq) - (ry_sq * x1p_sq);

  if (radicant < 0) {
    // due to rounding errors it might be e.g. -1.3877787807814457e-17
    radicant = 0;
  }

  radicant /= (rx_sq * y1p_sq) + (ry_sq * x1p_sq);
  radicant = sqrt(radicant) * (fa == fs ? -1 : 1);

  var cxp = radicant * rx / ry * y1p;
  var cyp = radicant * -ry / rx * x1p;

  // Step 3.
  //
  // Transform back to get centre coordinates (cx, cy) in the original
  // coordinate system.
  //
  double cx = cos_phi * cxp - sin_phi * cyp + (x1 + x2) / 2;
  double cy = sin_phi * cxp + cos_phi * cyp + (y1 + y2) / 2;

  // Step 4.
  //
  // Compute angles (theta1, delta_theta).
  //
  var v1x = (x1p - cxp) / rx;
  var v1y = (y1p - cyp) / ry;
  var v2x = (-x1p - cxp) / rx;
  var v2y = (-y1p - cyp) / ry;

  var theta1 = vectorAngle(1, 0, v1x, v1y);
  var delta_theta = vectorAngle(v1x, v1y, v2x, v2y);

  if (fs == 0 && delta_theta > 0) {
    delta_theta -= tau;
  }
  if (fs == 1 && delta_theta < 0) {
    delta_theta += tau;
  }

  return [cx, cy, theta1, delta_theta];
}

//
// Approximate one unit arc segment with bézier curves,
// see http://math.stackexchange.com/questions/873224
//
List<double> approximateUnitArc(theta1, delta_theta) {
  var alpha = 4 / 3 * tan(delta_theta / 4);

  var x1 = cos(theta1);
  var y1 = sin(theta1);
  var x2 = cos(theta1 + delta_theta);
  var y2 = sin(theta1 + delta_theta);

  return [
    x1,
    y1,
    x1 - y1 * alpha,
    y1 + x1 * alpha,
    x2 + y2 * alpha,
    y2 - x2 * alpha,
    x2,
    y2
  ];
}

List<List<double>> a2c(double x1, double y1, double x2, double y2, double? fa,
    double? fs, double? rx, double? ry, phi) {
  var sin_phi = sin(phi * tau / 360);
  var cos_phi = cos(phi * tau / 360);

  // Make sure radii are valid
  //
  var x1p = cos_phi * (x1 - x2) / 2 + sin_phi * (y1 - y2) / 2;
  var y1p = -sin_phi * (x1 - x2) / 2 + cos_phi * (y1 - y2) / 2;

  if (x1p == 0 && y1p == 0) {
    // we're asked to draw line to itself
    return [];
  }

  if (rx == 0 || ry == 0) {
    // one of the radii is zero
    return [];
  }

  // Compensate out-of-range radii
  //
  rx = rx!.abs();
  ry = ry!.abs();

  var lambda = (x1p * x1p) / (rx * rx) + (y1p * y1p) / (ry * ry);
  if (lambda > 1) {
    rx *= sqrt(lambda);
    ry *= sqrt(lambda);
  }

  // Get center parameters (cx, cy, theta1, delta_theta)
  //
  var cc = getArcCenter(x1, y1, x2, y2, fa, fs, rx, ry, sin_phi, cos_phi);

  var result = <List<double>>[];
  var theta1 = cc[2];
  var delta_theta = cc[3];

  // Split an arc to multiple segments, so each segment
  // will be less than τ/4 (= 90°)
  //
  var segments = max(((delta_theta).abs() / (tau / 4)).ceil(), 1);
  delta_theta /= segments;

  for (var i = 0; i < segments; i++) {
    result.add(approximateUnitArc(theta1, delta_theta));
    theta1 += delta_theta;
  }

  // We have a bezier approximation of a unit circle,
  // now need to transform back to the original ellipse
  //
  return result.map((List<double> curve) {
    for (var i = 0; i < curve.length; i += 2) {
      var x = curve[i];
      var y = curve[i + 1];

      // scale
      x *= rx!;
      y *= ry!;

      // rotate
      var xp = cos_phi * x - sin_phi * y;
      var yp = sin_phi * x + cos_phi * y;

      // translate
      curve[i] = xp + cc[0];
      curve[i + 1] = yp + cc[1];
    }

    return curve;
  }).toList();
}
