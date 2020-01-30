
package BPM_Calcul is
   type Cardic_Info is record
      BPM : Integer range 0 .. 226;
      Signal : Integer;
      Last_Beat_Time : Long_Integer;
      IBI : Integer;
      Pulse : Boolean;
      Thresh : Integer;
      Sample_Interval_Ms : Integer;
      Sample_Counter : Integer;
      First_Beat : Boolean;
      Second_Beat : Boolean;
   end record;

   procedure Init;

   function Get_BPM() return Integer;

   procedure Process();



end BPM_Calcul;
