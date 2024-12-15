# Check if running as Administrator
if (-Not (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[!] This script must be run as an Administrator." -ForegroundColor Red
    exit
} else {
    Write-Host "[#] Script is running as Administrator." -ForegroundColor Green
    # Navigate to the Desktop
    Set-Location -Path "$env:USERPROFILE\Desktop"
    
    # Check if Git is installed
    Write-Host "[+] Checking if Git is installed..." -ForegroundColor Yellow
    if (-Not (Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Host "[-] Git is not installed. Installing Git..."
        winget install --id Git.Git -e --silent
        Write-Host "[=] Git installed successfully." -ForegroundColor Green
    } else {
        Write-Host "[=] Git is already installed." -ForegroundColor Green
    }
    
    # Check if Dev-C++ is already installed
    $DevCppPath = "C:\Program Files (x86)\Dev-Cpp"
    if (Test-Path $DevCppPath) {
        Write-Host "[=] Dev-C++ is already installed at $DevCppPath." -ForegroundColor Green
    } else {
        # Download the Dev-C++ setup
        Write-Host "[+] Downloading Dev-C++ setup..." -ForegroundColor Yellow
        $DevCppSetupUrl = "https://webwerks.dl.sourceforge.net/project/orwelldevcpp/Setup%20Releases/Dev-Cpp%205.11%20TDM-GCC%204.9.2%20Setup.exe?viasf=1"
        $DevCppSetupPath = "DevCppSetup.exe"
        Invoke-WebRequest -Uri $DevCppSetupUrl -OutFile $DevCppSetupPath -UseBasicParsing
    
        # Run the Dev-C++ installer silently
        Write-Host "[+] Running Dev-C++ installer..." -ForegroundColor Yellow
        Start-Process -FilePath $DevCppSetupPath -ArgumentList "/SILENT" -Wait
    }
    
    # Clone the repository
    Write-Host "[+] Cloning DevCppSetup repository..." -ForegroundColor Yellow
    $cloneDir = "$env:USERPROFILE\Desktop\DevCppSetup"
    git clone https://github.com/GetSomeSleepBro/DevCppSetup
        
    # Define file paths for copying
    $GraphicsLibsPath = "$env:USERPROFILE\Desktop\DevCppSetup\graphicslibs"
    $DevCppIncludePath = "C:\Program Files (x86)\Dev-Cpp\MinGW64\include"
    $DevCppLibPath = "C:\Program Files (x86)\Dev-Cpp\MinGW64\lib"
    $DevCppTemplatesPath = "C:\Program Files (x86)\Dev-Cpp\Templates"
    
    # Copy graphics.h and winbgim.h to the include directory
    Write-Host "[+] Copying header files to include directory..."
    Copy-Item "$GraphicsLibsPath\graphics.h" "$DevCppIncludePath" -Force
    Copy-Item "$GraphicsLibsPath\winbgim.h" "$DevCppIncludePath" -Force
        
    # Copy libbgi.a to the lib directory
    Write-Host "[+] Copying libbgi.a to lib directory..."
    Copy-Item "$GraphicsLibsPath\libbgi.a" "$DevCppLibPath" -Force
        
    # Copy template files to the Templates directory
    Write-Host "[+] Copying template files to Templates directory..."
    Copy-Item "$GraphicsLibsPath\6-ConsoleAppGraphics.template" "$DevCppTemplatesPath" -Force
    Copy-Item "$GraphicsLibsPath\ConsoleApp_cpp_graph.txt" "$DevCppTemplatesPath" -Force
        
    # Confirm completion
    Write-Host "[=] Setup completed successfully." -ForegroundColor Green
        
    # Remove the cloned repository
    Write-Host "[+] Cleaning up by removing the cloned repository..." -ForegroundColor Yellow
    Remove-Item -Path $cloneDir -Recurse -Force
    Write-Host "[=] Cloned repository removed." -ForegroundColor Green

    # Copying flgas for linker options to clipboard 
    Write-Host "[+] Copied `-static-libgcc -lbgi -lgdi32 -lcomdlg32 -luuid -loleaut32 -lole32` to clipboard" -ForegroundColor Green
    "-static-libgcc -lbgi -lgdi32 -lcomdlg32 -luuid -loleaut32 -lole32" | Set-Clipboard
}
