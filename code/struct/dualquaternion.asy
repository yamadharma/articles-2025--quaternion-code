import "../struct/dual.asy" as dual;
import "../struct/quaternion.asy" as quaternion;

struct DualQuaternion {
  Dual Q0, Q1, Q2, Q3;
  Quaternion q, qo;

  void operator init (Dual Q0, Dual Q1, Dual Q2, Dual Q3) {
    this.Q0 = Q0;
    this.Q1 = Q1;
    this.Q2 = Q2;
    this.Q3 = Q3;
    this.q = Quaternion(Q0.a, Q1.a, Q2.a, Q3.a);
    this.qo = Quaternion(Q0.b, Q1.b, Q2.b, Q3.b);
  }

  void operator init (Quaternion q, Quaternion qo) {
    this.Q0 = Dual(q.w, qo.w);
    this.Q1 = Dual(q.x, qo.x);
    this.Q2 = Dual(q.y, qo.y);
    this.Q3 = Dual(q.z, qo.z);
    this.q = q;
    this.qo = qo;
  }

  // Addition of dual quaternions
  autounravel DualQuaternion operator + (DualQuaternion Q, DualQuaternion P) {
    return DualQuaternion(Q.q+P.q, Q.qo+P.qo);
  }

  // Addition of dual quaternion and dual number
  autounravel DualQuaternion operator + (DualQuaternion Q, Dual d) {
    return DualQuaternion(Q.Q0 + d, Q.Q1, Q.Q2, Q.Q3);
  }
  autounravel DualQuaternion operator + (Dual d, DualQuaternion Q) {
    return DualQuaternion(Q.Q0 + d, Q.Q1, Q.Q2, Q.Q3);
  }

  // Unary subtraction
  autounravel DualQuaternion operator - (DualQuaternion Q) {
    return DualQuaternion(-Q.q, -Q.qo);
  }

  // Subtraction of dual quaternions
  autounravel DualQuaternion operator - (DualQuaternion Q, DualQuaternion P) {
    return DualQuaternion(Q.q-P.q, Q.qo-P.qo);
  }

  // Subtraction of dual quaternion and dual number
  autounravel DualQuaternion operator - (DualQuaternion Q, Dual d) {
    return DualQuaternion(Q.Q0 - d, Q.Q1, Q.Q2, Q.Q3);
  }
  autounravel DualQuaternion operator - (Dual d, DualQuaternion Q) {
    return DualQuaternion(d - Q.Q0, -Q.Q1, -Q.Q2, -Q.Q3);
  }

  // Multiplication of dual quaternion and real number
  autounravel DualQuaternion operator * (DualQuaternion Q, real a) {
    return DualQuaternion(a*Q.q, a*Q.qo);
  }
  autounravel DualQuaternion operator * (real a, DualQuaternion Q) {
    return DualQuaternion(a*Q.q, a*Q.qo);
  }

  // Multiplication of dual quaternion and dual number
  autounravel DualQuaternion operator * (DualQuaternion Q, Dual d) {
    return DualQuaternion(d.a*Q.q, (d.a*Q.qo +  d.b*Q.q));
  }
  autounravel DualQuaternion operator * (Dual d, DualQuaternion Q) {
    return DualQuaternion(d.a*Q.q, (d.a*Q.qo +  d.b*Q.q));
  }

  // Multiplication of two dual quaternions
  autounravel DualQuaternion operator * (DualQuaternion Q, DualQuaternion P) {
    return DualQuaternion(Q.q*P.q, Q.q*P.qo + Q.qo*P.q);
  }

  // Division of dual quaternion by a real number
  autounravel DualQuaternion operator / (DualQuaternion Q, real a) {
    return DualQuaternion(Q.q / a, Q.qo / a);
  }

  // Division of dual quaternion by a dual number
  autounravel DualQuaternion operator / (DualQuaternion Q, Dual d) {
    return Q*inv(d);
  }

  // Exact equality comparison
  autounravel bool operator == (DualQuaternion Q1, DualQuaternion Q2) {
    return (Q1.q==Q2.q) && (Q1.qo==Q2.qo);
  }

  // Approximate equality comparison
  autounravel bool approx_equal (
    DualQuaternion Q1, DualQuaternion Q2, real tol=realEpsilon) {
      return approx_equal(Q1.Q0, Q2.Q0, tol) && approx_equal(Q1.Q1, Q2.Q1, tol) && approx_equal(Q1.Q2, Q2.Q2, tol) && approx_equal(Q1.Q3, Q2.Q3, tol);
  }

  // Dual conjunction
  autounravel DualQuaternion dualconj(DualQuaternion Q) {
    return DualQuaternion(Q.q, -Q.qo);
  }

  // Complex (quaternion) conjunction
  autounravel DualQuaternion complexconj(DualQuaternion Q) {
    return DualQuaternion(conj(Q.q), conj(Q.qo));
  }

  // Complex and dual conjunction
  autounravel DualQuaternion conj(DualQuaternion Q) {
    return DualQuaternion(conj(Q.q), -conj(Q.qo));
  }

  // Square of absolute value (dual number)
  autounravel Dual abs2(DualQuaternion Q) {
    return Dual(abs2(Q.q), 2dot(Q.q, Q.qo));
  }

  // Dual quaternion invariant (dot product of vector and moment parts)
  autounravel real invariant(DualQuaternion Q) {
    return dot(Q.q, Q.qo);
  }

  // Dual quaternion parameter
  autounravel real parameter(DualQuaternion Q) {
    return dot(Q.q, Q.qo) / abs2(Q.q);
  }

  // Absolute value (dual number)
  autounravel Dual abs(DualQuaternion Q) {
    return Dual(abs(Q.q), invariant(Q)/abs(Q.q));
  }

  // Screw or motor
  autounravel DualQuaternion screw(triple v, triple m) {
    return DualQuaternion(Quaternion(v), Quaternion(m));
  }

  // Mass point
  autounravel DualQuaternion mass_point(real w, triple p) {
    return DualQuaternion(Quaternion(w), Quaternion(p));
  }

  // Plane in dual quaternion representation
  autounravel DualQuaternion dq_plane(triple n, real d) {
    return DualQuaternion(Quaternion(n), Quaternion(d));
  }

  // Dot product of dual quaternions
  autounravel Dual dot(DualQuaternion P, DualQuaternion Q) {
    return Dual(dot(P.q, Q.q), dot(P.qo, Q.q) + dot(P.q, Q.qo));
  }

  // Screw product of dual quaternions
  autounravel DualQuaternion cross(DualQuaternion P, DualQuaternion Q) {
    assert((P.Q0 == Dual(0, 0)) && (Q.Q0 == Dual(0, 0)), "Screw product is defined only for pure dual quaternions!");
    return DualQuaternion(cross(P.q, Q.q), cross(P.q, Q.qo) + cross(P.qo, Q.q));
  }

  autounravel void write(DualQuaternion Q) {
    write(Q.q);
    write(Q.qo);
  }

  autounravel void write(string s, DualQuaternion Q) {
    write(s);
    write(Q.q);
    write(Q.qo);
  }
}

// Screw motion formulas for dual quaternions

// Anonymous function, representing screw motion
using ScrewMotion = DualQuaternion(DualQuaternion);

ScrewMotion RodriguesHamilton(DualQuaternion A, Dual Theta) {
  Dual Lambda0 = cos(Theta/2);
  DualQuaternion Lambda = sin(Theta/2)*A;
  return new DualQuaternion(DualQuaternion L) {
    return L + 2Lambda0*cross(Lambda, L) + 2cross(Lambda, cross(Lambda, L));
  };
}

ScrewMotion LineSandwichFormula(DualQuaternion A, Dual Theta) {
  // Screw motion of the line, represented by dual quaternion
  DualQuaternion Lambda = cos(Theta/2) + sin(Theta/2)*A;
  return new DualQuaternion(DualQuaternion L) {
    return Lambda * L * complexconj(Lambda);
  };
}

ScrewMotion PointSandwichFormula(DualQuaternion A, Dual Theta) {
  // Screw motion of the point, represented by dual quaternion
  DualQuaternion Lambda = cos(Theta/2) + sin(Theta/2)*A;
  return new DualQuaternion(DualQuaternion P) {
    return Lambda * P * conj(Lambda);
  };
}

ScrewMotion PlaneSandwichFormula(DualQuaternion A, Dual Theta) {
  // Same as point screw motion
  return PointSandwichFormula(A, Theta);
}

// Алгоритм вычисления двух векторов, ортогональных данному
// Marschner, Shirley Fundamentals of Computer Graphics, стр 29
triple[] orthogonal_triple(triple n) {
    triple w;
    if ( n.x <= n.y && n.x <= n.z) {
      w = n + (1, 0, 0);
    }
    else if (n.y <= n.x && n.y <= n.z) {
      w = n + (0, 1, 0);
    }
    else {
      w = n + (0, 0, 1);
    }
    triple u = unit(cross(w, n));
    triple v = unit(cross(n, u));
    return new triple[] {v, u};
}