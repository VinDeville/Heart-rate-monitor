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
with STM32.User_Button;     use STM32;
with BMP_Fonts;
with LCD_Std_Out;
with graph; use graph;

procedure Main 
is
   BG : constant Bitmap_Color := (Alpha => 0, others => 0);

   procedure Clear;

   -----------
   -- Clear --
   -----------

   procedure Clear is
   begin
      Display.Hidden_Buffer (1).Set_Source (BG);
      Display.Hidden_Buffer (1).Fill;

      LCD_Std_Out.Clear_Screen;
      
      --LCD_Std_Out.Put_Line ("Touch the screen to draw or");
      --LCD_Std_Out.Put_Line ("press the blue button for");
      --LCD_Std_Out.Put_Line ("a demo of drawing primitives.");
      --LCD_Std_Out.Put_Line (Positive'Image(Display.Pixel_Size(1)));


      Display.Update_Layer (1, Copy_Back => True);
   end Clear;

   type Mode is (Drawing_Mode, Bitmap_Showcase_Mode);

   Current_Mode : Mode := Drawing_Mode;

begin

   --  Initialize LCD
   Display.Initialize(Landscape);
   Display.Initialize_Layer (1, ARGB_8888, 0, 0, 240, 120);
   --  Initialize touch panel
   
   --  Initialize button
   User_Button.Initialize;
   
   --  Clear LCD (set background)

   --  The application: set pixel where the finger is (so that you
   --  cannot see what you are drawing).
   loop
      display_Cardiac_Graph(Display,
                            (120, 0, 120, 0, 120, 0, 120, 0, 120, 0, 120, 0,
                             120, 0, 120, 0, 120, 0, 120, 0, 120, 0, 120, 0,
                             120, 0, 120, 0, 120, 0, 120, 0, 120, 0, 120, 0),
                            0,
                            240,
                            120
                           );
      delay 0.1;
      display_Cardiac_Graph(Display,
                            (120, 0, 120, 0, 120, 0, 120, 0, 120, 0, 120, 0,
                             120, 0, 120, 0, 120, 0, 120, 0, 120, 0, 120, 0,
                             120, 0),
                            1,
                            240,
                            120
                           );
      delay 0.1;
   end loop;
end Main;
