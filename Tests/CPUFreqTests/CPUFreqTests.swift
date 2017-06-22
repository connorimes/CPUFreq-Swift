import XCTest
@testable import CPUFreq

class CPUFreqTests: XCTestCase {

    func testCPUFreqFile() {
        // all files accounted for
        XCTAssert(CPUFreqFile.count == 15)
        // file names
        XCTAssert(CPUFreqFile.affectedCpus.getFileName() == "affected_cpus")
        XCTAssert(CPUFreqFile.biosLimit.getFileName() == "bios_limit")
        XCTAssert(CPUFreqFile.cpuinfoCurFreq.getFileName() == "cpuinfo_cur_freq")
        XCTAssert(CPUFreqFile.cpuinfoMaxFreq.getFileName() == "cpuinfo_max_freq")
        XCTAssert(CPUFreqFile.cpuinfoMinFreq.getFileName() == "cpuinfo_min_freq")
        XCTAssert(CPUFreqFile.cpuinfoTransitionLatency.getFileName() == "cpuinfo_transition_latency")
        XCTAssert(CPUFreqFile.relatedCpus.getFileName() == "related_cpus")
        XCTAssert(CPUFreqFile.scalingAvailableFrequencies.getFileName() == "scaling_available_frequencies")
        XCTAssert(CPUFreqFile.scalingAvailableGovernors.getFileName() == "scaling_available_governors")
        XCTAssert(CPUFreqFile.scalingCurFreq.getFileName() == "scaling_cur_freq")
        XCTAssert(CPUFreqFile.scalingDriver.getFileName() == "scaling_driver")
        XCTAssert(CPUFreqFile.scalingGovernor.getFileName() == "scaling_governor")
        XCTAssert(CPUFreqFile.scalingMaxFreq.getFileName() == "scaling_max_freq")
        XCTAssert(CPUFreqFile.scalingMinFreq.getFileName() == "scaling_min_freq")
        XCTAssert(CPUFreqFile.scalingSetspeed.getFileName() == "scaling_setspeed")
        // from file names
        XCTAssert(CPUFreqFile(fileName: "affected_cpus") == CPUFreqFile.affectedCpus)
        XCTAssert(CPUFreqFile(fileName: "bios_limit") == CPUFreqFile.biosLimit)
        XCTAssert(CPUFreqFile(fileName: "cpuinfo_cur_freq") == CPUFreqFile.cpuinfoCurFreq)
        XCTAssert(CPUFreqFile(fileName: "cpuinfo_max_freq") == CPUFreqFile.cpuinfoMaxFreq)
        XCTAssert(CPUFreqFile(fileName: "cpuinfo_min_freq") == CPUFreqFile.cpuinfoMinFreq)
        XCTAssert(CPUFreqFile(fileName: "cpuinfo_transition_latency") == CPUFreqFile.cpuinfoTransitionLatency)
        XCTAssert(CPUFreqFile(fileName: "related_cpus") == CPUFreqFile.relatedCpus)
        XCTAssert(CPUFreqFile(fileName: "scaling_available_frequencies") == CPUFreqFile.scalingAvailableFrequencies)
        XCTAssert(CPUFreqFile(fileName: "scaling_available_governors") == CPUFreqFile.scalingAvailableGovernors)
        XCTAssert(CPUFreqFile(fileName: "scaling_cur_freq") == CPUFreqFile.scalingCurFreq)
        XCTAssert(CPUFreqFile(fileName: "scaling_driver") == CPUFreqFile.scalingDriver)
        XCTAssert(CPUFreqFile(fileName: "scaling_governor") == CPUFreqFile.scalingGovernor)
        XCTAssert(CPUFreqFile(fileName: "scaling_max_freq") == CPUFreqFile.scalingMaxFreq)
        XCTAssert(CPUFreqFile(fileName: "scaling_min_freq") == CPUFreqFile.scalingMinFreq)
        XCTAssert(CPUFreqFile(fileName: "scaling_setspeed") == CPUFreqFile.scalingSetspeed)
        // path
        XCTAssert(CPUFreqFile.affectedCpus.getPath(cpu: 0) == "/sys/devices/system/cpu/cpu0/cpufreq/affected_cpus")
        XCTAssert(CPUFreqFile.affectedCpus.getPath(cpu: 1) == "/sys/devices/system/cpu/cpu1/cpufreq/affected_cpus")
    }

    func testCPUFreq() {
        let c = CPUFreq(cpu: 0)
        print(String(describing: c.getAffectedCpus()))
        print(String(describing: c.getBiosLimit()))
        print(String(describing: c.getCpuinfoCurFreq()))
        print(String(describing: c.getCpuinfoMaxFreq()))
        print(String(describing: c.getCpuinfoMinFreq()))
        print(String(describing: c.getCpuinfoTransitionLatency()))
        print(String(describing: c.getRelatedCpus()))
        print(String(describing: c.getScalingAvailableFrequencies()))
        print(String(describing: c.getScalingAvailableGovernors()))
        print(String(describing: c.getScalingCurFreq()))
        print(String(describing: c.getScalingDriver()))
        print(String(describing: c.getScalingGovernor(readOnly: true)))
        print(String(describing: c.getScalingMaxFreq(readOnly: true)))
        print(String(describing: c.getScalingMinFreq(readOnly: true)))
    }


    static var allTests = [
        ("testCPUFreqFile", testCPUFreqFile),
        ("testCPUFreq", testCPUFreq),
    ]
}
