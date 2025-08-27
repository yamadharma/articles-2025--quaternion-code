struct Quaternion {
  real w, x, y, z;

  void operator init (real w, real x, real y, real z) {
    this.w = w; this.x = x; this.y = y; this.z = z;
  }

  void operator init (real w, triple v) {
    this.w = w; this.x = v.x; this.y = v.y; this.z = v.z;
  }

  void operator init (triple v) {
    this.w = 0; this.x = v.x; this.y = v.y; this.z = v.z;
  }

  void operator init (real w) {
    this.w = w; this.x = 0; this.y = 0; this.z = 0;
  }

  // Векторная часть
  autounravel triple vec(Quaternion q) {
    return (q.x, q.y, q.z);
  }
  // Скалярная часть
  autounravel real scalar(Quaternion q) {
    return q.w;
  }

  // Конвертация кватерниона в аффинную точку
  // кватернион интерпретируется как точечная масса
  autounravel triple operator cast (Quaternion q) {
    if (abs(q.w) < realEpsilon) {
      return vec(q);
    } else {
      return (vec(q) / q.w);
    }
  }

  // Конвертация вектора в чистый кватернион
  autounravel Quaternion operator cast (triple v) {
    return Quaternion(v);
  }


  // Сложения
  autounravel Quaternion operator + (Quaternion q, triple v) {
    return Quaternion(q.w, vec(q) + v);
  }

  autounravel Quaternion operator + (triple v, Quaternion q) {
    return Quaternion(q.w, vec(q) + v);
  }

  autounravel Quaternion operator + (Quaternion q, real a) {
    return Quaternion(q.w + a, vec(q));
  }

  autounravel Quaternion operator + (real a, Quaternion q) {
    return Quaternion(q.w + a, vec(q));
  }

  autounravel Quaternion operator + (Quaternion q1, Quaternion q2) {
    return Quaternion(q1.w+q2.w, vec(q1)+vec(q2));
  }

  autounravel Quaternion operator + (Quaternion q) {
    return Quaternion(q.w, vec(q));
  }

  // Разности
  autounravel Quaternion operator - (Quaternion q, triple v) {
    return Quaternion(q.w, vec(q) - v);
  }

  autounravel Quaternion operator - (triple v, Quaternion q) {
    return Quaternion(-q.w, v - vec(q));
  }

  autounravel Quaternion operator - (Quaternion q, real a) {
    return Quaternion(q.w - a, vec(q));
  }

  autounravel Quaternion operator - (real a, Quaternion q) {
    return Quaternion(a - q.w, -vec(q));
  }

  autounravel Quaternion operator - (Quaternion q1, Quaternion q2) {
    return Quaternion(q1.w-q2.w, vec(q1)-vec(q2));
  }
  
  autounravel Quaternion operator - (Quaternion q) {
    return Quaternion(-q.w, -vec(q));
  }

  // Произведения
  autounravel Quaternion operator * (real a, Quaternion q) {
    return Quaternion(a*q.w, a*vec(q));
  }

  autounravel Quaternion operator * (Quaternion q, real a) {
    return Quaternion(a*q.w, a*vec(q));
  }

  // Кватернионное произведение
  autounravel Quaternion operator * (Quaternion q1, Quaternion q2) {
    return Quaternion(
      q1.w*q2.w - dot(vec(q1), vec(q2)),
      q1.w*vec(q2) + q2.w*vec(q1) + cross(vec(q1), vec(q2))
    );
  }

  // Скалярное произведение кватернионов
  autounravel real dot(Quaternion q1, Quaternion q2) {
    return q1.w*q2.w + q1.x*q2.x + q1.y*q2.y + q1.z*q2.z;
  }

  // Векторное произведение кватернионов (определено только для чистых кватернионов)
  autounravel Quaternion cross(Quaternion q1, Quaternion q2) {
    assert(
      (abs(q1.w) <= realEpsilon) && (abs(q2.w) <= realEpsilon),
      "Quaternion cross product is only defined for pure quaternions!"
    );
    return Quaternion(cross(vec(q1), vec(q2)));
  }

  // Деление на действительное число
  autounravel Quaternion operator / (Quaternion q, real x) {
    return Quaternion(q.w/x, vec(q)/x);
  }

  // Проверка на равенство кватернионов
  autounravel bool operator == (Quaternion q1, Quaternion q2) {
    return (q1.w==q2.w) && (q1.x==q2.x) && (q1.y==q2.y) && (q1.z==q2.z);
  }

  // Проверка на равенство кватернионов с учетом некоторой погрешности tol
  autounravel bool approx_equal (Quaternion q1, Quaternion q2, real tol=realEpsilon){
    bool test = true;
    test = test && (abs(q1.w - q2.w) <= tol);
    test = test && (abs(q1.x - q2.x) <= tol);
    test = test && (abs(q1.y - q2.y) <= tol);
    test = test && (abs(q1.z - q2.z) <= tol);
    return test;
  }

  // Кватернионное сопряжение
  autounravel Quaternion conj(Quaternion q) {
    return Quaternion(q.w, -vec(q));
  }
  // Квадрат модуля кватерниона
  autounravel real abs2(Quaternion q) {
    return scalar(q * conj(q));
  }
  // Модуль кватерниона
  autounravel real abs(Quaternion q) {
    return sqrt(abs2(q));
  }
  // Обратный кватернион
  autounravel Quaternion inverse(Quaternion q) {
    return conj(q)/abs2(q);
  }

  // Деление справа
  autounravel Quaternion operator / (Quaternion q1, Quaternion q2) {
    return q1 * (conj(q2)/abs2(q2));
  }

  // Единичный кватернион
  autounravel Quaternion unit_quaternion(real theta, triple u) {
    return Quaternion(cos(theta), sin(theta)*unit(u));
  }

  autounravel void write(Quaternion q) {
    write(q.w, suffix=none);
    write(", ", vec(q));
  }
}