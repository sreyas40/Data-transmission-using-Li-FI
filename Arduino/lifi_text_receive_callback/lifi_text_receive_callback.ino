#define LED_PIN A1
#define BUTTON_PIN A0
#define PERIOD 2

char receivedString[250];
boolean newData = false;
boolean ledState = HIGH;

void setup() {
    pinMode(LED_PIN, OUTPUT);
    Serial.begin(115200);
}

void loop() {
    if (newData) {
        transmitString(receivedString);
        newData = false;
        Serial.flush();
        // Send confirmation signal to Matlab
        Serial.println("Next");
    }
    
    digitalWrite(LED_PIN, ledState);
}

void serialEvent() {
    static byte index = 0;
    while (Serial.available()) {
        char inChar = (char)Serial.read();
        if (inChar == '\n') {
            receivedString[index] = '\0';
            index = 0;
            newData = true;
        } else {
            receivedString[index] = inChar;
            index++;
            if (index >= 249) {
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
}

void sendByte(char my_byte) {
    digitalWrite(LED_PIN, LOW);
    delay(PERIOD);

    for (int i = 0; i < 8; i++) {
        digitalWrite(LED_PIN, (my_byte & (0x01 << i)) != 0);
        delay(PERIOD);
    }

    digitalWrite(LED_PIN, HIGH);
    delay(PERIOD);
}
