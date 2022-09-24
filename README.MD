## Git Assignment repository for COSC345.2022S2

https://forms.gle/mEvZEQ5y2Hp62gf19

## StudyShare

An inclusive app designed to assist in facilitating shared learning experiences!

## Badges

[![Build/Run Tests](https://github.com/Matthew-G-Jennings/StudyShare/actions/workflows/ios.yml/badge.svg)](https://github.com/Matthew-G-Jennings/StudyShare/actions/workflows/ios.yml)

[![Codacy Badge](https://app.codacy.com/project/badge/Grade/1da7d59373e3416b807513bcc87d15ab)](https://www.codacy.com/gh/Matthew-G-Jennings/StudyShare/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=Matthew-G-Jennings/StudyShare&amp;utm_campaign=Badge_Grade)

[![codecov](https://codecov.io/gh/Matthew-G-Jennings/StudyShare/branch/main/graph/badge.svg?token=5CN4FZIA13)](https://codecov.io/gh/Matthew-G-Jennings/StudyShare)

## Alpha Testing
Testers found that spelling check was annoying for logging in - this feature is now turned off.

Testers found the transcription save button does nothing -  this is fixed and can now create a class and save the transcript.

Testers found the app had a fixed size - our app now resizes according to the devices, this ensures full app visiblity on every iPhone/iPad.

## Beta Testing
Users wanted more info - will add more detailed cells with more information.

Users found button contrast too low -  will increase button brightness.

Users want the options to edit transcriptions - will add this as an option.

Users want to add images into the transcriptions - out of scope for what the app was meant to do.

Bugs founds:
Puttings spaces into the filename for a saved transcription causes the app to crash.

## Leak Testing
![image](https://user-images.githubusercontent.com/84311461/192069030-8faf4cc2-3509-4b6f-bfe6-7e85675d07b7.png)
![image](https://user-images.githubusercontent.com/84311461/192069403-a9dbe93e-8e36-417d-9eb7-afc6a2b62cfd.png)

With Xcode's leak checker we found a memory leak in our library when running the application. It appears to be leaking in the external libraries and not so much in our code. We are keeping an eye on this to ensure our app runs smoothly and avoids any crashing.

## CPU profiling
![image](https://user-images.githubusercontent.com/97982879/192091759-d7496137-32a7-49ca-8d21-d4f707795415.png)
The appears ordinary and as expected. Difficult to benchmark without a point of comparison but this will serve as a benchmark for future builds.

## Code Sources/References
Firebase authentication/logins - codewithchris

Speech to text - developer.apple.com (no longer exists here, has been replaced with SwiftUI based system, fundamentally the same)

Database interactions - firebase documentation/guides

Storage interactions - firebase documentation/guides

https://www.anycodings.com/1questions/4119941/optimizing-get-from-firestore-in-swift

https://www.anycodings.com/1questions/4243830/how-to-init-firebase-storage-image-in-flutter

https://www.youtube.com/watch?v=s27S6H1bM0w

koffler swift5 (book, not english)

apple developer documentation

