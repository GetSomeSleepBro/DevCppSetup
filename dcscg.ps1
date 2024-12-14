# Navigate to the Desktop
Set-Location -Path "$env:USERPROFILE\Desktop"

# Install Git using winget
Write-Host "Installing Git..."
winget install --id Git.Git -e --silent

# Download the Dev-C++ setup
Write-Host "Downloading Dev-C++ setup..."
$DevCppSetupUrl = "https://file.io/MFZ9nwTstWoO"
$DevCppSetupPath = "DevCppSetup.exe"
Invoke-WebRequest -Uri $DevCppSetupUrl -OutFile $DevCppSetupPath -UseBasicParsing

# Run the Dev-C++ installer silently
Write-Host "Running Dev-C++ installer..."
Start-Process -FilePath $DevCppSetupPath -ArgumentList "/SILENT" -Wait

# Clone the repository
Write-Host "Cloning DevCppSetup repository..."
git clone https://github.com/GetSomeSleepBro/DevCppSetup

# Define file paths for copying
$GraphicsLibsPath = "$env:USERPROFILE\Desktop\DevCppSetup\graphicslibs"
$DevCppIncludePath = "C:\Program Files (x86)\Dev-Cpp\MinGW64\include"
$DevCppLibPath = "C:\Program Files (x86)\Dev-Cpp\MinGW64\lib"
$DevCppTemplatesPath = "C:\Program Files (x86)\Dev-Cpp\Templates"

# Copy graphics.h and winbgim.h to the include directory
Write-Host "Copying header files to include directory..."
Copy-Item "$GraphicsLibsPath\graphics.h" "$DevCppIncludePath" -Force
Copy-Item "$GraphicsLibsPath\winbgim.h" "$DevCppIncludePath" -Force

# Copy libbgi.a to the lib directory
Write-Host "Copying libbgi.a to lib directory..."
Copy-Item "$GraphicsLibsPath\libbgi.a" "$DevCppLibPath" -Force

# Copy template files to the Templates directory
Write-Host "Copying template files to Templates directory..."
Copy-Item "$GraphicsLibsPath\6-ConsoleAppGraphics.template" "$DevCppTemplatesPath" -Force
Copy-Item "$GraphicsLibsPath\ConsoleApp_cpp_graph.txt" "$DevCppTemplatesPath" -Force

# Confirm completion
Write-Host "Setup completed successfully."
