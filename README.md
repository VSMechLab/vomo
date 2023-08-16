# vomo

## Project Structure

Service - stores our sevices, like the recording service and the notification service

Model - contains the storage and the models for different persistently saved items within the application

ViewModel - Contains shared model that many views access

Core - contains a folder for each of the main views and their componenets that directly relate to each

Components - Items that are used across multiple views 

Graphs - Graph interface, in a serparate folder because of its complexity and need to quickly view and edit

Extensions - Useful tools and functions that are extended off of classes

## Knowledge Base

**Collecting Logs from iOS Devices**

Run `sudo log collect --device` while connected to the iOS device with a Mac
Open resulting .logarchive in Console.app. Add flag `--last 4h` to collect last 4 hours of logs
