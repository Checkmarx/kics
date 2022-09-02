package api

import "fmt"

// NewEmbedBuilder returns a new embed builder
func NewEmbedBuilder() *EmbedBuilder {
	return &EmbedBuilder{}
}

// EmbedBuilder allows you to create embeds and use methods to set values
type EmbedBuilder struct {
	Embed
}

// SetTitle sets the title of the EmbedBuilder
func (b *EmbedBuilder) SetTitle(title string) *EmbedBuilder {
	b.Title = &title
	return b
}

// SetTitlef sets the title of the EmbedBuilder with format
func (b *EmbedBuilder) SetTitlef(title string, a ...interface{}) *EmbedBuilder {
	titlef := fmt.Sprintf(title, a...)
	b.Title = &titlef
	return b
}

// SetDescription sets the description of the EmbedBuilder
func (b *EmbedBuilder) SetDescription(description string) *EmbedBuilder {
	b.Description = &description
	return b
}

// SetDescriptionf sets the description of the EmbedBuilder with format
func (b *EmbedBuilder) SetDescriptionf(description string, a ...interface{}) *EmbedBuilder {
	descriptionf := fmt.Sprintf(description, a...)
	b.Description = &descriptionf
	return b
}

// SetEmbedAuthor sets the author of the EmbedBuilder using an EmbedAuthor struct
func (b *EmbedBuilder) SetEmbedAuthor(author *EmbedAuthor) *EmbedBuilder {
	b.Author = author
	return b
}

// SetAuthor sets the author of the EmbedBuilder without an Icon URL
func (b *EmbedBuilder) SetAuthor(name string, url string, iconURL string) *EmbedBuilder {
	if b.Author == nil {
		b.Author = &EmbedAuthor{}
	}
	b.Author.Name = &name
	b.Author.URL = &url
	b.Author.IconURL = &iconURL
	return b
}

// SetAuthorName sets the author of the EmbedBuilder
func (b *EmbedBuilder) SetAuthorName(name string) *EmbedBuilder {
	if b.Author == nil {
		b.Author = &EmbedAuthor{}
	}
	b.Author.Name = &name
	return b
}

// SetAuthorURL sets the author of the EmbedBuilder with an URL
func (b *EmbedBuilder) SetAuthorURL(url string) *EmbedBuilder {
	if b.Author == nil {
		b.Author = &EmbedAuthor{}
	}
	b.Author.URL = &url
	return b
}

// SetAuthorIcon sets the author of the EmbedBuilder with all properties
func (b *EmbedBuilder) SetAuthorIcon(iconURL string) *EmbedBuilder {
	if b.Author == nil {
		b.Author = &EmbedAuthor{}
	}
	b.Author.IconURL = &iconURL
	return b
}

// SetColor sets the color of the EmbedBuilder
func (b *EmbedBuilder) SetColor(color int) *EmbedBuilder {
	b.Color = &color
	return b
}

// SetEmbedFooter sets the footer of the EmbedBuilder
func (b *EmbedBuilder) SetEmbedFooter(footer *EmbedFooter) *EmbedBuilder {
	b.Footer = footer
	return b
}

// SetFooter sets the footer of the EmbedBuilder
func (b *EmbedBuilder) SetFooter(text string, iconURL string) *EmbedBuilder {
	if b.Footer == nil {
		b.Footer = &EmbedFooter{}
	}
	b.Footer.Text = text
	b.Footer.IconURL = &iconURL
	return b
}

// SetFooterText sets the footer of the EmbedBuilder by text
func (b *EmbedBuilder) SetFooterText(text string) *EmbedBuilder {
	if b.Footer == nil {
		b.Footer = &EmbedFooter{}
	}
	b.Footer.Text = text
	return b
}

// SetFooterIcon sets the footer of the EmbedBuilder by iconURL
func (b *EmbedBuilder) SetFooterIcon(iconURL string) *EmbedBuilder {
	if b.Footer == nil {
		b.Footer = &EmbedFooter{}
	}
	b.Footer.IconURL = &iconURL
	return b
}

// SetImage sets the image of the EmbedBuilder
func (b *EmbedBuilder) SetImage(url string) *EmbedBuilder {
	if b.Image == nil {
		b.Image = &EmbedResource{}
	}
	b.Image.URL = &url
	return b
}

// SetThumbnail sets the thumbnail of the EmbedBuilder
func (b *EmbedBuilder) SetThumbnail(url string) *EmbedBuilder {
	if b.Thumbnail == nil {
		b.Thumbnail = &EmbedResource{}
	}
	b.Thumbnail.URL = &url
	return b
}

// SetURL sets the URL of the EmbedBuilder
func (b *EmbedBuilder) SetURL(url string) *EmbedBuilder {
	b.URL = &url
	return b
}

// AddField adds a field to the EmbedBuilder by name and value
func (b *EmbedBuilder) AddField(name string, value string, inline bool) *EmbedBuilder {
	b.Fields = append(b.Fields, &EmbedField{name, value, &inline})
	return b
}

// SetField sets a field to the EmbedBuilder by name and value
func (b *EmbedBuilder) SetField(i int, name string, value string, inline bool) *EmbedBuilder {
	if len(b.Fields) > i {
		b.Fields[i] = &EmbedField{name, value, &inline}
	}
	return b
}

// AddFields adds multiple fields to the EmbedBuilder
func (b *EmbedBuilder) AddFields(field *EmbedField, fields ...*EmbedField) *EmbedBuilder {
	b.Fields = append(append(b.Fields, field), fields...)
	return b
}

// SetFields sets fields of the EmbedBuilder
func (b *EmbedBuilder) SetFields(fields ...*EmbedField) *EmbedBuilder {
	b.Fields = fields
	return b
}

// ClearFields removes all of the fields from the EmbedBuilder
func (b *EmbedBuilder) ClearFields() *EmbedBuilder {
	b.Fields = []*EmbedField{}
	return b
}

// RemoveField removes a field from the EmbedBuilder
func (b *EmbedBuilder) RemoveField(i int) *EmbedBuilder {
	if len(b.Fields) > i {
		b.Fields = append(b.Fields[:i], b.Fields[i+1:]...)
	}
	return b
}

// Build returns your built Embed
func (b *EmbedBuilder) Build() Embed {
	return b.Embed
}
