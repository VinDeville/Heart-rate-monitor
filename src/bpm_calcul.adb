package body BPM_Calcul is

   procedure Init(Cardiac_Info : in out Cardiac_Info_Type) is
   begin
      Cardiac_Info.BPM := 0;
      Cardiac_Info.Signal := 0;
      Cardiac_Info.Last_Beat_Time := 0;
      Cardiac_Info.IBI := 750;
      Cardiac_Info.Pulse := False;
      Cardiac_Info.Default_Thresh := 0;
      Cardiac_Info.Thresh := 550;
      Cardiac_Info.Peak := 512;
      Cardiac_Info.Trough := 512;
      Cardiac_Info.Amp := 0;
      Cardiac_Info.Sample_Interval_Ms := 50;
      Cardiac_Info.Sample_Counter := 0;
      Cardiac_Info.First_Beat := True;
      Cardiac_Info.Second_Beat := False;
      Cardiac_Info.Sample_Interval_Last := Ada.Real_Time.Clock;
   end;

   function Get_BPM(Cardiac_Info : Cardiac_Info_Type) return Integer is
   begin
      return Cardiac_Info.BPM;
   end;


   procedure Set_Default_Thresh(Cardiac_Info : in out Cardiac_Info_Type; Value : Integer) is
   begin
      Cardiac_Info.Default_Thresh := Value;
   end;


   procedure Process(Cardiac_Info : in out Cardiac_Info_Type; Signal : Integer) is
      N : Long_Integer;
      Current_Time : Ada.Real_Time.Time;
   begin
      Cardiac_Info.Signal := Signal;
      Current_Time := Ada.Real_Time.Clock;
      Cardiac_Info.Sample_Counter := Cardiac_Info.Sample_Counter
        + Long_Integer((Current_Time - Cardiac_Info.Sample_Interval_Last)
                        / Milliseconds(1));
      Cardiac_Info.Sample_Interval_Last := Current_Time;
      N := Cardiac_Info.Sample_Counter - Cardiac_Info.Last_Beat_Time;

      -- Find peak and through
      if Cardiac_Info.Signal < Cardiac_Info.Thresh and N > (Cardiac_Info.IBI / 5) * 3 then
         if Cardiac_Info.Signal < Cardiac_Info.Trough then
            Cardiac_Info.Trough := Cardiac_Info.Signal;
         end if;
      end if;
      if Cardiac_Info.Signal > Cardiac_Info.Thresh and
        Cardiac_Info.Signal > Cardiac_Info.Peak then
         Cardiac_Info.Peak := Cardiac_Info.Signal;
      end if;

      -- Heart beat
      if N > 250 then
         if Cardiac_Info.Signal > Cardiac_Info.Thresh and
           not Cardiac_Info.Pulse and
           N > (Cardiac_Info.IBI / 5) * 3 then
            Cardiac_Info.Pulse := True;
            Cardiac_Info.IBI := Cardiac_Info.Sample_Counter - Cardiac_Info.Last_Beat_Time;
            Cardiac_Info.Last_Beat_Time := Cardiac_Info.Sample_Counter;


            if Cardiac_Info.Second_Beat then
               Cardiac_Info.Second_Beat := False;
               --for I in range 0 .. 9 loop

               --end loop;

            end if;

            if Cardiac_Info.First_Beat then
               Cardiac_Info.First_Beat := False;
               Cardiac_Info.Second_Beat := True;
               return;
            end if;

            Cardiac_Info.BPM := 60000 / Integer(Cardiac_Info.IBI);
         end if;
      end if;

      if Cardiac_Info.Signal < Cardiac_Info.Thresh and
         Cardiac_Info.Pulse then
         Cardiac_Info.Pulse := False;
      end if;

      if N > 2500 then
         Cardiac_Info.Thresh := Cardiac_Info.Default_Thresh;
         Cardiac_Info.Peak := 512;
         Cardiac_Info.Trough := 512;
         Cardiac_Info.Last_Beat_Time := Cardiac_Info.Sample_Counter;
         Cardiac_Info.First_Beat := True;
         Cardiac_Info.Second_Beat := False;
         Cardiac_Info.BPM := 0;
         Cardiac_Info.IBI := 600;
         Cardiac_Info.Pulse := False;
         Cardiac_Info.Amp := 100;
      end if;
   end;

end BPM_Calcul;
