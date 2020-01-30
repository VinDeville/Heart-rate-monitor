with Framebuffer_ILI9341;
package graph 
is

  type Data_Array is array (Positive range <>) of Integer;
  procedure display_Cardiac_Graph(Display :  in out Framebuffer_ILI9341.Frame_Buffer;
                                  Data : Data_Array;
                                  Offset : Natural;
                                  Width : Positive;
                                  Height : Positive;
                                  Layer : Positive
                                  ) with
    Pre => Offset < Data'Last - 1 and then
           Display.width  >= Width and then
           Display.height >= Height and then
           Display.Initialized;

end graph;
