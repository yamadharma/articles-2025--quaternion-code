struct Dual {
  real a; // Действительная часть
  real b; // Дуальная часть
  real p; // Параметр дуального числа

  void operator init(real a, real b) {
    this.a = a;
    this.b = b;
    if (abs(this.a)<=realEpsilon) {
      this.p = inf;
    } else {
      this.p = this.b / this.a;
    }
  }

  autounravel real real(Dual d) {
    return d.a;
  }

  autounravel real dual(Dual d) {
    return d.b;
  }

  // Приведение типов
  autounravel Dual operator cast (real x) {
    return Dual(x, 0);
  }

  // Сложение
  autounravel Dual operator + (Dual z1, Dual z2) {
    return Dual(z1.a+z2.a, z1.b+z2.b);
  }

  autounravel Dual operator + (Dual z, real a) {
    return Dual(z.a + a, z.b);
  }

  autounravel Dual operator + (real a, Dual z) {
    return Dual(z.a + a, z.b);
  }

  autounravel Dual operator + (Dual z) {
    return Dual(z.a, z.b);
  }

  // Вычитание
  autounravel Dual operator - (Dual z1, Dual z2) {
    return Dual(z1.a-z2.a, z1.b-z2.b);
  }

  autounravel Dual operator - (Dual z, real a) {
    return Dual(z.a - a, z.b);
  }

  autounravel Dual operator - (real a, Dual z) {
    return Dual(a - z.a, -z.b);
  }

  autounravel Dual operator - (Dual z) {
    return Dual(-z.a, -z.b);
  }

  // Умножение
  autounravel Dual operator * (Dual z1, Dual z2) {
    return Dual(z1.a*z2.a, (z1.a * z2.b + z1.b * z2.a));
  }

  autounravel Dual operator * (Dual z, real x) {
    return Dual(z.a*x, z.b*x);
  }

  autounravel Dual operator * (real x, Dual z) {
    return Dual(z.a*x, z.b*x);
  }

  // Возведение в целую степень
  autounravel Dual operator ^ (Dual z, int n) {
    return Dual(z.a^n, n*z.b*z.a^(n-1));
  }

  // Деление
  autounravel Dual operator / (Dual z1, Dual z2) {
    return Dual(z1.a/z2.a, (z1.b * z2.a - z1.a * z2.b) / z2.a^2);
  }

  autounravel Dual operator / (Dual z, real x) {
    return Dual(z.a/x, z.b/x);
  }

  autounravel Dual operator ^ (Dual z, real x) {
    return Dual(z.a^x, x*z.b*z.a^(x-1));
  }

  // Извлечение квадратного корня
  autounravel Dual sqrt(Dual z) {
    return Dual(sqrt(z.a), z.b/(2sqrt(z.a)));
  }

  // Сравнение на равенство
  autounravel bool operator == (Dual z1, Dual z2) {
    return (z1.a==z2.a) && (z1.b == z2.b);
  }

  // Сравнение на равенство с учетом погрешностей
  autounravel bool approx_equal(Dual z1, Dual z2, real tol=realEpsilon) {
    return ((abs(z1.a-z2.a)<=tol) && (abs(z1.b-z2.b)<=tol));
  }

  autounravel real abs(Dual z) {
    return abs(z.a);
  }

  autounravel Dual conj(Dual z) {
    return Dual(z.a, -z.b);
  }

  autounravel Dual unit(Dual z) {
    return Dual(1, z.p);
  }

  // Обратное по умножению
  autounravel Dual inv(Dual z) {
    return Dual(1/z.a, -z.b/(z.a*z.a));
  }

  // Элементарные функции
  autounravel Dual exp(Dual z) {
    return Dual(exp(z.a), z.b*exp(z.a));
  }

  autounravel Dual sin(Dual z) {
    return Dual(sin(z.a), z.b*cos(z.a));
  }

  autounravel Dual cos(Dual z) {
    return Dual(cos(z.a), -z.b*sin(z.a));
  }

  autounravel Dual tan(Dual z) {
    return Dual(tan(z.a), z.b/(cos(z.a)^2));
  }

  autounravel Dual asin(Dual z) {
    return Dual(asin(z.a), z.b/sqrt(1-z.a*z.a));
  }

  autounravel Dual acos(Dual z) {
    return Dual(acos(z.a), -z.b/sqrt(1-z.a*z.a));
  }

  autounravel Dual atan(Dual z) {
    return Dual(atan(z.a), z.b/(1+z.a*z.a));
  }

  // Операции с массивами
  autounravel Dual[] operator + (Dual[] z1, Dual[] z2) {
    Dual[] res;
    assert(z1.length == z2.length, "z1.length /= z2.length");
    for (int i=0; i<z1.length; ++i) {
      res.push(z1[i] + z2[i]);
    }
    return res;
  }

  autounravel Dual[] operator - (Dual[] z1, Dual[] z2) {
    Dual[] res;
    assert(z1.length == z2.length, "z1.length /= z2.length");
    for (int i=0; i<z1.length; ++i) {
      res.push(z1[i] - z2[i]);
    }
    return res;
  }

  autounravel Dual[] operator * (Dual[] z1, Dual[] z2) {
    Dual[] res;
    assert(z1.length == z2.length, "z1.length /= z2.length");
    for (int i=0; i<z1.length; ++i) {
      res.push(z1[i] * z2[i]);
    }
    return res;
  }

  autounravel bool[] operator == (Dual[] z1, Dual[] z2) {
    bool[] res;
    assert(z1.length == z2.length, "z1.length /= z2.length");
    for (int i=0; i<z1.length; ++i) {
      res.push(z1[i] == z2[i]);
    }
    return res;
  }

  autounravel Dual sum(Dual[] Z) {
    Dual res = Dual(0, 0);
    for (var z : Z) {
      res += z;
    }
    return res;
  }

  autounravel Dual dot(Dual[] z1, Dual[] z2) {
    Dual res = Dual(0, 0);
    assert(z1.length == z2.length, "z1.length /= z2.length");
    for (int i=0; i<z1.length; ++i) {
      res += z1[i] * z2[i];
    }
    return res;
  }

  autounravel Dual[] cross(Dual[] z1, Dual[] z2) {
    Dual res = Dual(0, 0);
    assert(z1.length == z2.length, "z1.length /= z2.length");
    assert(z1.length == 3, "z1.length /= 3");
    return new Dual[] {
      z1[1]*z2[2] - z2[1]*z1[2],
      z1[2]*z2[0] - z2[2]*z1[0],
      z1[0]*z2[1] - z2[0]*z1[1]
    };
  }

  // Распечатка значений
  autounravel void write(Dual z) {
    write((z.a, z.b));
  }

  autounravel void write(Dual[] Z) {
    for (var z : Z) {
      write(z);  
    }
  }
}