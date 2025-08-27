include "../config.asy";

import three;
import graph3;
import "../struct/dual.asy" as dual;
import "../struct/quaternion.asy" as quaternion;
import "../struct/dualquaternion.asy" as dualquaternion;

// Направляющий вектор и момент прямой
triple v = X;
triple m = cross(O, v);
DualQuaternion L = screw(v, m);
// Точки лежащие на краях отрезка прямой L
DualQuaternion P1 = mass_point(1, +X);
DualQuaternion P2 = mass_point(1, -X);

// Винт, задающий ось винтового движения
DualQuaternion A = screw(Z, cross(O, Z));
// Дуальный угол
Dual Theta = Dual(pi/40, pi/80);

// Моторы винтового движения для прямой и точки
ScrewMotion LS = LineSandwichFormula(Theta=Theta, A=A);
ScrewMotion PS = PointSandwichFormula(Theta=Theta, A=A);

// Массивы для хранения всех промежуточных прямых и точек
DualQuaternion[] line_positions;
triple[] point_positions01;
triple[] point_positions02;

// Вычисления
for (int i=0; i<=100; ++i) {
  line_positions.push(L);
  point_positions01.push(vec(P1.qo));
  point_positions02.push(vec(P2.qo));
  L = LS(L);
  P1 = PS(P1);
  P2 = PS(P2);
}

render = 10;
unitsize(1cm);
// currentprojection=obliqueX;
currentpicture.keepAspect=true;

// Рисуем прямые геликоида
for (var l : line_positions) {
  triple P = cross(l.q, l.qo);
  draw(g=P-vec(l.q) -- P+vec(l.q), p=0.25bp+solid);
}

// Рисуем крайние точки геликоида
draw(graph(point_positions01), p=blue);
draw(graph(point_positions02), p=blue);

real arrow_size = 5;
xaxis3(
  pic=currentpicture, L=Label("$x$", position=EndPoint),
  axis=YZZero, xmin=-2, xmax=2, p=0.5bp+heavyred, ticks=NoTicks3,
  arrow=Arrow3(size=arrow_size), above=false
);
yaxis3(
  pic=currentpicture, L=Label("$y$", position=EndPoint),
  axis=YZZero, ymin=-2, ymax=2, p=0.5bp+deepgreen,
  ticks=NoTicks3, arrow=Arrow3(size=arrow_size), above=false
);
zaxis3(
  pic=currentpicture, L=Label("$z$", position=EndPoint),
  axis=YZZero, zmin=-0.2, zmax=5, p=0.5bp+heavyblue,
  ticks=NoTicks3, arrow=Arrow3(size=arrow_size), above=false
);