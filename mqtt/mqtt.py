import paho.mqtt.client as mqtt
import random
from json import loads, JSONDecodeError, dumps

import threading

ADDRESS = "159.203.31.239"
PORT = 1884
USER = "03716016a9c368fa6579a2d70ea944051ef876915c00d8689c3c489eae97782453"
PASSWORD = "166857857f658f100f5834288c2a4ef6d9ebf5bbcbf62ad72d00c2b5ff8455f7bdb6793c81654de0365eca8921da20a93521abf2b31514a9e8ddfdb481c8f4133c8c06a0"
TOPIC = "DABfNNMU2w53Wi6oAk4ZBBF4foxi577dky/hacked/flexsensor"


class MQTT:
    queue = []
    subscribed = False
    _disconnect = False

    def __init__(self, callBack, debug=False):
        client_id = f'python-mqtt-{random.randint(0, 1000)}'
        self.client = mqtt.Client(client_id=client_id, clean_session=True, protocol=mqtt.MQTTv31, transport="tcp")
        self.client.on_message = self.on_message
        self.client.on_connect = self.on_connect
        self.client.on_connect_fail = self.on_fail
        self.client.on_disconnect = self.on_disconnect
        self.client.on_subscribe = self.on_subscribe
        self.client.username_pw_set(USER, PASSWORD)
        self._debug = debug

        self.sub = threading.Thread(target=self.subscribe)
        self.sub.start()

        self.send = threading.Thread(target=self.sendQueue)
        self.send.start()

        self.callBack = callBack


    def subscribe(self):
        self.client.connect(ADDRESS, PORT, 60)
        self.client.loop_forever()


    def on_connect(self, client, userdata, flags, rc):
        if (self._debug):
            print("Connected with result code " + str(rc))
        client.subscribe(TOPIC, qos=0)


    def on_message(self, client, userdata, msg):
        """
        """
        try:
            if (self.callBack != None):
                self.callBack(loads(msg.payload.decode("utf-8")))
        except JSONDecodeError:
            print("Error decoding JSON, ignoring message")
            pass


    def send_message(self, data):
        """
        Send message to the MQTT broker

        :param data: Dictionary that contains data
        :return: none
        """
        self.queue.append(data)

    def on_disconnect(self, client, userdata, rc):
        if (self._debug):
            print("Disconnected")


    def on_fail(self, client, userdata, rc):
        if (self._debug):
            print("Connection failed")


    def on_subscribe(self, client, userdata, mid, granted_qos):
        self.subscribed = True

    def disconnect(self):
        self.callBack = None
        self.client.disconnect()
        self._disconnect = True


    def sendQueue(self):
        while not self._disconnect:
            if (self.subscribed and self.client.is_connected()):
                if len(self.queue) > 0:
                    try:
                        self.client.publish(TOPIC, dumps(self.queue[0]))
                    except Exception as e:
                        if (self._debug):
                            print(f"Error sending message {e}")
                    self.queue.pop(0)
    

