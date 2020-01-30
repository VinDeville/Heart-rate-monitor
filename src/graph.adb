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
      Current : Integer := Data(Offset + 1);
   begin
      Display.Hidden_Buffer (1).Set_Source (BG);
      Display.Hidden_Buffer (1).Fill;
      Display.Hidden_Buffer (1).Set_Source (HAL.Bitmap.Green);
      for I in Data'First + Offset + 1 .. Data'Last loop
         Draw_Line
                    (Display.Hidden_Buffer (1).all,
                     Start     => (Index * Width / Data'Length, Current* Height / 1024),
                     Stop      => ((Index + 1) * Width / Data'Length, Data(i) * height / 1024),
                     Thickness => 1,
                     Fast      => False);
         Index := Index + 1;
         Current := Data(i);
      end loop;
      for I in Data'First .. Data'First + Offset loop
         Draw_Line
                    (Display.Hidden_Buffer (1).all,
                     Start     => (Index * Width / Data'Length, Current* Height / 1024),
                     Stop      => ((Index + 1) * Width / Data'Length, Data(i) * height / 1024),
                     Thickness => 1,
                     Fast      => False);
         Index := Index + 1;
         Current := Data(i);
      end loop;
      Display.Update_Layer (1, Copy_Back => True);
   end display_Cardiac_Graph;
end graph;
