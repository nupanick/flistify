@ECHO OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
SET max_dimensions=2000x2000
SET max_size=2097152
SET out_dir=.\downsized
SET out_prefix=flist_
SET t_name=""

IF NOT EXIST %out_dir% MKDIR %out_dir%

FOR %%A IN (%*) DO (
    SET t_name=%out_dir%\%out_prefix%%%~nxA
    ECHO Resizing %%~nxA as !t_name!
    magick %%A ^
        -resize %max_dimensions%^> ^
        -set filename:orig "%%f" ^
        !t_name!
    IF %%~zA GTR %max_size% CALL :jpegcrunch !t_name!
)
PAUSE
GOTO :eof

:jpegcrunch
ECHO %~nx1 was too big, at a size of %~z1 bytes. Using jpeg compression.
SET t_name=%out_dir%\%~n1.jpg
magick %1 ^
    -define jpeg:extent=%max_size% ^
    %t_name%
IF NOT .jpg==%~x1 DEL %1.
GOTO :eof