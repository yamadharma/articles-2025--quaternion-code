import three;

import "../struct/dualquaternion.asy" as dualquaternion;

Quaternion q1 = Quaternion(1, 1, 1, -1);
Quaternion q2 = Quaternion(1, -1, 1, 1);

DualQuaternion Q1 = DualQuaternion(q1, q2);
DualQuaternion Q2 = DualQuaternion(q2, q1);

assert(
  Q1 + Q2 == DualQuaternion(q1+q2, q2+q1),
  "Addition test"
);

assert(
  Q1 + Dual(1, 2) == DualQuaternion(q1 + 1, q2 + 2),
  "Addition of dual number test"
);

assert(
  Q1 - Dual(1, 2) == DualQuaternion(q1 - 1, q2 - 2),
  "Subtraction of dual number test"
);

assert(
  Q1 - Q2 == DualQuaternion(q1-q2, q2-q1),
  "Subtraction test"
);

assert(
  approx_equal(conj(Q1 * Q2), conj(Q2)*conj(Q1)),
  "Conjunction test"
);


assert(
  approx_equal(Q1/Dual(2, 1), DualQuaternion(0.5Q1.q, 0.5Q1.qo - 0.25Q1.q)),
  "Dual number and dual quaternion multiplication test"
);

assert(
  approx_equal(Q1*Q2, DualQuaternion(q1*q2, q1*q1 + q2*q2)),
  "Dual quaternions multiplication test"
);

assert(
  approx_equal(Q2*Q1, DualQuaternion(q2*q1, q1*q1 + q2*q2)),
  "Dual quaternions multiplication test"
);

assert(
  approx_equal(abs2(Q1), Dual(abs2(q1), 2dot(q1, q2))),
  "Square of absolute value test"
);

assert(
  approx_equal(invariant(Q1), dot(q1, q2)),
  "Dual quaternion invariant test"
);

assert(
  approx_equal(parameter(Q1), dot(q1, q2)/abs2(q1)),
  "Dual quaternion parameter test"
);


// Винтовое движение прямой вокруг оси Oz
Dual Theta = Dual(pi/4, 1);
triple v = unit((1, 1, 0));
triple a = Z;
triple ao = O;
DualQuaternion L = screw(v, O); // Винт, который задает прямую
DualQuaternion A = screw(a, ao); // Винт — ось винтового движения

// Rodrigues--Hamilton screw formula
ScrewMotion RH_screw = RodriguesHamilton(Theta=Theta, A=A);
// Sandwich screw formula for line
ScrewMotion LS_screw = LineSandwichFormula(Theta=Theta, A=A);

assert(
  approx_equal(RH_screw(L), LS_screw(L)),
  "Dual Quaternions screw motion test"
);


// Винтовое движение точки вокруг оси Oz
DualQuaternion P = DualQuaternion(Quaternion(1), Quaternion(v));
ScrewMotion PS_screw = PointSandwichFormula(Theta=Theta, A=A);
write(PS_screw(P));


// Винтовое движение плоскости вокруг оси Oz
DualQuaternion OZY_plane = DualQuaternion(Quaternion(Z), Quaternion(0));
ScrewMotion PS_screw = PlaneSandwichFormula(Theta=Theta, A=A);
write(PS_screw(OZY_plane));

