# Watson IoT Gateway for EnOcean – Introduction

Gateway to integrate EnOcean devices to Watson IoT platform.

## How to use  

Refer recipe ... for detailed information on how to use this source code. In short this code runs inside the Fhem process enabling Fhem to call Watson IoT embedded 'C' client API's.

## Dependencies
[Watson IOT Embedded C client](https://github.com/ibm-messaging/iotf-embeddedc)

## Watson IoT–EnOcean Gateway client

### Hardware requirements:
* Raspberry Pi - 2 (model 1 is also expected to work, but recipe not tested on it)
* EnOcean kit containing devices and the EnOcean receiver preferably USB300 which was used for testing this recipe.

### Software requirements:
* Fhem server 5.7 (Last released version: as of 2015-11-15) installed on Raspberry Pi.
* Perl interpreter
  >We will need “perlxs” to build our gateway. To ensure that we can build perlxs modules check for “xsubpp” executable in “bin” directory of your device Perl installation.  
`Note:` In case Perl is not installed on Raspberry Pi (to check type perl -v on Raspberry Pi command line), use the below commands to install Perl  
  * sudo apt-get install perl libdevice-serialport-perl libio-socket-ssl-perl libwww-perl 
  * sudo apt-get install –f 

  >`Note:` It is recommended that you go through the section “Raspberry PI with EnOcean” at http://fhem.de/fhem.html#Links to ensure you have latest information about setting up Fhem with Raspbeery Pi and EnOcean.  
  
* IBM Watson IoT Embedded 'C' client libraries.  
  Link to source code:  https://github.com/ibm-messaging/iotf-embeddedc

## Steps to build Watson IoT Gateway for EnOcean

### Downloading the source code  
* Clone the Watson IoT gateway repository using command **git clone https://github.com/WatsonIoT-Ecosystem/iot_enocean.git iot-enocean**  
`   ` This will create a directory *iot-enocean* in your current directory containing all the source code needed for building the gateway.
* Change to directory *iot-enocean* and run the script *getiotfc.sh*  
`   ` This will create a directory *gtw* in your parent directory and clone the Watson IoT Embedded 'C' client repository into it.  
**`Note:`** It is important that directory *gtw* is created in the same directory as *iot-enocean*

### Building the Watson IoT Embedded 'C' client library  

* Change to directory *gtw*
* Run *setup.sh* to download the dependencies
* Change to directory *gtw/src*
* Run *buildlib.sh* to build Watson IoT Embedded 'C' client shared library “libiotf.so”   
`   ` This will create a directory *build* in *gtw/src*, containing libiotf.so.

### Building Watson IoT gateway library

* Change back to directory *iot-enocean*. This is the directory where Makefile.PL resides.  

* Run the following commands in sequence  

   * sudo perl Makefile.PL  
        `   ` This will generate the Makefile needed to build the code
   * sudo make  
        `   ` This will generate a new shared library named “enoceaniot.so”
   * sudo make install	
        `   ` This command will copy the various files and shared library “enoceaniot.so” to appropriate directories in the Perl installation.  
          * <b>Example output:</b>  
       <i>Files found in blib/arch: installing files in blib/lib into architecture dependent library tree  
Installing /usr/local/lib/perl/5.14.2/auto/enoceaniot/enoceaniot.bs  
Installing /usr/local/lib/perl/5.14.2/auto/enoceaniot/enoceaniot.so  
Installing /usr/local/lib/perl/5.14.2/enoceaniot.pm  
Installing /usr/local/lib/perl/5.14.2/auto/enoceaniot/autosplit.ix  
Installing /usr/local/man/man3/enoceaniot.3pm  
Appending installation info to /usr/local/lib/perl/5.14.2/perllocal.pod</i></font>  
  
* Copy the Watson IoT Embedded 'C' client library *libiotf.so* from gtw/src/build that you just built to /usr/lib.  
`Note:` you will need root privileges to do this. On Raspberry pi use “sudo cp ….” to do this copy as root.
* Copy file *98_ENOCEANIOT.pm* from iot-enocean to /opt/fhem/FHEM directory. This is the directory where Fhem will install by default.
`Note:` you will need root privileges to do this. On Raspberry pi use “sudo cp ….” to do this copy as root.

**`On completion:`** You will have the all the required libraries built and installed at appropriate location.  
To verify run the command *define testObj ENOCEANIOT* on telnet command line. No error verifies that everything went successfully.


