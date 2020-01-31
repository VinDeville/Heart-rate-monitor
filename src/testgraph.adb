with graph;                 use graph;
with STM32.Board;           use STM32.Board;
with HAL.Bitmap;            use HAL.Bitmap;
with HAL.Framebuffer;       use HAL.Framebuffer;
package body TestGraph is
   
   procedure testGraphDisplay is
      Data : Data_Array (1 .. 200) := (others => 512);
   begin
      Display.Initialize(Landscape);
      Display.Initialize_Layer (1, ARGB_8888, 0, 0, 320, 240);
      for I in Data'First .. Data'First + Data'Length/2 loop
        Data(I) := (1023 * i) / (Data'Length / 2); 
      end loop;
      for I in Data'First + Data'Length / 2 .. Data'Last loop
        Data(I) := 1023 - (1023 * (i - Data'Length / 2)) / (Data'Length / 2); 
      end loop;
      display_Cardiac_Graph(Display, Data, 0, 320, 240, 1);
      loop
         null;
      end loop;
   end;
end TestGraph;
