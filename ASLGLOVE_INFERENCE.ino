#include "time.h"  // required for internal clock to syncronize with NTP server

#include <ArduinoJson.h>

/********************************************************************************
    EspMQTTClient Library by @plapointe6
    WiFi and MQTT connection handler for ESP32
    This library does a nice job of encapsulating the handling of WiFi and MQTT connections.
    You just need to provide your credentials and it will manage the connection and reconnections to the Wifi and MQTT networks.
    EspMQTTClient is a wrapper around the MQTT PubSubClient Library by @knolleary
********************************************************************************/
#include "EspMQTTClient.h"

#define MQTT_SERVER_IP    "159.203.31.239"
#define MQTT_USERNAME     "03716016a9c368fa6579a2d70ea944051ef876915c00d8689c3c489eae97782453"
#define MQTT_PASSWORD     "166857857f658f100f5834288c2a4ef6d9ebf5bbcbf62ad72d00c2b5ff8455f7bdb6793c81654de0365eca8921da20a93521abf2b31514a9e8ddfdb481c8f4133c8c06a0"
#define MQTT_CLIENT_NAME  "ASLGLOVE"    //this should be a "random" value. This value is ignored if you call WiFiMQTTclient.enableMACaddress_for_ClientName();
#define MQTT_SERVER_PORT  1884

#define WIFI_SSID         "Hotspot"
#define WIFI_PASS         "Jacobsen2021"

#define MQTT_BASE_TOPIC_flexSensor "DABfNNMU2w53Wi6oAk4ZBBF4foxi577dky/hacked/flexsensor"
#define MQTT_BASE_TOPIC_decodedCharacter "DABfNNMU2w53Wi6oAk4ZBBF4foxi577dky/decodedCharacter"

#define WIFI_SSID         "Hotspot"
#define WIFI_PASS         "Jacobsen2021"

int8_t TIME_ZONE = -7;
int16_t DST = 3600;

EspMQTTClient WiFiMQTTclient(
  WIFI_SSID,
  WIFI_PASS,
  MQTT_SERVER_IP,
  MQTT_USERNAME,
  MQTT_PASSWORD,
  MQTT_CLIENT_NAME,
  MQTT_SERVER_PORT);

// Assign ADC connections
const int ADC_0 = 13;
const int ADC_1 = 37;
const int ADC_2 = 38;
const int ADC_3 = 39;
const int ADC_4 = 34;
const int ADC_5 = 35;
const int ADC_6 = 12;
const int ADC_7 = 32;
const int ADC_8 = 33;
const int BUTTON_PIN = 36;

int flexValue_0 = 0;
int flexValue_1 = 0;
int flexValue_2 = 0;
int flexValue_3 = 0;
int flexValue_4 = 0;
int flexValue_5 = 0;
int flexValue_6 = 0;
int flexValue_7 = 0;
int flexValue_8 = 0;

int flexValue_previous_0 = 0;
int flexValue_previous_1 = 0;
int flexValue_previous_2 = 0;
int flexValue_previous_3 = 0;
int flexValue_previous_4 = 0;
int flexValue_previous_5 = 0;
int flexValue_previous_6 = 0;
int flexValue_previous_7 = 0;
int flexValue_previous_8 = 0;

int numSamples = 0;
int sumSamples_0 = 0;
int sumSamples_1 = 0;
int sumSamples_2 = 0;
int sumSamples_3 = 0;
int sumSamples_4 = 0;
int sumSamples_5 = 0;
int sumSamples_6 = 0;
int sumSamples_7 = 0;
int sumSamples_8 = 0;

int toggle = 0;

bool initialConnectionEstablished_Flag = false;  //used to detect first run after power up

//Frequency at which MQTT packets are periodically published
uint32_t UpdateInterval_MQTT_Publish = 500;  // 1 second
uint32_t previousUpdateTime_MQTT_Publish = millis();

// Frequency at which ADC is sampled
uint32_t UpdateInterval_SampleADC = 2500; 
uint32_t previousUpdateTime_SampleADC = millis();


/********************************************************************************
  Handler for received MQTT subscription
********************************************************************************/
void decodedCharacter_Handler(const String& payload) {

  // Serial.println("received mqtt packet");

  // The following assumes the received MQTT packet is json formatted like this:  {"character":"d"}
  StaticJsonDocument<256> doc;  //allocate memory on stack for the received MQTT JSON packets

  // Deserialize the JSON packet
  DeserializationError error = deserializeJson(doc, payload);
  // Test if parsing succeeds.
  if (error) {
    Serial.print(F("deserializeJson() failed: "));
    Serial.println(error.f_str());
    return;
  }

  const char* decodedCharacter = doc["character"];
  Serial.print("received decoded character: ");
  Serial.println(decodedCharacter);

}



/********************************************************************************
  This function is called once WiFi and MQTT connections are complete
  This must be implemented for EspMQTTClient to function
********************************************************************************/
void onConnectionEstablished() {

  if (!initialConnectionEstablished_Flag) {  //execute this the first time we have established a WiFi and MQTT connection after powerup
    initialConnectionEstablished_Flag = true;

    // sync local time to NTP server
    configTime(TIME_ZONE * 3600, DST, "pool.ntp.org", "time.nist.gov");

    // subscribe to Events Here
    WiFiMQTTclient.subscribe(MQTT_BASE_TOPIC_decodedCharacter, decodedCharacter_Handler);

    //wait for time to sync from NTP server
    while (time(nullptr) <= 100000) {
      delay(20);
    }

  }

  else {
    // subscribe to Events Here
    WiFiMQTTclient.subscribe(MQTT_BASE_TOPIC_decodedCharacter, decodedCharacter_Handler);
  }
}


//--------------------------------------------
// Mealy Finite State Machine
// The state machine logic is executed once each cycle of the "main" loop.
// For this simple application it just helps manage the connection states of WiFi and MQTT
//--------------------------------------------

enum State_enum { STATE_0,
                  STATE_1,
                  STATE_2 };  //The possible states of the state machine

State_enum state = STATE_0;  //initialize the starting state.

void StateMachine() {
  switch (state) {

    //--------------------------------------------
    // State 0
    // Initial state after ESP32 powers up and initializes the various peripherals
    // Transitions to State 1 once WiFi is connected
    case STATE_0:
      {
        if (WiFiMQTTclient.isWifiConnected()) {  //wait for WiFi to connect
          state = STATE_1;

          Serial.print("\nState: ");
          Serial.print(state);
          Serial.print("  WiFi Connected to IP address: ");
          Serial.println(WiFi.localIP());
        } else {
          state = STATE_0;
        }
        break;
      }

    //--------------------------------------------
    // State 1
    // Transitions to state 2 once connected to MQTT broker
    // Return to state 0 if WiFi disconnects
    case STATE_1:
      {
        if (!WiFiMQTTclient.isWifiConnected()) {  //check for WiFi disconnect
          state = STATE_0;
          Serial.print("\nState: ");
          Serial.print(state);
          Serial.println("  WiFi Disconnected");
        } else if (WiFiMQTTclient.isMqttConnected()) {  //wait for MQTT connect
          state = STATE_2;
          Serial.print("\nState: ");
          Serial.print(state);
          Serial.print("  MQTT Connected at local time: ");

          time_t now = time(nullptr);  //get current time
          struct tm* timeinfo;
          timeinfo = localtime(&now);
          char formattedTime[30];
          strftime(formattedTime, 30, "%r", timeinfo);
          Serial.println(formattedTime);

        } else {
          state = STATE_1;
        }
        break;
      }

    //--------------------------------------------
    // State 2
    // Return to state 0 if WiFi disconnects
    // Returns to state 1 if MQTT disconnects
    case STATE_2:
      {
        if (!WiFiMQTTclient.isWifiConnected()) {  //check for WiFi disconnect
          state = STATE_0;
          Serial.print("\nState: ");
          Serial.print(state);
          Serial.println("  WiFi Disconnected");
        } else if (!WiFiMQTTclient.isMqttConnected()) {  //check for MQTT disconnect
          state = STATE_1;
          Serial.print("\nState: ");
          Serial.print(state);
          Serial.println("  MQTT Disconnected");
        } else {
          state = STATE_2;
        }
        break;
      }
  }
}


void SampleADC_Periodically() {
  if (millis() - previousUpdateTime_SampleADC > UpdateInterval_SampleADC) {
    previousUpdateTime_SampleADC += UpdateInterval_SampleADC;


    //flexValue_0 = analogRead(ADC_0);      // Abandoned due to insignificant data
    flexValue_1 = analogRead(ADC_1);      // Read ADC Channel.  12 bit ADC range
    flexValue_2 = analogRead(ADC_2);      // Read ADC Channel.  12 bit ADC range
    flexValue_3 = analogRead(ADC_3);      // Read ADC Channel.  12 bit ADC range
    flexValue_4 = analogRead(ADC_4);      // Read ADC Channel.  12 bit ADC range
    flexValue_5 = analogRead(ADC_5);      // Read ADC Channel.  12 bit ADC range
    //flexValue_6 = analogRead(ADC_6);      // Abandoned due to insignificant data
    flexValue_7 = analogRead(ADC_7);      // Read ADC Channel.  12 bit ADC range
    flexValue_8 = analogRead(ADC_8);      // Read ADC Channel.  12 bit ADC range
    //Serial.println(flexValue_0);
    Serial.println(flexValue_1);
    Serial.println(flexValue_2);
    Serial.println(flexValue_3);
    Serial.println(flexValue_4);
    Serial.println(flexValue_5);
    //Serial.println(flexValue_6);
    Serial.println(flexValue_7);
    Serial.println(flexValue_8);


    if (WiFiMQTTclient.isMqttConnected()) {  //check if MQTT is connected
      
      // Create json with values = array of 5 integers.
      StaticJsonDocument<256> doc;  // 96 bytes are minimum amount of memory needed to store array of 5 values. Reserve 256 bytes in case we want to increase the size of the array
      JsonArray values = doc.createNestedArray("values");

      //values.add(flexValue_0);
      values.add(flexValue_1);
      values.add(flexValue_2);
      values.add(flexValue_3);
      values.add(flexValue_4);
      values.add(flexValue_5);
      //values.add(flexValue_6);
      values.add(flexValue_7);
      values.add(flexValue_8);

      

      char output[256];
      serializeJson(doc, output);  //serialize the json so we can send it via MQTT
      Serial.println(output);
      Serial.println(" ");
      Serial.println(" ");
      Serial.println(numSamples);
      Serial.println(" ");
      Serial.println(" ");

      if(digitalRead(BUTTON_PIN) == 1)  {
        WiFiMQTTclient.publish(MQTT_BASE_TOPIC_flexSensor, output);  //send json packet
      }
      toggle = 0;
    } else {
      Serial.println("Gathering Data......");
    }
    
  }
}


/********************************************************************************
  Configure peripherals and system
********************************************************************************/
void setup() {

  Serial.begin(115200);  // Initialize Serial Connection for debug
  while (!Serial && millis() < 20)
    ;  // wait 20ms for serial port adapter to power up

  Serial.println("\n\nStarting Simple_MQTT_ESP32");

  pinMode(BUTTON_PIN, INPUT);    // initialize on button pin

  // Optional Features of EspMQTTClient
  // WiFiMQTTclient.enableDebuggingMessages();  // Enable MQTT debugging messages
}


/********************************************************************************
  MAIN LOOP
********************************************************************************/
void loop() {

  //--------------------------------------------
  // Process state machine
  StateMachine();

  //--------------------------------------------
  // Handle the WiFi and MQTT connections
  WiFiMQTTclient.loop();

  //--------------------------------------------
  // Periodically Sample ADC and send MQTT packet

   SampleADC_Periodically();
}