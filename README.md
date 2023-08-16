# vomo

## Project Structure

Service - stores our sevices, like the recording service and the notification service

Model - contains the storage and the models for different persistently saved items within the application

ViewModel - Contains shared model that many views access

Core - contains a folder for each of the main views and their componenets that directly relate to each

Components - Items that are used across multiple views 

Graphs - Graph interface, in a serparate folder because of its complexity and need to quickly view and edit

Extensions - Useful tools and functions that are extended off of classes

## Testing Through App Center

Once you've been added to the App Center Team by another member, follow these steps to install the latest Vomo release on your iPhone.

1. You’ll need to login to the App Center website on your iPhone by signing in with your UC Microsoft Account

2. You should see a header that says “My apps,” with Vomo underneath. Go ahead and tap this to get the Overview menu, pictured below. Tap the download icon in the top right.

3. Click “Add Device” and “Allow” when the configuration profile prompt comes up.

4. Next, go to Settings->General->VPN & Device Management->App Center Device Registration Service and click “Install” in the top right.

5. Assuming the installation went ok, you should be redirected to a screen with another “Install” button next to latest release. Hit this install button, and the app will begin downloading in the background.

6. The app should now be on your phone. You could try to run it, but it will show an “Untrusted Enterprise Developer” error. Go back to Settings->General->VPN & Device Management and under “The University of Cincinnati” you should be able to tap the trust button.

7. You should now be able to launch the app!

**Note: For future updates, you should only have to click the download button on the App Center Overview screen for Vomo.**

## Knowledge Base

**Collecting Logs from iOS Devices**

Run `sudo log collect --device` while connected to the iOS device with a Mac
Open resulting .logarchive in Console.app. Add flag `--last 4h` to collect last 4 hours of logs
