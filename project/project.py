import m5
from m5.objects import *

from optparse import OptionParser


# Setting
parser = OptionParser()

# Short way
parser.add_option('--l1pf', help='L1 Cache prefetcher')
parser.add_option('--l2pf', help='L1 Cache prefetcher')
parser.add_option('--l1rp', help='L1 Cache replacement policy')
parser.add_option('--l2rp', help='L2 Cache replacement policy')
parser.add_option('--l1ll', help='L1 Cache lookup latency')
parser.add_option('--l2ll', help='L2 Cache lookup latency')
parser.add_option('--l1a', help='L1 caches associativity')
parser.add_option('--l2a', help='L2 cache associativity')


# Get settings
(options, args) = parser.parse_args()


class L1Cache(Cache):
    """This class represents a base class for L1 Cache.
    """
    def __init__(self, assoc=2, tag_latency=2, prefetcher=None,
                replacement_policy=None):
        # Init parent class
        super(L1Cache, self).__init__()

        # Settings
        self.assoc = assoc
        self.tag_latency = tag_latency
        self.data_latency = 2
        self.response_latency = 2
        self.mshrs = 4
        self.tgts_per_mshr = 20

        # Choose prefetcher
        if prefetcher:
            if prefetcher == 'BasePrefetcher':
                self.prefetcher = BasePrefetcher()
            elif prefetcher == 'MultiPrefetcher':
                self.prefetcher = MultiPrefetcher()
            elif prefetcher == 'QueuedPrefetcher':
                self.prefetcher = QueuedPrefetcher()
            elif prefetcher == 'StridePrefetcher':
                self.prefetcher = StridePrefetcher()
            elif prefetcher == 'TaggedPrefetcher':
                self.prefetcher = TaggedPrefetcher()
            elif prefetcher == 'IndirectMemoryPrefetcher':
                self.prefetcher = IndirectMemoryPrefetcher()
            elif prefetcher == 'SignaturePathPrefetcher':
                self.prefetcher = SignaturePathPrefetcher()
            elif prefetcher == 'SignaturePathPrefetcherV2':
                self.prefetcher = SignaturePathPrefetcherV2()
            elif prefetcher == 'AMPMPrefetcher':
                self.prefetcher = AMPMPrefetcher()
            elif prefetcher == 'DCPTPrefetcher':
                self.prefetcher = DCPTPrefetcher()
            elif prefetcher == 'IrregularStreamBufferPrefetcher':
                self.prefetcher = IrregularStreamBufferPrefetcher()
            elif prefetcher == 'SlimAMPMPrefetcher':
                self.prefetcher = SlimAMPMPrefetcher()
            elif prefetcher == 'BOPPrefetcher':
                self.prefetcher = BOPPrefetcher()
            elif prefetcher == 'SBOOEPrefetcher':
                self.prefetcher = SBOOEPrefetcher()
            elif prefetcher == 'STeMSPrefetcher':
                self.prefetcher = STeMSPrefetcher()
            elif prefetcher == 'PIFPrefetcher':
                self.prefetcher = PIFPrefetcher()
            else:
                raise ValueError('No valid prefetcher was given.')

    def connectCPU(self, cpu):
        """This method connects a CPU with the Cache.
        """
        raise NotImplementedError

    def connectBus(self, bus):
        """This method connects the Cache to the bus.
        """
        self.mem_side = bus.slave

class L1ICache(L1Cache):
    """This class represents a L1 Cache for intructions.
    """
    def __init__(self, size='16kB', assoc=None, tag_latency=None,
                 prefetcher=None, replacement_policy=None):
        # Init parent class
        L1Cache.__init__(self, assoc=assoc, tag_latency=tag_latency,
                         prefetcher=prefetcher,
                         replacement_policy=replacement_policy)
        self.size = size

    def connectCPU(self, cpu):
        """This method connects a CPU with the Cache.
        """
        self.cpu_side = cpu.icache_port

class L1DCache(L1Cache):
    """This class represents a L1 Cache for data.
    """
    def __init__(self, size='64kB', assoc=None, tag_latency=None,
                 prefetcher=None, replacement_policy=None):
        L1Cache.__init__(self, assoc=assoc, tag_latency=tag_latency,
                         prefetcher=prefetcher,
                         replacement_policy=replacement_policy)
        self.size = size

    def connectCPU(self, cpu):
        """This method connect a CPU with the Cache.
        """
        self.cpu_side = cpu.dcache_port

class L2Cache(Cache):
    """This class represents a L2 Cache (for data and instructions).
    """
    def __init__(self, assoc=8, tag_latency=20, prefetcher=None,
                replacement_policy=None):
        # Init parent class
        super(L2Cache, self).__init__()
        # Settings
        self.size = '256kB'
        self.assoc = assoc
        self.tag_latency = tag_latency
        self.data_latency = 20
        self.response_latency = 20
        self.mshrs = 20
        self.tgts_per_mshr = 12

        # Choose prefetcher
        if prefetcher:
            if prefetcher == 'BasePrefetcher':
                self.prefetcher = BasePrefetcher()
            elif prefetcher == 'MultiPrefetcher':
                self.prefetcher = MultiPrefetcher()
            elif prefetcher == 'QueuedPrefetcher':
                self.prefetcher = QueuedPrefetcher()
            elif prefetcher == 'StridePrefetcher':
                self.prefetcher = StridePrefetcher()
            elif prefetcher == 'TaggedPrefetcher':
                self.prefetcher = TaggedPrefetcher()
            elif prefetcher == 'IndirectMemoryPrefetcher':
                self.prefetcher = IndirectMemoryPrefetcher()
            elif prefetcher == 'SignaturePathPrefetcher':
                self.prefetcher = SignaturePathPrefetcher()
            elif prefetcher == 'SignaturePathPrefetcherV2':
                self.prefetcher = SignaturePathPrefetcherV2()
            elif prefetcher == 'AMPMPrefetcher':
                self.prefetcher = AMPMPrefetcher()
            elif prefetcher == 'DCPTPrefetcher':
                self.prefetcher = DCPTPrefetcher()
            elif prefetcher == 'IrregularStreamBufferPrefetcher':
                self.prefetcher = IrregularStreamBufferPrefetcher()
            elif prefetcher == 'SlimAMPMPrefetcher':
                self.prefetcher = SlimAMPMPrefetcher()
            elif prefetcher == 'BOPPrefetcher':
                self.prefetcher = BOPPrefetcher()
            elif prefetcher == 'SBOOEPrefetcher':
                self.prefetcher = SBOOEPrefetcher()
            elif prefetcher == 'STeMSPrefetcher':
                self.prefetcher = STeMSPrefetcher()
            elif prefetcher == 'PIFPrefetcher':
                self.prefetcher = PIFPrefetcher()
            else:
                raise ValueError('No valid prefetcher was given.')

    def connectCPUSideBus(self, bus):
        """This method
        """
        self.cpu_side = bus.master

    def connectMemSideBus(self, bus):
        self.mem_side = bus.slave

class AtomicSimpleCPUSystem(System):
    """This class represents System based on the Atomic Simple CPU
    with a L1 Data Cache, a L1 Instruction Cache, a L2 Cache and a
    RAM with its controller.
    """
    def __init__(self, args):
        System.__init__(self)

        # Set the clock to 1GHz
        self.clk_domain = SrcClockDomain()
        self.clk_domain.clock = '1GHz'
        self.clk_domain.voltage_domain = VoltageDomain()

        # Set atomic memory accesses
        self.mem_mode = 'atomic'
        self.mem_ranges = [AddrRange('8192MB')]

        # Using Atomic Simple CPU
        self.cpu = AtomicSimpleCPU()

        # Creating L1 Caches
        self.cpu.dcache = L1DCache(assoc=args.l1a, tag_latency=args.l1ll,
                                    prefetcher=args.l1pf)
        self.cpu.icache = L1ICache(assoc=args.l1a, tag_latency=args.l1ll,
                                    prefetcher=args.l1pf)

        # Connect bus to data and instructions cache
        self.cpu.icache.connectCPU(self.cpu)
        self.cpu.dcache.connectCPU(self.cpu)

        # Creating bus to connect data and instruction cache to L2
        # cache
        self.l2bus = L2XBar()

        # Connecting L1 caches bus to L2 cache
        self.cpu.icache.connectBus(self.l2bus)
        self.cpu.dcache.connectBus(self.l2bus)

        # Creating L2 cache
        self.l2cache = L2Cache(assoc=args.l2a)

        # Connecting L2 cache to the bus
        self.l2cache.connectCPUSideBus(self.l2bus)

        # Creating system bus to connect L2 cache to RAM
        self.membus = SystemXBar()

        # Connecting cache to RAM memory bus
        self.l2cache.connectMemSideBus(self.membus)

        # Creating an I/O controller on the CPU
        self.cpu.createInterruptController()

        # Connecting Controller to the RAM memory bus
        self.cpu.interrupts[0].pio = self.membus.master
        self.cpu.interrupts[0].int_master = self.membus.slave
        self.cpu.interrupts[0].int_slave = self.membus.master

        # Creating a memory controller and connect it to the membus
        self.mem_ctrl = DDR3_1600_8x8()
        self.mem_ctrl.range = self.mem_ranges[0]
        self.mem_ctrl.port = self.membus.master

        self.system_port = self.membus.slave
    
    def setProcess(self, process):
        """This method set the process to be executed.

        Params
        --------------------------------------------------------------
            process: Process
                process to be executed
        """
        self.cpu.workload = process
        self.cpu.createThreads()

## MAIN PROGRAM

print(options, args)
print(options.l1pf)
print(options.l1rp)
print(options.l1ll)
print(options.l1a)

print(options.l2pf)
print(options.l2rp)
print(options.l2ll)
print(options.l2a)

# Create System
system = AtomicSimpleCPUSystem(options)

# Create process
process = Process()
process.cmd = ['./project/hello']

# Set process to the system
system.setProcess(process)

# Creating the Root object
root = Root(full_system=False, system=system)

# Start simulation
m5.instantiate()

print('Beginning simulation!')
exit_event = m5.simulate()

print('Exiting @ tick {} because {}'
      .format(m5.curTick(), exit_event.getCause()))
