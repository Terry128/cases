unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    bnSelect: TButton;
    mmData: TMemo;
    lbSource: TLabel;
    Panel2: TPanel;
    bnCalc: TButton;
    mmMinMax: TMemo;
    mmBetween: TMemo;
    Label2: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    mmNegative: TMemo;
    lbResult: TLabel;
    lbResultCaption: TLabel;
    OpenDialog1: TOpenDialog;
    procedure bnCalcClick(Sender: TObject);
    procedure bnSelectClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure Clean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

(*** Процедура очистки (обнуления) данных перед началом расчетов ***)
procedure TForm1.Clean;
begin
  lbResult.caption := '';
  mmData.Lines.Clear;
  mmMinMax.Lines.Clear;
  mmBetween.Lines.Clear;
  mmNegative.Lines.Clear;
  OpenDialog1.InitialDir := '';
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  //Производим очистку при запуске программы
  Clean;
end;


(*** Процедура выбора файла с данными для расчета ***)
procedure TForm1.bnSelectClick(Sender: TObject);
var
  I: Integer;
begin
  //Открываем диалоговое окно для открытия файла
  OpenDialog1.Execute;

  //Если файл существует, загружаем его значения в mmData
  if (FileExists(OpenDialog1.FileName)) then
  begin
    Clean;
    mmData.Lines.LoadFromFile(OpenDialog1.FileName);
  end;

  //Проверям знак отделения десятичной части
  //Если системный знак разделителя отличается от ",",
  //то меняем запятую на этот разделитель
  if FormatSettings.DecimalSeparator <> ',' then
  for I := 0 to mmData.Lines.Count - 1 do
    mmData.Lines[I] := StringReplace(mmData.Lines[I], ',', FormatSettings.DecimalSeparator, []);
end;


(*** Процедура расчета согласно условий кейс-задачи
Промежуточные данные расчетов выводятся на экран для наглядности ***)
procedure TForm1.bnCalcClick(Sender: TObject);
var
  data: array of Real; //Переменная для массива с данными
  I: Integer; //Счётчик
  min, max, result: Real; //минимальное и максимальное значения
  min_ind, max_ind: Integer; //Индексы минимального и максимального значений
begin
  //Определяем длину массива по данным в mmData
  SetLength(data, mmData.Lines.Count);

  //Передаем данные из mmData в массив data преобразуя их из String в Real
  //Попутно определяем min и max значения и их индексы
  //В качестве начального значения берем значение с индексом 0 (самое первое)
  data[0] := StrToInt(mmData.Lines[0]);
  min := data[0];
  max := data[0];
  min_ind := 0;
  max_ind := 0;
  //Перебор начинаем со второго значения (индекс 1)
  for I := 1 to mmData.Lines.Count - 1 do
  begin
    data[I] := StrToFloat(mmData.Lines[I]);
    //Проверяем, не будет ли это новым минимальным значением
    if data[I] < min then
    begin
      min := data[I];
      min_ind := I;
    end;
    //Проверяем, не будет ли это новым максимальным значением
    if data[I] > max then
    begin
      max := data[I];
      max_ind := I;
    end;
  end;

  //Отражаем результаты расчета min и max в mmMinMax
  mmMinMax.Lines.Add('Минимум:');
  mmMinMax.Lines.Add('Значение=' + FloatToStr(min));
  mmMinMax.Lines.Add('Индекс=' + IntToStr(min_ind));
  mmMinMax.Lines.Add('');
  mmMinMax.Lines.Add('Максимум:');
  mmMinMax.Lines.Add('Значение=' + FloatToStr(max));
  mmMinMax.Lines.Add('Индекс=' + IntToStr(max_ind));

  //Находим отрицательные числа между min и max и суммируем их
  //Сначала определяем, какой из индексов меньше
  if min_ind > max_ind then
  begin
    //Если минимальный индекс больше максимального, то меняем их местами
    I := min_ind;
    min_ind := max_ind;
    max_ind := I;
  end;
  //В цикле выполняем вычисления и выводим промежуточные данные на экран
  //Крайние значения не включаем в расчет
  result := 0;
  for i := min_ind + 1 to max_ind - 1 do
  begin
    mmBetween.Lines.Add(FloatToStr(data[I]));
    if data[I] < 0 then
    begin
      result := result + data[I];
      mmNegative.Lines.Add(FloatToStr(data[I]));
    end;
  end;

  //Выводим результат работы программы на экран
  lbResult.Caption := FloatToStr(result);
end;


end.
