// Package deb implements nfpm.Packager providing .deb bindings.
package deb

import (
	"archive/tar"
	"bytes"
	"crypto/md5" // nolint:gas
	"crypto/sha1"
	"errors"
	"fmt"
	"io"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"
	"text/template"
	"time"

	"github.com/blakesmith/ar"
	"github.com/goreleaser/chglog"
	"github.com/goreleaser/nfpm/v2"
	"github.com/goreleaser/nfpm/v2/deprecation"
	"github.com/goreleaser/nfpm/v2/files"
	"github.com/goreleaser/nfpm/v2/internal/sign"
	gzip "github.com/klauspost/pgzip"
	"github.com/ulikunitz/xz"
)

const packagerName = "deb"

// nolint: gochecknoinits
func init() {
	nfpm.RegisterPackager(packagerName, Default)
}

// nolint: gochecknoglobals
var archToDebian = map[string]string{
	"386":      "i386",
	"arm5":     "armel",
	"arm6":     "armhf",
	"arm7":     "armhf",
	"mipsle":   "mipsel",
	"mips64le": "mips64el",
	"ppc64le":  "ppc64el",
	"s390":     "s390x",
}

func ensureValidArch(info *nfpm.Info) *nfpm.Info {
	if info.Deb.Arch != "" {
		info.Arch = info.Deb.Arch
	} else if arch, ok := archToDebian[info.Arch]; ok {
		info.Arch = arch
	}

	return info
}

// Default deb packager.
// nolint: gochecknoglobals
var Default = &Deb{}

// Deb is a deb packager implementation.
type Deb struct{}

// ConventionalFileName returns a file name according
// to the conventions for debian packages. See:
// https://manpages.debian.org/buster/dpkg-dev/dpkg-name.1.en.html
func (*Deb) ConventionalFileName(info *nfpm.Info) string {
	info = ensureValidArch(info)

	version := info.Version
	if info.Prerelease != "" {
		version += "~" + info.Prerelease
	}

	if info.VersionMetadata != "" {
		version += "+" + info.VersionMetadata
	}

	if info.Release != "" {
		version += "-" + info.Release
	}

	// package_version_architecture.package-type
	return fmt.Sprintf("%s_%s_%s.deb", info.Name, version, info.Arch)
}

// ErrInvalidSignatureType happens if the signature type of a deb is not one of
// origin, maint or archive.
var ErrInvalidSignatureType = errors.New("invalid signature type")

// Package writes a new deb package to the given writer using the given info.
func (d *Deb) Package(info *nfpm.Info, deb io.Writer) (err error) { // nolint: funlen
	info = ensureValidArch(info)
	if err = info.Validate(); err != nil {
		return err
	}

	// Set up some deb specific defaults
	d.SetPackagerDefaults(info)

	dataTarball, md5sums, instSize, dataTarballName, err := createDataTarball(info)
	if err != nil {
		return err
	}

	controlTarGz, err := createControl(instSize, md5sums, info)
	if err != nil {
		return err
	}

	debianBinary := []byte("2.0\n")

	w := ar.NewWriter(deb)
	if err := w.WriteGlobalHeader(); err != nil {
		return fmt.Errorf("cannot write ar header to deb file: %w", err)
	}

	if err := addArFile(w, "debian-binary", debianBinary); err != nil {
		return fmt.Errorf("cannot pack debian-binary: %w", err)
	}

	if err := addArFile(w, "control.tar.gz", controlTarGz); err != nil {
		return fmt.Errorf("cannot add control.tar.gz to deb: %w", err)
	}

	if err := addArFile(w, dataTarballName, dataTarball); err != nil {
		return fmt.Errorf("cannot add data.tar.gz to deb: %w", err)
	}

	if info.Deb.Signature.KeyFile != "" {
		sig, sigType, err := doSign(info, debianBinary, controlTarGz, dataTarball)
		if err != nil {
			return err
		}

		if err := addArFile(w, "_gpg"+sigType, sig); err != nil {
			return &nfpm.ErrSigningFailure{
				Err: fmt.Errorf("add signature to ar file: %w", err),
			}
		}
	}

	return nil
}

func doSign(info *nfpm.Info, debianBinary, controlTarGz, dataTarball []byte) ([]byte, string, error) {
	switch info.Deb.Signature.Method {
	case "dpkg-sig":
		return dpkgSign(info, debianBinary, controlTarGz, dataTarball)
	default:
		return debSign(info, debianBinary, controlTarGz, dataTarball)
	}
}

func dpkgSign(info *nfpm.Info, debianBinary, controlTarGz, dataTarball []byte) ([]byte, string, error) {
	sigType := "builder"
	if info.Deb.Signature.Type != "" {
		sigType = info.Deb.Signature.Type
	}

	data, err := readDpkgSigData(info, debianBinary, controlTarGz, dataTarball)
	if err != nil {
		return nil, sigType, &nfpm.ErrSigningFailure{Err: err}
	}

	sig, err := sign.PGPClearSignWithKeyID(data, info.Deb.Signature.KeyFile, info.Deb.Signature.KeyPassphrase, info.Deb.Signature.KeyID)
	if err != nil {
		return nil, sigType, &nfpm.ErrSigningFailure{Err: err}
	}
	return sig, sigType, nil
}

func debSign(info *nfpm.Info, debianBinary, controlTarGz, dataTarball []byte) ([]byte, string, error) {
	data := readDebsignData(debianBinary, controlTarGz, dataTarball)

	sigType := "origin"
	if info.Deb.Signature.Type != "" {
		sigType = info.Deb.Signature.Type
	}

	if sigType != "origin" && sigType != "maint" && sigType != "archive" {
		return nil, sigType, &nfpm.ErrSigningFailure{
			Err: ErrInvalidSignatureType,
		}
	}

	sig, err := sign.PGPArmoredDetachSignWithKeyID(data, info.Deb.Signature.KeyFile, info.Deb.Signature.KeyPassphrase, info.Deb.Signature.KeyID)
	if err != nil {
		return nil, sigType, &nfpm.ErrSigningFailure{Err: err}
	}
	return sig, sigType, nil
}

func readDebsignData(debianBinary, controlTarGz, dataTarball []byte) io.Reader {
	return io.MultiReader(bytes.NewReader(debianBinary), bytes.NewReader(controlTarGz),
		bytes.NewReader(dataTarball))
}

// reference: https://manpages.debian.org/jessie/dpkg-sig/dpkg-sig.1.en.html
const dpkgSigTemplate = `
Hash: SHA1

Version: 4
Signer: {{ .Signer }}
Date: {{ .Date }}
Role: {{ .Role }}
Files:
{{range .Files}}{{ .Md5Sum }} {{ .Sha1Sum }} {{ .Size }} {{ .Name }}{{end}}
`

type dpkgSigData struct {
	Signer string
	Date   time.Time
	Role   string
	Files  []dpkgSigFileLine
	Info   *nfpm.Info
}
type dpkgSigFileLine struct {
	Md5Sum  [16]byte
	Sha1Sum [20]byte
	Size    int
	Name    string
}

func newDpkgSigFileLine(name string, fileContent []byte) dpkgSigFileLine {
	return dpkgSigFileLine{
		Name:    name,
		Md5Sum:  md5.Sum(fileContent),
		Sha1Sum: sha1.Sum(fileContent),
		Size:    len(fileContent),
	}
}

func readDpkgSigData(info *nfpm.Info, debianBinary, controlTarGz, dataTarball []byte) (io.Reader, error) {
	data := dpkgSigData{
		Signer: info.Deb.Signature.Signer,
		Date:   time.Now(),
		Role:   info.Deb.Signature.Type,
		Files: []dpkgSigFileLine{
			newDpkgSigFileLine("debian-binary", debianBinary),
			newDpkgSigFileLine("control.tar.gz", controlTarGz),
			newDpkgSigFileLine("data.tar.gz", dataTarball),
		},
	}
	temp, _ := template.New("dpkg-sig").Parse(dpkgSigTemplate)
	buf := &bytes.Buffer{}
	err := temp.Execute(buf, data)
	if err != nil {
		return nil, fmt.Errorf("dpkg-sig template error: %w", err)
	}
	return buf, nil
}

func (*Deb) SetPackagerDefaults(info *nfpm.Info) {
	// Priority should be set on all packages per:
	//   https://www.debian.org/doc/debian-policy/ch-archive.html#priorities
	// "optional" seems to be the safe/sane default here
	if info.Priority == "" {
		info.Priority = "optional"
	}

	// The safe thing here feels like defaulting to something like below.
	// That will prevent existing configs from breaking anyway...  Wondering
	// if in the long run we should be more strict about this and error when
	// not set?
	if info.Maintainer == "" {
		deprecation.Println("Leaving the 'maintainer' field unset will not be allowed in a future version")
		info.Maintainer = "Unset Maintainer <unset@localhost>"
	}
}

func addArFile(w *ar.Writer, name string, body []byte) error {
	header := ar.Header{
		Name:    files.ToNixPath(name),
		Size:    int64(len(body)),
		Mode:    0o644,
		ModTime: time.Now(),
	}
	if err := w.WriteHeader(&header); err != nil {
		return fmt.Errorf("cannot write file header: %w", err)
	}
	_, err := w.Write(body)
	return err
}

type nopCloser struct {
	io.Writer
}

func (nopCloser) Close() error { return nil }

func createDataTarball(info *nfpm.Info) (dataTarBall, md5sums []byte,
	instSize int64, name string, err error,
) {
	var (
		dataTarball            bytes.Buffer
		dataTarballWriteCloser io.WriteCloser
	)

	switch info.Deb.Compression {
	case "", "gzip": // the default for now
		dataTarballWriteCloser = gzip.NewWriter(&dataTarball)
		name = "data.tar.gz"
	case "xz":
		dataTarballWriteCloser, err = xz.NewWriter(&dataTarball)
		if err != nil {
			return nil, nil, 0, "", err
		}
		name = "data.tar.xz"
	case "none":
		dataTarballWriteCloser = nopCloser{Writer: &dataTarball}
		name = "data.tar"
	default:
		return nil, nil, 0, "", fmt.Errorf("unknown compression algorithm: %s", info.Deb.Compression)
	}

	// the writer is properly closed later, this is just in case that we error out
	defer dataTarballWriteCloser.Close() // nolint: errcheck

	md5sums, instSize, err = fillDataTar(info, dataTarballWriteCloser)
	if err != nil {
		return nil, nil, 0, "", err
	}

	if err := dataTarballWriteCloser.Close(); err != nil {
		return nil, nil, 0, "", fmt.Errorf("closing data tarball: %w", err)
	}

	return dataTarball.Bytes(), md5sums, instSize, name, nil
}

func fillDataTar(info *nfpm.Info, w io.Writer) (md5sums []byte, instSize int64, err error) {
	out := tar.NewWriter(w)

	// the writer is properly closed later, this is just in case that we have
	// an error in another part of the code.
	defer out.Close() // nolint: errcheck

	created := map[string]bool{}

	md5buf, instSize, err := createFilesInsideDataTar(info, out, created)
	if err != nil {
		return nil, 0, err
	}

	if err := out.Close(); err != nil {
		return nil, 0, fmt.Errorf("closing data.tar.gz: %w", err)
	}

	return md5buf.Bytes(), instSize, nil
}

func createSymlinkInsideTar(file *files.Content, out *tar.Writer) error {
	return newItemInsideTar(out, []byte{}, &tar.Header{
		Name:     normalizePath(file.Destination),
		Linkname: file.Source,
		Typeflag: tar.TypeSymlink,
		ModTime:  file.FileInfo.MTime,
		Format:   tar.FormatGNU,
	})
}

func createFilesInsideDataTar(info *nfpm.Info, tw *tar.Writer,
	created map[string]bool,
) (md5buf bytes.Buffer, instSize int64, err error) {
	// create explicit directories first
	for _, file := range info.Contents {
		// at this point, we don't care about other types yet
		if file.Type != "dir" {
			continue
		}

		// only consider contents for this packager
		if file.Packager != "" && file.Packager != packagerName {
			continue
		}

		if err := createTree(tw, file.Destination, created); err != nil {
			return md5buf, 0, err
		}

		normalizedName := normalizePath(strings.Trim(file.Destination, "/")) + "/"

		if created[normalizedName] {
			return md5buf, 0, fmt.Errorf("duplicate directory: %q", normalizedName)
		}

		err = tw.WriteHeader(&tar.Header{
			Name:     normalizedName,
			Mode:     int64(file.FileInfo.Mode),
			Typeflag: tar.TypeDir,
			Format:   tar.FormatGNU,
			Uname:    file.FileInfo.Owner,
			Gname:    file.FileInfo.Group,
			ModTime:  file.FileInfo.MTime,
		})
		if err != nil {
			return md5buf, 0, err
		}

		created[normalizedName] = true
	}

	// create files and implicit directories
	for _, file := range info.Contents {
		// only consider contents for this packager
		if file.Packager != "" && file.Packager != packagerName {
			continue
		}
		// create implicit directory structure below the current content
		if err = createTree(tw, file.Destination, created); err != nil {
			return md5buf, 0, err
		}

		var size int64 // declare early to avoid shadowing err
		switch file.Type {
		case "ghost":
			// skip ghost files in deb
			continue
		case "dir":
			// already handled above
			continue
		case "symlink":
			err = createSymlinkInsideTar(file, tw)
		default:
			size, err = copyToTarAndDigest(file, tw, &md5buf)
		}
		if err != nil {
			return md5buf, 0, err
		}
		instSize += size
	}

	if info.Changelog != "" {
		size, err := createChangelogInsideDataTar(tw, &md5buf, created, info)
		if err != nil {
			return md5buf, 0, err
		}

		instSize += size
	}

	return md5buf, instSize, nil
}

func copyToTarAndDigest(file *files.Content, tw *tar.Writer, md5w io.Writer) (int64, error) {
	tarFile, err := os.OpenFile(file.Source, os.O_RDONLY, 0o600) //nolint:gosec
	if err != nil {
		return 0, fmt.Errorf("could not add tarFile to the archive: %w", err)
	}
	// don't care if it errs while closing...
	defer tarFile.Close() // nolint: errcheck,gosec

	header, err := tar.FileInfoHeader(file, file.Source)
	if err != nil {
		return 0, err
	}

	// tar.FileInfoHeader only uses file.Mode().Perm() which masks the mode with
	// 0o777 which we don't want because we want to be able to set the suid bit.
	header.Mode = int64(file.Mode())
	header.Format = tar.FormatGNU
	header.Name = normalizePath(file.Destination)
	header.Uname = file.FileInfo.Owner
	header.Gname = file.FileInfo.Group
	if err := tw.WriteHeader(header); err != nil {
		return 0, fmt.Errorf("cannot write header of %s to data.tar.gz: %w", file.Source, err)
	}
	digest := md5.New() // nolint:gas
	if _, err := io.Copy(tw, io.TeeReader(tarFile, digest)); err != nil {
		return 0, fmt.Errorf("failed to copy: %w", err)
	}
	if _, err := fmt.Fprintf(md5w, "%x  %s\n", digest.Sum(nil), header.Name); err != nil {
		return 0, fmt.Errorf("failed to write md5: %w", err)
	}
	return file.Size(), nil
}

func createChangelogInsideDataTar(tarw *tar.Writer, md5w io.Writer,
	created map[string]bool, info *nfpm.Info,
) (int64, error) {
	var buf bytes.Buffer
	out := gzip.NewWriter(&buf)
	// the writers are properly closed later, this is just in case that we have
	// an error in another part of the code.
	defer out.Close() // nolint: errcheck

	changelogContent, err := formatChangelog(info)
	if err != nil {
		return 0, err
	}

	if _, err = out.Write([]byte(changelogContent)); err != nil {
		return 0, err
	}

	if err = out.Close(); err != nil {
		return 0, fmt.Errorf("closing changelog.gz: %w", err)
	}

	changelogData := buf.Bytes()

	// https://www.debian.org/doc/manuals/developers-reference/pkgs.de.html#recording-changes-in-the-package
	changelogName := normalizePath(fmt.Sprintf("/usr/share/doc/%s/changelog.gz", info.Name))
	if err = createTree(tarw, changelogName, created); err != nil {
		return 0, err
	}

	digest := md5.New() // nolint:gas
	if _, err = digest.Write(changelogData); err != nil {
		return 0, err
	}

	if _, err = fmt.Fprintf(md5w, "%x  %s\n", digest.Sum(nil), changelogName); err != nil {
		return 0, err
	}

	if err = newFileInsideTar(tarw, changelogName, changelogData); err != nil {
		return 0, err
	}

	return int64(len(changelogData)), nil
}

func formatChangelog(info *nfpm.Info) (string, error) {
	changelog, err := info.GetChangeLog()
	if err != nil {
		return "", err
	}

	tpl, err := chglog.DebTemplate()
	if err != nil {
		return "", err
	}

	formattedChangelog, err := chglog.FormatChangelog(changelog, tpl)
	if err != nil {
		return "", err
	}

	return strings.TrimSpace(formattedChangelog) + "\n", nil
}

// nolint:funlen
func createControl(instSize int64, md5sums []byte, info *nfpm.Info) (controlTarGz []byte, err error) {
	var buf bytes.Buffer
	compress := gzip.NewWriter(&buf)
	out := tar.NewWriter(compress)
	// the writers are properly closed later, this is just in case that we have
	// an error in another part of the code.
	defer out.Close()      // nolint: errcheck
	defer compress.Close() // nolint: errcheck

	var body bytes.Buffer
	if err = writeControl(&body, controlData{
		Info:          info,
		InstalledSize: instSize / 1024,
	}); err != nil {
		return nil, err
	}

	filesToCreate := map[string][]byte{
		"control":   body.Bytes(),
		"md5sums":   md5sums,
		"conffiles": conffiles(info),
	}

	if info.Changelog != "" {
		changeLogData, err := formatChangelog(info)
		if err != nil {
			return nil, err
		}

		filesToCreate["changelog"] = []byte(changeLogData)
	}

	triggers := createTriggers(info)
	if len(triggers) > 0 {
		filesToCreate["triggers"] = triggers
	}

	for name, content := range filesToCreate {
		if err := newFileInsideTar(out, name, content); err != nil {
			return nil, err
		}
	}

	type fileAndMode struct {
		fileName string
		mode     int64
	}

	specialFiles := map[string]*fileAndMode{}
	specialFiles[info.Scripts.PreInstall] = &fileAndMode{
		fileName: "preinst",
		mode:     0o755,
	}
	specialFiles[info.Scripts.PostInstall] = &fileAndMode{
		fileName: "postinst",
		mode:     0o755,
	}
	specialFiles[info.Scripts.PreRemove] = &fileAndMode{
		fileName: "prerm",
		mode:     0o755,
	}
	specialFiles[info.Scripts.PostRemove] = &fileAndMode{
		fileName: "postrm",
		mode:     0o755,
	}
	specialFiles[info.Overridables.Deb.Scripts.Rules] = &fileAndMode{
		fileName: "rules",
		mode:     0o755,
	}
	specialFiles[info.Overridables.Deb.Scripts.Templates] = &fileAndMode{
		fileName: "templates",
		mode:     0o644,
	}
	specialFiles[info.Overridables.Deb.Scripts.Config] = &fileAndMode{
		fileName: "config",
		mode:     0o755,
	}

	for path, destMode := range specialFiles {
		if path != "" {
			if err := newFilePathInsideTar(out, path, destMode.fileName, destMode.mode); err != nil {
				return nil, err
			}
		}
	}

	if err := out.Close(); err != nil {
		return nil, fmt.Errorf("closing control.tar.gz: %w", err)
	}
	if err := compress.Close(); err != nil {
		return nil, fmt.Errorf("closing control.tar.gz: %w", err)
	}
	return buf.Bytes(), nil
}

func newItemInsideTar(out *tar.Writer, content []byte, header *tar.Header) error {
	if err := out.WriteHeader(header); err != nil {
		return fmt.Errorf("cannot write header of %s file to control.tar.gz: %w", header.Name, err)
	}
	if _, err := out.Write(content); err != nil {
		return fmt.Errorf("cannot write %s file to control.tar.gz: %w", header.Name, err)
	}
	return nil
}

func newFileInsideTar(out *tar.Writer, name string, content []byte) error {
	return newItemInsideTar(out, content, &tar.Header{
		Name:     normalizePath(name),
		Size:     int64(len(content)),
		Mode:     0o644,
		ModTime:  time.Now(),
		Typeflag: tar.TypeReg,
		Format:   tar.FormatGNU,
	})
}

func newFilePathInsideTar(out *tar.Writer, path, dest string, mode int64) error {
	file, err := os.Open(path) //nolint:gosec
	if err != nil {
		return err
	}
	content, err := ioutil.ReadAll(file)
	if err != nil {
		return err
	}
	return newItemInsideTar(out, content, &tar.Header{
		Name:     normalizePath(dest),
		Size:     int64(len(content)),
		Mode:     mode,
		ModTime:  time.Now(),
		Typeflag: tar.TypeReg,
		Format:   tar.FormatGNU,
	})
}

// normalizePath returns a path separated by slashes, all relative path items
// resolved and relative to the current directory (so it starts with "./").
func normalizePath(src string) string {
	return "." + files.ToNixPath(filepath.Join("/", src))
}

// this is needed because the data.tar.gz file should have the empty folders
// as well, so we walk through the dst and create all subfolders.
func createTree(tarw *tar.Writer, dst string, created map[string]bool) error {
	for _, path := range pathsToCreate(dst) {
		path = normalizePath(path) + "/"

		if created[path] {
			// skipping dir that was previously created inside the archive
			// (eg: usr/)
			continue
		}

		if err := tarw.WriteHeader(&tar.Header{
			Name:     path,
			Mode:     0o755,
			Typeflag: tar.TypeDir,
			Format:   tar.FormatGNU,
			ModTime:  time.Now(),
			Uname:    "root",
			Gname:    "root",
		}); err != nil {
			return fmt.Errorf("failed to create folder: %w", err)
		}
		created[path] = true
	}
	return nil
}

func pathsToCreate(dst string) []string {
	paths := []string{}
	base := strings.Trim(dst, "/")
	for {
		base = filepath.Dir(base)
		if base == "." {
			break
		}
		paths = append(paths, files.ToNixPath(base))
	}
	// we don't really need to create those things in order apparently, but,
	// it looks really weird if we don't.
	result := []string{}
	for i := len(paths) - 1; i >= 0; i-- {
		result = append(result, paths[i])
	}
	return result
}

func conffiles(info *nfpm.Info) []byte {
	// nolint: prealloc
	var confs []string
	for _, file := range info.Contents {
		if file.Packager != "" && file.Packager != packagerName {
			continue
		}
		switch file.Type {
		case "config", "config|noreplace":
			confs = append(confs, file.Destination)
		}
	}
	return []byte(strings.Join(confs, "\n") + "\n")
}

func createTriggers(info *nfpm.Info) []byte {
	var buffer bytes.Buffer

	// https://man7.org/linux/man-pages/man5/deb-triggers.5.html
	triggerEntries := []struct {
		Directive    string
		TriggerNames *[]string
	}{
		{"interest", &info.Deb.Triggers.Interest},
		{"interest-await", &info.Deb.Triggers.InterestAwait},
		{"interest-noawait", &info.Deb.Triggers.InterestNoAwait},
		{"activate", &info.Deb.Triggers.Activate},
		{"activate-await", &info.Deb.Triggers.ActivateAwait},
		{"activate-noawait", &info.Deb.Triggers.ActivateNoAwait},
	}

	for _, triggerEntry := range triggerEntries {
		for _, triggerName := range *triggerEntry.TriggerNames {
			fmt.Fprintf(&buffer, "%s %s\n", triggerEntry.Directive, triggerName)
		}
	}

	return buffer.Bytes()
}

const controlTemplate = `
{{- /* Mandatory fields */ -}}
Package: {{.Info.Name}}
Version: {{ if .Info.Epoch}}{{ .Info.Epoch }}:{{ end }}{{.Info.Version}}
         {{- if .Info.Prerelease}}~{{ .Info.Prerelease }}{{- end }}
         {{- if .Info.VersionMetadata}}+{{ .Info.VersionMetadata }}{{- end }}
         {{- if .Info.Release}}-{{ .Info.Release }}{{- end }}
Section: {{.Info.Section}}
Priority: {{.Info.Priority}}
Architecture: {{.Info.Arch}}
{{- /* Optional fields */ -}}
{{- if .Info.Maintainer}}
Maintainer: {{.Info.Maintainer}}
{{- end }}
Installed-Size: {{.InstalledSize}}
{{- with .Info.Replaces}}
Replaces: {{join .}}
{{- end }}
{{- with .Info.Provides}}
Provides: {{join .}}
{{- end }}
{{- with .Info.Depends}}
Depends: {{join .}}
{{- end }}
{{- with .Info.Recommends}}
Recommends: {{join .}}
{{- end }}
{{- with .Info.Suggests}}
Suggests: {{join .}}
{{- end }}
{{- with .Info.Conflicts}}
Conflicts: {{join .}}
{{- end }}
{{- with .Info.Deb.Breaks}}
Breaks: {{join .}}
{{- end }}
{{- if .Info.Homepage}}
Homepage: {{.Info.Homepage}}
{{- end }}
{{- /* Mandatory fields */}}
Description: {{multiline .Info.Description}}
{{- range $key, $value := .Info.Deb.Fields }}
{{- if $value }}
{{$key}}: {{$value}}
{{- end }}
{{- end }}
`

type controlData struct {
	Info          *nfpm.Info
	InstalledSize int64
}

func writeControl(w io.Writer, data controlData) error {
	tmpl := template.New("control")
	tmpl.Funcs(template.FuncMap{
		"join": func(strs []string) string {
			return strings.Trim(strings.Join(strs, ", "), " ")
		},
		"multiline": func(strs string) string {
			ret := strings.ReplaceAll(strs, "\n", "\n ")
			return strings.Trim(ret, " \n")
		},
	})
	return template.Must(tmpl.Parse(controlTemplate)).Execute(w, data)
}
