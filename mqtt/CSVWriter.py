from mqtt import MQTT
import csv
import os
from string import ascii_lowercase, ascii_uppercase
import time
from colorama import Fore, Back, Style
from threading import Thread
from collections import deque

letter = input("Letter:")

class CSVWriter:
    queue = []
    some = ""
    count = 0
    interval = 1000
    MAX = 1000
    file = 0
    index = 0
    buffer = ""
    render = 0

    def __init__(self) -> None:
        self.mqtt = MQTT(self.on_message)
        self.index = ascii_uppercase.index(letter)+1

        Thread(target=self.display).start()
        self.render = 0

    def display(self):
        while self.render != 3:
            if (self.render == 0):
                os.system("clear")
                print(f"{Fore.WHITE}Current Count: {Fore.CYAN}{self.count} / {self.MAX}{Fore.WHITE}\nCurrent Letter: {Fore.YELLOW}{ascii_uppercase[self.index-1]}{Fore.WHITE}\n")
                
                print("[" + Fore.GREEN + int((self.count/self.MAX)*35.0)*"=" + (35-int((self.count/self.MAX)*35.0))*" " + Fore.WHITE + "]\n")
                print(self.some)
                time.sleep(0.5)


    def timer(self):
        timer = 5
        for i in range(timer):
            os.system("clear")
            print(f"{Fore.RED}Finished {ascii_uppercase[self.index-1]}\nNext letter is {Fore.YELLOW}{ascii_uppercase[self.index]}{Fore.RED}")
            print(f"Starting in:{Fore.GREEN} {str(timer-i)}")
            time.sleep(1.0)


    def on_message(self, data):
        self.render = 0
        if self.count < self.MAX:
            if (self.count % (self.interval+1) < self.interval):
                self.queue.append(data['values'])
                self.some = data['values']
            else:
                self.writeFile()
            self.count += 1
        else:
            self.render = 1
            self.mqtt.disconnect()
            self.writeFile()
            self.some.clear()
            self.count = 0
            if self.index >= len(ascii_lowercase):
                os.system("clear")
                print("Finished All Letters")
                self.render = 3
                return

            self.timer()

            self.index += 1
            self.file = 0
            
            os.system("clear")
            print(f"{Fore.GREEN}Current Letter: {Fore.YELLOW}{ascii_uppercase[self.index-1]}{Fore.GREEN}\nGo!")

            self.mqtt = MQTT(self.on_message)

    def writeFile(self):
        with open(f"./letters/{ascii_lowercase[self.index-1]}.csv", 'w') as f:
            writer = csv.writer(f, delimiter=',')
            writer.writerows(self.queue)
        self.file += 1
        self.queue.clear()


CSVWriter()
