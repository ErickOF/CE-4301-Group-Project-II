import m5
from m5.objects import *


class L1Cache(Cache):
    assoc = 2
    tag_latency = 2
    data_latency = 2
    response_latency = 2
    mshrs = 4
    tgts_per_mshr = 20

    def connectCPU(self, cpu):
        raise NotImplementedError

    def connectBus(self, bus):
        self.mem_side = bus.slave

class L1ICache(L1Cache):
    size = '16kB'

    def connectCPU(self, cpu):
        self.cpu_side = cpu.icache_port

class L1DCache(L1Cache):
    size = '64kB'

    def connectCPU(self, cpu):
        self.cpu_side = cpu.dcache_port

class L2Cache(Cache):
    size = '256kB'
    assoc = 8
    tag_latency = 20
    data_latency = 20
    response_latency = 20
    mshrs = 20
    tgts_per_mshr = 12

    def connectCPUSideBus(self, bus):
        self.cpu_side = bus.master

    def connectMemSideBus(self, bus):
        self.mem_side = bus.slave

class AtomicSimpleCPUSystem(System):
    def __init__(self, prefetch=None, replacementPolicies=None,
                lookupLatency=None, associativity=None,
                branchPredictorType=None):
        System.__init__(self)

        # Set the clock to 1GHz
        self.clk_domain = SrcClockDomain()
        self.clk_domain.clock = '1GHz'
        self.clk_domain.voltage_domain = VoltageDomain()

        # Using atomic memory accesses
        self.mem_mode = 'atomic'
        self.mem_ranges = [AddrRange('512MB')]

        # Using Atomic Simple CPU
        self.cpu = AtomicSimpleCPU()

        self.cpu.dcache = L1DCache()
        self.cpu.icache = L1ICache()

        # Connect bus to data and instruction cache
        self.cpu.icache.connectCPU(self.cpu)
        self.cpu.dcache.connectCPU(self.cpu)

        self.l2bus = L2XBar()

        self.cpu.icache.connectBus(self.l2bus)
        self.cpu.dcache.connectBus(self.l2bus)

        self.l2cache = L2Cache()
        self.l2cache.connectCPUSideBus(self.l2bus)

        # System bus
        self.membus = SystemXBar()

        self.l2cache.connectMemSideBus(self.membus)

        # Creating an I/O controller on the CPU
        self.cpu.createInterruptController()

        # Connecting Controller to the memory bus
        self.cpu.interrupts[0].pio = self.membus.master
        self.cpu.interrupts[0].int_master = self.membus.slave
        self.cpu.interrupts[0].int_slave = self.membus.master

        # Creating a memory controller and connect it to the membus
        self.mem_ctrl = DDR3_1600_8x8()
        self.mem_ctrl.range = self.mem_ranges[0]
        self.mem_ctrl.port = self.membus.master

        self.system_port = self.membus.slave
    
    def setProcess(self, process):
        self.cpu.workload = process
        self.cpu.createThreads()

    def setAssociativity(self, assoc):
        self.cache.assoc = assoc


# Create System
system = AtomicSimpleCPUSystem()

# Create process
process = Process()
process.cmd = ['./project/hello']

# Set process to the system
system.setProcess(process)

# Create the Root object
root = Root(full_system=False, system=system)

# Start simulation
m5.instantiate()

print('Beginning simulation!')
exit_event = m5.simulate()

print('Exiting @ tick {} because {}'
      .format(m5.curTick(), exit_event.getCause()))
