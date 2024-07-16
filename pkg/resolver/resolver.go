package resolver

import (
	"os"
	"path/filepath"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/rs/zerolog/log"
)

// kindResolver is a type of resolver interface (ex: helm resolver)
// Resolve will render file/template
// SupportedTypes will return the file kinds that the resolver supports
type kindResolver interface {
	Resolve(filePath string) (model.ResolvedFiles, error)
	SupportedTypes() []model.FileKind
}

// Resolver is a struct containing the resolvers by file kind
type Resolver struct {
	resolvers map[model.FileKind]kindResolver
}

// Builder is a struct used to create a new resolver
type Builder struct {
	resolvers []kindResolver
}

// NewBuilder creates a new Builder's reference
func NewBuilder() *Builder {
	return &Builder{}
}

// Add will add kindResolvers for building the resolver
func (b *Builder) Add(p kindResolver) *Builder {
	log.Debug().Msgf("resolver.Add()")
	b.resolvers = append(b.resolvers, p)
	return b
}

// Build will create a new instance of a resolver
func (b *Builder) Build() (*Resolver, error) {
	log.Debug().Msg("resolver.Build()")

	resolvers := make(map[model.FileKind]kindResolver, len(b.resolvers))
	for _, resolver := range b.resolvers {
		for _, typeRes := range resolver.SupportedTypes() {
			resolvers[typeRes] = resolver
		}
	}

	return &Resolver{
		resolvers: resolvers,
	}, nil
}

// Resolve will resolve the files according to its type
func (r *Resolver) Resolve(filePath string, kind model.FileKind) (model.ResolvedFiles, error) {
	if r, ok := r.resolvers[kind]; ok {
		obj, err := r.Resolve(filePath)
		if err != nil {
			return model.ResolvedFiles{}, err
		}
		log.Debug().Msgf("resolver.Resolve() rendered file: %s", filePath)
		return obj, nil
	}
	// need to log here
	return model.ResolvedFiles{}, nil
}

// GetType will analyze the filepath to determine which resolver to use
func (r *Resolver) GetType(filePath string) model.FileKind {
	_, err := os.Stat(filepath.Join(filePath, "Chart.yaml"))
	if err == nil {
		return model.KindHELM
	}
	return model.KindCOMMON
}
