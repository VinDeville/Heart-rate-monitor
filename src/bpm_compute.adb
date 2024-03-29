package body BPM_Compute is

  procedure Init(Cardiac_Info : in out Cardiac_Info_Type) is
  begin
    Cardiac_Info.Last_Beat_Time := 0;
    Cardiac_Info.IBI := 750;
    Cardiac_Info.Pulse := False;
    Cardiac_Info.Thresh := 550;
    Cardiac_Info.Sample_Counter := 0;
    Cardiac_Info.Sample_Interval_Last := Ada.Real_Time.Clock;
  end;

  function Get_BPM(Cardiac_Info : Cardiac_Info_Type)     return Integer is
  begin
    return 60000 / Integer(Cardiac_Info.IBI);
  end;


  procedure Process(Cardiac_Info : in out Cardiac_Info_Type; Signal : Integer) is
    N : Long_Integer;
    Current_Time : Ada.Real_Time.Time;
  begin
    Current_Time := Ada.Real_Time.Clock;
    Cardiac_Info.Sample_Counter := Cardiac_Info.Sample_Counter
    + Long_Integer((Current_Time - Cardiac_Info.Sample_Interval_Last)
    / Milliseconds(1));
    Cardiac_Info.Sample_Interval_Last := Current_Time;
    N := Cardiac_Info.Sample_Counter - Cardiac_Info.Last_Beat_Time;

    -- Heart beat
    if N > 250 then
      if Signal > Cardiac_Info.Thresh and
        not Cardiac_Info.Pulse and
        N > (Cardiac_Info.IBI / 5) * 3 then
        Cardiac_Info.Pulse := True;
        Cardiac_Info.IBI := Cardiac_Info.Sample_Counter - Cardiac_Info.Last_Beat_Time;
        Cardiac_Info.Last_Beat_Time := Cardiac_Info.Sample_Counter;
      end if;
    end if;

    if Signal < Cardiac_Info.Thresh and
      Cardiac_Info.Pulse then
      Cardiac_Info.Pulse := False;
    end if;

    if N > 2500 then
      Cardiac_Info.Last_Beat_Time := Cardiac_Info.Sample_Counter;
      Cardiac_Info.IBI := 600;
      Cardiac_Info.Pulse := False;
    end if;
  end;

end BPM_Compute;
