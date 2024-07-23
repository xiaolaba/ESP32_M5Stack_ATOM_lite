REM uses flash mode DIO, ESP32
REM 2022-10-09, ESP32_Frequency_generation_2MHz_10MHz.ino firmware
REM burn test ok

:: To erase esp32 completely, do not rely on Arduino IDE and code upload, it has cluster and odd thing when uses FATFS, 
:: unless format SPIFFS or FATFS everytime on the fly
:: xiaolaba, 2020-MAR-02
:: Arduino 1.8.16, esptool and path,

REM %userprofile%

@echo off

cls
prompt $xiao


:: drag & drop bin
set BIN=%~n1
set EXT=%~x1
echo %BIN% %EXT%


set comport=COM6
REM set esptoolpath="C:\Users\user0\AppData\Local\Arduino15\packages\esp32\tools\esptool_py\3.1.0/esptool.exe"
REM set esptoolpath="%userprofile%\AppData\Local\Arduino15\packages\esp32\tools\esptool_py\3.1.0/esptool.exe"
REM set esptoolpath="%userprofile%\AppData\Local\Arduino15\packages\esp32\tools\esptool_py\4.2.1/esptool.exe"
set esptoolpath="esptool_4.2.1.exe"
REM set esptoolpath="esptool2.5.0.exe"

set MCU=esp32
set BAUDRATE=921600
REM set BAUDRATE=512000

:: input filename by drag & drop to this batch file
set project=%1%

::goto merge
goto drag_drop_merge


:: erase whole flash of esp32
%esptoolpath% --chip %MCU% ^
--port %comport% ^
--baud %BAUDRATE% ^
erase_flash




REM pause

REM burn firmware
%esptoolpath% --chip %MCU% ^
--port %comport% ^
--baud %BAUDRATE% ^
--before default_reset ^
--after hard_reset write_flash -z ^
--flash_mode dio ^
--flash_freq 80m ^
--flash_size detect ^
0x1000 %project%.ino.bootloader.bin ^
0x8000 %project%.ino.partitions.bin ^
0xe000 boot_app0.bin ^
0x10000 %project%.ino.esp32.bin

pause




rem C:\Users\user0\AppData\Local\Arduino15\packages\esp32\tools\esptool_py\4.2.1/esptool.exe" 
--chip esp32 --port "COM5" --baud 921600  
--before default_reset 
--after hard_reset write_flash  -z 
--flash_mode dio 
--flash_freq 80m 
--flash_size 4MB 
0x1000 C:\Users\user0\AppData\Local\Temp\arduino_build_289407/sketch.ino.bootloader.bin 
0x8000 C:\Users\user0\AppData\Local\Temp\arduino_build_289407/sketch.ino.partitions.bin 
0xe000 C:\Users\user0\AppData\Local\Arduino15\packages\esp32\hardware\esp32\2.0.12/tools/partitions/boot_app0.bin 
0x10000 C:\Users\user0\AppData\Local\Temp\arduino_build_289407/sketch.ino.bin 

esptool.py v4.2.1


:merge

::uses Arduino IDE, upload code, log will see the temp folder of bin

%esptoolpath% ^
--chip %MCU% ^
 merge_bin ^
-o %project%_%MCU%_merged-flash.bin ^
--flash_mode dio ^
--flash_size 4MB ^
 0x1000 %project%.ino.bootloader.bin ^
 0x8000 %project%.ino.partitions.bin ^
 0xe000 boot_app0.bin ^
 0x10000 %project%.ino.esp32.bin




:drag_drop_merge

::uses Arduino IDE, upload code, log will see the temp folder of bin
:: copy the bin files and burn code script
:: rename to boot*.bin bpartion.bin

%esptoolpath% ^
--chip %MCU% ^
 merge_bin ^
-o %project%_%MCU%_merged-flash.bin ^
--flash_mode dio ^
--flash_size 4MB ^
 0x1000 bootloader.bin ^
 0x8000 bpartitions.bin ^
 0xe000 boot_app0.bin ^
 0x10000 %project%


pause
