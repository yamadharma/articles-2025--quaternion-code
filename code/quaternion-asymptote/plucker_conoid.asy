include "../config.asy";

import three;
import graph3;
import "../struct/dual.asy" as dual;
import "../struct/quaternion.asy" as quaternion;
import "../struct/dualquaternion.asy" as dualquaternion;

/*
Коноид Плюккера может быть получен вращением горизонтальной прямой вокруг очи Oz
Одновременно прямая осуществляет гармонические колебательные движения вдоль оси Oz с амплитудой 1.
https://en.wikipedia.org/wiki/Plücker's_conoid
Фактически это последовательность мгновенных винтовых движений с ось Oz
*/

// Расположим прямую L вдоль оси Ox
triple v = X;
triple m = cross(O, v);
DualQuaternion L = screw(v, m);

// Точки лежащие на краях отрезка прямой L
// отрезок одной точкой лежит на оси винтового движения
DualQuaternion P1 = mass_point(1, +v);
DualQuaternion P2 = mass_point(1, O);

// Направляющий вектор и момент оси
DualQuaternion A = screw(Z, cross(O, Z));

// Массивы для хранения всех промежуточных прямых и точек
DualQuaternion[] line_positions;
triple[] point_positions01;
triple[] point_positions02;

real n = 2;
// Вычисления
for (real t : uniform(0, n*pi, 300)) {
  // Дуальный угол
  Dual Theta = Dual(t, sin(n*t));
  // Моторы винтового движения для прямой и точки
  ScrewMotion LS = LineSandwichFormula(Theta=Theta, A=A);
  ScrewMotion PS = PointSandwichFormula(Theta=Theta, A=A);

  line_positions.push(LS(L));
  point_positions01.push(vec(PS(P1).qo));
  point_positions02.push(vec(PS(P2).qo));
}

render = 10;
unitsize(3cm);

currentpicture.keepAspect=true;

// Рисуем образующие коноида
for (var l : line_positions) {
  triple P = cross(l.q, l.qo);
  draw(g=P -- P+vec(l.q), p=0.25bp+solid);
}

// Рисуем крайние точки геликоида
draw(graph(point_positions01), p=blue);
draw(graph(point_positions02), p=blue);


real arrow_size = 5;
xaxis3(
  pic=currentpicture, L=Label("$x$", position=EndPoint),
  axis=YZZero, xmin=-1.7, xmax=1.5, p=0.5bp+heavyred, ticks=NoTicks3,
  arrow=Arrow3(size=arrow_size), above=false
);
yaxis3(
  pic=currentpicture, L=Label("$y$", position=EndPoint),
  axis=YZZero, ymin=-1.7, ymax=1.5, p=0.5bp+deepgreen,
  ticks=NoTicks3, arrow=Arrow3(size=arrow_size), above=false
);
zaxis3(
  pic=currentpicture, L=Label("$z$", position=EndPoint),
  axis=YZZero, zmin=-1, zmax=1.5, p=0.5bp+heavyblue,
  ticks=NoTicks3, arrow=Arrow3(size=arrow_size), above=false
);