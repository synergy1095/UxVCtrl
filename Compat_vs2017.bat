@cd /d "%~dp0"

@md "%TMP%\UxVCtrl"

@set /P DISABLE_KINECT2="Disable Kinect2 (0, 1 (recommended)) : "
@set /P DISABLE_CLEYE="Disable CLEye (0, 1 (recommended)) : "
@set /P DISABLE_BLUEVIEW="Disable BlueView (0, 1 (recommended)) : "
@set /P DISABLE_MAVLINK="Disable MAVLink (0, 1) : "
@set /P DISABLE_LABJACK="Disable LabJack (0, 1) : "
@set /P DISABLE_LIBMODBUS="Disable libmodbus (0, 1) : "
@set /P DISABLE_SBG="Disable SBG (0, 1) : "
@echo.

@if "%DISABLE_KINECT2%"=="1" (

@echo Disabling Kinect2 

@replaceinfile /infile UxVCtrl.vcxproj /outfile "%TMP%\UxVCtrl\UxVCtrl.vcxproj" /searchstr ";ENABLE_CVKINECT2SDKHOOK" /replacestr ""
@copy /Y /B "%TMP%\UxVCtrl\UxVCtrl.vcxproj" UxVCtrl.vcxproj

@replaceinfile /infile UxVCtrl.vcxproj /outfile "%TMP%\UxVCtrl\UxVCtrl.vcxproj" /searchstr ";$(KINECTSDK20_DIR)\inc" /replacestr ""
@copy /Y /B "%TMP%\UxVCtrl\UxVCtrl.vcxproj" UxVCtrl.vcxproj

@replaceinfile /infile UxVCtrl.vcxproj /outfile "%TMP%\UxVCtrl\UxVCtrl.vcxproj" /searchstr ";$(KINECTSDK20_DIR)\Lib\x86" /replacestr ""
@copy /Y /B "%TMP%\UxVCtrl\UxVCtrl.vcxproj" UxVCtrl.vcxproj

@replaceinfile /infile UxVCtrl.vcxproj /outfile "%TMP%\UxVCtrl\UxVCtrl.vcxproj" /searchstr ";Kinect20.lib" /replacestr ""
@copy /Y /B "%TMP%\UxVCtrl\UxVCtrl.vcxproj" UxVCtrl.vcxproj
)

@if "%DISABLE_CLEYE%"=="1" (

@echo Disabling CLEye

@replaceinfile /infile UxVCtrl.vcxproj /outfile "%TMP%\UxVCtrl\UxVCtrl.vcxproj" /searchstr ";ENABLE_CVCLEYESDKHOOK" /replacestr ""
@copy /Y /B "%TMP%\UxVCtrl\UxVCtrl.vcxproj" UxVCtrl.vcxproj

@replaceinfile /infile UxVCtrl.vcxproj /outfile "%TMP%\UxVCtrl\UxVCtrl.vcxproj" /searchstr ";$(CLEYESDK_DIR)\Include" /replacestr ""
@copy /Y /B "%TMP%\UxVCtrl\UxVCtrl.vcxproj" UxVCtrl.vcxproj

@replaceinfile /infile UxVCtrl.vcxproj /outfile "%TMP%\UxVCtrl\UxVCtrl.vcxproj" /searchstr ";$(CLEYESDK_DIR)\Lib" /replacestr ""
@copy /Y /B "%TMP%\UxVCtrl\UxVCtrl.vcxproj" UxVCtrl.vcxproj

@replaceinfile /infile UxVCtrl.vcxproj /outfile "%TMP%\UxVCtrl\UxVCtrl.vcxproj" /searchstr ";CLEyeMulticam.lib" /replacestr ""
@copy /Y /B "%TMP%\UxVCtrl\UxVCtrl.vcxproj" UxVCtrl.vcxproj

@echo Please note that CLEye is incompatible with Kinect2
)

@if "%DISABLE_BLUEVIEW%"=="1" (

@echo Disabling BlueView

@replaceinfile /infile UxVCtrl.vcxproj /outfile "%TMP%\UxVCtrl\UxVCtrl.vcxproj" /searchstr ";ENABLE_BLUEVIEW_SUPPORT" /replacestr ""
@copy /Y /B "%TMP%\UxVCtrl\UxVCtrl.vcxproj" UxVCtrl.vcxproj

@replaceinfile /infile UxVCtrl.vcxproj /outfile "%TMP%\UxVCtrl\UxVCtrl.vcxproj" /searchstr ";$(BVTSDK_DIR)\include" /replacestr ""
@copy /Y /B "%TMP%\UxVCtrl\UxVCtrl.vcxproj" UxVCtrl.vcxproj

@replaceinfile /infile UxVCtrl.vcxproj /outfile "%TMP%\UxVCtrl\UxVCtrl.vcxproj" /searchstr ";$(BVTSDK_DIR)\x86\vc15\lib" /replacestr ""
@copy /Y /B "%TMP%\UxVCtrl\UxVCtrl.vcxproj" UxVCtrl.vcxproj

@replaceinfile /infile UxVCtrl.vcxproj /outfile "%TMP%\UxVCtrl\UxVCtrl.vcxproj" /searchstr ";bvtsdk4.lib" /replacestr ""
@copy /Y /B "%TMP%\UxVCtrl\UxVCtrl.vcxproj" UxVCtrl.vcxproj

@echo Please manually exclude from build BlueView.cpp/.h
)

@if "%DISABLE_MAVLINK%"=="1" (

@echo Disabling MAVLink 

@replaceinfile /infile UxVCtrl.vcxproj /outfile "%TMP%\UxVCtrl\UxVCtrl.vcxproj" /searchstr ";ENABLE_MAVLINK_SUPPORT" /replacestr ""
@copy /Y /B "%TMP%\UxVCtrl\UxVCtrl.vcxproj" UxVCtrl.vcxproj

@replaceinfile /infile UxVCtrl.vcxproj /outfile "%TMP%\UxVCtrl\UxVCtrl.vcxproj" /searchstr ";$(MAVLINK_SDK_DIR)" /replacestr ""
@copy /Y /B "%TMP%\UxVCtrl\UxVCtrl.vcxproj" UxVCtrl.vcxproj

@echo Please manually exclude from build MAVLinkDevice.cpp/.h, MAVLinkInterface.cpp/.h
)

@if "%DISABLE_LABJACK%"=="1" (

@echo Disabling LabJack 

@replaceinfile /infile UxVCtrl.vcxproj /outfile "%TMP%\UxVCtrl\UxVCtrl.vcxproj" /searchstr ";ENABLE_LABJACK_SUPPORT" /replacestr ""
@copy /Y /B "%TMP%\UxVCtrl\UxVCtrl.vcxproj" UxVCtrl.vcxproj

@replaceinfile /infile UxVCtrl.vcxproj /outfile "%TMP%\UxVCtrl\UxVCtrl.vcxproj" /searchstr ";$(ProgramFiles)\LabJack\Drivers" /replacestr ""
@copy /Y /B "%TMP%\UxVCtrl\UxVCtrl.vcxproj" UxVCtrl.vcxproj

@replaceinfile /infile UxVCtrl.vcxproj /outfile "%TMP%\UxVCtrl\UxVCtrl.vcxproj" /searchstr ";labjackud.lib" /replacestr ""
@copy /Y /B "%TMP%\UxVCtrl\UxVCtrl.vcxproj" UxVCtrl.vcxproj

@echo Please manually exclude from build UE9Core.c/.h, UE9Cfg.c/.h, UE9A.cpp/.h
)

@if "%DISABLE_LIBMODBUS%"=="1" (

@echo Disabling libmodbus 

@replaceinfile /infile UxVCtrl.vcxproj /outfile "%TMP%\UxVCtrl\UxVCtrl.vcxproj" /searchstr ";ENABLE_LIBMODBUS_SUPPORT" /replacestr ""
@copy /Y /B "%TMP%\UxVCtrl\UxVCtrl.vcxproj" UxVCtrl.vcxproj

@replaceinfile /infile UxVCtrl.vcxproj /outfile "%TMP%\UxVCtrl\UxVCtrl.vcxproj" /searchstr ";$(ProgramFiles)\libmodbus-3.0.6-msvc\include" /replacestr ""
@copy /Y /B "%TMP%\UxVCtrl\UxVCtrl.vcxproj" UxVCtrl.vcxproj

@replaceinfile /infile UxVCtrl.vcxproj /outfile "%TMP%\UxVCtrl\UxVCtrl.vcxproj" /searchstr ";$(ProgramFiles)\libmodbus-3.0.6-msvc\x86\vc15\lib" /replacestr ""
@copy /Y /B "%TMP%\UxVCtrl\UxVCtrl.vcxproj" UxVCtrl.vcxproj

@replaceinfile /infile UxVCtrl.vcxproj /outfile "%TMP%\UxVCtrl\UxVCtrl.vcxproj" /searchstr ";$(ProgramFiles)\libmodbus-3.0.6-msvc\x86\vc15\staticlib" /replacestr ""
@copy /Y /B "%TMP%\UxVCtrl\UxVCtrl.vcxproj" UxVCtrl.vcxproj

@replaceinfile /infile UxVCtrl.vcxproj /outfile "%TMP%\UxVCtrl\UxVCtrl.vcxproj" /searchstr ";libmodbus-3.0.6-msvcd.lib" /replacestr ""
@copy /Y /B "%TMP%\UxVCtrl\UxVCtrl.vcxproj" UxVCtrl.vcxproj

@replaceinfile /infile UxVCtrl.vcxproj /outfile "%TMP%\UxVCtrl\UxVCtrl.vcxproj" /searchstr ";libmodbus-3.0.6-msvc.lib" /replacestr ""
@copy /Y /B "%TMP%\UxVCtrl\UxVCtrl.vcxproj" UxVCtrl.vcxproj

@echo Please manually exclude from build CISCREA.cpp/.h
)

@if "%DISABLE_SBG%"=="1" (

@echo Disabling SBG 

@replaceinfile /infile UxVCtrl.vcxproj /outfile "%TMP%\UxVCtrl\UxVCtrl.vcxproj" /searchstr ";ENABLE_SBG_SUPPORT" /replacestr ""
@copy /Y /B "%TMP%\UxVCtrl\UxVCtrl.vcxproj" UxVCtrl.vcxproj

@replaceinfile /infile UxVCtrl.vcxproj /outfile "%TMP%\UxVCtrl\UxVCtrl.vcxproj" /searchstr ";$(SBG_SDK_DIR)\common;$(SBG_SDK_DIR)\src" /replacestr ""
@copy /Y /B "%TMP%\UxVCtrl\UxVCtrl.vcxproj" UxVCtrl.vcxproj

@replaceinfile /infile UxVCtrl.vcxproj /outfile "%TMP%\UxVCtrl\UxVCtrl.vcxproj" /searchstr ";$(SBG_SDK_DIR)\x86\vc15\lib" /replacestr ""
@copy /Y /B "%TMP%\UxVCtrl\UxVCtrl.vcxproj" UxVCtrl.vcxproj

@replaceinfile /infile UxVCtrl.vcxproj /outfile "%TMP%\UxVCtrl\UxVCtrl.vcxproj" /searchstr ";$(SBG_SDK_DIR)\x86\vc15\staticlib" /replacestr ""
@copy /Y /B "%TMP%\UxVCtrl\UxVCtrl.vcxproj" UxVCtrl.vcxproj

@replaceinfile /infile UxVCtrl.vcxproj /outfile "%TMP%\UxVCtrl\UxVCtrl.vcxproj" /searchstr ";sbgEComd.lib" /replacestr ""
@copy /Y /B "%TMP%\UxVCtrl\UxVCtrl.vcxproj" UxVCtrl.vcxproj

@replaceinfile /infile UxVCtrl.vcxproj /outfile "%TMP%\UxVCtrl\UxVCtrl.vcxproj" /searchstr ";sbgECom.lib" /replacestr ""
@copy /Y /B "%TMP%\UxVCtrl\UxVCtrl.vcxproj" UxVCtrl.vcxproj

@echo Please manually exclude from build SBG.cpp/.h
)

@echo.
@echo Please change Platform Toolset in Visual Studio project settings if needed
@echo.

@pause

@rd /s /q "%TMP%\UxVCtrl"

@exit
