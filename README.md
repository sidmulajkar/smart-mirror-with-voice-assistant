# Smart-mirror-with-Voice-Assistant-Raspberrypi
The world is moving fast and we are constantly left wanting for time and finding out things that can be postponed or cancelled just because we run out of time in the day. They say every second counts and we considered this saying in the best of  letter and spirit. We normally spend about 20-25 minutes in-front of a mirror in our daily lives. We planned to make this time also productive and useful to the person using the mirror. We are moving towards a world with smart things and appliances. In the proposed idea we present an Interactive Smart Mirror with various features to make sure that every minute of the user is utilized properly. The smart mirror will be acting as a Personal Digital Assistant providing day-today schedule and appointments pulling the information from the users account, it is also capable of displaying real time information such as live weather updates, local time of a particular location and also helps the person to get in touch with the current affairs happening around the world. The Smart Mirror would help in developing smart houses with embedded artificial intelligence, as well as finding its applications in industries. Further, the mirror can also be used to control anything with your voice as it also gets Virtual Voice Assistant services.

<img src=mirror.jpg>

MagicMirror² Module Development Documentation
This document describes the way to develop your own MagicMirror² modules.

Table of Contents:

Module structure

Files
The Core module file: modulename.js

Available module instance properties
Subclassable module methods
Module instance methods
Visibility locking
The Node Helper: node_helper.js

Available module instance properties
Subclassable module methods
Module instance methods
MagicMirror Helper Methods

Module Selection
MagicMirror Logger

General Advice
As MagicMirror has gained huge popularity, so has the number of available modules. For new users and developers alike, it is very time consuming to navigate around the various repositories in order to find out what exactly a certain modules does, how it looks and what it depends on. Unfortunately, this information is rarely available, nor easily obtained without having to install it first. Therefore we highly recommend you to include the following information in your README file.

A high quality screenshot of your working module
A short, one sentence, clear description what it does (duh!)
What external API's it depend on, including web links to those
Wheteher the API/request require a key and the user limitations of those. (Is it free?)
Surely this also help you get better recognition and feedback for your work.

Module structure
All modules are loaded in the modules folder. The default modules are grouped together in the modules/default folder. Your module should be placed in a subfolder of modules. Note that any file or folder your create in the modules folder will be ignored by git, allowing you to upgrade the MagicMirror² without the loss of your files.

A module can be placed in one single folder. Or multiple modules can be grouped in a subfolder. Note that name of the module must be unique. Even when a module with a similar name is placed in a different folder, they can't be loaded at the same time.

Files
modulename/modulename.js - This is your core module script.
modulename/node_helper.js - This is an optional helper that will be loaded by the node script. The node helper and module script can communicate with each other using an intergrated socket system.
modulename/public - Any files in this folder can be accesed via the browser on /modulename/filename.ext.
modulename/anyfileorfolder Any other file or folder in the module folder can be used by the core module script. For example: modulename/css/modulename.css would be a good path for your additional module styles.
