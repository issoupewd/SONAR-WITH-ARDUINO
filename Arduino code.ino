// SONAR : movement detection with ultrasonic sensor by issou : Arduino uno , servo motor , ultrason

#include <Servo.h>

const int TX = 9; //the TRIG pin
const int RX = 10; // the ECHO pin
Servo Bservo; // our base servo

int servoPos = 0; //first servo position 
int BsDirec = 1; // for controlling base servo step and direction 
unsigned long BsMoveT = 20; // base servo moving time , as a servo clock 
unsigned long BsMoved = 0; // last move

long duration;
int distance;

void setup() {
 // put your setup code here, to run once:
  Bservo.attach(7);  
  Serial.begin(9600);
  pinMode(TX, OUTPUT);
  pinMode(RX, INPUT);
}

void loop() {
  // put your main code here, to run repeatedly:  

  //servo part
  if (millis() - BsMoved >= BsMoveT) {
    BsMoved = millis();
    Bservo.write(servoPos);
    servoPos += BsDirec; // add one degree 
    if (servoPos >= 180 || servoPos <= 0) {
      BsDirec *= -1; // reverse direction 
    }
  }

  //ultrason part
  digitalWrite(TX, LOW);
  delayMicroseconds(2);
  digitalWrite(TX, HIGH);
  delayMicroseconds(10);
  digitalWrite(TX, LOW);
  duration = pulseIn(RX, HIGH);
  distance = 0.034*duration / 2;

  //processing part
  Serial.print(distance);
  Serial.print(",");
  Serial.println(servoPos);

  delay(100);
}



