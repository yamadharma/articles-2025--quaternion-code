import "../struct/dual.asy" as dual;

Dual d1 = Dual(1, 1);
Dual d2 = Dual(2, 1);

assert(
  (d1 + d2) == Dual(3, 2),
  "Ошибка в операции сложении"
);

assert(
  (d1 - d2) == Dual(-1, 0),
  "Ошибка в операции вычитания"
);

assert(
  +d1 == d1,
  "Ошибка в унарном плюсе"
);

assert(
  -d1-d2 == Dual(-3, -2),
  "Ошибка в унарном минусе"
);

assert(
  (d1 * d2) == Dual(2, 3),
  "Ошибка в умножении дуальных чисел"
);

assert(
  (2d1) == Dual(2, 2),
  "Ошибка в умножении на число типа real"
);

assert(
  (d1 * 2) == Dual(2, 2),
  "Ошибка в умножении на число типа real"
);

assert(
  (d1 / d2) == Dual(0.5, 0.25),
  "Ошибка в делении дуальных чисел"
);

assert(
  (d2 / 2) == Dual(1, 0.5),
  "Ошибка в делении дуального числа на действительное число"
);

assert(
  (d1^3) == Dual(1, 3),
  "Ошибка в возведении в степень"
);

assert(
  (d1/d2 - d1 * d2^(-1)) == Dual(0, 0),
  "Ошибка в проверке, что деление == умножение на обратное число"
);

assert(
  conj(d1) == Dual(d1.a, -d1.b),
  "Ошибка в дуальном сопряжении"
);


assert(
  abs(real(sin(d1)/cos(d1) - tan(d1))) <= realEpsilon,
  "Ошибка в sin, cos или tan"
);

assert(
  abs(real((cos(d1))^2 + (sin(d1))^2) - 1) <= realEpsilon,
  "Не выполняется основное тригонометрическое тождество"
);

assert(
  abs(real(cos(Dual(pi, pi/2)) + 1)) <= realEpsilon,
  "Ошибка вычисления cos от дуального угла"
);

assert(
  abs(dual(sin(Dual(pi, pi/2)) + Dual(0, pi/2))) <= realEpsilon,
  "Ошибка вычисления sin от дуального угла"
);

assert(
  abs(dual(tan(Dual(pi, pi/2)) - Dual(0, pi/2))) <= realEpsilon,
  "Ошибка вычисления tan от дуального угла"
);

Dual test = sqrt(Dual(4, 4)) - Dual(2, 1);

assert(
  abs(real(test)) <= realEpsilon && abs(dual(test)) <= realEpsilon,
  "Ошибка в извлечении квадратного корня"
);


Dual[] L1 = {d1, d2, d1};
Dual[] L2 = {d2, d1, d1};
Dual s = dot(L1, L2);

assert(s == Dual(5, 8), "Ошибка в dot");

bool[] test = ((L1+L2) == new Dual[] {Dual(3, 2), Dual(3, 2), Dual(2, 2)});
for (bool tr : test) {
  assert(tr, "Ошибка в сложении массивов дуальных чисел");
}

bool[] test = ((L1*L2) == new Dual[] {Dual(2, 3), Dual(2, 3), Dual(1, 2)});
for (bool tr : test) {
  assert(tr, "Ошибка в умножении массивов дуальных чисел");
}

