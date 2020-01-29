
#include "Arduino.h"

void setup() {
  // put your setup code here, to run once:
  //pulseSensor.analogInput(PulseWire);
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
 uint16_t value = analogRead(0);


 Serial.write(value >> 8);
 Serial.write(value);
 delay(50);
}
