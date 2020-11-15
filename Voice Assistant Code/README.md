## L3-37 Alexa
---
Companion code for the following Project by PatchBOTS

<a href="http://www.youtube.com/watch?feature=player_embedded&v=H4KK212-Jss
" target="_blank"><img src="http://img.youtube.com/vi/H4KK212-Jss/0.jpg" 
alt="IMAGE ALT TEXT HERE" width="240" height="180" border="10" /></a>

Video Tutorial:

<a href="http://www.youtube.com/watch?feature=player_embedded&v=nn37prRCmNE
" target="_blank"><img src="http://img.youtube.com/vi/H4KK212-Jss/0.jpg" 
alt="IMAGE ALT TEXT HERE" width="240" height="180" border="10" /></a>


---
### Prerequisites:
An Amazon Developer account, and an Alexa Voice Service product profile.
Intructions here:
https://developer.amazon.com/docs/alexa-voice-service/register-a-product.html


### Install Steps
---
Clone me:
```
git clone https://github.com/henrymendez/l3-37-alexa_patchbots
```

Run the setup script.
```bash
./setup.sh
```

It will prompt you for your AVS ProducID, ClientID, & DeviceSerialNumber.

**Make sure you use the correct ClientID or you will get authentication errors
when trying to start the app.**

Read:
> Click on the Security Profile link under the Details and management section, 
> then go to Other devices and platforms from the Web - Android/Kindle - iOS - Other devices and platforms options.
> https://developer.amazon.com/docs/alexa-voice-service/input-avs-credentials.html

```bash
Enter your ProductID: SomeID
Enter your ClientID: myverylongclientidfromamazon
Enter your DeviceSerialNumber (Can be anything): 42
```

The script will update the following files with your AVS Id's and 
set the proper directory paths required to run.
* config/AlexaClientSDKConfig.json
* source/avs-device-sdk/SampleApp/src/UIManager.cpp

The setup script will install all the required packages and compile the code.
Go grab a beer (or two), it will take awhile to finish.

Once the setup finishes, you can now start the app by using the l337.sh script.
```bash
./l337.sh run
```
When the app starts for the first time, you'll need to authorize it before it will work.

Look for the following line in the output.
```
################################################################################################
#       To authorize, browse to: 'https://amazon.com/us/code' and enter the code: XXXXXX       #
################################################################################################
```

If all went well, you'll see the following:
```
########################################
#       Alexa is currently idle!       #
########################################
```

Now you try asking it something!
> L3, what time is it?

### Starting on boot
---
If you want to start this app automatically on boot, you can run autostart.sh.
You will need to run it via sudo because systemd requires root privileges
```bash
sudo ./autostart.sh on
```
To disable it from starting on boot:
```bash
sudo ./autostart.sh off
```
To stop the service after making it start on boot:
```bash
sudo systemctl stop l337
```
To start the service after making it start on boot:
```bash
sudo systemctl start l337
```

### Making changes
---
If you want to make futher code changes you'll need to recompile the app.
You can use the l337.sh script to recompile the code without losing your changes to AlexaClientSDKConfig.json
and waste time trying to install the required packages.
```bash
./l337.sh rebuild
```

### Further reading:
---
PathBOTS github:
<https://github.com/PatchBOTS>

AVS Service state with LEDs:
<https://developer.amazon.com/docs/alexa-voice-service/indicate-device-state-with-leds.html>

AVS Service state with Sounds:
<https://developer.amazon.com/docs/alexa-voice-service/indicate-device-state-with-sounds.html>

Snowboy doc:
<http://docs.kitt.ai/snowboy/>

