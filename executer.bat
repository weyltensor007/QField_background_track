@echo off

chcp 65001 > NUL

CHOICE /CS /M "此操作會刪除QField 中所有 Imported Projects, 請確認資料已備份再進行本操作!(Y/N請注意大小寫)"


if %ERRORLEVEL% EQU 1 (
	goto :YES

) else (
	goto :NO
)



:YES

set javamain=OpenJDKJRE64\bin\java.exe

echo pulling original base.apk of QField
for /F "delims=:, tokens=2" %%i in ('adb shell pm path ch.opengis.qfield') do (
	adb pull %%i
	)

echo decompiling base.apk
%javamain% -jar apktool.jar d base.apk -o base
del base.apk

echo modifying AndroidManifest.xml
powershell -file insert_xml.ps1


echo compiling new apk

%javamain% -jar apktool.jar b base -o base_new_unsigned.apk
rmdir /s /q base



echo signing apk
%javamain% -jar uber-apk-signer-1.2.1.jar --apks base_new_unsigned.apk
del base_new_unsigned.apk

ren base_new_unsigned-aligned-debugSigned.apk base.apk

echo uninstalling old qfield
adb uninstall ch.opengis.qfield
echo installing new qfield
adb install base.apk
del base.apk


:: adb install GPS lock
ren GPS_Lock.apk base.apk
echo installing GPS_connected 
adb install base.apk
ren base.apk GPS_Lock.apk

goto :EOF


:NO

echo 請檢查 QField 資料後再次執行!

goto :EOF