// Package nfpm provides ways to package programs in some linux packaging
// formats.
package nfpm

import (
	"fmt"
	"io"
	"os"
	"sync"

	"github.com/AlekSi/pointer"
	"github.com/Masterminds/semver/v3"
	"github.com/goreleaser/chglog"
	"github.com/goreleaser/nfpm/v2/deprecation"
	"github.com/goreleaser/nfpm/v2/files"
	"github.com/imdario/mergo"
	"gopkg.in/yaml.v3"
)

// nolint: gochecknoglobals
var (
	packagers = map[string]Packager{}
	lock      sync.Mutex
)

// RegisterPackager a new packager for the given format.
func RegisterPackager(format string, p Packager) {
	lock.Lock()
	defer lock.Unlock()
	packagers[format] = p
}

// ClearPackagers clear all registered packagers, used for testing.
func ClearPackagers() {
	lock.Lock()
	defer lock.Unlock()
	packagers = map[string]Packager{}
}

// ErrNoPackager happens when no packager is registered for the given format.
type ErrNoPackager struct {
	format string
}

func (e ErrNoPackager) Error() string {
	return fmt.Sprintf("no packager registered for the format %s", e.format)
}

// Get a packager for the given format.
func Get(format string) (Packager, error) {
	p, ok := packagers[format]
	if !ok {
		return nil, ErrNoPackager{format}
	}
	return p, nil
}

// Parse decodes YAML data from an io.Reader into a configuration struct.
func Parse(in io.Reader) (config Config, err error) {
	return ParseWithEnvMapping(in, os.Getenv)
}

// ParseWithEnvMapping decodes YAML data from an io.Reader into a configuration struct.
func ParseWithEnvMapping(in io.Reader, mapping func(string) string) (config Config, err error) {
	dec := yaml.NewDecoder(in)
	dec.KnownFields(true)
	if err = dec.Decode(&config); err != nil {
		return
	}
	config.envMappingFunc = mapping
	if config.envMappingFunc == nil {
		config.envMappingFunc = func(s string) string { return s }
	}

	config.expandEnvVars()

	WithDefaults(&config.Info)

	return config, nil
}

// ParseFile decodes YAML data from a file path into a configuration struct.
func ParseFile(path string) (config Config, err error) {
	return ParseFileWithEnvMapping(path, os.Getenv)
}

// ParseFileWithEnvMapping decodes YAML data from a file path into a configuration struct.
func ParseFileWithEnvMapping(path string, mapping func(string) string) (config Config, err error) {
	var file *os.File
	file, err = os.Open(path) //nolint:gosec
	if err != nil {
		return
	}
	defer file.Close() // nolint: errcheck,gosec
	return ParseWithEnvMapping(file, mapping)
}

// Packager represents any packager implementation.
type Packager interface {
	Package(info *Info, w io.Writer) error
	ConventionalFileName(info *Info) string
}

// Config contains the top level configuration for packages.
type Config struct {
	Info           `yaml:",inline"`
	Overrides      map[string]Overridables `yaml:"overrides,omitempty" jsonschema:"title=overrides,description=override some fields when packaging with a specific packager,enum=apk,enum=deb,enum=rpm"`
	envMappingFunc func(string) string
}

// Get returns the Info struct for the given packager format. Overrides
// for the given format are merged into the final struct.
func (c *Config) Get(format string) (info *Info, err error) {
	info = &Info{}
	// make a deep copy of info
	if err = mergo.Merge(info, c.Info); err != nil {
		return nil, fmt.Errorf("failed to merge config into info: %w", err)
	}
	override, ok := c.Overrides[format]
	if !ok {
		// no overrides
		return info, nil
	}
	if err = mergo.Merge(&info.Overridables, override, mergo.WithOverride); err != nil {
		return nil, fmt.Errorf("failed to merge overrides into info: %w", err)
	}
	var contents []*files.Content
	for _, f := range info.Contents {
		if f.Packager == format || f.Packager == "" {
			contents = append(contents, f)
		}
	}
	info.Contents = contents
	return info, nil
}

// Validate ensures that the config is well typed.
func (c *Config) Validate() error {
	if err := Validate(&c.Info); err != nil {
		return err
	}
	for format := range c.Overrides {
		if _, err := Get(format); err != nil {
			return err
		}
	}
	return nil
}

func (c *Config) expandEnvVars() {
	// Version related fields
	c.Info.Release = os.Expand(c.Info.Release, c.envMappingFunc)
	c.Info.Version = os.Expand(c.Info.Version, c.envMappingFunc)
	c.Info.Prerelease = os.Expand(c.Info.Prerelease, c.envMappingFunc)
	c.Info.Arch = os.Expand(c.Info.Arch, c.envMappingFunc)
	for _, override := range c.Overrides {
		for i, dep := range override.Depends {
			override.Depends[i] = os.Expand(dep, c.envMappingFunc)
		}
	}

	// Maintainer and vendor fields
	c.Info.Maintainer = os.Expand(c.Info.Maintainer, c.envMappingFunc)
	c.Info.Vendor = os.Expand(c.Info.Vendor, c.envMappingFunc)

	// Package signing related fields
	c.Info.Deb.Signature.KeyFile = os.Expand(c.Deb.Signature.KeyFile, c.envMappingFunc)
	c.Info.RPM.Signature.KeyFile = os.Expand(c.RPM.Signature.KeyFile, c.envMappingFunc)
	c.Info.APK.Signature.KeyFile = os.Expand(c.APK.Signature.KeyFile, c.envMappingFunc)
	c.Info.Deb.Signature.KeyID = pointer.ToString(os.Expand(pointer.GetString(c.Deb.Signature.KeyID), c.envMappingFunc))
	c.Info.RPM.Signature.KeyID = pointer.ToString(os.Expand(pointer.GetString(c.RPM.Signature.KeyID), c.envMappingFunc))
	c.Info.APK.Signature.KeyID = pointer.ToString(os.Expand(pointer.GetString(c.APK.Signature.KeyID), c.envMappingFunc))

	// Package signing passphrase
	generalPassphrase := os.Expand("$NFPM_PASSPHRASE", c.envMappingFunc)
	c.Info.Deb.Signature.KeyPassphrase = generalPassphrase
	c.Info.RPM.Signature.KeyPassphrase = generalPassphrase
	c.Info.APK.Signature.KeyPassphrase = generalPassphrase

	debPassphrase := os.Expand("$NFPM_DEB_PASSPHRASE", c.envMappingFunc)
	if debPassphrase != "" {
		c.Info.Deb.Signature.KeyPassphrase = debPassphrase
	}

	rpmPassphrase := os.Expand("$NFPM_RPM_PASSPHRASE", c.envMappingFunc)
	if rpmPassphrase != "" {
		c.Info.RPM.Signature.KeyPassphrase = rpmPassphrase
	}

	apkPassphrase := os.Expand("$NFPM_APK_PASSPHRASE", c.envMappingFunc)
	if apkPassphrase != "" {
		c.Info.APK.Signature.KeyPassphrase = apkPassphrase
	}

	// RPM specific
	c.Info.RPM.Packager = os.Expand(c.RPM.Packager, c.envMappingFunc)
}

// Info contains information about a single package.
type Info struct {
	Overridables    `yaml:",inline"`
	Name            string `yaml:"name" jsonschema:"title=package name"`
	Arch            string `yaml:"arch" jsonschema:"title=target architecture,example=amd64"`
	Platform        string `yaml:"platform,omitempty" jsonschema:"title=target platform,example=linux,default=linux"`
	Epoch           string `yaml:"epoch,omitempty" jsonschema:"title=version epoch,example=2,default=extracted from version"`
	Version         string `yaml:"version" jsonschema:"title=version,example=v1.0.2,example=2.0.1"`
	VersionSchema   string `yaml:"version_schema,omitempty" jsonschema:"title=version schema,enum=semver,enum=none,default=semver"`
	Release         string `yaml:"release,omitempty" jsonschema:"title=version release,example=1"`
	Prerelease      string `yaml:"prerelease,omitempty" jsonschema:"title=version prerelease,default=extracted from version"`
	VersionMetadata string `yaml:"version_metadata,omitempty" jsonschema:"title=version metadata,example=git"`
	Section         string `yaml:"section,omitempty" jsonschema:"title=package section,example=default"`
	Priority        string `yaml:"priority,omitempty" jsonschema:"title=package priority,example=extra"`
	Maintainer      string `yaml:"maintainer,omitempty" jsonschema:"title=package maintainer,example=me@example.com"`
	Description     string `yaml:"description,omitempty" jsonschema:"title=package description"`
	Vendor          string `yaml:"vendor,omitempty" jsonschema:"title=package vendor,example=MyCorp"`
	Homepage        string `yaml:"homepage,omitempty" jsonschema:"title=package homepage,example=https://example.com"`
	License         string `yaml:"license,omitempty" jsonschema:"title=package license,example=MIT"`
	Changelog       string `yaml:"changelog,omitempty" jsonschema:"title=package changelog,example=changelog.yaml,description=see https://github.com/goreleaser/chglog for more details"`
	DisableGlobbing bool   `yaml:"disable_globbing,omitempty" jsonschema:"title=wether to disable file globbing,default=false"`
	Target          string `yaml:"-"`
}

func (i *Info) Validate() error {
	return Validate(i)
}

// GetChangeLog parses the provided changelog file.
func (i *Info) GetChangeLog() (log *chglog.PackageChangeLog, err error) {
	// if the file does not exist chglog.Parse will just silently
	// create an empty changelog but we should notify the user instead
	if _, err = os.Stat(i.Changelog); os.IsNotExist(err) {
		return nil, err
	}

	entries, err := chglog.Parse(i.Changelog)
	if err != nil {
		return nil, err
	}

	return &chglog.PackageChangeLog{
		Name:    i.Name,
		Entries: entries,
	}, nil
}

func (i *Info) parseSemver() {
	// parse the version as a semver so we can properly split the parts
	// and support proper ordering for both rpm and deb
	if v, err := semver.NewVersion(i.Version); err == nil {
		i.Version = fmt.Sprintf("%d.%d.%d", v.Major(), v.Minor(), v.Patch())
		if i.Prerelease == "" {
			i.Prerelease = v.Prerelease()
		}

		if i.VersionMetadata == "" {
			i.VersionMetadata = v.Metadata()
		}
	}
}

// Overridables contain the field which are overridable in a package.
type Overridables struct {
	Replaces     []string       `yaml:"replaces,omitempty" jsonschema:"title=replaces directive,example=nfpm"`
	Provides     []string       `yaml:"provides,omitempty" jsonschema:"title=provides directive,example=nfpm"`
	Depends      []string       `yaml:"depends,omitempty" jsonschema:"title=depends directive,example=nfpm"`
	Recommends   []string       `yaml:"recommends,omitempty" jsonschema:"title=recommends directive,example=nfpm"`
	Suggests     []string       `yaml:"suggests,omitempty" jsonschema:"title=suggests directive,example=nfpm"`
	Conflicts    []string       `yaml:"conflicts,omitempty" jsonschema:"title=conflicts directive,example=nfpm"`
	Contents     files.Contents `yaml:"contents,omitempty" jsonschema:"title=files to add to the package"`
	EmptyFolders []string       `yaml:"empty_folders,omitempty" jsonschema:"title=empty folders to be created when installing the package,example=/var/log/nfpm"` // deprecated
	Scripts      Scripts        `yaml:"scripts,omitempty" jsonschema:"title=scripts to execute"`
	RPM          RPM            `yaml:"rpm,omitempty" jsonschema:"title=rpm-specific settings"`
	Deb          Deb            `yaml:"deb,omitempty" jsonschema:"title=deb-specific settings"`
	APK          APK            `yaml:"apk,omitempty" jsonschema:"title=apk-specific settings"`
}

// RPM is custom configs that are only available on RPM packages.
type RPM struct {
	Arch        string       `yaml:"arch,omitempty" jsonschema:"title=architecture in rpm nomenclature"`
	Scripts     RPMScripts   `yaml:"scripts,omitempty" jsonschema:"title=rpm-specific scripts"`
	Group       string       `yaml:"group,omitempty" jsonschema:"title=package group,example=Unspecified"`
	Summary     string       `yaml:"summary,omitempty" jsonschema:"title=package summary"`
	Compression string       `yaml:"compression,omitempty" jsonschema:"title=compression algorithm to be used,enum=gzip,enum=lzma,enum=xz,default=gzip:-1"`
	Signature   RPMSignature `yaml:"signature,omitempty" jsonschema:"title=rpm signature"`
	Packager    string       `yaml:"packager,omitempty" jsonschema:"title=organization that actually packaged the software"`
}

// RPMScripts represents scripts only available on RPM packages.
type RPMScripts struct {
	PreTrans  string `yaml:"pretrans,omitempty" jsonschema:"title=pretrans script"`
	PostTrans string `yaml:"posttrans,omitempty" jsonschema:"title=posttrans script"`
}

type PackageSignature struct {
	// PGP secret key, can be ASCII-armored
	KeyFile       string  `yaml:"key_file,omitempty" jsonschema:"title=key file,example=key.gpg"`
	KeyID         *string `yaml:"key_id,omitempty" jsonschema:"title=key id,example=bc8acdd415bd80b3"`
	KeyPassphrase string  `yaml:"-"` // populated from environment variable
}

type RPMSignature struct {
	PackageSignature `yaml:",inline"`
}

type APK struct {
	Arch      string       `yaml:"arch,omitempty" jsonschema:"title=architecture in apk nomenclature"`
	Signature APKSignature `yaml:"signature,omitempty" jsonschema:"title=apk signature"`
	Scripts   APKScripts   `yaml:"scripts,omitempty" jsonschema:"title=apk scripts"`
}

type APKSignature struct {
	PackageSignature `yaml:",inline"`
	// defaults to <maintainer email>.rsa.pub
	KeyName string `yaml:"key_name,omitempty" jsonschema:"title=key name,example=origin,default=maintainer_email.rsa.pub"`
}

type APKScripts struct {
	PreUpgrade  string `yaml:"preupgrade,omitempty" jsonschema:"title=pre upgrade script"`
	PostUpgrade string `yaml:"postupgrade,omitempty" jsonschema:"title=post upgrade script"`
}

// Deb is custom configs that are only available on deb packages.
type Deb struct {
	Arch        string            `yaml:"arch,omitempty" jsonschema:"title=architecture in deb nomenclature"`
	Scripts     DebScripts        `yaml:"scripts,omitempty" jsonschema:"title=scripts"`
	Triggers    DebTriggers       `yaml:"triggers,omitempty" jsonschema:"title=triggers"`
	Breaks      []string          `yaml:"breaks,omitempty" jsonschema:"title=breaks"`
	Signature   DebSignature      `yaml:"signature,omitempty" jsonschema:"title=signature"`
	Compression string            `yaml:"compression,omitempty" jsonschema:"title=compression algorithm to be used,enum=gzip,enum=xz,enum=none,default=gzip"`
	Fields      map[string]string `yaml:"fields,omitempty" jsonschema:"title=fields"`
}

type DebSignature struct {
	PackageSignature `yaml:",inline"`
	// debsign, or dpkg-sig (defaults to debsign)
	Method string `yaml:"method,omitempty" jsonschema:"title=method role,enum=debsign,enum=dpkg-sig,default=debsign"`
	// origin, maint or archive (defaults to origin)
	Type   string `yaml:"type,omitempty" jsonschema:"title=signer role,enum=origin,enum=maint,enum=archive,default=origin"`
	Signer string `yaml:"signer,omitempty" jsonschema:"title=signer"`
}

// DebTriggers contains triggers only available for deb packages.
// https://wiki.debian.org/DpkgTriggers
// https://man7.org/linux/man-pages/man5/deb-triggers.5.html
type DebTriggers struct {
	Interest        []string `yaml:"interest,omitempty" jsonschema:"title=interest"`
	InterestAwait   []string `yaml:"interest_await,omitempty" jsonschema:"title=interest await"`
	InterestNoAwait []string `yaml:"interest_noawait,omitempty" jsonschema:"title=interest noawait"`
	Activate        []string `yaml:"activate,omitempty" jsonschema:"title=activate"`
	ActivateAwait   []string `yaml:"activate_await,omitempty" jsonschema:"title=activate await"`
	ActivateNoAwait []string `yaml:"activate_noawait,omitempty" jsonschema:"title=activate noawait"`
}

// DebScripts is scripts only available on deb packages.
type DebScripts struct {
	Rules     string `yaml:"rules,omitempty" jsonschema:"title=rules"`
	Templates string `yaml:"templates,omitempty" jsonschema:"title=templates"`
	Config    string `yaml:"config,omitempty" jsonschema:"title=config"`
}

// Scripts contains information about maintainer scripts for packages.
type Scripts struct {
	PreInstall  string `yaml:"preinstall,omitempty" jsonschema:"title=pre install"`
	PostInstall string `yaml:"postinstall,omitempty" jsonschema:"title=post install"`
	PreRemove   string `yaml:"preremove,omitempty" jsonschema:"title=pre remove"`
	PostRemove  string `yaml:"postremove,omitempty" jsonschema:"title=post remove"`
}

// ErrFieldEmpty happens when some required field is empty.
type ErrFieldEmpty struct {
	field string
}

func (e ErrFieldEmpty) Error() string {
	return fmt.Sprintf("package %s must be provided", e.field)
}

// Validate the given Info and returns an error if it is invalid.
func Validate(info *Info) (err error) {
	if info.Name == "" {
		return ErrFieldEmpty{"name"}
	}
	if info.Arch == "" && (info.Deb.Arch == "" || info.RPM.Arch == "" || info.APK.Arch == "") {
		return ErrFieldEmpty{"arch"}
	}
	if info.Version == "" {
		return ErrFieldEmpty{"version"}
	}

	contents, err := files.ExpandContentGlobs(info.Contents, info.DisableGlobbing)
	if err != nil {
		return err
	}

	if len(info.EmptyFolders) > 0 {
		deprecation.Println("'empty_folders' is deprecated and " +
			"will be removed in a future version, create content with type 'dir' and " +
			"directory name as 'dst' instead")

		for _, emptyFolder := range info.EmptyFolders {
			if contents.ContainsDestination(emptyFolder) {
				return fmt.Errorf("empty folder already exists in contents: %s", emptyFolder)
			}

			f := &files.Content{
				Destination: emptyFolder,
				Type:        "dir",
			}
			contents = append(contents, f.WithFileInfoDefaults())
		}
	}

	// The deprecated EmptyFolders are already converted to contents, so we
	// remove it such that Validate can be called more than once.
	info.EmptyFolders = nil

	info.Contents = contents

	return nil
}

// WithDefaults set some sane defaults into the given Info.
func WithDefaults(info *Info) *Info {
	if info.Platform == "" {
		info.Platform = "linux"
	}
	if info.Description == "" {
		info.Description = "no description given"
	}
	if info.Arch == "" {
		info.Arch = "amd64"
	}
	if info.Version == "" {
		info.Version = "v0.0.0-rc0"
	}

	switch info.VersionSchema {
	case "none":
		// No change to the version or prerelease info set in the YAML file
		break
	case "semver":
		fallthrough
	default:
		info.parseSemver()
	}

	return info
}

// ErrSigningFailure is returned whenever something went wrong during
// the package signing process. The underlying error can be unwrapped
// and could be crypto-related or something that occurred while adding
// the signature to the package.
type ErrSigningFailure struct {
	Err error
}

func (s *ErrSigningFailure) Error() string {
	return fmt.Sprintf("signing error: %v", s.Err)
}

func (s *ErrSigningFailure) Unwarp() error {
	return s.Err
}
