import three;

import "../struct/quaternion.asy" as quaternion;

include "../config.asy";

Quaternion q1 = Quaternion(1, 1, 1, -1);
Quaternion q2 = Quaternion(1, -1, 1, 1);

// Для проверки равенства с учетом погрешности округления
// чисел с плавающей запятой
bool approx_equal(real a, real b, real tol=realEpsilon) {
  return abs(a-b) <= tol;
}

write("Тестируем сложение и вычитание кватернионов");

assert(
  +q1 == q1,
  "Ошибка в унарном плюсе"
);

assert(
  (q1 + q2) == Quaternion(2, 0, 2, 0),
  "Ошибка в сложении кватернионов"
);

assert(
  ((0, 0, 0) + q1 + (1, 1, 1)) == Quaternion(q1.w, 2, 2, 0),
  "Ошибка в сложении с вектором"
);

assert(
  (1 + q1 - 2) == Quaternion(0, 1, 1, -1),
  "Ошибка в сложении кватерниона с числами типа real"
);
assert(
  (1 + q1 + 2) == Quaternion(4, 1, 1, -1),
  "Ошибка в сложении кватерниона с числами типа real"
);

assert(
  (1 - q1 - 2) == Quaternion(-2, -1, -1, +1),
  "Ошибка в сложении кватерниона с числами типа real"
);

assert(
  -q1 == Quaternion(-1, -1, -1, +1),
  "Ошибка в унарном минусе"
);

assert(
  (q1 - q2) == Quaternion(0, 2, 0, -2),
  "Ошибка в вычитании кватернионов"
);

assert(
  (q2 - q1) == Quaternion(0, -2, 0, +2),
  "Ошибка в вычитании кватернионов"
);


write("Тестируем вычисление модулей кватернионов");

assert(abs2(q1) == 4, "Ошибка в вычислении квадрата модуля кватерниона");
assert( abs(q1) == 2, "Ошибка в вычислении  модуля кватерниона");


write("Тестируем вычисление скалярной и векторных частей");

assert(
  scalar(q1) == q1.w,
  "Ошибка в вычислении скалярной части"
);

assert(
  vec(q1) == (q1.x, q1.y, q1.z),
  "Ошибка в вычислении векторной части"
);


assert(
  dot(q1, q2) == q1.w*q2.w + dot(vec(q1), vec(q2)),
  "Скалярное произведение двух кватернионов"
);

assert(
  cross(Quaternion((1, 1, 1)), Quaternion((2, 1, 1))) == Quaternion(cross((1, 1, 1), (2, 1, 1))),
  "Векторное произведение двух кватернионов"
);

assert(
  approx_equal(q1*q2, Quaternion(2, 2, 2, 2)),
  "Ошибка в кватернионном умножении"
);

assert(
  approx_equal(q2*q1, Quaternion(2, -2, 2, -2)),
  "Ошибка в кватернионном умножение"
);

assert(
  2*q1 == Quaternion(2, 2, 2, -2),
  "Проверка умножения на число"
);

assert(
  q1*2 == Quaternion(2, 2, 2, -2),
  "Проверка умножения на число"
);

assert(
  (-1)*q1*(-1) == Quaternion(1, 1, 1, -1),
  "Проверка умножения на число"
);

assert(
  approx_equal(q1*(1, 1, 1), q1 * Quaternion((1, 1, 1))),
  "Ошибка в умножении кватерниона на чистый кватернион"
);

write("Тестируем деление на действительное число");

assert(
  approx_equal(q1 / 2, Quaternion(1/2, 1/2, 1/2, -1/2)),
  "Ошибка в делении кватерниона на действительное число"
);
assert(
  approx_equal(q2 / 2, Quaternion(1/2, -1/2, 1/2, 1/2)),
  "Ошибка в делении кватерниона на действительное число"
);

write("Тестируем выполнение ряда формул");

assert(
  scalar(q1 + conj(q1)) == 2q1.w,
  "Не выполняется формула q+q^* = 2q.w"
);
assert(
  vec(q1*q2 - q2*q1) == 2cross(vec(q1), vec(q2)),
  "Не выполняется формула q1*q2 - q2*q1 = 2q1xq2"
);

assert(
  approx_equal(abs2(q1 * inverse(q1)), 1),
  "Неправильно вычисляется обратный кватернион"
);

assert(
  (Quaternion)(1, 1, 1) == Quaternion(v=(1, 1, 1)),
  "Приведение вектора к кватерниону"
);

// Тестируем вращение
triple P = (1, 1, 1); // Вращаемая точка
real theta = 30; // Угол
triple a = (1, 0, 1); // Направляющий вектор оси вращения
// Вращающий кватернион
Quaternion RQ = unit_quaternion(theta=radians(theta/2), u=unit(a));
// Вращаемый кватернион
Quaternion Pq = Quaternion(0, P);

transform3 R = rotate(angle=theta, v=a);

assert(
  approx_equal(R*P, RQ*Pq*conj(RQ), tol=1e-15),
  "Тест на вращение не пройден!"
);