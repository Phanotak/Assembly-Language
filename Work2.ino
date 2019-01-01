extern "C" void doit();
extern "C" void USART_Init();

void setup() {
  USART_Init();
  doit();
}

void loop() {
}

