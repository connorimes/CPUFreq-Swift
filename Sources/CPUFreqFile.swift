/**
 * CPUFreqFile enumeration
 *
 * @author Connor Imes
 * @date 2017-06-15
 */

/// Enumeration of the files possibly available for each CPU.
public enum CPUFreqFile: Int {
    case affectedCpus = 0
    case biosLimit
    case cpuinfoCurFreq
    case cpuinfoMaxFreq
    case cpuinfoMinFreq
    case cpuinfoTransitionLatency
    case relatedCpus
    case scalingAvailableFrequencies
    case scalingAvailableGovernors
    case scalingCurFreq
    case scalingDriver
    case scalingGovernor
    case scalingMaxFreq
    case scalingMinFreq
    case scalingSetspeed

    /// How many entries are in the enum.
    public static let count: Int = {
        var n: Int = 0
        while let _ = CPUFreqFile(rawValue: n) {
            n += 1
        }
        return n
    }()

    // TODO: Can we roll this into the enum declaration above so we don't need a separate array?
    fileprivate static let fileNames: [String] = [
        "affected_cpus",
        "bios_limit",
        "cpuinfo_cur_freq",
        "cpuinfo_max_freq",
        "cpuinfo_min_freq",
        "cpuinfo_transition_latency",
        "related_cpus",
        "scaling_available_frequencies",
        "scaling_available_governors",
        "scaling_cur_freq",
        "scaling_driver",
        "scaling_governor",
        "scaling_max_freq",
        "scaling_min_freq",
        "scaling_setspeed"
    ]

    internal init?(fileName: String) {
        if let idx = CPUFreqFile.fileNames.index(of: fileName) {
            self = CPUFreqFile(rawValue: idx)!
        } else {
            return nil
        }
    }

    /// Get the file name for a file type.
    public func getFileName() -> String {
        return CPUFreqFile.fileNames[self.rawValue]
    }

    /// Get the complete file path for a file type.
    public func getPath(cpu: UInt32) -> String {
        return "/sys/devices/system/cpu/cpu\(cpu)/cpufreq/\(getFileName())"
    }
}
