
#include <Wire.h>
uint32_t readings;

void setup()
{
  Wire.begin();        // join i2c bus as master
  Serial.begin(9600);  // start serial for output
}

void loop()
{
  Wire.requestFrom(2, 4);    // request 4 bytes from slave device #2
  int thisByte = 0;
  while(Wire.available())    // slave may send less than requested
  { 
    char c = Wire.read(); // receive a byte as character
    int offset = thisByte*8;
    for(int i = 0; i < 8; i++){
      bool thisBit = bitRead(c, i);
      bitWrite(readings,offset+i, thisBit);
    }
    thisByte++;
  }

  for(int i = 0; i < 20; i++){
   bool thisBit = bitRead(readings, i); 
   Serial.print(thisBit);
  }
  Serial.println();
  
  delay(500);
}
