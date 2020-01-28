
with Framebuffer_ILI9341;
package graph is

   type Data_Array is array (Positive range <>) of Integer;
   procedure display_Cardiac_Graph(Display :  in out Framebuffer_ILI9341.Frame_Buffer;
                                   Data : Data_Array;
                                   Offset : Integer;
                                   Width : Positive;
                                   Height : Positive
                                  );

end graph;
