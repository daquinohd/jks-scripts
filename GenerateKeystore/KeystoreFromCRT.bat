@echo off
@set PATH=C:\Program Files\JRE64\bin;C:\Program Files (x86)\Apache Software Foundation\Apache2.2\bin;%PATH%

REM Set local variables
SETLOCAL
SET INPUT_PATH=\path\to\cert_and_key
SET INPUT_CRT=existing_cert.crt
SET INPUT_KEY=existing_key.key
SET INPUT_CA=existing_ca_cert.crt
SET INPUT_PEM=my_generated_pem.pem
SET OUTPUT_PATH=\path\for\jks
SET OUTPUT_PFX=my_generated_pfx.pfx
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


ECHO Copying certificates and key into temp folder...
mkdir %TEMP_PATH%
xcopy %INPUT_PATH% %TEMP_PATH%
ECHO Done.


ECHO Concatenating .pem file...
copy %TEMP_PATH%\%INPUT_CRT%+%TEMP_PATH%\%INPUT_CA% %TEMP_PATH%\%INPUT_PEM% 
ECHO Done.


ECHO Creating the .pfx from pem and key...
openssl pkcs12 -export -in %TEMP_PATH%\%INPUT_PEM% -inkey %TEMP_PATH%\%INPUT_KEY% -out %TEMP_PATH%\%OUTPUT_PFX% -password pass:password
ECHO Done.


ECHO Creating the keystore from .pfx...
keytool -importkeystore -srckeystore %TEMP_PATH%\%OUTPUT_PFX% -srcstoretype PKCS12 -srcstorepass password -destkeystore %TEMP_PATH%\%OUTPUT_JKS% -storepass password 
copy %TEMP_PATH%\%OUTPUT_JKS% %OUTPUT_PATH%
rd /s /q %TEMP_PATH% 2>nul
ECHO Keystore created in %OUTPUT_PATH%
ECHO Done!


ENDLOCAL
pause
@echo on