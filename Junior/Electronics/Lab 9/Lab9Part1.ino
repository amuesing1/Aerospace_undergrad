int pinSout = 12;
int pinM = 10;
int pinD = 8;
int pinV = 9;

void setup()
{
  pinMode(pinSout, OUTPUT); 
  pinMode(pinM, INPUT);
  pinMode(pinD, INPUT);
  pinMode(pinV, INPUT);
}
void loop()
{
  boolean pinDState = digitalRead(pinD);
  boolean pinVState = digitalRead(pinV);
  boolean pinMState = digitalRead(pinM);
  boolean pinSoutState;
  // and
  pinSoutState =pinMState & (pinDState | pinVState);
  digitalWrite(pinSout, pinSoutState);
}
