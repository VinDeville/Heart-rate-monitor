

with stm32;
with Peripherals_Blocking;  use Peripherals_Blocking;
with Serial_IO.Blocking;    use Serial_IO.Blocking;
with Message_Buffers;       use Message_Buffers;
with LCD_Std_Out;

package body uart is

  procedure uartProcedure is
    Incoming : aliased Message (Physical_Size => 8);  -- arbitrary size
  begin

    Initialize (COM);
    Configure (COM, Baud_Rate => 9_600);
    loop
      Get (COM, Incoming'Unchecked_Access);
      LCD_Std_Out.Clear_Screen;
      LCD_Std_Out.Put_Line (Content(Incoming));
    end loop;
  end uartProcedure;

end uart;
