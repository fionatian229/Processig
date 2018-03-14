/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;
import processing.sound.*;
int hour;
int minute;
int timeOFdayINminutes;

OscP5 oscP5;
NetAddress myRemoteLocation;
int counter = 0;
boolean hello = false;
boolean bye = false;
int offset = 100;

void setup() {
  size(400, 400);
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12001);

  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress("127.0.0.1", 12001);
}


void draw() {
  background(0);
  textSize(24);
    hour=hour();
  minute=minute();
  timeOFdayINminutes = hour*60 + minute;

  //displaying the text according to the data received from wekinator
  if (hello && (timeOFdayINminutes >= 680)&& (timeOFdayINminutes <= 690)) {
    text("Hello guys!", width/2 - offset, height/2);
    println("Very Happy");
  } else if (bye) {
    text("Bye Bye!", width/2 - offset, height/2);
  } else {
    text(" Nothing special.", width/2 - offset, height/2);
  }
}

void mousePressed() {
  /* in the following different ways of creating osc messages are shown by example */
  //OscMessage myMessage = new OscMessage("/test");

  //myMessage.add(123); /* add an int to the osc message */

  /* send the message */
  //oscP5.send(myMessage, myRemoteLocation);
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* check if theOscMessage has the address pattern we are looking for. */
  println(counter + " /wek/outputs received " + theOscMessage);

  if (theOscMessage.checkTypetag("f")) {

    //unpacking the 'classifier' value
    float firstValue = theOscMessage.get(0).floatValue();  
    println(" values: "+firstValue);

    //setting flags for who is printing and who is not
    if (firstValue == 1) {
      hello = true;
    } else if (firstValue == 2) {
      bye = true;
    } else {
      hello = false;
      bye = false;
    }
  }

  //counter to for console debugging purpose to see the progress
  counter++;
}