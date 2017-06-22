/**
 * Bindings to cpufreq in Linux sysfs.
 * Files that are read/write can be opened as read only so unprivileged applications can still read values.
 *
 * @author Connor Imes
 * @date 2017-06-15
 */

import Foundation

fileprivate extension FileHandle {

    func readString() -> String? {
        seek(toFileOffset: 0)
        // must replace newline characters for conversions to integer types to work
        return String(data: readDataToEndOfFile(), encoding: String.Encoding.ascii)?.replacingOccurrences(of: "\n", with: "")
    }

    func readStringArr() -> [String]? {
        return readString()?.components(separatedBy: " ")
    }

    func readU32() -> UInt32? {
        if let s: String = readString() {
            return UInt32(s)
        }
        return nil
    }

    func readU32Arr() -> [UInt32]? {
        return readStringArr()?.flatMap{UInt32($0)}
    }

    func writeString(_ s: String) -> Bool {
        if let data = s.data(using: String.Encoding.ascii, allowLossyConversion: false) {
            seek(toFileOffset: 0)
            write(data)
            return true
        }
        return false
    }

    func writeU32(_ u: UInt32) -> Bool {
        return writeString("\(u)")
    }
}

/// Bindings for CPUFreq that manage file I/O and data parsing/conversion.
/**
 Manages reading and writing files for files in the CPUFreq sysfs interface in Linux.
 The class automatically opens files when a read or write is requested.
 Files are automatically closed when the class instance is deallocated.
 A function is also available for users to close individual files without deallocating the class instance.
*/
public class CPUFreq {
    /// The CPU that these bindings operate on
    public let cpu: UInt32
    /// FileHandle instances for each potential file
    private var files: [FileHandle?] = [FileHandle?](repeating: nil, count: CPUFreqFile.count)

    /// Instantiate for a CPU - cpu0 is used by default.
    public init(cpu: UInt32 = 0) {
        self.cpu = cpu
    }

    /// Close a file if it is open.
    public func closeFile(file: CPUFreqFile) {
        files[file.rawValue] = nil
    }

    private func openForR(_ f: CPUFreqFile) {
        if files[f.rawValue] == nil {
            files[f.rawValue] = FileHandle(forReadingAtPath: f.getPath(cpu: cpu))
        }
    }

    private func openForW(_ f: CPUFreqFile) {
        if files[f.rawValue] == nil {
            files[f.rawValue] = FileHandle(forWritingAtPath: f.getPath(cpu: cpu))
        }
    }

    private func openForRW(_ f: CPUFreqFile, _ readOnly: Bool) {
        if readOnly {
            openForR(f)
        } else if files[f.rawValue] == nil {
            files[f.rawValue] = FileHandle(forUpdatingAtPath: f.getPath(cpu: cpu))
        }
    }

    /// Get the affected CPUs.
    public func getAffectedCpus() -> [UInt32]? {
        openForR(CPUFreqFile.affectedCpus)
        return files[CPUFreqFile.affectedCpus.rawValue]?.readU32Arr()
    }

    /// Get the BIOS limit.
    public func getBiosLimit() -> UInt32? {
        openForR(CPUFreqFile.biosLimit)
        return files[CPUFreqFile.biosLimit.rawValue]?.readU32()
    }

    /// Get the current frequency.
    public func getCpuinfoCurFreq() -> UInt32? {
        openForR(CPUFreqFile.cpuinfoCurFreq)
        return files[CPUFreqFile.cpuinfoCurFreq.rawValue]?.readU32()
    }

    /// Get the allowable maximum frequency.
    public func getCpuinfoMaxFreq() -> UInt32? {
        openForR(CPUFreqFile.cpuinfoMaxFreq)
        return files[CPUFreqFile.cpuinfoMaxFreq.rawValue]?.readU32()
    }

    /// Get the allowable minimum frequency.
    public func getCpuinfoMinFreq() -> UInt32? {
        openForR(CPUFreqFile.cpuinfoMinFreq)
        return files[CPUFreqFile.cpuinfoMinFreq.rawValue]?.readU32()
    }

    /// Get the transition latency.
    public func getCpuinfoTransitionLatency() -> UInt32? {
        openForR(CPUFreqFile.cpuinfoTransitionLatency)
        return files[CPUFreqFile.cpuinfoTransitionLatency.rawValue]?.readU32()
    }

    /// Get related CPUs.
    public func getRelatedCpus() -> [UInt32]? {
        openForR(CPUFreqFile.relatedCpus)
        return files[CPUFreqFile.relatedCpus.rawValue]?.readU32Arr()
    }

    /// Get the available scaling frequencies.
    public func getScalingAvailableFrequencies() -> [UInt32]? {
        openForR(CPUFreqFile.scalingAvailableFrequencies)
        return files[CPUFreqFile.scalingAvailableFrequencies.rawValue]?.readU32Arr()
    }

    /// Get the available scaling governors.
    public func getScalingAvailableGovernors() -> [String]? {
        openForR(CPUFreqFile.scalingAvailableGovernors)
        return files[CPUFreqFile.scalingAvailableGovernors.rawValue]?.readStringArr()
    }

    /// Get the current scaling frequency.
    public func getScalingCurFreq() -> UInt32? {
        openForR(CPUFreqFile.scalingCurFreq)
        return files[CPUFreqFile.scalingCurFreq.rawValue]?.readU32()
    }

    /// Get the scaling driver.
    public func getScalingDriver() -> String? {
        openForR(CPUFreqFile.scalingDriver)
        return files[CPUFreqFile.scalingDriver.rawValue]?.readString()
    }

    /// Get the scaling governor.
    public func getScalingGovernor(readOnly: Bool = false) -> String? {
        openForRW(CPUFreqFile.scalingGovernor, readOnly)
        return files[CPUFreqFile.scalingGovernor.rawValue]?.readString()
    }

    /// Set the scaling governor.
    public func setScalingGovernor(governor: String, readOnly: Bool = false) -> Bool {
        openForRW(CPUFreqFile.scalingGovernor, readOnly)
        if let f = files[CPUFreqFile.scalingGovernor.rawValue] {
            return f.writeString(governor)
        }
        return false
    }

    /// Get the maximum frequency.
    public func getScalingMaxFreq(readOnly: Bool = false) -> UInt32? {
        openForRW(CPUFreqFile.scalingMaxFreq, readOnly)
        return files[CPUFreqFile.scalingMaxFreq.rawValue]?.readU32()
    }

    /// Set the maximum frequency.
    public func setScalingMaxFreq(freq: UInt32, readOnly: Bool = false) -> Bool {
        openForRW(CPUFreqFile.scalingMaxFreq, readOnly)
        if let f = files[CPUFreqFile.scalingMaxFreq.rawValue] {
            return f.writeU32(freq)
        }
        return false
    }

    /// Get the minimum frequency.
    public func getScalingMinFreq(readOnly: Bool = false) -> UInt32? {
        openForRW(CPUFreqFile.scalingMinFreq, readOnly)
        return files[CPUFreqFile.scalingMinFreq.rawValue]?.readU32()
    }

    /// Set the minimum frequency.
    public func setScalingMinFreq(freq: UInt32, readOnly: Bool = false) -> Bool {
        openForRW(CPUFreqFile.scalingMinFreq, readOnly)
        if let f = files[CPUFreqFile.scalingMinFreq.rawValue] {
            return f.writeU32(freq)
        }
        return false
    }

    /// Set the scaling speed when using the userspace governor.
    public func setScalingSetspeed(freq: UInt32) -> Bool {
        openForW(CPUFreqFile.scalingSetspeed)
        if let f = files[CPUFreqFile.scalingSetspeed.rawValue] {
            return f.writeU32(freq)
        }
        return false
    }

}
