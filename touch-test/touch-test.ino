void setup() {
  pinMode(9, INPUT);
  Serial.begin(115200);
}

void loop() {
  Serial.println(analogRead(9));
  delay(100);
}
