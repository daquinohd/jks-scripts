@echo off
@set PATH=C:\Program Files\JRE64\bin;%PATH%

REM Set local variables
SETLOCAL
SET INPUT_PATH=\path\to\pfx
SET INPUT_PFX=existing_pfx.pfx
SET OUTPUT_PATH=\path\for\jks
SET OUTPUT_JKS=my_generated_jks.jks
SET TEMP_PATH=_jks_temp


ECHO Removing old temp folder (if exists)...
rd /s /q %TEMP_PATH% 2>nul
ECHO Done.


ECHO Checking for an existing keystore...
if exist %OUTPUT_PATH%\%OUTPUT_JKS% (
  echo %OUTPUT_JKS% already exists in the target folder. Are you sure you need to create a new Java keystore? Please verify before proceeding.
  pause
  exit /b
)
ECHO Done.


ECHO Copying PFX into temp folder...
mkdir %TEMP_PATH%
xcopy %INPUT_PATH% %TEMP_PATH%
ECHO Done.


ECHO Creating the keystore from .pfx...
keytool -importkeystore -srckeystore %TEMP_PATH%\%INPUT_PFX% -srcstoretype PKCS12 -srcstorepass password -destkeystore %TEMP_PATH%\%OUTPUT_JKS% -storepass password 
copy %TEMP_PATH%\%OUTPUT_JKS% %OUTPUT_PATH%
rd /s /q %TEMP_PATH% 2>nul
ECHO Keystore created in %OUTPUT_PATH%
ECHO Done!


ENDLOCAL
pause
@echo on