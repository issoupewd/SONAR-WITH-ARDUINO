import processing.serial.*;


PFont font;
Serial arduino;
int radius = 350; // Radius of the radar circle
int distance = 0; // Variable to store distance data
int servoPos = 0; // Variable to store servo position data
color radarLineColor = color(255, 0, 0); // Radar line color 
boolean objectDetected = false; 
float dotSize = 0; 
float dotDistance = 0; 


void setup() {
  size(1000, 800);
  font = createFont("Arial", 20);
  textFont(font);

  // Setup Arduino communication
  String[] ports = Serial.list();
  for (String port : ports) {
    if (port.startsWith("COM9") || port.startsWith("/COM9")) { // Adjust based on your system
      arduino = new Serial(this, port, 9600);
      break;
    }
  }
}

void draw() {
  background(0);
  translate(width / 2, height / 2);

 

  // Draw radar lines
  stroke(0, 0, 255);
  for (int i = 0; i <= 180; i += 5) {
    float rad = radians(i - 180);
    line(cos(rad) * radius, sin(rad)*radius, 0, 0);
  }

  // Read data from Arduino
  while (arduino.available() > 0) {
    String data = arduino.readStringUntil('\n');
    if (data != null) {
      data = trim(data);
      String[] values = split(data, ',');
      if (values.length == 2) {
        distance = int(values[0]);
        servoPos = int(values[1]);

        // Check if an object is detected within proximity (e.g., 40 cm)
        objectDetected = (distance <= 70);
        if (objectDetected) {
          // Adjust the size of the red dot based on distance
          dotSize = map(distance, 0, 70, 10, 30);
          // Adjust the distance of the red dot from the center based on distance
          dotDistance = map(distance, 0, 70, 0, radius);
        } else {
          dotSize = 0; // No red dot if no object detected
          dotDistance = 0; // Reset dot distance
        }
      }
    }
  }

  // Display angle and distance
  fill(255);
  textAlign(LEFT);
  text("Angle: " + servoPos + " degrees", -360, 200);
  text("Distance: " + distance + " cm", -360, 220);

  // Calculate the endpoint of the radar line
  float angle = radians(servoPos + 180);
  float x = radius * cos(angle);
  float y = radius * sin(angle);

  // Draw the radar line
  strokeWeight(3); // Thicker radar line
  stroke(radarLineColor);
  line(0,0, x, y);

  
  

  // Draw the red dot for object detection
  fill(0, 255, 0);
  noStroke();
  ellipse(dotDistance * cos(angle), dotDistance * sin(angle), dotSize, dotSize);
}
