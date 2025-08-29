include "../config.asy";

import three;
import graph3;
import "../struct/dual.asy" as dual;
import "../struct/quaternion.asy" as quaternion;
import "../struct/dualquaternion.asy" as dualquaternion;

// Нарисуем картинку с более сложным поворотом прямой

// Зададим прямую
triple P = (0, -1/2, 0);
triple v = dir(colatitude=90, longitude=15);
triple m = cross(P, v);
DualQuaternion L = screw(v, m);

// Винт, задающий ось винтового движения Oz
DualQuaternion A = screw(Z, cross(O, Z));
// Дуальный угол
Dual Theta = Dual(radians(175), 1);

// Чистое вращение и чистая трансляция
ScrewMotion Rotation = LineSandwichFormula(Theta=Dual(real(Theta), 0), A=A);
ScrewMotion Translation = LineSandwichFormula(Theta=Dual(0, dual(Theta)), A=A);
ScrewMotion Motor = LineSandwichFormula(Theta=Theta, A=A);


DualQuaternion L1 = Rotation(L);
DualQuaternion L2 = Translation(L1);
DualQuaternion L2_alt = Motor(L);

// Точка прямой
triple P0 = cross(vec(L.q), vec(L.qo));
// Точка прямой после вращения
triple P10 = cross(vec(L1.q), vec(L1.qo)); 
// Точка прямой после вращения и трансляции
triple P20 = cross(vec(L2.q), vec(L2.qo)); 

// Сравниваем вектор v заданный встроенной в асимптот функцией и вручную
write("v = ", v);
write("v = ", (Sin(90)*Cos(15), Sin(90)*Sin(15), Cos(90)));
write("P0 = ", P0);
write("P10 = ", P10);
write("P20 = ", P20);
write("L = ", L);
write("L1 = ", L1);
write("L2 = ", L2);
write("L2_alt = ", L2_alt);

render = 10;
unitsize(3cm);
currentpicture.keepAspect=true;



// Рисуем прямую в начальном положении
draw(
  g=P0 - vec(L.q) -- P0 + vec(L.q),
  p=1bp+black,
  arrow=Arrow3(size=4),
  L=Label("$l$", position=Relative(0.90))
);
// После вращения
draw(
  g=P10 - vec(L1.q) -- P10 + vec(L1.q),
  p=1bp+black,
  arrow=Arrow3(size=4),
  L=Label("$l^{\prime}$", position=Relative(0.90))
);
// После трансляции (винтового движения)
draw(
  g=P20 - vec(L2.q) -- P20 + vec(L2.q),
  p=1bp+black,
  arrow=Arrow3(size=4),
  L=Label("$l^{\prime\prime}$", align=N, position=Relative(0.90))
);


dot(P, L=Label(s="$P$", align=N));
// Обозначим угол поворота
dot(P0, L=Label(s="$P_0$", align=SE));
dot(P10, L=Label(s="$P^\prime_0$", align=2E));

draw(O--P0, p=0.25+dashed);
draw(O--P10, p=0.25+dashed);

path3 theta_arc = Arc(c=O, v1=P0, v2=P10, direction=CCW);
draw(
  g=theta_arc,
  arrow=Arrow3(size=4, position=Relative(0.5)),
  p=0.25bp+solid,
  L=Label("$\theta$", align=SE, position=Relative(0.5))
);

// Обозначим направление и расстояние трансляции с помощью дуального угла
dot(P20, L=Label(s="$P^{\prime\prime}_0$", align=N));
draw(O--P20, p=0.25+dashed);
draw(
  g=P10--P20,
  arrow=Arrow3(size=4),
  p=0.25bp+solid,
  L=Label("$\theta^o$", align=W, position=Relative(0.5))
);

dot(O, L=Label("$O$", align=2S+W));

real arrow_size = 5;
xaxis3(
  pic=currentpicture, L=Label("$x$", position=EndPoint),
  axis=YZZero, xmin=-1.5, xmax=1.2, p=0.5bp+heavyred, ticks=NoTicks3,
  arrow=Arrow3(size=arrow_size), above=false
);
yaxis3(
  pic=currentpicture, L=Label("$y$", position=EndPoint),
  axis=YZZero, ymin=-1.2, ymax=1.0, p=0.5bp+deepgreen,
  ticks=NoTicks3, arrow=Arrow3(size=arrow_size), above=false
);
zaxis3(
  pic=currentpicture, L=Label("$z$", position=EndPoint),
  axis=YZZero, zmin=-0.5, zmax=1.2, p=0.5bp+heavyblue,
  ticks=NoTicks3, arrow=Arrow3(size=arrow_size), above=false
);