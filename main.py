import torch
import torch.nn as nn
from torch.nn import functional as F
from mqtt.mqtt import MQTT

input_dictionay = {}

class Model(nn.Module):
    def __init__(self):
        super(Model, self).__init__()
        self.conv_layers = nn.Sequential(nn.Conv1d(in_channels=1, out_channels=4, kernel_size=3),
                                    nn.Dropout1d(0.25),
                                    nn.ReLU(),
                                    nn.Conv1d(in_channels=4, out_channels=8, kernel_size=2),
                                    nn.Dropout1d(0.25),
                                    nn.ReLU(),
                                    nn.Conv1d(in_channels=8, out_channels=16, kernel_size=2),
                                    nn.Dropout1d(0.25),
                                    nn.ReLU(),
                                    )
        
        self.linear = nn.Linear(16 * 3, 64)
        self.dropout = nn.Dropout(0.25)
        self.out = nn.Linear(64, 26)
        
    def forward(self, x):
        x = self.conv_layers(x)
        x = nn.Flatten()(x)
        x = nn.ReLU()(self.dropout(self.linear(x)))
        x = self.out(x)
        #x = nn.LogSoftmax()(x)
        return x
    
model = Model()
model = torch.load("ASL_interpreter.pt").cuda()
model.eval()   


def callback(dict):
    
    
    input_as_int = [int(element) for element in dict["values"]]
    input_tensor = torch.tensor(input_as_int, dtype=torch.FloatTensor).unsqueeze().cuda()
    input_tensor /= 4095
    
    prediction = nn.Softmax(dim = 1)(model(input_tensor))
    pred_class = torch.argmax(prediction, dim = 1)
    
    output = pred_class.detach().cpu().item()

def main():
    
    Mqtt_connection = MQTT(callback)
    

if __name__ == '__main__':
    main()