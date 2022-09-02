// Package rpm implements nfpm.Packager providing .rpm bindings using
// google/rpmpack.
package rpm

import (
	"bytes"
	"fmt"
	"io"
	"io/ioutil"
	"os"
	"strconv"
	"strings"
	"time"

	"github.com/google/rpmpack"
	"github.com/goreleaser/chglog"
	"github.com/goreleaser/nfpm/v2"
	"github.com/goreleaser/nfpm/v2/files"
	"github.com/goreleaser/nfpm/v2/internal/sign"
)

const (
	// https://github.com/rpm-software-management/rpm/blob/master/lib/rpmtag.h#L152
	tagChangelogTime = 1080
	// https://github.com/rpm-software-management/rpm/blob/master/lib/rpmtag.h#L153
	tagChangelogName = 1081
	// https://github.com/rpm-software-management/rpm/blob/master/lib/rpmtag.h#L154
	tagChangelogText = 1082

	// Symbolic link
	tagLink = 0o120000
	// Directory
	tagDirectory = 0o40000

	changelogNotesTemplate = `
{{- range .Changes }}{{$note := splitList "\n" .Note}}
- {{ first $note }}
{{- range $i,$n := (rest $note) }}{{- if ne (trim $n) ""}}
{{$n}}{{end}}
{{- end}}{{- end}}`
)

const packagerName = "rpm"

// nolint: gochecknoinits
func init() {
	nfpm.RegisterPackager(packagerName, Default)
}

// Default RPM packager.
// nolint: gochecknoglobals
var Default = &RPM{}

// RPM is a RPM packager implementation.
type RPM struct{}

// https://docs.fedoraproject.org/ro/Fedora_Draft_Documentation/0.1/html/RPM_Guide/ch01s03.html
// nolint: gochecknoglobals
var archToRPM = map[string]string{
	"all":    "noarch",
	"amd64":  "x86_64",
	"386":    "i386",
	"arm64":  "aarch64",
	"arm5":   "armv5tel",
	"arm6":   "armv6hl",
	"arm7":   "armv7hl",
	"mips":   "mips",
	"mipsle": "mipsel",
	// TODO: other arches
}

func ensureValidArch(info *nfpm.Info) *nfpm.Info {
	if info.RPM.Arch != "" {
		info.Arch = info.RPM.Arch
	} else if arch, ok := archToRPM[info.Arch]; ok {
		info.Arch = arch
	}

	return info
}

// ConventionalFileName returns a file name according
// to the conventions for RPM packages. See:
// http://ftp.rpm.org/max-rpm/ch-rpm-file-format.html
func (*RPM) ConventionalFileName(info *nfpm.Info) string {
	info = ensureValidArch(info)

	version := formatVersion(info)
	if info.Release != "" {
		version += "-" + info.Release
	}

	// name-version-release.architecture.rpm
	return fmt.Sprintf("%s-%s.%s.rpm", info.Name, version, info.Arch)
}

// Package writes a new RPM package to the given writer using the given info.
func (*RPM) Package(info *nfpm.Info, w io.Writer) (err error) {
	var (
		meta *rpmpack.RPMMetaData
		rpm  *rpmpack.RPM
	)
	info = ensureValidArch(info)
	if err = info.Validate(); err != nil {
		return err
	}

	if meta, err = buildRPMMeta(info); err != nil {
		return err
	}
	if rpm, err = rpmpack.NewRPM(*meta); err != nil {
		return err
	}

	if info.RPM.Signature.KeyFile != "" {
		rpm.SetPGPSigner(sign.PGPSignerWithKeyID(info.RPM.Signature.KeyFile, info.RPM.Signature.KeyPassphrase, info.RPM.Signature.KeyID))
	}

	if err = createFilesInsideRPM(info, rpm); err != nil {
		return err
	}

	if err = addScriptFiles(info, rpm); err != nil {
		return err
	}

	if info.Changelog != "" {
		if err = addChangeLog(info, rpm); err != nil {
			return err
		}
	}

	if err = rpm.Write(w); err != nil {
		return err
	}

	return nil
}

func addChangeLog(info *nfpm.Info, rpm *rpmpack.RPM) error {
	changelog, err := info.GetChangeLog()
	if err != nil {
		return fmt.Errorf("reading changelog: %w", err)
	}

	if len(changelog.Entries) == 0 {
		// no nothing because creating empty tags
		// would result in an invalid package
		return nil
	}

	tpl, err := chglog.LoadTemplateData(changelogNotesTemplate)
	if err != nil {
		return fmt.Errorf("parsing RPM changelog template: %w", err)
	}

	changes := make([]string, len(changelog.Entries))
	titles := make([]string, len(changelog.Entries))
	times := make([]uint32, len(changelog.Entries))
	for idx, entry := range changelog.Entries {
		var formattedNotes bytes.Buffer

		err := tpl.Execute(&formattedNotes, entry)
		if err != nil {
			return fmt.Errorf("formatting changelog notes: %w", err)
		}

		changes[idx] = strings.TrimSpace(formattedNotes.String())
		times[idx] = uint32(entry.Date.Unix())
		titles[idx] = fmt.Sprintf("%s - %s", entry.Packager, entry.Semver)
	}

	rpm.AddCustomTag(tagChangelogTime, rpmpack.EntryUint32(times))
	rpm.AddCustomTag(tagChangelogName, rpmpack.EntryStringSlice(titles))
	rpm.AddCustomTag(tagChangelogText, rpmpack.EntryStringSlice(changes))

	return nil
}

//nolint:funlen
func buildRPMMeta(info *nfpm.Info) (*rpmpack.RPMMetaData, error) {
	var (
		err   error
		epoch uint64
		provides,
		depends,
		recommends,
		replaces,
		suggests,
		conflicts rpmpack.Relations
	)
	if info.RPM.Compression == "" {
		info.RPM.Compression = "gzip:-1"
	}
	if epoch, err = strconv.ParseUint(defaultTo(info.Epoch, "0"), 10, 32); err != nil {
		return nil, err
	}
	if provides, err = toRelation(info.Provides); err != nil {
		return nil, err
	}
	if depends, err = toRelation(info.Depends); err != nil {
		return nil, err
	}
	if recommends, err = toRelation(info.Recommends); err != nil {
		return nil, err
	}
	if replaces, err = toRelation(info.Replaces); err != nil {
		return nil, err
	}
	if suggests, err = toRelation(info.Suggests); err != nil {
		return nil, err
	}
	if conflicts, err = toRelation(info.Conflicts); err != nil {
		return nil, err
	}

	hostname, err := os.Hostname()
	if err != nil {
		return nil, err
	}

	return &rpmpack.RPMMetaData{
		Name:        info.Name,
		Summary:     defaultTo(info.RPM.Summary, strings.Split(info.Description, "\n")[0]),
		Description: info.Description,
		Version:     formatVersion(info),
		Release:     defaultTo(info.Release, "1"),
		Epoch:       uint32(epoch),
		Arch:        info.Arch,
		OS:          info.Platform,
		Licence:     info.License,
		URL:         info.Homepage,
		Vendor:      info.Vendor,
		Packager:    defaultTo(info.RPM.Packager, info.Maintainer),
		Group:       info.RPM.Group,
		Provides:    provides,
		Recommends:  recommends,
		Requires:    depends,
		Obsoletes:   replaces,
		Suggests:    suggests,
		Conflicts:   conflicts,
		Compressor:  info.RPM.Compression,
		BuildTime:   time.Now(),
		BuildHost:   hostname,
	}, nil
}

func formatVersion(info *nfpm.Info) string {
	version := info.Version

	if info.Prerelease != "" {
		version += "~" + info.Prerelease
	}

	if info.VersionMetadata != "" {
		version += "+" + info.VersionMetadata
	}

	return version
}

func defaultTo(in, def string) string {
	if in == "" {
		return def
	}
	return in
}

func toRelation(items []string) (rpmpack.Relations, error) {
	relations := make(rpmpack.Relations, 0)
	for idx := range items {
		if err := relations.Set(items[idx]); err != nil {
			return nil, err
		}
	}

	return relations, nil
}

func addScriptFiles(info *nfpm.Info, rpm *rpmpack.RPM) error {
	if info.RPM.Scripts.PreTrans != "" {
		data, err := ioutil.ReadFile(info.RPM.Scripts.PreTrans)
		if err != nil {
			return err
		}
		rpm.AddPretrans(string(data))
	}
	if info.Scripts.PreInstall != "" {
		data, err := ioutil.ReadFile(info.Scripts.PreInstall)
		if err != nil {
			return err
		}
		rpm.AddPrein(string(data))
	}

	if info.Scripts.PreRemove != "" {
		data, err := ioutil.ReadFile(info.Scripts.PreRemove)
		if err != nil {
			return err
		}
		rpm.AddPreun(string(data))
	}

	if info.Scripts.PostInstall != "" {
		data, err := ioutil.ReadFile(info.Scripts.PostInstall)
		if err != nil {
			return err
		}
		rpm.AddPostin(string(data))
	}

	if info.Scripts.PostRemove != "" {
		data, err := ioutil.ReadFile(info.Scripts.PostRemove)
		if err != nil {
			return err
		}
		rpm.AddPostun(string(data))
	}

	if info.RPM.Scripts.PostTrans != "" {
		data, err := ioutil.ReadFile(info.RPM.Scripts.PostTrans)
		if err != nil {
			return err
		}
		rpm.AddPosttrans(string(data))
	}

	return nil
}

func createFilesInsideRPM(info *nfpm.Info, rpm *rpmpack.RPM) (err error) {
	for _, content := range info.Contents {
		if content.Packager != "" && content.Packager != packagerName {
			continue
		}

		var file *rpmpack.RPMFile

		switch content.Type {
		case "config":
			file, err = asRPMFile(content, rpmpack.ConfigFile)
		case "config|noreplace":
			file, err = asRPMFile(content, rpmpack.ConfigFile|rpmpack.NoReplaceFile)
		case "ghost":
			if content.FileInfo.Mode == 0 {
				content.FileInfo.Mode = os.FileMode(0o644)
			}

			file, err = asRPMFile(content, rpmpack.GhostFile)
		case "doc":
			file, err = asRPMFile(content, rpmpack.DocFile)
		case "licence", "license":
			file, err = asRPMFile(content, rpmpack.LicenceFile)
		case "readme":
			file, err = asRPMFile(content, rpmpack.ReadmeFile)
		case "symlink":
			file = asRPMSymlink(content)
		case "dir":
			file, err = asRPMDirectory(content)
		default:
			file, err = asRPMFile(content, rpmpack.GenericFile)
		}

		if err != nil {
			return err
		}

		rpm.AddFile(*file)
	}

	return nil
}

func asRPMDirectory(content *files.Content) (*rpmpack.RPMFile, error) {
	return &rpmpack.RPMFile{
		Name:  content.Destination,
		Mode:  uint(content.Mode()) | tagDirectory,
		MTime: uint32(time.Now().Unix()),
		Owner: content.FileInfo.Owner,
		Group: content.FileInfo.Group,
	}, nil
}

func asRPMSymlink(content *files.Content) *rpmpack.RPMFile {
	return &rpmpack.RPMFile{
		Name:  content.Destination,
		Body:  []byte(content.Source),
		Mode:  uint(tagLink),
		MTime: uint32(content.FileInfo.MTime.Unix()),
		Owner: content.FileInfo.Owner,
		Group: content.FileInfo.Group,
	}
}

func asRPMFile(content *files.Content, fileType rpmpack.FileType) (*rpmpack.RPMFile, error) {
	data, err := ioutil.ReadFile(content.Source)
	if err != nil && content.Type != "ghost" {
		return nil, err
	}

	return &rpmpack.RPMFile{
		Name:  content.Destination,
		Body:  data,
		Mode:  uint(content.FileInfo.Mode),
		MTime: uint32(content.FileInfo.MTime.Unix()),
		Owner: content.FileInfo.Owner,
		Group: content.FileInfo.Group,
		Type:  fileType,
	}, nil
}
