## Installation

This section describes installation procedure of ICE.

To have a fully working environment to use and develop in ICE you will need:

1. Download and install Go: https://golang.org/dl/
2. Install VS Code (or another IDE of your choosing): https://code.visualstudio.com/Download
3. Inside VS Code, install the following extensions:
 - Go
 - Open Policy Agent
 - Git Lens 
4. Install PostgreSQL: https://www.postgresql.org/download/ (optional, not needed for CLI usage)
5. Clone the repository of ICE to VS Code: https://github.com/CheckmarxDev/ice
6. Test if the application is running properly by running in the terminal, in the root of the project:

go run ./cmd/console/main.go -p assets/queries/terraform