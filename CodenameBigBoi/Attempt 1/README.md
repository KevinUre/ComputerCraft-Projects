# Attempt 1

This was the first crack at controlling this reactor. It appears that the messaging frequency is too high for the CC middleware to move events around the network. Because of the timeouts inherent to the the safety system this resulted in all sorts of unwanted behaviors. Changing timeouts and messaging frequencies did not alliterate the back-pressure issues and a completely new approach is probably needed.

## Shortcomings

### Back-pressure

as mentioned above the system regularly encounters messaging back-pressure and is ill equipped to handle it, almost by design.

### Lack of injectable configuration

all sensor modules had their sensor target locations hardcoded at the top of each file. this is not as dry as it could be, although im not sure current OTA can handle multiple files

### No OTA (or OTW)

VSCode on the minecraft server was pretty much the only way to reasonably update the control systems