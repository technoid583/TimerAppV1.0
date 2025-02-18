unit TimerAppUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.StdCtrls, Vcl.Samples.Spin, MMSystem;

type
  TTimerAppForm = class(TForm)
    TimeSpinEdt: TSpinEdit;
    ResetBtn: TButton;
    Label1: TLabel;
    TimerLbl: TLabel;
    StartBtn: TButton;
    Timer1: TTimer;
    Container: TPanel;
    procedure Timer1Timer(Sender: TObject);
    procedure StartBtnClick(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure UpdateLabel;
    procedure PlayMP3(const FileName: string);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TimerAppForm: TTimerAppForm;
  var countdownTime: integer;

implementation

{$R *.dfm}

procedure TTimerAppForm.FormCreate(Sender: TObject);
begin
  countdownTime := 0; // Set the initial countdown time (e.g., 5 minutes)
  UpdateLabel;
end;

procedure TTimerAppForm.FormResize(Sender: TObject);
begin
  Container.Left := (ClientWidth - Container.Width) div 2;
  Container.Top := (ClientHeight - Container.Height) div 2;
end;

procedure TTimerAppForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Ensure the MP3 file is closed when the form is closed
  mciSendString('close mp3', nil, 0, 0);
end;

procedure TTimerAppForm.StartBtnClick(Sender: TObject);
begin
  if countdownTime = 0 then
    countdownTime := TimeSpinEdt.Value;

  Timer1.Enabled := not Timer1.Enabled; ResetBtn.Enabled := True;

  if Timer1.Enabled then StartBtn.Caption := 'Pause'
  else
    StartBtn.Caption := 'Start';
end;

procedure TTimerAppForm.ResetBtnClick(Sender: TObject);
begin
  Timer1.Enabled := False; ResetBtn.Enabled := False; StartBtn.Caption := 'Start';
  countdownTime := 0; UpdateLabel; // Reset the countdown time & Update the Label
end;

procedure TTimerAppForm.Timer1Timer(Sender: TObject);
begin
//  TimerLbl.Caption := TimeToStr(Now);


  if countdownTime >= 0 then begin
//    countdownTime := countdownTime - 1;
    UpdateLabel; Dec(countdownTime); // Update the Label & Decrement the countdown time
  end
  else begin
    Timer1.Enabled := False; // Stop the timer when it reaches zero
    StartBtn.Caption := 'Start'; ResetBtn.Enabled := False;

    // Play the MP3 file
    PlayMP3('Assets/electronic_alarm_clock.mp3');

    // Show a messagebox
    MessageBox(Handle, 'Time Over! Press OK to continue.', 'TimerApp - Time Over!', MB_OK);

    // Close the MP3 file
    mciSendString('close mp3', nil, 0, 0);
  end
end;

procedure TTimerAppForm.UpdateLabel;
begin
  TimerLbl.Caption := FormatDateTime('hh:nn:ss', CountdownTime / SecsPerDay);

//  TimerLbl.Caption := Format('%.2d:%.2d', [CountdownTime div 60, CountdownTime mod 60]);
//  TimerLbl.Caption := Format('%.2d:%.2d:%.2d', [CountdownTime div 3600, (CountdownTime div 60) mod 60, CountdownTime mod 60]);
end;

procedure TTimerAppForm.PlayMP3(const FileName: string);
begin
  // Open and play the MP3 file
  mciSendString(PChar('open "' + FileName + '" type mpegvideo alias mp3'), nil, 0, 0);
  mciSendString('play mp3 repeat', nil, 0, 0);
end;

end.
