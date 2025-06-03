# vdi-auto-login

I made a VDI auto login script taking my credentials from 1password

## Pre-requisites:
- your creds are in 1password stored under Okta-emea GDS
- you’ve enabled google authenticator, and used 1password for that
- you’ve installed tesseract and imagemagick (`brew install tesseract imagemagick`)
- you cross your fingers and hope


opens the horizon app, takes your browser through the auth journey, and puts your password into the login prompt, also should work when the VDI locks through inactivity throughout the day

FML - why have I had to create this monster?!!


— yes it screenshots the VDI and OCR’s the content to wait for the password prompt to appear, yes if you run this and anywhere on the screen it says `Password` and its not the password prompt, it will blindly type your password and push return - so be warned, only run it when you’re logged out, improvements to more intelligently check its actually at the login prompt welcome
