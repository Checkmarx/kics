# go-csync
Golang: [context](https://godoc.org/golang.org/x/net/context)-aware synchronization primitives.

Only has a mutex right now.

csync.Mutex can used as a drop-in replacement for the [sync.Mutex](https://golang.org/pkg/sync/#Mutex), or with a context, like this:

```go
var mu csync.Mutex
...
func (...) {
	ctx, cf := context.WithTimeout(context.Background(), time.Second)
	if mu.CLock(ctx) != nil {
		// Failed to lock.
		return err
	}
	defer mu.Unlock()
	// Do stuff.
}
```

## Benchstat
On my MacBook Pro:

Comparing [regular mutex](https://golang.org/pkg/sync/#Mutex) to this implementation:
Note, this benchmarks the Lock function.

```
name                old time/op  new time/op  delta
MutexUncontended-8  3.73ns ± 0%  4.43ns ±10%  +18.90%  (p=0.016 n=4+5)
Mutex-8             96.8ns ± 2%  38.6ns ±14%  -60.10%  (p=0.008 n=5+5)
MutexSlack-8         125ns ± 3%    45ns ±14%  -64.12%  (p=0.008 n=5+5)
MutexWork-8          113ns ± 3%   105ns ± 8%     ~     (p=0.095 n=5+5)
MutexWorkSlack-8     149ns ± 7%   103ns ± 5%  -30.97%  (p=0.008 n=5+5)
MutexNoSpin-8        258ns ±10%   281ns ± 7%     ~     (p=0.111 n=5+5)
MutexSpin-8         1.23µs ± 9%  1.25µs ± 5%     ~     (p=1.000 n=5+5)
```

Clock benchmarks:
Note, this benchmars CLock function. Slightly worse than Lock.

```
CMutexUncontended-8         5.59ns ± 9%
CMutexUncontendedTimeout-8  5.38ns ±10%
CMutex-8                    45.1ns ± 6%
CMutexSlack-8               48.8ns ± 6%
CMutexWork-8                 110ns ± 5%
CMutexWorkSlack-8            107ns ± 7%
CMutexNoSpin-8               301ns ±19%
CMutexSpin-8                1.25µs ± 9%
CMutexTimeout-8             26.9ns ± 6%
CMutexSlackTimeout-8        44.2ns ± 3%
CMutexWorkTimeout-8          109ns ± 6%
CMutexWorkSlackTimeout-8     109ns ± 5%
CMutexNoSpinTimeout-8        294ns ± 8%
CMutexSpinTimeout-8         1.30µs ±11%
```
