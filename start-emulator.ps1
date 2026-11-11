param([string]$AvdName = 'Kornilov_API_36')
$emulatorPath = Join-Path $env:ANDROID_HOME 'emulator/emulator.exe'
& $emulatorPath -avd $AvdName -no-snapshot-load -no-audio -no-boot-anim -gpu host -feature -Vulkan
exit $LASTEXITCODE
