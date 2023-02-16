program ViaCep;

uses
  Vcl.Forms,
  uMaster in 'uMaster.pas' {fMaster},
  ClasseViaCep in 'ZipCode\ClasseViaCep.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfMaster, fMaster);
  Application.Run;

  ReportMemoryLeaksOnShutdown := True;
end.
