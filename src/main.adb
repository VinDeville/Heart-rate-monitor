------------------------------------------------------------------------------
--                                                                          --
--                     Copyright (C) 2015-2016, AdaCore                     --
--                                                                          --
--  Redistribution and use in source and binary forms, with or without      --
--  modification, are permitted provided that the following conditions are  --
--  met:                                                                    --
--     1. Redistributions of source code must retain the above copyright    --
--        notice, this list of conditions and the following disclaimer.     --
--     2. Redistributions in binary form must reproduce the above copyright --
--        notice, this list of conditions and the following disclaimer in   --
--        the documentation and/or other materials provided with the        --
--        distribution.                                                     --
--     3. Neither the name of the copyright holder nor the names of its     --
--        contributors may be used to endorse or promote products derived   --
--        from this software without specific prior written permission.     --
--                                                                          --
--   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS    --
--   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT      --
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR  --
--   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT   --
--   HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, --
--   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT       --
--   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,  --
--   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY  --
--   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT    --
--   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE  --
--   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.   --
--                                                                          --
------------------------------------------------------------------------------

--  A very simple draw application.
--  Use your finger to draw pixels.

with Last_Chance_Handler;  pragma Unreferenced (Last_Chance_Handler);
--  The "last chance handler" is the user-defined routine that is called when
--  an exception is propagated. We need it in the executable, therefore it
--  must be somewhere in the closure of the context clauses.

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
  --  Initialize LCD
  Display.Initialize(Landscape);
  Display.Initialize_Layer (Text_Layer, ARGB_8888, 0, 0, 320, 120);
  Display.Initialize_Layer (Graph_Layer, ARGB_8888, 0, 120, 320, 120);
  Init(Cardiac_Info);
  --  Initialize touch panel

  --  Initialize button
  --User_Button.Initialize;

  --  Clear LCD (set background)

  --  The application: set pixel where the finger is (so that you
  --  cannot see what you are drawing).
  --STM32.Board.Initialize_LEDs

  --TestADCProc;
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
