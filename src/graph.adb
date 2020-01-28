with HAL.Bitmap;            use HAL.Bitmap;

package body graph is
   
   
   procedure display_Cardiac_Graph(Display : in out Framebuffer_ILI9341.Frame_Buffer;
                                   Data : Data_Array;
                                   Offset : Integer;
                                   Width : Positive;
                                   Height : Positive
                                  ) is
      Index : Integer := 0;
      BG : constant Bitmap_Color := (Alpha => 255, others => 64);
   begin
      Display.Hidden_Buffer (1).Set_Source (BG);
      Display.Hidden_Buffer (1).Fill;
      Display.Hidden_Buffer (1).Set_Source (HAL.Bitmap.Green);
      for I in Data'First + Offset .. Data'Last - 1 loop
         Draw_Line
                    (Display.Hidden_Buffer (1).all,
                     Start     => (Index * Width / Data'Length, Data(i)),
                     Stop      => ((Index + 1) * Width / Data'Length, Data(i + 1)),
                     Thickness => 1,
                     Fast      => False);
         Index := Index + 1;
      end loop;
      if Offset /= 0 then
         Draw_Line
                 (Display.Hidden_Buffer (1).all,
                     Start     => (Index * Width / Data'Length, Data(Data'Last)),
                     Stop      => ((Index + 1) * Width / Data'Length, Data(Data'First)),
                     Thickness => 1,
                     Fast      => False);
         Index := Index + 1;   
      end if;
      for I in Data'First + 1 .. Data'First + Offset - 1 loop
         Draw_Line
                    (Display.Hidden_Buffer (1).all,
                     Start     => (Index * Width / Data'Length, Data(i)),
                     Stop      => ((Index + 1) * Width / Data'Length, Data(i + 1)),
                     Thickness => 1,
                     Fast      => False);
         Index := Index + 1;
      end loop;
      
      
      Display.Update_Layer (1, Copy_Back => True);
   end display_Cardiac_Graph;
end graph;
