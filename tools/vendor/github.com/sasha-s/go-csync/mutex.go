package csync

import (
	"runtime"
	"sync/atomic"

	"context"
)

// Mutex is a context-aware mutual exclusion lock.
// Mutexes can be created as part of other structures;
// the zero value for a Mutex is an unlocked mutex.
// See https://golang.org/pkg/sync/#Mutex
// Supports CLock and TryLock.
type Mutex struct {
	c  int32
	ch signalChan
}

// SpinFor controls the number of iterations Lock/Clock is allowed to spin for before
// resorting to a slower (channel based) way of locking.
var SpinFor = 50

// Lock the mutex.
// If the mutex is is already locked, the calling goroutine
// blocks until the mutex is available.
func (m *Mutex) Lock() {
	// Try spinning.
	for i := 0; i < SpinFor; i++ {
		if m.TryLock() {
			return
		}
		// Let other goroutines do stuff.
		runtime.Gosched()
	}
	v := atomic.AddInt32(&m.c, 1)
	if v == 1 {
		// Lock grabbed.
		return
	}
	<-m.ch.get()
}

// CLock tries to lock the mutex.
// If the mutex is is already locked, the calling goroutine
// blocks until the mutex is available or the context expires.
// Returns nil if the lock was taken successfully.
func (m *Mutex) CLock(ctx context.Context) error {
	// Try spinning.
	for i := 0; i < SpinFor; i++ {
		if m.TryLock() {
			return nil
		}
		if ctx.Err() != nil {
			return ctx.Err()
		}
		runtime.Gosched()
	}
	v := atomic.AddInt32(&m.c, 1)
	if v == 1 {
		// Lock grabbed.
		return nil
	}
	select {
	case <-m.ch.get():
		// Lock grabbed.
		return nil
	case <-ctx.Done():
		// We have to pull from the channel (otherwise Unlock might block).
		go func() {
			<-m.ch.get()
			m.Unlock()
		}()
		return ctx.Err()
	}
}

// Unlock the mutex. Does not block.
// It is a run-time error (panic) if m is not locked on entry to Unlock.
//
// A locked Mutex is not associated with a particular goroutine.
// It is allowed for one goroutine to lock a Mutex and then
// arrange for another goroutine to unlock it.
func (m *Mutex) Unlock() {
	v := atomic.AddInt32(&m.c, -1)
	if v < 0 {
		panic("sync: unlock of unlocked mutex")
	}
	// Wake one of the waiters up.
	if v != 0 {
		m.ch.get() <- struct{}{}
	}
}

// TryLock tries to lock the mutex. Does not block.
// If the mutex is is already locked, returns false immediately.
// Returns true if the lock was taken successfully.
func (m *Mutex) TryLock() bool {
	return atomic.CompareAndSwapInt32(&m.c, 0, 1)
}
