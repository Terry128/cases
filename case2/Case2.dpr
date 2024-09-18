program Case2;

{$APPTYPE CONSOLE}

uses
  SysUtils;

// ������� ����� "������������ ��������" (��)
type
  TVehicle = class
  private
    FSpeed: Integer;    // ��������� ���� - ��������
  public
    procedure Move; virtual;   // ���������� � �������� ��. ����������� ����� ��� ������������ ������������
    procedure Info;            // Public ����� ��� ���������� � ��
    procedure SetSpeed(ASpeed: Integer); // ����� ��������� ��������
    function GetSpeed: Integer;  // ����� ��������� ��������
  end;

// ����������� ����� "����������"
type
  TCar = class(TVehicle)
  private
    FBrand: string;    // ��������� ���� - ����� ����������
  public
    procedure Move; override;  // ���������� � �������� ����������. ��������������� ������ Move
    procedure Info;            // ����� � ����� �� ������, ��� � ������� ������ (�������������� ����� TVehicle.Info)
    procedure CallBaseInfo;    // ������������ ������ � �������� ������ Info ����� inherited
    procedure SetBrand(ABrand: string); // ��������� ����� ����������
    procedure ShowBrand;       // �������� ����� ����������
  end;

// ���������� ������� �������� ������ TVehicle

procedure TVehicle.Move;
begin
  WriteLn('������������ �������� �������� �� ��������� ', FSpeed, ' ��/�.');
end;

procedure TVehicle.Info;
begin
  WriteLn('��� ����� ������������ ��������.');
end;

procedure TVehicle.SetSpeed(ASpeed: Integer);
begin
  FSpeed := ASpeed;
end;

function TVehicle.GetSpeed: Integer;
begin
  Result := FSpeed;
end;

// ���������� ������� ������������ ������ TCar

procedure TCar.Move;
begin
  WriteLn('���������� �������� �� �������� ', GetSpeed, ' ��/�.');
end;

procedure TCar.Info;
begin
  WriteLn('��� ���������� ����� ', FBrand, '.');
end;

procedure TCar.CallBaseInfo;
begin
  inherited Info; // ����� ������ Info �������� ������ TVehicle
end;

procedure TCar.SetBrand(ABrand: string);
begin
  FBrand := ABrand;
end;

procedure TCar.ShowBrand;
begin
  WriteLn('����� ������: ', FBrand);
end;

var
  Vehicle: TVehicle;
  Car: TCar;

begin
  try
    // �������� ������� �������� ������ TVehicle
    Vehicle := TVehicle.Create;
    WriteLn('������������ ������ ������� �������� ������ "������������ ��������"');
    WriteLn('1. ������������� �������� 80 ��/� � ������� ������ SetSpeed');
    Vehicle.SetSpeed(80);  // ������������� ��������
    WriteLn('2. � ������� ������ Move ������������� ������ �������� ��:');
    Vehicle.Move;          // ������������� ������ ������ Move �������� ������
    WriteLn('3. � ������� ������ Info ������������� ���������� � ��:');
    Vehicle.Info;          // ������������� ������ ������ Info �������� ������
    WriteLn;

    // �������� ������� ������������ ������ TCar
    Car := TCar.Create;
    WriteLn('������������ ������ ������� ������������ ������ "����������"');
    WriteLn('1. ������������� �������� 120 ��/� � ������� ������ �������� ������ SetSpeed');
    Car.SetSpeed(120);     // ��������� �������� ����� ����� �������� ������
    WriteLn('2. � ������� ����������˨����� ������ Move ������������� ������ �������� �/�:');
    Car.Move;              // ����� ���������������� ������ Move �� TCar
    WriteLn('3. � ������� ������������ ������ SetBrand ������������� ����� ����������');
    Car.SetBrand('Toyota'); // ��������� ����� ����������
    WriteLn('4. � ������� ������������ ������ ShowBrand ���������� ����� ����������:');
    Car.ShowBrand;         // �������� ����� ����������
    WriteLn('5. � ������� ������������ ������ Info ������������� ���������� �� ����������:');
    Car.Info;              // ����� ������ Info �� TCar (�������� ����� �������� ������)
    WriteLn;
    WriteLn('6. �������� ������� ����� Info ����� ����������� �����:');
    Car.CallBaseInfo;      // ����� �������� ������ Info ����� ����������� �����
  finally
    Vehicle.Free;
    Car.Free;
  end;

  ReadLn;  //��������� ���� ������� ��������

end.

