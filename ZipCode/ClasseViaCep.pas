unit ClasseViaCep;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics,Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Bind.Components,
  Data.Bind.ObjectScope,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,

  REST.Types, REST.Response.Adapter, REST.Client, REST.Authenticator.Basic;
type
  TViaCep = class
  private
    { Private declarations }
    FCEP: string;
    FUf: string;
    FCidade: string;
    FLogradouro: string;
    FBairro: string;
    FComplemento: string;
    FZipCodeData: string;
    FNmCidade: string;
    FNmLogradouro: string;
    FNmBairro: string;
    FDsComplemento: string;

  public
    { Public declarations }
    property CEP: string read FCEP write FCEP;
    property Uf: string read FUf write FUf;
    property Cidade: string read FCidade write FCidade;
    property Bairro: string read FBairro write FBairro;
    property Logradouro: string read FLogradouro write FLogradouro;
    property Complemento: string read FComplemento write FComplemento;
    property ZipCodeData: string read FZipCodeData write FZipCodeData;

    constructor Create(CEP: string);
    destructor Destroy; Override;

    procedure SearchZipCode;
  end;

var
  ViaCep: TViaCEP;

  FTestCEP: string;
  LRESTClient: TRESTClient;
  LRESTResponse: TRESTResponse;
  LRESTRequest: TRESTRequest;
  LRESTResponseDataSetAdapter: TRESTResponseDataSetAdapter;
  LMemTableCEP: TFDMemTable;

implementation

{ TViaCEP }

constructor TViaCep.Create(CEP: string);
begin
  FTestCEP := CEP;

  LRESTClient := TRESTClient.Create(nil);
  LRESTClient.BaseURL := 'http://viacep.com.br/ws';

  LRESTResponse := TRESTResponse.Create(nil);

  LRESTRequest := TRESTRequest.Create(nil);
  LRESTRequest.Client := LRESTClient;
  LRESTRequest.Resource := FTestCEP + '/json';
  LRESTRequest.Response := LRESTResponse;

  LMemTableCEP := TFDMemTable.Create(nil);

  LRESTResponseDataSetAdapter := TRESTResponseDataSetAdapter.Create(nil);
  LRESTResponseDataSetAdapter.Dataset := LMemTableCEP;
  LRESTResponseDataSetAdapter.Response := LRESTResponse;
end;

destructor TViaCep.Destroy;
begin
  LRESTClient.Destroy;
  LRESTResponse.Destroy;
  LRESTRequest.Destroy;
  LRESTResponseDataSetAdapter.Destroy;
  LMemTableCEP.Destroy;
  inherited;
end;

procedure TViaCep.SearchZipCode;
begin
  try
    LRESTRequest.Resource := FTestCEP + '/json';
    LRESTRequest.Execute;

    if LRESTRequest.Response.StatusCode = 200 then
    begin
      FZipCodeData := '';

      if LRESTRequest.Response.Content.IndexOf('erro') > 0 then
        FZipCodeData := 'CEP '+ FTestCEP +' não localizado'
      else
      begin
        CEP := LMemTableCEP.FieldByName('cep').AsString;
        Uf := LMemTableCEP.FieldByName('uf').AsString;
        Cidade := LMemTableCEP.FieldByName('localidade').AsString;
        Bairro := LMemTableCEP.FieldByName('bairro').AsString;
        Logradouro := LMemTableCEP.FieldByName('logradouro').AsString;
        Complemento := LMemTableCEP.FieldByName('complemento').AsString;
      end;
    end;
  except
    on E:Exception do
      FZipCodeData := 'Erro ao pesquisar CEP' +#13+
        'Erro: ' + e.Message;
  end;
end;

end.
