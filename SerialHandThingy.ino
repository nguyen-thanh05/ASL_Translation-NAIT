#include <HardwareSerial.h>

HardwareSerial SerialPort(2); // use UART2
//Full open positions: 20, 40, 130, 10, 30
//L to R: 4, 1, 3, 0, 2
// closed: 170, 
//First val in second dimension is thumb, then index, middle, ring, etc
//First line A, B, C, D, E
//Second line F, G, H, I, J, K
//Third line L, M, N, O, P, Q
//Fourth line R, S, T, U, V, W
//Fifth line X, Y, Z
int CharacterVals[26][5] = {{20, 100, 100, 80, 80}, {100, 20, 20, 160, 160}, {90, 90, 90, 90, 90}, {100, 20, 80, 80, 80}, {100, 100, 80, 80, 80}, 
{90, 120, 20, 160, 160}, {90, 40, 100, 80, 80}, {90, 90, 100, 80, 80}, {100, 100, 100, 20, 160}, {90, 90, 90, 90, 90}, {90, 90, 90, 90, 90}, 
{90, 90, 90, 90, 90}, {90, 90, 90, 90, 90}, {90, 90, 90, 90, 90}, {90, 90, 90, 90, 90}, {90, 90, 90, 90, 90}, {90, 90, 90, 90, 90}, 
{90, 90, 90, 90, 90}, {90, 90, 90, 90, 90}, {90, 90, 90, 90, 90}, {90, 90, 90, 90, 90}, {90, 90, 90, 90, 90}, {90, 90, 90, 90, 90}, 
{90, 90, 90, 90, 90}, {90, 90, 90, 90, 90}, {90, 90, 90, 90, 90}}

void setup()  
{
  Serial.begin(115200);
  SerialPort.begin(15200, SERIAL_8N1, 16, 17);

  for(int i = 0; i < 26; i++) {
    for(int x = 0; x < 5; x++)  {
      CharacterVals[i][1] = i;
    }
  } 
}

void loop() {
  for(int i = 0; i < 26; i++) {
    for(int x = 0; x < 5; x++)  {
      Serial.println(CharacterVals[i][x]);
    }
  } 
  /*
  Serialport.println("0 90");
  Serialport.println("1 90");
  Serialport.println("2 90");
  Serialport.println("3 90");
  Serialport.println("4 90");
  */
}
