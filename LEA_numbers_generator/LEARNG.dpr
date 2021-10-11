program LEARNG;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  LEA_Hash in 'LEA_Hash.pas',
  LEA_RNG in 'LEA_RNG.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'LEA-RNG';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
