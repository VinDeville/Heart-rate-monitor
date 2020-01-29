with stm32;
with Peripherals_Blocking;  use Peripherals_Blocking;
with Serial_IO.Blocking;    use Serial_IO.Blocking;
with Message_Buffers;       use Message_Buffers;
with LCD_Std_Out;
with HAL;           use HAL;

package body uart is

  procedure uartProcedure is
      I : Uint32;
      Count : Integer := 0;
   begin

    Initialize (COM);
    Configure (COM, Baud_Rate => 9_600);
   
      
    loop
        
         Get_UART_Value (COM, I, 2);
         LCD_Std_Out.Clear_Screen;
         LCD_Std_Out.Put_Line (I'Image);
    end loop;
  end uartProcedure;

end uart;
