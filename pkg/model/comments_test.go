package model

import (
	"reflect"
	"testing"
)

// TestRemoveDuplicates tests the RemoveDuplicates function.
func TestRemoveDuplicates(t *testing.T) {
	type args struct {
		lines []int
	}
	tests := []struct {
		name string
		args args
		want []int
	}{
		{
			name: "remove duplicates",
			args: args{
				lines: []int{1, 1, 2, 3, 4, 5},
			},
			want: []int{1, 2, 3, 4, 5},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := RemoveDuplicates(tt.args.lines); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("RemoveDuplicates() = %v, want %v", got, tt.want)
			}
		})
	}
}

// TestProcessCommands tests the ProcessCommands function.
func TestProcessCommands(t *testing.T) {
	type args struct {
		commands []string
	}
	tests := []struct {
		name string
		args args
		want CommentCommand
	}{
		{
			name: "process commands: ignore-line",
			args: args{
				commands: []string{"ignore-line"},
			},
			want: IgnoreLine,
		},
		{
			name: "process commands: ignore-block",
			args: args{
				commands: []string{"ignore-block"},
			},
			want: IgnoreBlock,
		},
		{
			name: "process commands: regular-command",
			args: args{
				commands: []string{"regular-command"},
			},
			want: CommentCommand("regular-command"),
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := ProcessCommands(tt.args.commands); got != tt.want {
				t.Errorf("ProcessCommands() = %v, want %v", got, tt.want)
			}
		})
	}
}

// TestRange tests the Range function.
func TestRange(t *testing.T) {
	type args struct {
		start int
		end   int
	}
	tests := []struct {
		name      string
		args      args
		wantLines []int
	}{
		{
			name: "range: start=1, end=5",
			args: args{
				start: 1,
				end:   5,
			},
			wantLines: []int{1, 2, 3, 4, 5},
		},
		{
			name: "range: start=1, end=1",
			args: args{
				start: 1,
				end:   1,
			},
			wantLines: []int{1},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if gotLines := Range(tt.args.start, tt.args.end); !reflect.DeepEqual(gotLines, tt.wantLines) {
				t.Errorf("Range() = %v, want %v", gotLines, tt.wantLines)
			}
		})
	}
}
