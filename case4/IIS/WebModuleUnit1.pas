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
  // Путь к INI-файлу рядом с DLL
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
  //Загрузка настроек сервера
  LoadServerSettings;
  // Чтение параметров запроса
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
    Title := 'Авторизация';
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
      // Выполняем редирект на другой URL
      Response.SendRedirect(WEBAppURL + '/abon_info?session_id='+IntToStr(Session_ID));

      // Завершаем обработку
      Handled := True;
    end
    else
    begin
      OperType := '/auth';
      Title := 'Авторизация';
      ErrMess := 'Ошибка авторизации! Проверьте введенные данные!';
    end;
  end
  else if OperType = '/schetchik' then
  begin
    Title := 'Счётчики';
    Table := GetDataTable;
  end
  else if OperType = '/tariff' then
  begin
    Title := 'Тарифы';
    Table := GetDataTable;
  end
  else if OperType = '/control' then
  begin
    Title := 'Контрольные снятия показаний';
    Table := GetDataTable;
  end
  else if OperType = '/calc' then
  begin
    Title := 'Расчёт стоимости электроэнергии';
    Table := GetDataTable;
  end
  else if OperType = '/pays' then
  begin
    Title := 'Поступившая оплата';
    Table := GetDataTable;
  end
  else if OperType = '/abon_info' then
  begin
    Title := 'Информация об абоненте';
    Table := GetDataTable;
  end
  else
  begin
    // Если URL не распознан, возвращаем ошибку 404
    Response.StatusCode := 404;
    Response.Content := '<html><body><h1>404 - Page Not Found OperType='
                        + OperType + '='
                        + Request.PathInfo + '</h1></body></html>';
    Response.ContentType := 'text/html; charset=UTF-8';  // Устанавливаем кодировку UTF-8
    Exit;
  end;

  // Формируем HTML-ответ
  Response.Content := GetHTMLPage(Session_ID, Title, Table, ErrMess);
  Response.ContentType := 'text/html';
  Response.ContentType := 'text/html; charset=UTF-8';  // Устанавливаем кодировку UTF-8
end;

//Настраиваем подключение к базе данных
procedure TWebModule1.DBSetParams;
begin
  // Устанавливаем параметры подключения к MySQL
  FDConnection.DriverName := 'MySQL';
  FDConnection.Params.Database := 'energo';    // Имя базы данных
  FDConnection.Params.UserName := 'test_user'; // Имя пользователя
  FDConnection.Params.Password := 'Test,123';  // Пароль пользователя
  FDConnection.Params.Add('Server=localhost'); // Адрес сервера (localhost или IP-адрес)
  FDConnection.Params.Add('Port=3306');        // Порт MySQL (по умолчанию 3306)
  FDConnection.Params.Add('CharacterSet=utf8'); //Определяем кодировку    mb4
end;

//Проводим процедуру авторизации
function TWebModule1.Login(UserLogin, Password: string): Integer;
  //Тестовая процедура, которая эмулирует сервис проверки паролей в закрытой сети
  //Из готовой программы ее следует удалить!!!
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

    if (FDQueryTemp.FieldByName('login').AsString = '2222222222') //Эмулируем проверку лицевого счета на существование
      and (FDQueryTemp.FieldByName('passw').AsString = 'test') then //Эмулируем проверку пароля
    begin
      FDQueryTemp.Close;
      FDQueryTemp.SQL.Clear;
      //Убираем из таблицы auth пароль и выдаем идентификатор сессии
      //Также на этом этапе должны были бы быть скопированы в базу данных
      //данные для личного кабинета (для тестирования они уже там есть с session_id = 1001)
      FDQueryTemp.SQL.Add('UPDATE auth set session_id = 1001 where auth_id = :auth_id');
      FDQueryTemp.Params.ParamByName('auth_id').AsInteger := id;
      FDQueryTemp.ExecSQL;
    end
    else
    begin
      FDQueryTemp.Close;
      FDQueryTemp.SQL.Clear;
      //В случае неверных аутентификационных данных убираем их из таблицы auth
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

    FDConnection.Connected := True;  // Открываем подключение

    // Заносим логин и пароль в БД для проверки
    FDQuery.Close;
    FDQuery.SQL.Clear;
    FDQuery.SQL.Add('INSERT INTO auth (auth_id, login, passw, session_id)');
    FDQuery.SQL.Add('VALUES (Null, :UserLogin, :Passw, Null)');
    FDQuery.Params.ParamByName('UserLogin').AsString := UserLogin;
    FDQuery.Params.ParamByName('Passw').AsString := Password;
    FDQuery.ExecSQL;
    FDConnection.Commit;

    // Получаем последнее вставленное значение автоинкрементного поля
    FDQuery.Close;
    FDQuery.SQL.Clear;
    FDQuery.SQL.Text := 'SELECT LAST_INSERT_ID() as auth_id';
    FDQuery.Open;
    New_ID := FDQuery.FieldByName('auth_id').AsInteger;

    // В этот момент должна сработать программа в закрытой сети, которая проверит логин
    //и пароль и обновит базу данных личного кабинета
    //Мы эмулируем её работу
    PasswordCheckEmulation;

    // Задержка на 2000 миллисекунд (2 секунды) чтобы ПО закрытой сети успело отработать
    Sleep(2000);

    //Смотрим результаты проверки логина и пароля
    FDQuery.Close;
    FDQuery.SQL.Clear;
    FDQuery.SQL.Add('SELECT * FROM auth WHERE auth_id = :auth_id and session_id is not Null');
    FDQuery.Params.ParamByName('auth_id').AsInteger := New_ID;
    FDQuery.Open;

    if FDQuery.RecordCount > 0 then
      //Если проверка пройдена, считываем session_id
      begin
        Result := FDQuery.FieldByName('session_id').AsInteger;
        //Удаляем уже ненужную запись из таблицы auth
        FDQuery.Close;
        FDQuery.SQL.Clear;
        FDQuery.SQL.Add('DELETE FROM auth WHERE auth_id = :auth_id');
        FDQuery.Params.ParamByName('auth_id').AsInteger := New_ID;
        FDQuery.ExecSQL;
      end;

    FDConnection.Connected := False; //Отключаемся от БД
  end;

end;


// Загрузка шаблона HTML из файла
function TWebModule1.LoadHTMLTemplate: string;
var
  TemplatePath: string;
begin
  // Получаем путь к исполняемому файлу и добавляем к нему нужный template
  //TemplatePath := ExtractFilePath(ParamStr(0));
  //TemplatePath := '';
  if OperType = '/auth' then
    TemplatePath := TemplatesDir + 'template_auth.html'
  else
    TemplatePath := TemplatesDir + 'template_table.html';

  // Проверяем, существует ли файл
  if not FileExists(TemplatePath) then
    raise Exception.Create('HTML template file not found: ' + TemplatePath);

  // Загружаем содержимое файла в кодировке UTF-8
  Result := TFile.ReadAllText(TemplatePath, TEncoding.UTF8);
end;


// Формирование таблицы в зависимости от типа животного и количества записей
function TWebModule1.GetDataTable: string;
var
  i: Integer;
  TableName, FIO: string;
begin
  DBSetParams;

  FDConnection.Connected := True;  // Открываем подключение

  Result := '';
  if OperType = '/schetchik' then
  begin
    TableName := 'schetchik';
    // Формирование заголовков таблицы
    Result := '<thead>'
            + '<tr>'
            + '<th scope="col">Тип</th>'
            + '<th scope="col">Заводской номер</th>'
            + '<th scope="col">Фазность</th>'
            + '<th scope="col">Разрядность</th>'
            + '<th scope="col">Установлен</th>'
            + '<th scope="col">Показание при уст.</th>'
            + '<th scope="col">Снят</th>'
            + '<th scope="col">Показание при снятии</th>'
            + '</tr>'
            + '</thead>';
  end
  else if OperType = '/control' then
  begin
    TableName := 'control';
    // Формирование заголовков таблицы
    Result := '<thead>'
            + '<tr>'
            + '<th scope="col">Дата обхода</th>'
            + '<th scope="col">Показание прибора учёта при обходе</th>'
            + '</tr>'
            + '</thead>';
  end
  else if OperType = '/tariff' then
  begin
    TableName := 'tariff';
    // Формирование заголовков таблицы
    Result := '<thead>'
            + '<tr>'
            + '<th scope="col">Тип тарифа</th>'
            + '<th scope="col">Начало действия</th>'
            + '<th scope="col">Конец действия</th>'
            + '<th scope="col">Тариф, руб.</th>'
            + '</tr>'
            + '</thead>';
  end
  else if OperType = '/calc' then
  begin
    TableName := 'calc';
    // Формирование заголовков таблицы
    Result := '<thead>'
            + '<tr>'
            + '<th scope="col">Период</th>'
            + '<th scope="col">Нач. показание</th>'
            + '<th scope="col">Кон. показание</th>'
            + '<th scope="col">Расход, кВтч</th>'
            + '<th scope="col">К оплате, руб.</th>'
            + '<th scope="col">Оплачено, руб.</th>'
            + '<th scope="col">Оплачено, кВтч</th>'
            + '</tr>'
            + '</thead>';
  end
  else if OperType = '/pays' then
  begin
    TableName := 'pays';
    // Формирование заголовков таблицы
    Result := '<thead>'
            + '<tr>'
            + '<th scope="col">Дата оплаты</th>'
            + '<th scope="col">Сумма, руб.</th>'
            + '<th scope="col">В т.ч. пеня, руб.</th>'
            + '</tr>'
            + '</thead>';
  end
  else if OperType = '/abon_info' then
  begin
    TableName := 'abon_info';
  end;

  // В зависимости от таблицы формируем SQL-запрос и получаем данные
  FDQuery.SQL.Text := Format('SELECT * FROM %s where session_id = %d', [TableName, Session_ID]);
  FDQuery.Open;

  // Формирование строк таблицы
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
    //Проверяем, чтобы фамилия не попала целиком в выходную форму
    FIO := FDQuery.FieldValues['abon_fio'];
    if pos('***', FIO) = 0 then
      FIO := copy(FIO, 1, 1) + '***' + copy(FIO, pos(' ', FIO) - 1, length(FIO));
    //ShowMessage(FIO);

    Result := '<tr><th>Лицевой счёт</th><td>' + FDQuery.FieldByName('lic_schet').AsString + '</td></tr>'
            + '<tr><th>Адрес</th><td>' + FDQuery.FieldByName('address').AsString + '</td></tr>'
            + '<tr><th>Абонент</th><td>' + FIO + '</td></tr>'
            + '<tr><th>Тип счетчика</th><td>' + FDQuery.FieldByName('schetchik_type').AsString + '</td></tr>'
            + '<tr><th>Заводской номер счетчика</th><td>' + FDQuery.FieldByName('schetchik_sn').AsString + '</td></tr>'
            + '<tr><th>Фазность счетчика</th><td>' + FDQuery.FieldByName('schetchik_phase').AsString + '</td></tr>'
            + '<tr><th>Разрядность счетчика</th><td>' + FDQuery.FieldByName('schetchik_razr').AsString + '</td></tr>'
            + '<tr><th>Тип тарифа</th><td>' + FDQuery.FieldByName('tariff_type').AsString + '</td></tr>'
            + '<tr><th>Дата последнего обхода</th><td>' + FDQuery.FieldByName('last_control_date').AsString + '</td></tr>'
            + '<tr><th>Снятое показание при обходе</th><td>' + FDQuery.FieldByName('last_control_data').AsString + '</td></tr>';
  end;
  Result := Result + '</tbody>';

  FDQuery.Close;

  FDConnection.Connected := False;  // Закрываем подключение
end;


// Формирование конечной HTML-страницы из шаблона
function TWebModule1.GetHTMLPage(Session_ID: Integer; Title, TableContent, ErrMess: string): string;
begin
  // Загружаем шаблон
  Result := LoadHTMLTemplate;

  // Заменяем {{*****}} на реальные значения
  Result := StringReplace(Result, '{{server_url}}', WEBAppURL, [rfReplaceAll]);
  Result := StringReplace(Result, '{{session_id}}', IntToStr(Session_ID), [rfReplaceAll]);
  Result := StringReplace(Result, '{{title}}', Title, [rfReplaceAll]);
  Result := StringReplace(Result, '{{table}}', TableContent, [rfReplaceAll]);
  Result := StringReplace(Result, '{{ErrorMessage}}', ErrMess, [rfReplaceAll]);
end;

end.
