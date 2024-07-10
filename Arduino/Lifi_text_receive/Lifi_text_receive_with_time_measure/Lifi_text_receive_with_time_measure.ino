#define LED_PIN 3
#define LDR_PIN A0
#define THRESHOLD 500
#define PERIOD 2

bool previous_state;
bool current_state;

void setup() 
{
    Serial.begin(115200);
    pinMode(LED_PIN, OUTPUT);
}

void loop() 
{
  current_state = get_ldr();
  if(!current_state && previous_state)
  {
    unsigned long start_time = micros();
    char received_byte = get_byte();
    unsigned long end_time = micros();
    print_byte(received_byte);
    unsigned long time_taken = end_time - start_time;
    //Serial.print(" Time taken: ");
    //Serial.println(time_taken);
  }
  previous_state = current_state;
}

bool get_ldr()
{
  int voltage = analogRead(LDR_PIN);
  return voltage > THRESHOLD ? false : true;
}

char get_byte()
{
  char ret = 0;
  delay(PERIOD * 1.5);
  for(int i = 0; i < 8; i++)
  {
   ret = ret | get_ldr() << i; 
   delay(PERIOD);
  }
  return ret;
}

void print_byte(char my_byte)
{
  char buff[2];
  sprintf(buff, "%c", my_byte);
  Serial.print(buff);
}
