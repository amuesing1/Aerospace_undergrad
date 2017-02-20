#include <Servo.h>  // servo library
#include <LiquidCrystal.h>  //LCD library
//#include "DHT.h" //Temp and Hum library
//#define DHTPIN 13
//#define DHTTYPE DHT22

Servo servo1;  // servo control up/down
Servo servo2;  // servo control left/right
const int motorPin = 8;
LiquidCrystal lcd(6,5,3,3,2,1);
const int analogPin1 = A0;  //microphone
const int analogPin2 = A1;  //up
const int analogPin3 = A2;  //down
const int analogPin4 = A3;  //left
const int analogPin5 = A4;  //right
int MicValue = 0;
//DHT dht(DHTPIN, DHTTYPE);

void setup()
{
  servo1.attach(9);
  servo2.attach(10);
  pinMode(motorPin, OUTPUT);
  Serial.begin(9600);
  lcd.begin(16, 2);
  lcd.clear();
  //dht.begin();
}

void loop()
{
  /*servos*/
  int position;  // int for servo positioning
 /* if((A1)>15)
  {
    servo1.write(45);
    delay(20);
  }
  if((A2)>16)
  {
    servo1.write(135);
    delay(20);
  }
  if((A3)>17)
  {
    servo2.write(45);
    delay(20);
  }
  if((A4)>18)
  {
    servo2.write(135);
    delay(20);
  }*/
  if(servo1.read() != 90)
  {
    servo1.write(1);
    delay(20);
  }
  else if(servo2.read() != 90)
  {
   servo2.write(1);
    delay(20);
  }
  /*fan*/
  digitalWrite(motorPin, HIGH);  //turn the fan on high always
  /*temperature and humidity*/
  //dht.read22(DHTpin);
  /*float h = dht.readHumidity();  //reads hum
  float t = dht.readTemperature();  //& temp
  if (isnan(t) || isnan(h)) 
  {
    lcd.println("Failed to read from DHT");
  }
  else
  {
    lcd.setCursor(0,0);  //first line for printing on the LCD
    lcd.print("Humidity: "); 
    lcd.print(h);
    lcd.print(" %\t");
    lcd.setCursor(0,1);  //second line for printing on the LCD
    lcd.print("Temperature: "); 
    lcd.print(t);
    lcd.println(" *C");
  }*/
  /*jokes*/
  MicValue = analogRead(A0);
  if(MicValue>=1)
  {
    //code to play a joke
  }
  //Serial.println(A0);
  Serial.println(A1);
  //Serial.println(A2);
  //Serial.println(A3);
  //Serial.println(h);
  //Serial.println(t);
  //Serial.println(position);
  Serial.println(servo1.read());
}
