with Ada.Real_Time;       use Ada.Real_Time;
package BPM_Calcul is
   type Cardiac_Info_Type is record
      BPM : Integer;
      Signal : Integer;
      Last_Beat_Time : Long_Integer;
      IBI : Long_Integer;
      Pulse : Boolean;
      Thresh : Integer;
      Amp : Integer;
      Sample_Counter : Long_Integer;
      First_Beat : Boolean;
      Second_Beat : Boolean;
      Sample_Interval_Last : Ada.Real_Time.Time;
   end record;

   procedure Init(Cardiac_Info : in out Cardiac_Info_Type);

   function Get_BPM(Cardiac_Info : Cardiac_Info_Type) return Integer;

   procedure Process(Cardiac_Info : in out Cardiac_Info_Type; Signal : Integer)
     with Post => Cardiac_Info.Sample_Counter'Old < Cardiac_Info.Sample_Counter and then
     Cardiac_Info.Sample_Interval_Last'Old < Cardiac_Info.Sample_Interval_Last;



end BPM_Calcul;
