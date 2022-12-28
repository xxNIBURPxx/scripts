# Set DNS servers cmd
powershell -Command “Start-Process cmd -Verb RunAs”

# Run netsh
netsh
interface ip set dns name="Ethernet" source="static" address="10.180.44.90"

# Join domain via CMD prompt
netdom /domain:niburp.local /user:phil-da /password:addyourown member niburp-pc01 /joindomain

# Join domain via PowerShell
Add-Computer -DomainName niburp.local
Add-Computer -DomainName niburp.local -Credential
