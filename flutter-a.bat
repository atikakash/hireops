@echo off
setlocal

set "FLUTTER_ROOT=A:\flutter"
set "PUB_CACHE=A:\pub-cache"
set "LOCALAPPDATA=A:\tmp-localappdata"
set "APPDATA=A:\tmp-appdata"

"%FLUTTER_ROOT%\bin\cache\dart-sdk\bin\dart.exe" --packages="%FLUTTER_ROOT%\packages\flutter_tools\.dart_tool\package_config.json" "%FLUTTER_ROOT%\bin\cache\flutter_tools.snapshot" --suppress-analytics %*

endlocal
