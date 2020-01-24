with HAL.Bitmap;            use HAL.Bitmap;

package body graph is
   procedure display_Cardiac_Graph(Display : in out Framebuffer_ILI9341.Frame_Buffer;
                                   Data : Data_Array;
                                   Width : Positive;
                                   Height : Positive
                                  ) is
      Index : Integer := 0;
   begin
      
      Display.Hidden_Buffer (1).Set_Source (HAL.Bitmap.Green);
      for I in Data'First .. Data'Last - 1 loop
         Draw_Line
                    (Display.Hidden_Buffer (1).all,
                     Start     => (Index * Width / Data'Length, Data(i)),
                     Stop      => ((Index + 1) * Width / Data'Length, Data(i + 1)),
                     Thickness => 2,
                     Fast      => False);
         Index := Index + 1;
      end loop;
      
      
      Display.Update_Layer (1, Copy_Back => True);
   end display_Cardiac_Graph;
end graph;
