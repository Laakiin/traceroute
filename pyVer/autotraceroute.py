#!/usr/bin/env python3
import os
sudo=os.getuid()

if sudo != 0:
    print("You have to run this program with super user privileges.")
    exit
print("test")
