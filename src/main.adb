
with Last_Chance_Handler;  pragma Unreferenced (Last_Chance_Handler);

with STM32.Board;           use STM32.Board;
with HAL.Bitmap;            use HAL.Bitmap;
with HAL.Framebuffer;       use HAL.Framebuffer;
with Serial_IO.Blocking;    use Serial_IO.Blocking;
with Peripherals_Blocking;  use Peripherals_Blocking;
with LCD_Std_Out;
with HAL;           use HAL;
with Display_Graph; use Display_Graph;
with BPM_Compute;   use BPM_Compute;
with Ada.Exceptions;   use Ada.Exceptions;

procedure Main 
is
  UART_Value : Uint16;
  Data : Data_Array (1 .. 200) := (others => 512);
  Offset : Natural := 0;
  Cardiac_Info : Cardiac_Info_Type;
  Text_Layer : Constant Positive := 1;
  Graph_Layer: Constant Positive := 2;
  BPM_Value : Integer;
  BPM_Valid : Boolean := True;
begin
  Display.Initialize(Landscape);
  Display.Initialize_Layer (Text_Layer, ARGB_8888, 0, 0, 320, 120);
  Display.Initialize_Layer (Graph_Layer, ARGB_8888, 0, 120, 320, 120);
  Init(Cardiac_Info);
  Initialize (COM);
  Configure (COM, Baud_Rate => 9_600);
  Initialize_LEDs;
  loop
      BPM_Value := Get_BPM(Cardiac_Info);
      if (BPM_Value in 60 .. 150) then
        LCD_Std_Out.Clear_Screen;
        LCD_Std_Out.Put_Line (Get_BPM(Cardiac_Info)'Image);
        BPM_Valid := True;
      else
        if BPM_Valid then
          LCD_Std_Out.Clear_Screen;
          LCD_Std_Out.Put_Line ("Invalid BPM");
        end if;
        BPM_Valid := False;
      end if;
      display_Cardiac_Graph(Display, Data, Offset, 320, 120, Graph_Layer);
      for J in 1 .. 10 loop
        Get_UART_Value (COM, UART_Value, 2);
        Data(Offset + J) := Integer(UART_Value); 
        Process(Cardiac_Info, Integer(UART_Value));
        if BPM_Valid and then Cardiac_Info.Pulse then
          STM32.Board.Turn_On(Green_LED);
        else
          STM32.Board.Turn_Off(Green_LED);
        end if;
      end loop;
      Offset := Offset + 10;
      if Offset >= Data'Last then
        Offset := 0;
      end if;
   end loop;
exception
   when Error : others =>
      LCD_Std_Out.Clear_Screen;
      LCD_Std_Out.Put_Line(Exception_Information(Error));
      loop
         null;
      end loop;
end Main;
