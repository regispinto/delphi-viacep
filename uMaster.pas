unit uMaster;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage, VCLTee.TeCanvas, VCLTee.TeeEdiGrad,
  Vcl.Imaging.jpeg,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,

  ClasseViaCep;

type
  TfMaster = class(TForm)
    imgFundo: TImage;
    pnlTop: TPanel;
    lblViewData: TLabel;
    Panel1: TPanel;
    Image1: TImage;
    edtCEP: TEdit;
    btgPesquisar: TButtonGradient;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btgPesquisarClick(Sender: TObject);
    procedure edtCEPKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    procedure InitialVision;
    procedure SearchZipCode;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fMaster: TfMaster;
  FCEP: TViaCep;

CONST
  CR = #13;

implementation

{$R *.dfm}

procedure TfMaster.FormShow(Sender: TObject);
begin
  InitialVision;
end;

procedure TfMaster.edtCEPKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then SearchZipCode;
end;

procedure TfMaster.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then Self.Close;
end;

procedure TfMaster.btgPesquisarClick(Sender: TObject);
begin
  SearchZipCode;
end;

procedure TfMaster.SearchZipCode;
begin
  try
    try
      lblViewData.Caption := EmptyStr;

      FCEP := TViaCep.Create(edtCEP.Text);
      FCEP.SearchZipCode;

      if FCEP.ZipCodeData = EmptyStr then

        lblViewData.Caption := 'CEP: ' + FCEP.CEP + CR +
          'Endereço: ' + FCEP.Logradouro + CR +
          'Complemento: ' + FCEP.Complemento + CR +
          'Bairro: ' + FCEP.Bairro + CR +
          'Cidade: ' + FCEP.Cidade + CR +
          'UF: ' + '' + FCEP.UF
      else
        lblViewData.Caption := 'CEP ' + edtCEP.Text + ' não localizao';

      InitialVision;
    except
      on E:Exception do
        lblViewData.Caption := 'Falha ao consultar CEP: ' + edtCEP.Text;
    end;
  finally
    FCEP.Destroy;
  end;
end;

procedure TfMaster.InitialVision;
begin
  edtCEP.Clear;
  edtCEP.SetFocus;
end;

end.
