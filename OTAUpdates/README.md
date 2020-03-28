# OTA Updates

## Setup

The workers to be updated all need a wireless modem (turtle or computer). the application they run on startup should be in a file called `app` and the side of the modem put into the variable in `bootloader`.
The application to load must be parallelizable, i.e. it must use something like `sleep(0)` to yield to the OTA listener on occasion.

The station that issues the updates must have a wireless modem, and it's side must be put into the variable in `OTALoader`

## Use

The new application must be uploaded to pastebin.

`OTALoader <code> worker-label1 worker-label2 ...`

ex. `OTALoader ET8mS6v2 farmer-1 farmer-2`
