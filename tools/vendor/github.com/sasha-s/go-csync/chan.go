package csync

import "sync/atomic"

const (
	start uint32 = iota
	inProgress
	finished
)

// signalChan is a low-level, zero-init singal channel.
type signalChan struct {
	once uint32
	ch   chan struct{}
}

// get makes sure the c is created and returns it.
// This is needed so we can use it as a part of other structs with zero initialization.
func (s *signalChan) get() chan struct{} {
	for {
		// Fast pass.
		switch atomic.LoadUint32(&s.once) {
		case start:
			// Try start -> inProgress.
			if atomic.CompareAndSwapUint32(&s.once, start, inProgress) {
				// State is inProgress now.
				// Init.
				s.ch = make(chan struct{})
				// Finish.
				atomic.SwapUint32(&s.once, finished)
				return s.ch
			}
		case inProgress:
			// Wait for finished.
			continue
		case finished:
			return s.ch
		}
	}
}
