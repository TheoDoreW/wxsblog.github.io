#!/usr/bin/python3
# -*- coding: utf-8 -*-

"""
Date: 23/11/2020
Author: Xinsheng Wang
Description: A Python Script to Send Messages to Azure Eventhub
Requires: azure.eventhub in python
"""

import logging
import uuid
import time
import random
import json

from azure.eventhub import EventHubProducerClient
from azure.eventhub import EventData

def run():
    # Create a producer client to send messages to the event hub.
    # Specify a connection string to your event hubs namespace and the event hub name.
    event_data_batch = producer.create_batch()
    event_data_batch.add(EventData(s))
    producer.send_batch(event_data_batch)
if __name__=="__main__":
    CONNECTION_STR = "Endpoint=sb://streamingdemoehns01.servicebus.chinacloudapi.cn/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    EVENTHUB_NAME = "ingestion"
    producer = EventHubProducerClient.from_connection_string(conn_str=CONNECTION_STR, eventhub_name=EVENTHUB_NAME)
    # -------------------------------------------------------
    # This is the global variables to create some sample data
    # --------------------------------------------------------
    storeids = [1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013, 1014, 1015, 1016, 1017, 1018, 1019, 1020, 1021, 1022, 1023, 1024, 1025, 1026, 1027, 1028, 1029, 1030]
    products = [
        [1, "Chefs Knife", "Kitchen", 15.99],
        [2, "Spatula", "Kitchen", 2.99],
        [3, "Wooden Spoon", "Kitchen", 1.99],
        [4, "Knife Block", "Kitchen", 10.99],
        [5, "Roasting Pan", "Kitchen", 17.99],
        [6, "Saucepan", "Kitchen", 21.99],
        [7, "Blender", "Kitchen", 25.99],
        [8, "Toaster", "Kitchen", 30.99],
        [9, "Rice Cooker", "Kitchen", 29.99],
        [10, "Cutting Board", "Kitchen", 12.99],
        [11, "Grill", "Outdoors", 159.99],
        [12, "Dog Bed", "Pets", 30.00],
        [13, "Litter Box", "Pets", 30.00],
        [14, "CoughSyrup", "Medicine", 15.00],
        [15, "Bowl", "Kitchen", 10.00],
        [16, "Dishwasher", "Kitchen", 899.00],
        [17, "Microwave", "Kitchen", 150.00],
        [18, "Refrigerator", "Kitchen", 999.00],
        [19, "Dust Bin", "Kitchen", 8.50],
        [20, "Nutcracker", "Kitchen", 5.00],
        [21, "Bathtub", "Bathroom", 1500.00],
        [22, "Shampoo", "Bathroom", 50.00],
        [23, "Toothbrush", "Bathroom", 15.00],
        [24, "Slippers", "Bathroom", 12.00],
        [25, "Shaver", "Bathroom", 198.00],
        [26, "Climbing Boots", "Bathroom", 200.00],
        [27, "Climbing Trousers", "Bathroom", 198.00],
        [28, "Glacier Cap", "Bathroom", 180.00],
        [29, "Sunglasses", "Bathroom", 528.00],
        [30, "Mattress", "Bathroom", 120.00]
    ]
    keepRunning = True
    #This will run for about 2.5 hours which should be fine for labs and demos
    for y in range(0,2000):
        # Get a product from the products variable
        product = products[random.randint(13,13)]
        # define a reading as a python dictionary object
        reading = {'storeId': storeids[random.randint(0, 29)],
            'timestamp': time.time(),
            'producttype': product[0],
            'name': product[1],
            'category': product[2],
            'price': product[3],
            'quantity': random.randint(1,3)
        }
        # Add some intrigue...
        if product[1] == "Cough Syrup":
            reading['quantity'] += 10
        # use json.dumps to convert the dictionary to a JSON format
        s = json.dumps(reading)
        run()
        print(s)
        time.sleep(10)
