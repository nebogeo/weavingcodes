//this code reads the first 4 pins and transmits over i2c

#include <Wire.h>

#define CS0 8
#define CS1 9
#define CS2 10

#define MUXA 5
#define MUXB 6
#define MUXC 7

#define READ A0

#define STATUS 13

uint32_t readings;

void setup() {
  //init 4051 pins
  pinMode(CS0, OUTPUT);
  pinMode(CS1, OUTPUT);
  pinMode(CS2, OUTPUT);
  pinMode(MUXA, OUTPUT);
  pinMode(MUXB, OUTPUT);
  pinMode(MUXC, OUTPUT);
  pinMode(READ, INPUT);
  
  //status led 
  pinMode(STATUS, OUTPUT);
  
  //set input inhibit high on 4051s
  digitalWrite(CS0, HIGH);
  digitalWrite(CS1, HIGH);
  digitalWrite(CS2, HIGH); 
  
  //set all mux pins low
  digitalWrite(MUXA, LOW);
  digitalWrite(MUXB, LOW);
  digitalWrite(MUXC, LOW);  
 
  //start serial 
  Serial.begin(9600); 
  
  //start i2c 
  Wire.begin(2);
  Wire.onRequest(wireReq);
  
}

void wireReq(){
  readPins();
  Wire.write(readings);
}

void loop() {
  
  //readPins();
  
  delay(50); 
}

void readPins(){
  digitalWrite(STATUS, HIGH);
  //select first chip 
  digitalWrite(CS0, LOW);
  //all MUX lines low = input 0 
  //read the input
  int in0 = digitalRead(READ);
  Serial.print("0: ");
  Serial.print(in0);
  Serial.print("    ");
  
  //input 1
  digitalWrite(MUXA, HIGH);
  digitalWrite(MUXB, LOW);  
  digitalWrite(MUXC, LOW);  
  int in1 = digitalRead(READ);
  digitalWrite(MUXA, LOW);
  digitalWrite(MUXB, LOW);  
  digitalWrite(MUXC, LOW);    
  Serial.print("1: ");
  Serial.print(in1);
  Serial.print("    ");  
  
  //input 2
  digitalWrite(MUXA, LOW);
  digitalWrite(MUXB, HIGH);  
  digitalWrite(MUXC, LOW);  
  int in2 = digitalRead(READ);
  digitalWrite(MUXA, LOW);
  digitalWrite(MUXB, LOW);  
  digitalWrite(MUXC, LOW);    
  Serial.print("2: ");
  Serial.print(in2);
  Serial.print("    ");    
  
  //input 3
  digitalWrite(MUXA, HIGH);
  digitalWrite(MUXB, HIGH);  
  digitalWrite(MUXC, LOW);  
  int in3 = digitalRead(READ);
  digitalWrite(MUXA, LOW);
  digitalWrite(MUXB, LOW);  
  digitalWrite(MUXC, LOW);    
  Serial.print("3: ");
  Serial.print(in3);
  Serial.print("    ");  
  
  bitWrite(readings, 0, in0);
  bitWrite(readings, 1, in1);
  bitWrite(readings, 2, in2);
  bitWrite(readings, 3, in3);

  digitalWrite(STATUS, LOW);

  Serial.print(readings);  
  Serial.println();
}
