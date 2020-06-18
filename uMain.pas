unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, sgcWebSocket_Classes, sgcBase_Classes,
  sgcTCP_Classes, sgcWebSocket_Classes_Indy, sgcWebSocket_Client, sgcWebSocket;

type
  TForm2 = class(TForm)
    procedure FormShow(Sender: TObject);
    procedure GQLClientDisconnect(Connection: TsgcWSConnection; Code: Integer);
    procedure GQLClientError(Connection: TsgcWSConnection; const Error: string);
    procedure GQLClientException(Connection: TsgcWSConnection; E: Exception);
    procedure GQLClientHandshake(Connection: TsgcWSConnection; var Headers:
        TStringList);
    procedure GQLClientMessage(Connection: TsgcWSConnection; const Text: string);
    procedure GQLClientConnect(Connection: TsgcWSConnection);
  private
    { Private declarations }
    GQLClient: TsgcWebSocketClient;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.FormShow(Sender: TObject);
begin

  GQLClient := TsgcWebSocketClient.Create(nil);

  GQLClient.Host := '192.168.0.103';
  GQLClient.Port := 8080;
  GQLClient.TLS := False;
  GQLClient.Options.Parameters := '/v1/graphql';
//  GQLClient.TCPKeepAlive.Enabled := True;
//  GQLClient.TCPKeepAlive.Time := 1000;

  GQLClient.Authentication.Enabled := True;
  GQLClient.Authentication.URL.Enabled := False;
  GQLClient.Authentication.Session.Enabled := False;
  GQLClient.Authentication.Basic.Enabled := False;

  GQLClient.OnError := GQLClientError;
  GQLClient.OnException := GQLClientException;
  GQLClient.OnDisconnect := GQLClientDisconnect;
  GQLClient.OnMessage := GQLClientMessage;
  GQLClient.OnConnect := GQLClientConnect;

  GQLClient.Active := True;

//  if GQLClient.Connect(10000) then
//  begin
//    GQLClient.WriteData(
//      '{"query": "subscription EventSubs { ' +
//      'events_received(where: { device_id: { _eq: \"yoMerengues\"},' +
//      'response: { _is_null: false}})' +
//      '{response}' +
//      ' }" }'
//    );
//
//  end
//  else
//    ShowMessage('No se pudo conectar');
end;

procedure TForm2.GQLClientDisconnect(Connection: TsgcWSConnection; Code:
    Integer);
begin
  ShowMessage('Desconectado');
end;

procedure TForm2.GQLClientError(Connection: TsgcWSConnection; const Error:
    string);
begin
  ShowMessage(Error);
end;

procedure TForm2.GQLClientException(Connection: TsgcWSConnection; E: Exception);
begin
  ShowMessage(E.Message);
end;

procedure TForm2.GQLClientHandshake(Connection: TsgcWSConnection; var Headers:
    TStringList);
begin
  Headers.Add('content-type: application/json');
  Headers.Add('x-hasura-admin-secret: secretSalsa');
end;

procedure TForm2.GQLClientMessage(Connection: TsgcWSConnection; const Text:
    string);
begin
  ShowMessage(Text);
end;

procedure TForm2.GQLClientConnect(Connection: TsgcWSConnection);
begin
  GQLClient.WriteData(
    '{"query": "subscription EventSubs { ' +
    'events_received(where: { device_id: { _eq: \"yoMerengues\"},' +
    'response: { _is_null: false}})' +
    '{response}' +
    ' }" }'
  );
end;

end.
