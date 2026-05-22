$env:FLUTTER_ROOT = 'A:\flutter'
$env:PUB_CACHE = 'A:\pub-cache'
$env:LOCALAPPDATA = 'A:\tmp-localappdata'
$env:APPDATA = 'A:\tmp-appdata'

& 'A:\flutter\bin\cache\dart-sdk\bin\dart.exe' `
  '--packages=A:\flutter\packages\flutter_tools\.dart_tool\package_config.json' `
  'A:\flutter\bin\cache\flutter_tools.snapshot' `
  '--suppress-analytics' `
  @args
