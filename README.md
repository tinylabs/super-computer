Supercomputer is a raspberry pi image based on raspian for the raspberry pi zero 2 w.  
Its purpose is to allow various standalone USB device (gadget) functionality. It requires a papirus zero hat for the UI.  

To use it:  
- Download the git repo  
  git clone https://github.com/tinylabs/super-computer.git
- Compile the code  
  ./generate_image.sh
- Install with the rpi imager
  - Use the "Custom image" option and point it to the compiled supercomputer.img.xz file.  
  - Make sure to click the gear icon to configure a user and WIFI credentials.  
  
![image1](./assets/sc3.jpeg)  
  
  
