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

(*** ��������� ������� (���������) ������ ����� ������� �������� ***)
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
  //���������� ������� ��� ������� ���������
  Clean;
end;


(*** ��������� ������ ����� � ������� ��� ������� ***)
procedure TForm1.bnSelectClick(Sender: TObject);
var
  I: Integer;
begin
  //��������� ���������� ���� ��� �������� �����
  OpenDialog1.Execute;

  //���� ���� ����������, ��������� ��� �������� � mmData
  if (FileExists(OpenDialog1.FileName)) then
  begin
    Clean;
    mmData.Lines.LoadFromFile(OpenDialog1.FileName);
  end;

  //�������� ���� ��������� ���������� �����
  //���� ��������� ���� ����������� ���������� �� ",",
  //�� ������ ������� �� ���� �����������
  if FormatSettings.DecimalSeparator <> ',' then
  for I := 0 to mmData.Lines.Count - 1 do
    mmData.Lines[I] := StringReplace(mmData.Lines[I], ',', FormatSettings.DecimalSeparator, []);
end;


(*** ��������� ������� �������� ������� ����-������
������������� ������ �������� ��������� �� ����� ��� ����������� ***)
procedure TForm1.bnCalcClick(Sender: TObject);
var
  data: array of Real; //���������� ��� ������� � �������
  I: Integer; //�������
  min, max, result: Real; //����������� � ������������ ��������
  min_ind, max_ind: Integer; //������� ������������ � ������������� ��������
begin
  //���������� ����� ������� �� ������ � mmData
  SetLength(data, mmData.Lines.Count);

  //�������� ������ �� mmData � ������ data ���������� �� �� String � Real
  //������� ���������� min � max �������� � �� �������
  //� �������� ���������� �������� ����� �������� � �������� 0 (����� ������)
  data[0] := StrToInt(mmData.Lines[0]);
  min := data[0];
  max := data[0];
  min_ind := 0;
  max_ind := 0;
  //������� �������� �� ������� �������� (������ 1)
  for I := 1 to mmData.Lines.Count - 1 do
  begin
    data[I] := StrToFloat(mmData.Lines[I]);
    //���������, �� ����� �� ��� ����� ����������� ���������
    if data[I] < min then
    begin
      min := data[I];
      min_ind := I;
    end;
    //���������, �� ����� �� ��� ����� ������������ ���������
    if data[I] > max then
    begin
      max := data[I];
      max_ind := I;
    end;
  end;

  //�������� ���������� ������� min � max � mmMinMax
  mmMinMax.Lines.Add('�������:');
  mmMinMax.Lines.Add('��������=' + FloatToStr(min));
  mmMinMax.Lines.Add('������=' + IntToStr(min_ind));
  mmMinMax.Lines.Add('');
  mmMinMax.Lines.Add('��������:');
  mmMinMax.Lines.Add('��������=' + FloatToStr(max));
  mmMinMax.Lines.Add('������=' + IntToStr(max_ind));

  //������� ������������� ����� ����� min � max � ��������� ��
  //������� ����������, ����� �� �������� ������
  if min_ind > max_ind then
  begin
    //���� ����������� ������ ������ �������������, �� ������ �� �������
    I := min_ind;
    min_ind := max_ind;
    max_ind := I;
  end;
  //� ����� ��������� ���������� � ������� ������������� ������ �� �����
  //������� �������� �� �������� � ������
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

  //������� ��������� ������ ��������� �� �����
  lbResult.Caption := FloatToStr(result);
end;


end.
