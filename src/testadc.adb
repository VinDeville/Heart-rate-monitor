with STM32.Board;  use STM32.Board;
with STM32.Device; use STM32.Device;
with STM32.PWM;    use STM32.PWM;

with HAL;          use HAL; --adc library
with STM32.ADC;    use STM32.ADC; --adc library
with STM32.GPIO;   use STM32.GPIO; --adc library

with Ada.Real_Time;  use Ada.Real_Time; --adc library

with LCD_Std_Out;
package body TestADC is

   procedure TestADCProc is
   Converter     : Analog_To_Digital_Converter renames ADC_1; --adc instruction
   Input_Channel : constant Analog_Input_Channel := 1; --adc instruction, channel 1
   Input1         : constant GPIO_Point := PA1; --adc instruction, PA1 port

   All_Regular_Conversions : constant Regular_Channel_Conversions :=
          (1 => (Channel => Input_Channel, Sample_Time => Sample_3_Cycles)); --adc instruction

   Raw : UInt32 := 0; --adc instruction

   Successful : Boolean; --adc instruction


   procedure Configure_Analog_Input is --adc instruction
   begin -- adc
      Enable_Clock (Input1); --adc instruction
      Configure_IO (Input1, (Mode => Mode_Analog, Resistors => Floating)); -- adc instruction
   end Configure_Analog_Input; --adc instruction

begin

   Initialize_LEDs; --adc instruction

   Configure_Analog_Input; --adc instruction

   Enable_Clock (Converter); --adc instruction

   Reset_All_ADC_Units; --adc instruction

   Configure_Common_Properties --adc instruction
     (Mode           => Independent, --adc instruction
      Prescalar      => PCLK2_Div_2, --adc instruction
      DMA_Mode       => Disabled, --adc instruction
      Sampling_Delay => Sampling_Delay_5_Cycles); --adc instruction

   Configure_Unit --adc instruction
     (Converter, --adc instruction
      Resolution => ADC_Resolution_12_Bits, --adc instruction
      Alignment  => Right_Aligned); --adc instruction

   Configure_Regular_Conversions --adc instruction
     (Converter, --adc instruction
      Continuous  => False, --adc instruction
      Trigger     => Software_Triggered, --adc instruction
      Enable_EOC  => True, --adc instruction
      Conversions => All_Regular_Conversions); --adc instruction

   Enable (Converter); --adc instruction

   declare
      Value     : Percentage;
--      Raw1      : Long_Float;
--      setpoint  : constant := 1480.0; -- 1.084 volts approx - 43 lx
--      setpoint  : constant := 2067.0; -- 1.514 volts approx - 86 lx
--      error     : Long_Float := 0.0;
--      output    : Long_Float;
--      integral  : Long_Float := 0.0;
--      dt        : constant := 0.0005;
--      Kp        : constant := 0.025;
--         Ki        : constant := 0.025;
        Max : UInt32 := UInt32'First;
        Min : UInt32 := UInt32'Last;

   begin
         loop
         Start_Conversion (Converter); --adc instruction
         Poll_For_Status (Converter, Regular_Channel_Conversion_Complete, Successful); --adc instruction
         Raw := UInt32 (Conversion_Value (Converter)); -- reading PA1
         --Raw1 := Long_Float(Raw * 1);
         --error := (setpoint - Raw1);
         --integral := (integral + (error*dt));
         --output := ((Kp*error) + (Ki*integral));
         --Value := Percentage (output); -- duty cycle value

               LCD_Std_Out.Clear_Screen;
               LCD_Std_Out.Put_Line (Raw'Image);
            delay until Clock + Milliseconds (100);
      end loop;
   end;
   end TestADCProc;
end TestADC;
