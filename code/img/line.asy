include "../config.asy";

import three;
import graph3;
import "../struct/dual.asy" as dual;
import "../struct/quaternion.asy" as quaternion;
import "../struct/dualquaternion.asy" as dualquaternion;

// Направляющий вектор и момент прямой
triple v = unit(X+Y);
triple m = cross(O, v);
DualQuaternion L = screw(v, m);

// Винт, задающий ось винтового движения
DualQuaternion A = screw(Z, cross(O, Z));
// Дуальный угол
Dual Theta = Dual(pi/4, 1);

// Мотор винтового движения для прямой
ScrewMotion LS = LineSandwichFormula(Theta=Theta, A=A);

DualQuaternion L_new = LS(L);

write(L_new);

render = 10;
unitsize(3cm);
// currentprojection=obliqueX;
currentpicture.keepAspect=true;

// Точка прямой
triple P0 = cross(vec(L.q), vec(L.qo)); 
triple P0_new = cross(vec(L_new.q), vec(L_new.qo)); 
write("P_0 = ", P0);
write("P_0_new = ", P0_new);

// Рисуем прямую в начальном положении и после винтового движения
draw(
  g=P0 - 1.5vec(L.q) -- P0 + 1.5vec(L.q),
  p=1bp+black,
  L=Label("$l$", align=W, position=Relative(0.90))
);
draw(
  g=P0_new - 1.5vec(L_new.q) -- P0_new + 1.2vec(L_new.q),
  p=1bp+black,
  L=Label("$l^{\prime}$", align=N, position=Relative(0.90))
);

// Обозначим угол поворота
path3 theta_arc = Arc(c=O, v1=vec(L.q), v2=vec(L_new.q), direction=CCW);
draw(
  g=theta_arc,
  arrow=Arrow3(size=4),
  p=0.5bp+dashed,
  L=Label("$\theta = \frac{\pi}{4}$", align=SE, position=Relative(0.45))
);
// Обозначим направление и расстояние трансляции с помощью дуального угла
draw(
  g=vec(L_new.q)--vec(L_new.q)+dual(Theta)*vec(A.q),
  arrow=Arrow3(size=4),
  p=0.5bp+dashed,
  L=Label("$\theta^o = 1$", align=W, position=Relative(0.3))
);

dot(O, L=Label("$O$", align=2S+W));
dot(Z, L=Label("$P_0 = (0, 0, 1)$", align=NE));

real arrow_size = 5;
xaxis3(
  pic=currentpicture, L=Label("$x$", position=EndPoint),
  axis=YZZero, xmin=-1.5, xmax=1.2, p=0.5bp+heavyred, ticks=NoTicks3,
  arrow=Arrow3(size=arrow_size), above=false
);
yaxis3(
  pic=currentpicture, L=Label("$y$", position=EndPoint),
  axis=YZZero, ymin=-1.5, ymax=1.2, p=0.5bp+deepgreen,
  ticks=NoTicks3, arrow=Arrow3(size=arrow_size), above=false
);
zaxis3(
  pic=currentpicture, L=Label("$z$", position=EndPoint),
  axis=YZZero, zmin=-0.2, zmax=1.5, p=0.5bp+heavyblue,
  ticks=NoTicks3, arrow=Arrow3(size=arrow_size), above=false
);