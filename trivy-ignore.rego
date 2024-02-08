package trivy

default ignore = false

ignore_cve := {
    "terraform-provider-aws" : {
        "golang.org/x/crypto" : ["CVE-2021-43565", "CVE-2022-27191", "CVE-2023-48795"],
        "golang.org/x/net" : ["CVE-2022-27664", "CVE-2022-41723", "CVE-2023-39325", "CVE-2023-3978", "CVE-2023-44487"],
        "golang.org/x/sys" : ["CVE-2022-29526"],
        "golang.org/x/text" : ["CVE-2021-38561", "CVE-2022-32149"],
        "google.golang.org/grpc" : ["GHSA-m425-mq94-257g", "CVE-2023-44487"],
    },
    "terraform-provider-azurerm" : {
        "golang.org/x/crypto" : ["CVE-2023-48795"],
        "golang.org/x/net" : ["CVE-2023-39325", "CVE-2023-3978", "CVE-2023-44487"],
        "google.golang.org/grpc" : ["GHSA-m425-mq94-257g", "CVE-2023-44487"],
    },
    "terraform-provider-google" : {
        "golang.org/x/crypto" : ["CVE-2023-48795"],
        "golang.org/x/net" : ["CVE-2022-27664", "CVE-2022-41721", "CVE-2022-41723", "CVE-2023-39325", "CVE-2023-3978", "CVE-2023-44487"],
        "golang.org/x/text" : ["CVE-2022-32149"],
        "google.golang.org/grpc" : ["GHSA-m425-mq94-257g", "CVE-2023-44487"],
    },
    "terraform" : {
        "golang.org/x/crypto" : ["CVE-2023-48795"],
        "golang.org/x/net" : ["CVE-2023-39325", "CVE-2023-3978", "CVE-2023-44487"],
        "google.golang.org/grpc" : ["GHSA-m425-mq94-257g", "CVE-2023-44487"],
    },
    "terraformer" : {
        "github.com/crewjam/saml" : ["CVE-2023-45683"],
        "github.com/hashicorp/vault" : ["CVE-2020-16250", "CVE-2021-32923", "CVE-2023-24999", "CVE-2023-5077", "CVE-2023-5954", "CVE-2021-38554", "CVE-2022-41316", "CVE-2023-0620", "CVE-2023-0665", "CVE-2023-2121", "CVE-2023-25000", "CVE-2023-3462"],
        "golang.org/x/crypto" : ["CVE-2023-48795"],
        "golang.org/x/net" : ["CVE-2023-39325", "CVE-2023-3978", "CVE-2023-44487"],
        "google.golang.org/grpc" : ["GHSA-m425-mq94-257g", "CVE-2023-44487"],
    },
}

ignore {
    packageUse := ignore_cve[_]
    packageValue := packageUse[input.PkgName]
	input.VulnerabilityID == packageValue[_]
}


