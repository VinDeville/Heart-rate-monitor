with stm32;
with STM32.Board;           use STM32.Board;
with HAL.Bitmap;            use HAL.Bitmap;
with HAL.Framebuffer;       use HAL.Framebuffer;
with Peripherals_Blocking;  use Peripherals_Blocking;
with Serial_IO.Blocking;    use Serial_IO.Blocking;
with Message_Buffers;       use Message_Buffers;
with LCD_Std_Out;
with HAL;           use HAL;
with graph;         use graph;

package body uart is

  procedure uartProcedure is
    I : Uint32;
    Data : Data_Array (1 .. 100) := (others => 0);
    Counter : Integer := 0;
  begin

    Initialize (COM);
    Configure (COM, Baud_Rate => 9_600);


    for J in Data'Range loop
      Get_UART_Value (COM, I, 2);
      Data(J) := Integer(I); 
    end loop;
    loop
      display_Cardiac_Graph(Display, Data, Counter, 320, 120);
      for J in 1 .. 10 loop
        Get_UART_Value (COM, I, 2);
        Data(Counter + J) := Integer(I); 
      end loop;
      Counter := Counter + 10;
      if Counter >= Data'Last then
        Counter := 0;
      end if;
    end loop;
  end uartProcedure;

end uart;
