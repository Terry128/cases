program Case2;

{$APPTYPE CONSOLE}

uses
  SysUtils;

// Базовый класс "Транспортное средство" (ТС)
type
  TVehicle = class
  private
    FSpeed: Integer;    // Приватное поле - скорость
  public
    procedure Move; virtual;   // Информация о движении ТС. Виртуальный метод для демонстрации полиморфизма
    procedure Info;            // Public метод для информации о ТС
    procedure SetSpeed(ASpeed: Integer); // Метод установки скорости
    function GetSpeed: Integer;  // Метод получения скорости
  end;

// Производный класс "Автомобиль"
type
  TCar = class(TVehicle)
  private
    FBrand: string;    // Приватное поле - марка автомобиля
  public
    procedure Move; override;  // Информация о движении автомобиля. Переопределение метода Move
    procedure Info;            // Метод с таким же именем, как в базовом классе (переопределяет метод TVehicle.Info)
    procedure CallBaseInfo;    // Обеспечиваем доступ к базовому методу Info через inherited
    procedure SetBrand(ABrand: string); // Установка марки автомобиля
    procedure ShowBrand;       // Показать марку автомобиля
  end;

// Реализация методов базового класса TVehicle

procedure TVehicle.Move;
begin
  WriteLn('Транспортное средство движется со скоростью ', FSpeed, ' км/ч.');
end;

procedure TVehicle.Info;
begin
  WriteLn('Это некое транспортное средство.');
end;

procedure TVehicle.SetSpeed(ASpeed: Integer);
begin
  FSpeed := ASpeed;
end;

function TVehicle.GetSpeed: Integer;
begin
  Result := FSpeed;
end;

// Реализация методов производного класса TCar

procedure TCar.Move;
begin
  WriteLn('Автомобиль движется со скорость ', GetSpeed, ' км/ч.');
end;

procedure TCar.Info;
begin
  WriteLn('Это автомобиль марки ', FBrand, '.');
end;

procedure TCar.CallBaseInfo;
begin
  inherited Info; // Вызов метода Info базового класса TVehicle
end;

procedure TCar.SetBrand(ABrand: string);
begin
  FBrand := ABrand;
end;

procedure TCar.ShowBrand;
begin
  WriteLn('Марка машины: ', FBrand);
end;

var
  Vehicle: TVehicle;
  Car: TCar;

begin
  try
    // Создание объекта базового класса TVehicle
    Vehicle := TVehicle.Create;
    WriteLn('Демонстрация работы методов базового класса "Транспортное средство"');
    WriteLn('1. Устанавливаем скорость 80 км/ч с помощью метода SetSpeed');
    Vehicle.SetSpeed(80);  // Устанавливаем скорость
    WriteLn('2. С помощью метода Move демонстрируем статус движения ТС:');
    Vehicle.Move;          // Демонстрируем работу метода Move базового класса
    WriteLn('3. С помощью метода Info демонстрируем информацию о ТС:');
    Vehicle.Info;          // Демонстрируем работу метода Info базового класса
    WriteLn;

    // Создание объекта производного класса TCar
    Car := TCar.Create;
    WriteLn('Демонстрация работы методов производного класса "Автомобиль"');
    WriteLn('1. Устанавливаем скорость 120 км/ч с помощью метода БАЗОВОГО класса SetSpeed');
    Car.SetSpeed(120);     // Установка скорости через метод базового класса
    WriteLn('2. С помощью ПЕРЕОПРЕДЕЛЁННОГО метода Move демонстрируем статус движения а/м:');
    Car.Move;              // Вызов переопределённого метода Move из TCar
    WriteLn('3. С помощью собственного метода SetBrand устанавливаем марку автомобиля');
    Car.SetBrand('Toyota'); // Установка марки автомобиля
    WriteLn('4. С помощью собственного метода ShowBrand показываем марку автомобиля:');
    Car.ShowBrand;         // Показать марку автомобиля
    WriteLn('5. С помощью собственного метода Info демонстрируем информацию об автомобиле:');
    Car.Info;              // Вызов метода Info из TCar (скрывает метод базового класса)
    WriteLn;
    WriteLn('6. Вызоваем БАЗОВЫЙ метод Info через производный класс:');
    Car.CallBaseInfo;      // Вызов базового метода Info через производный класс
  finally
    Vehicle.Free;
    Car.Free;
  end;

  ReadLn;  //Оставляем окно консоли открытым

end.

