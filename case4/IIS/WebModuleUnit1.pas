unit WebModuleUnit1;

interface

uses System.SysUtils, System.Classes, Web.HTTPApp, FireDAC.Comp.Client,
  FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.DApt, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, Data.DB, FireDAC.Comp.DataSet,
  System.IOUtils, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, IniFiles, Vcl.Dialogs;

type
  TWebModule1 = class(TWebModule)
    FDConnection: TFDConnection;
    FDQuery: TFDQuery;
    FDQueryTemp: TFDQuery;
    procedure WebModule1DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  private
    { Private declarations }
    procedure DBSetParams;
    function Login(UserLogin, Password: string): Integer;
    function LoadHTMLTemplate: string;
    function GetDataTable: string;
    function GetHTMLPage(Session_ID: Integer;
                         Title, TableContent, ErrMess: string): string;
  public
    { Public declarations }
  end;

var
  WebModuleClass: TComponentClass = TWebModule1;
  OperType: string;
  Session_ID: Integer;
  HostName, Port, WEBApp, WEBAppURL: string;
  TemplatesDir: string;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure LoadServerSettings;
var
  Ini: TIniFile;
  IniFilePath: string;
begin
  // ���� � INI-����� ����� � DLL
  IniFilePath := ExtractFilePath(ParamStr(0)) + 'config.ini';

  Ini := TIniFile.Create(IniFilePath);
  try
    HostName := Ini.ReadString('Server', 'HostName', 'http://localhost');
    Port := Ini.ReadString('Server', 'Port', '80');
    WEBApp := Ini.ReadString('Server', 'WEBApp', '/Cabinet/Cabinet.dll');
    WEBAppURL := Ini.ReadString('Server', 'WEBAppURL', 'http://localhost/Cabinet/Cabinet.dll');;
    TemplatesDir := Ini.ReadString('Server', 'TemplatesDir', 'c:\inetpub\wwwroot\cabinet\templates\');
  finally
    Ini.Free;
  end;
end;


procedure TWebModule1.WebModule1DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  Table, Title, ErrMess: string;
  UserLogin, Password: string;
begin
  //�������� �������� �������
  LoadServerSettings;
  // ������ ���������� �������
  UserLogin := Request.ContentFields.Values['username'];
  Password := Request.ContentFields.Values['password'];
  if Request.QueryFields.Values['session_id'] > '' then
    Session_ID := StrToInt(Request.QueryFields.Values['session_id'])
  else
    Session_ID := 0;

  OperType := Request.PathInfo;
  OperType := StringReplace(OperType, WEBApp, '', [rfReplaceAll, rfIgnoreCase]);
  //Session_ID := 1001;

  if (OperType = '/auth') or (OperType = '/') or (OperType = '') then
  begin
    OperType := '/auth';
    Title := '�����������';
    ErrMess := '';
  end
  else if OperType = '/login' then
  begin
    if UserLogin > '' then
      Session_ID := Login(UserLogin, Password)
    else Session_ID := 0;
    //ShowMessage('=' + IntToStr(Session_ID) + '=');
    if Session_ID > 0 then
    begin
      // ��������� �������� �� ������ URL
      Response.SendRedirect(WEBAppURL + '/abon_info?session_id='+IntToStr(Session_ID));

      // ��������� ���������
      Handled := True;
    end
    else
    begin
      OperType := '/auth';
      Title := '�����������';
      ErrMess := '������ �����������! ��������� ��������� ������!';
    end;
  end
  else if OperType = '/schetchik' then
  begin
    Title := '��������';
    Table := GetDataTable;
  end
  else if OperType = '/tariff' then
  begin
    Title := '������';
    Table := GetDataTable;
  end
  else if OperType = '/control' then
  begin
    Title := '����������� ������ ���������';
    Table := GetDataTable;
  end
  else if OperType = '/calc' then
  begin
    Title := '������ ��������� ��������������';
    Table := GetDataTable;
  end
  else if OperType = '/pays' then
  begin
    Title := '����������� ������';
    Table := GetDataTable;
  end
  else if OperType = '/abon_info' then
  begin
    Title := '���������� �� ��������';
    Table := GetDataTable;
  end
  else
  begin
    // ���� URL �� ���������, ���������� ������ 404
    Response.StatusCode := 404;
    Response.Content := '<html><body><h1>404 - Page Not Found OperType='
                        + OperType + '='
                        + Request.PathInfo + '</h1></body></html>';
    Response.ContentType := 'text/html; charset=UTF-8';  // ������������� ��������� UTF-8
    Exit;
  end;

  // ��������� HTML-�����
  Response.Content := GetHTMLPage(Session_ID, Title, Table, ErrMess);
  Response.ContentType := 'text/html';
  Response.ContentType := 'text/html; charset=UTF-8';  // ������������� ��������� UTF-8
end;

//����������� ����������� � ���� ������
procedure TWebModule1.DBSetParams;
begin
  // ������������� ��������� ����������� � MySQL
  FDConnection.DriverName := 'MySQL';
  FDConnection.Params.Database := 'energo';    // ��� ���� ������
  FDConnection.Params.UserName := 'test_user'; // ��� ������������
  FDConnection.Params.Password := 'Test,123';  // ������ ������������
  FDConnection.Params.Add('Server=localhost'); // ����� ������� (localhost ��� IP-�����)
  FDConnection.Params.Add('Port=3306');        // ���� MySQL (�� ��������� 3306)
  FDConnection.Params.Add('CharacterSet=utf8'); //���������� ���������    mb4
end;

//�������� ��������� �����������
function TWebModule1.Login(UserLogin, Password: string): Integer;
  //�������� ���������, ������� ��������� ������ �������� ������� � �������� ����
  //�� ������� ��������� �� ������� �������!!!
  procedure PasswordCheckEmulation;
  var
    id: Integer;
  begin
    FDQueryTemp.Close;
    FDQueryTemp.SQL.Clear;
    FDQueryTemp.SQL.Add('SELECT * FROM auth WHERE login = :UserLogin');
    FDQueryTemp.Params.ParamByName('UserLogin').AsString := UserLogin;
    FDQueryTemp.Open;

    id := FDQueryTemp.FieldByName('auth_id').AsInteger;

    if (FDQueryTemp.FieldByName('login').AsString = '2222222222') //��������� �������� �������� ����� �� �������������
      and (FDQueryTemp.FieldByName('passw').AsString = 'test') then //��������� �������� ������
    begin
      FDQueryTemp.Close;
      FDQueryTemp.SQL.Clear;
      //������� �� ������� auth ������ � ������ ������������� ������
      //����� �� ���� ����� ������ ���� �� ���� ����������� � ���� ������
      //������ ��� ������� �������� (��� ������������ ��� ��� ��� ���� � session_id = 1001)
      FDQueryTemp.SQL.Add('UPDATE auth set session_id = 1001 where auth_id = :auth_id');
      FDQueryTemp.Params.ParamByName('auth_id').AsInteger := id;
      FDQueryTemp.ExecSQL;
    end
    else
    begin
      FDQueryTemp.Close;
      FDQueryTemp.SQL.Clear;
      //� ������ �������� ������������������ ������ ������� �� �� ������� auth
      FDQueryTemp.SQL.Add('DELETE FROM auth  where auth_id = :auth_id');
      FDQueryTemp.Params.ParamByName('auth_id').AsInteger := id;
      FDQueryTemp.ExecSQL;
    end;

  end;
  var
    New_ID: Integer;
begin

  Result := 0;

  if UserLogin > '' then
  begin

    DBSetParams;

    FDConnection.Connected := True;  // ��������� �����������

    // ������� ����� � ������ � �� ��� ��������
    FDQuery.Close;
    FDQuery.SQL.Clear;
    FDQuery.SQL.Add('INSERT INTO auth (auth_id, login, passw, session_id)');
    FDQuery.SQL.Add('VALUES (Null, :UserLogin, :Passw, Null)');
    FDQuery.Params.ParamByName('UserLogin').AsString := UserLogin;
    FDQuery.Params.ParamByName('Passw').AsString := Password;
    FDQuery.ExecSQL;
    FDConnection.Commit;

    // �������� ��������� ����������� �������� ����������������� ����
    FDQuery.Close;
    FDQuery.SQL.Clear;
    FDQuery.SQL.Text := 'SELECT LAST_INSERT_ID() as auth_id';
    FDQuery.Open;
    New_ID := FDQuery.FieldByName('auth_id').AsInteger;

    // � ���� ������ ������ ��������� ��������� � �������� ����, ������� �������� �����
    //� ������ � ������� ���� ������ ������� ��������
    //�� ��������� � ������
    PasswordCheckEmulation;

    // �������� �� 2000 ����������� (2 �������) ����� �� �������� ���� ������ ����������
    Sleep(2000);

    //������� ���������� �������� ������ � ������
    FDQuery.Close;
    FDQuery.SQL.Clear;
    FDQuery.SQL.Add('SELECT * FROM auth WHERE auth_id = :auth_id and session_id is not Null');
    FDQuery.Params.ParamByName('auth_id').AsInteger := New_ID;
    FDQuery.Open;

    if FDQuery.RecordCount > 0 then
      //���� �������� ��������, ��������� session_id
      begin
        Result := FDQuery.FieldByName('session_id').AsInteger;
        //������� ��� �������� ������ �� ������� auth
        FDQuery.Close;
        FDQuery.SQL.Clear;
        FDQuery.SQL.Add('DELETE FROM auth WHERE auth_id = :auth_id');
        FDQuery.Params.ParamByName('auth_id').AsInteger := New_ID;
        FDQuery.ExecSQL;
      end;

    FDConnection.Connected := False; //����������� �� ��
  end;

end;


// �������� ������� HTML �� �����
function TWebModule1.LoadHTMLTemplate: string;
var
  TemplatePath: string;
begin
  // �������� ���� � ������������ ����� � ��������� � ���� ������ template
  //TemplatePath := ExtractFilePath(ParamStr(0));
  //TemplatePath := '';
  if OperType = '/auth' then
    TemplatePath := TemplatesDir + 'template_auth.html'
  else
    TemplatePath := TemplatesDir + 'template_table.html';

  // ���������, ���������� �� ����
  if not FileExists(TemplatePath) then
    raise Exception.Create('HTML template file not found: ' + TemplatePath);

  // ��������� ���������� ����� � ��������� UTF-8
  Result := TFile.ReadAllText(TemplatePath, TEncoding.UTF8);
end;


// ������������ ������� � ����������� �� ���� ��������� � ���������� �������
function TWebModule1.GetDataTable: string;
var
  i: Integer;
  TableName, FIO: string;
begin
  DBSetParams;

  FDConnection.Connected := True;  // ��������� �����������

  Result := '';
  if OperType = '/schetchik' then
  begin
    TableName := 'schetchik';
    // ������������ ���������� �������
    Result := '<thead>'
            + '<tr>'
            + '<th scope="col">���</th>'
            + '<th scope="col">��������� �����</th>'
            + '<th scope="col">��������</th>'
            + '<th scope="col">�����������</th>'
            + '<th scope="col">����������</th>'
            + '<th scope="col">��������� ��� ���.</th>'
            + '<th scope="col">����</th>'
            + '<th scope="col">��������� ��� ������</th>'
            + '</tr>'
            + '</thead>';
  end
  else if OperType = '/control' then
  begin
    TableName := 'control';
    // ������������ ���������� �������
    Result := '<thead>'
            + '<tr>'
            + '<th scope="col">���� ������</th>'
            + '<th scope="col">��������� ������� ����� ��� ������</th>'
            + '</tr>'
            + '</thead>';
  end
  else if OperType = '/tariff' then
  begin
    TableName := 'tariff';
    // ������������ ���������� �������
    Result := '<thead>'
            + '<tr>'
            + '<th scope="col">��� ������</th>'
            + '<th scope="col">������ ��������</th>'
            + '<th scope="col">����� ��������</th>'
            + '<th scope="col">�����, ���.</th>'
            + '</tr>'
            + '</thead>';
  end
  else if OperType = '/calc' then
  begin
    TableName := 'calc';
    // ������������ ���������� �������
    Result := '<thead>'
            + '<tr>'
            + '<th scope="col">������</th>'
            + '<th scope="col">���. ���������</th>'
            + '<th scope="col">���. ���������</th>'
            + '<th scope="col">������, ����</th>'
            + '<th scope="col">� ������, ���.</th>'
            + '<th scope="col">��������, ���.</th>'
            + '<th scope="col">��������, ����</th>'
            + '</tr>'
            + '</thead>';
  end
  else if OperType = '/pays' then
  begin
    TableName := 'pays';
    // ������������ ���������� �������
    Result := '<thead>'
            + '<tr>'
            + '<th scope="col">���� ������</th>'
            + '<th scope="col">�����, ���.</th>'
            + '<th scope="col">� �.�. ����, ���.</th>'
            + '</tr>'
            + '</thead>';
  end
  else if OperType = '/abon_info' then
  begin
    TableName := 'abon_info';
  end;

  // � ����������� �� ������� ��������� SQL-������ � �������� ������
  FDQuery.SQL.Text := Format('SELECT * FROM %s where session_id = %d', [TableName, Session_ID]);
  FDQuery.Open;

  // ������������ ����� �������
  Result := Result + '<tbody>';
  if TableName <> 'abon_info' then
  begin
    while not FDQuery.Eof do
    begin
      Result := Result + '<tr>';
      for i := 2 to FDQuery.FieldCount - 1 do
        //Result := Result + '<td>' + FDQuery.FieldByName('').AsString + '</td>';
        Result := Result + '<td>' + FDQuery.Fields[i].AsString + '</td>';
      Result := Result + '</tr>';
      FDQuery.Next;
    end
  end
  else
  begin
    //���������, ����� ������� �� ������ ������� � �������� �����
    FIO := FDQuery.FieldValues['abon_fio'];
    if pos('***', FIO) = 0 then
      FIO := copy(FIO, 1, 1) + '***' + copy(FIO, pos(' ', FIO) - 1, length(FIO));
    //ShowMessage(FIO);

    Result := '<tr><th>������� ����</th><td>' + FDQuery.FieldByName('lic_schet').AsString + '</td></tr>'
            + '<tr><th>�����</th><td>' + FDQuery.FieldByName('address').AsString + '</td></tr>'
            + '<tr><th>�������</th><td>' + FIO + '</td></tr>'
            + '<tr><th>��� ��������</th><td>' + FDQuery.FieldByName('schetchik_type').AsString + '</td></tr>'
            + '<tr><th>��������� ����� ��������</th><td>' + FDQuery.FieldByName('schetchik_sn').AsString + '</td></tr>'
            + '<tr><th>�������� ��������</th><td>' + FDQuery.FieldByName('schetchik_phase').AsString + '</td></tr>'
            + '<tr><th>����������� ��������</th><td>' + FDQuery.FieldByName('schetchik_razr').AsString + '</td></tr>'
            + '<tr><th>��� ������</th><td>' + FDQuery.FieldByName('tariff_type').AsString + '</td></tr>'
            + '<tr><th>���� ���������� ������</th><td>' + FDQuery.FieldByName('last_control_date').AsString + '</td></tr>'
            + '<tr><th>������ ��������� ��� ������</th><td>' + FDQuery.FieldByName('last_control_data').AsString + '</td></tr>';
  end;
  Result := Result + '</tbody>';

  FDQuery.Close;

  FDConnection.Connected := False;  // ��������� �����������
end;


// ������������ �������� HTML-�������� �� �������
function TWebModule1.GetHTMLPage(Session_ID: Integer; Title, TableContent, ErrMess: string): string;
begin
  // ��������� ������
  Result := LoadHTMLTemplate;

  // �������� {{*****}} �� �������� ��������
  Result := StringReplace(Result, '{{server_url}}', WEBAppURL, [rfReplaceAll]);
  Result := StringReplace(Result, '{{session_id}}', IntToStr(Session_ID), [rfReplaceAll]);
  Result := StringReplace(Result, '{{title}}', Title, [rfReplaceAll]);
  Result := StringReplace(Result, '{{table}}', TableContent, [rfReplaceAll]);
  Result := StringReplace(Result, '{{ErrorMessage}}', ErrMess, [rfReplaceAll]);
end;

end.
