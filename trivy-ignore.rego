package trivy

default ignore = false

ignore_cve := {}

ignore {
    packageUse := ignore_cve[_]
    packageValue := packageUse[input.PkgName]
	input.VulnerabilityID == packageValue[_]
}


