# CPUFreq - Swift 3.x bindings to CPUFreq in Linux sysfs

The project provides the `CPUFreq` Swift package - a thin wrapper around the `CPUFreq` Linux interface in sysfs for getting and setting DVFS-related configurations.
Its purpose is to abstract programs from file I/O and data parsing/conversion.
It does not provide core/domain/socket discovery or DVFS management logic.

For Linux kernel documentation on CPUFreq, see: https://www.kernel.org/doc/Documentation/cpu-freq/user-guide.txt


## Building

To build, run:

```sh
swift build
```


## Usage

A simple example of setting DVFS frequencies with the `userspace` governor:

```Swift
import CPUFreq

// in practice, core IDs could be discovered dynamically using other means...
let bindings: [CPUFreq] = [ CPUFreq(cpu: 0), CPUFreq(cpu: 1) ]

// populate "availableFreqs" array
let availableFreqs: [UInt32] = bindings[0].getScalingAvailableFrequencies()!
// won't use that file again, so we can manually close it to free up resources
bindings[0].closeFile(file: CPUFreqFile.scalingAvailableFrequencies)

// set "userspace" governor on all cores
for cpu in bindings {
    let _ = cpu.setScalingGovernor(governor: "userspace")
    // again, close the file manually to free up resources
    cpu.closeFile(file: CPUFreqFile.scalingGovernor)
}

// do application work, breaking from loop when finished...
while (true) {
    // in practice, a new frequency would be determined dynamically by some scheduling logic...
    let freq = availableFreqs[0];
    for cpu in bindings {
        let _ = cpu.setScalingSetspeed(freq: freq);
    }
}

// once bindings go out of scope, any open files (e.g. CPUFreqFile.scalingSetspeed) are closed automatically
```

The files `scaling_governor`, `scaling_min_freq`, and `scaling_max_freq` are opened as read/write by default, but may be opened as read-only by specifying `readOnly: True` as a function parameter when they are first accessed.
The file `scaling_setspeed` is opened as write-only.
All other files are opened as read-only.
Users are responsible for ensuring that their programs have correct read/write privileges.
