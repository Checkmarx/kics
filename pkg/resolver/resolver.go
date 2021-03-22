package resolver

import (
	"os"
	"path/filepath"

	"github.com/Checkmarx/kics/pkg/model"
)

type kindResolver interface {
	// GetKind() model.FileKind
	Resolve(filePath string) (model.RenderedFiles, error)
	SupportedTypes() []model.FileKind
}

type Resolver struct {
	resolvers map[model.FileKind]kindResolver
}

type Builder struct {
	resolvers []kindResolver
}

// NewBuilder creates a new Builder's reference
func NewBuilder() *Builder {
	return &Builder{}
}

// Add will add kindResolvers for building the resolver
func (b *Builder) Add(p kindResolver) *Builder {
	b.resolvers = append(b.resolvers, p)
	return b
}

// Build will create a new intance of a resolver
func (b *Builder) Build() (*Resolver, error) {
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
func (r *Resolver) Resolve(filePath string, kind model.FileKind) (model.RenderedFiles, error) {
	if r, ok := r.resolvers[kind]; ok {
		obj, err := r.Resolve(filePath)
		if err != nil {
			return model.RenderedFiles{}, nil
		}
		return obj, nil
	}
	// need to log here
	return model.RenderedFiles{}, nil
}

// GetType will analyze the filepath to determine which resolver to use
func (r *Resolver) GetType(filePath string) model.FileKind {
	if _, err := os.Stat(filepath.Join(filePath, "Chart.yaml")); err == nil {
		return model.KINDHELM
	}
	return model.KindCOMMON
}
