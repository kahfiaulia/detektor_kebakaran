import processing.serial.*;
import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import cc.arduino.*;

Arduino arduino;
String myText="";
Capture video;
OpenCV opencv;

color off = color(4, 79, 111);
color on = color(84, 145, 158);

int[] values = { Arduino.LOW, Arduino.LOW, Arduino.LOW, Arduino.LOW, 
  Arduino.LOW, Arduino.LOW, Arduino.LOW, Arduino.LOW, Arduino.LOW, 
  Arduino.LOW, Arduino.LOW, Arduino.LOW, Arduino.LOW, Arduino.LOW };

void setup() {
  size(640, 480);
  arduino = new Arduino(this, "COM4", 9600);

  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);
  opencv.loadCascade("haarcascade_api2.xml");

  video.start();

  for (int j = 7; j <= 13; j++)
    arduino.pinMode(j, Arduino.OUTPUT);
  for (int j = 1; j <= 6; j++)
    arduino.pinMode(j, Arduino.INPUT);
  
}

void draw() {

  println();
  scale(2);
  opencv.loadImage(video);

  image(video, 0, 0 );

  noFill();
  stroke(255, 0, 0);
  strokeWeight(3);
  Rectangle[] api = opencv.detect();
  println(api.length);

  for (int i = 0; i < api.length; i++) {
    println(api[i].x + "," + api[i].y);
    rect(api[i].x, api[i].y, api[i].width, api[i].height);  

    if (api.length > 0) {
      arduino.digitalWrite(13, Arduino.HIGH);
      values[13] = Arduino.HIGH;
      arduino.digitalWrite(8, Arduino.HIGH);
      values[8] = Arduino.HIGH;
    }

    if (api.length == 0 || values[13] == Arduino.HIGH) {
      arduino.digitalWrite(13, Arduino.LOW);
      values[13] = Arduino.LOW;
      arduino.digitalWrite(8, Arduino.LOW);
      values[8] = Arduino.LOW;
    }
    
  }
  for (int j = 1; j <= 6; j++) {
    if (arduino.digitalRead(j) == Arduino.HIGH){
      arduino.digitalWrite(13, Arduino.HIGH);
       values[13] = Arduino.HIGH;
       arduino.digitalWrite(8, Arduino.HIGH);
       values[8] = Arduino.HIGH;
    }
    else{
      arduino.digitalWrite(13, Arduino.LOW);
      values[13] = Arduino.LOW;
      arduino.digitalWrite(8, Arduino.LOW);
      values[8] = Arduino.LOW;
    }
  }
}
void captureEvent(Capture c) {
  c.read();
}

public void stop() {
  video.stop();
  super.stop();
}
