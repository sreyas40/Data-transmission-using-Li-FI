#define LED_PIN A1
#define BUTTON_PIN A0
#define PERIOD 3

char receivedString[100]; // Buffer to store received string
boolean newData = false; // Flag to indicate new data received
boolean ledState = HIGH; // Initial LED state

void setup() {
  pinMode(LED_PIN, OUTPUT);
  Serial.begin(115200); // Start serial communication
}

void loop() {
  if (newData) {
    transmitString(receivedString);
    newData = false; // Reset the flag after transmitting
    Serial.flush(); // Clear serial buffer after transmission
  }
  
  digitalWrite(LED_PIN, ledState); // Set LED pin based on ledState
}

void serialEvent() {
  static byte index = 0;
  while (Serial.available()) {
    char inChar = (char)Serial.read();
    if (inChar == '\n') { // Check for end of line
      receivedString[index] = '\0'; // Terminate the string
      index = 0; // Reset index for next string
      newData = true; // Set flag to indicate new data
    } else {
      receivedString[index] = inChar;
      index++;
      if (index >= 99) { // Avoid buffer overflow
        index = 0;
      }
    }
  }
}

void transmitString(char* string) {
  int string_length = strlen(string);
  for (int i = 0; i < string_length; i++) {
    sendByte(string[i]);
  }
  // After transmission, set ledState to LOW
  //ledState = LOW;
}

void sendByte(char my_byte) {
  digitalWrite(LED_PIN, LOW);
  delay(PERIOD);

  // Transmission of bits
  for (int i = 0; i < 8; i++) {
    digitalWrite(LED_PIN, (my_byte & (0x01 << i)) != 0);
    delay(PERIOD);
  }

  digitalWrite(LED_PIN, HIGH);
  delay(PERIOD);
}
