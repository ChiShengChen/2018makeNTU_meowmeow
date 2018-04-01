void setup() {
  pinMode(A0, INPUT);
  Serial.begin(115200);
}

void loop() {
  Serial.println(analogRead(A0));
  delay(100);
}
