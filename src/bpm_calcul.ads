with Ada.Real_Time;       use Ada.Real_Time;
package BPM_Calcul is
   type Cardiac_Info_Type is record
      BPM : Integer range 0 .. 226;
      Signal : Integer;
      Last_Beat_Time : Long_Integer;
      IBI : Long_Integer;
      Pulse : Boolean;
      Default_Thresh : Integer;
      Thresh : Integer;
      Peak : Integer;
      Trough : Integer;
      Amp : Integer;
      Sample_Interval_Ms : Long_Integer;
      Sample_Counter : Long_Integer;
      First_Beat : Boolean;
      Second_Beat : Boolean;
      Sample_Interval_Last : Ada.Real_Time.Time;
   end record;

   procedure Init(Cardiac_Info : in out Cardiac_Info_Type);

   function Get_BPM(Cardiac_Info : Cardiac_Info_Type) return Integer;

   procedure Set_Default_Thresh(Cardiac_Info : in out Cardiac_Info_Type; Value : Integer);


   procedure Process(Cardiac_Info : in out Cardiac_Info_Type; Signal : Integer);



end BPM_Calcul;
