# Enable logging
"Script started at $(Get-Date)" 

# Check if the GIT_URL parameter is passed
if (-not $args[0]) {
    "Error: GIT_URL is not provided. Usage: script_name.ps1 [GIT_URL] [GIT_USER] [GIT_PASSWORD]" 
    Write-Host "Error: GIT_URL is not provided. Usage: script_name.ps1 [GIT_URL] [GIT_USER] [GIT_PASSWORD]"
    exit 1
}

# Get GIT_URL from the first command-line parameter
$gitUrl = $args[0]
"Original GIT_URL: $gitUrl" 

# Get GIT_USER and GIT_PASSWORD from optional command-line parameters
$gitUser = $args[1]
$gitPassword = $args[2]
"Git User: $gitUser" 
"Git Password: $gitPassword" 

# Modify GIT_URL to include credentials if provided
if ($gitUser) {
    "Adding credentials to GIT_URL" 

    # Check if the URL starts with https:// or http://
    if ($gitUrl.StartsWith("https://")) {
        $protocol = "https://"
        $remainder = $gitUrl.Substring(8)
    } elseif ($gitUrl.StartsWith("http://")) {
        $protocol = "http://"
        $remainder = $gitUrl.Substring(7)
    } else {
        "Invalid URL format. Exiting." 
        exit 1
    }

    # Construct the new GIT_URL with credentials
    $gitUrl = "$protocol$gitUser`:$gitPassword`@$remainder"
    "Modified GIT_URL: $gitUrl" 
}

# Define other variables
$cxServer = "http://ec2-35-167-1-96.us-west-2.compute.amazonaws.com"
$cxUser = "admin"
$cxPassword = "Aa12345678!"
$projectNameBase = "CxServer"
$projectsRoot = "C:\projects"
$cxConsolePath = "C:\Users\Yoel\Downloads\CxConsolePlugin-1.1.30"

"PROJECTS_ROOT: $projectsRoot" 
"CXCONSOLE_PATH: $cxConsolePath" 

# Extract the repository name from GIT_URL and remove the '.git' extension
$repoName = [System.IO.Path]::GetFileNameWithoutExtension($gitUrl)
"REPO_NAME: $repoName" 

# Construct LOCATION_PATH
$locationPath = Join-Path -Path $projectsRoot -ChildPath $repoName
"LOCATION_PATH: $locationPath" 

# Concatenate REPO_NAME to PROJECT_NAME_BASE
$fullProjectName = "$projectNameBase\$repoName"
"FULL_PROJECT_NAME: $fullProjectName" 

# Navigate to the project directory
Set-Location -Path $projectsRoot
"Navigated to PROJECTS_ROOT: $projectsRoot" 

# Check if the repository folder exists and delete it if it does
if (Test-Path -Path $locationPath) {
    "Deleting existing repository folder: $locationPath" 
    Remove-Item -Recurse -Force -Path $locationPath
}

# Clone the repository
"Cloning repository" 
git clone $gitUrl $locationPath 

# Navigate to the CxConsole Plugin directory
Set-Location -Path $cxConsolePath
"Navigated to CXCONSOLE_PATH: $cxConsolePath" 

# Run the CxConsole Scan using the .cmd extension
"Running CxConsole Scan" 
.\runCxConsole Scan -CxServer $cxServer -ProjectName $fullProjectName -CxUser $cxUser -CxPassword $cxPassword -locationtype folder -locationpath $locationPath
"Script ended at $(Get-Date)" 
"Log saved to $logFile" 
