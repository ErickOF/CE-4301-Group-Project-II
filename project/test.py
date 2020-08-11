# This is just a normal python file that will be executed by the
# embedded python in the gem5 executable. Therefore, you can use any
# features and libraries available in python.

# The first thing we’ll do in this file is import the m5 library and
# all SimObjects that we’ve compiled.

import m5
from m5.objects import *

# Next, we’ll create the first SimObject: the system that we are going
# to simulate. The System object will be the parent of all the other
# objects in our simulated system. The System object contains a lot of
# functional (not timing-level) information, like the physical memory
# ranges, the root clock domain, the root voltage domain, the kernel
# (in full-system simulation), etc. To create the system SimObject, we
# simply instantiate it like a normal python class:

system = System()

# Now that we have a reference to the system we are going to simulate,
# let’s set the clock on the system. We first have to create a clock
# domain. Then we can set the clock frequency on that domain. Setting
# parameters on a SimObject is exactly the same as setting members of
# an object in python, so we can simply set the clock to 1 GHz, for
# instance. Finally, we have to specify a voltage domain for this
# clock domain. Since we don’t care about system power right now,
# we’ll just use the default options for the voltage domain.

system.clk_domain = SrcClockDomain()
system.clk_domain.clock = '1GHz'
system.clk_domain.voltage_domain = VoltageDomain()

# Once we have a system, let’s set up how the memory will be
# simulated. We are going to use timing mode for the memory
# simulation. You will almost always use timing mode for the memory
# simulation, except in special cases like fast-forwarding and
# restoring from a checkpoint. We will also set up a single memory
# range of size 512 MB, a very small system. Note that in the python
# configuration scripts, whenever a size is required you can specify
# that size in common vernacular and units like '512MB'. Similarly,
# with time you can use time units (e.g., '5ns'). These will
# automatically be converted to a common representation, respectively.

system.mem_mode = 'timing'
system.mem_ranges = [AddrRange('512MB')]

# Now, we can create a CPU. We’ll start with the most simple timing-
# based CPU in gem5, TimingSimpleCPU. This CPU model executes each
# instruction in a single clock cycle to execute, except memory
# requests, which flow through the memory system. To create the CPU
# you can simply just instantiate the object:

system.cpu = TimingSimpleCPU()

# Next, we’re going to create the system-wide memory bus:

system.membus = SystemXBar()

# Now that we have a memory bus, let’s connect the cache ports on the
# CPU to it. In this case, since the system we want to simulate
# doesn’t have any caches, we will connect the I-cache and D-cache
# ports directly to the membus. In this example system, we have no
# caches.

system.cpu.icache_port = system.membus.slave
system.cpu.dcache_port = system.membus.slave

# Next, we need to connect up a few other ports to make sure that our
# system will function correctly. We need to create an I/O controller
# on the CPU and connect it to the memory bus. Also, we need to
# connect a special port in the system up to the membus. This port is
# a functional-only port to allow the system to read and write memory.

# Connecting the PIO and interrupt ports to the memory bus is an
# x86-specific requirement. Other ISAs (e.g., ARM) do not require
# these 3 extra lines.

system.cpu.createInterruptController()
system.cpu.interrupts[0].pio = system.membus.master
system.cpu.interrupts[0].int_master = system.membus.slave
system.cpu.interrupts[0].int_slave = system.membus.master

system.system_port = system.membus.slave

# Next, we need to create a memory controller and connect it to the
# membus. For this system, we’ll use a simple DDR3 controller and it
# will be responsible for the entire memory range of our system.

system.mem_ctrl = DDR3_1600_8x8()
system.mem_ctrl.range = system.mem_ranges[0]
system.mem_ctrl.port = system.membus.master


process = Process()
process.cmd = ['./project/hello']
system.cpu.workload = process
system.cpu.createThreads()

root = Root(full_system = False, system = system)
m5.instantiate()

print('Beginning simulation!')
exit_event = m5.simulate()

print('Exiting @ tick {} because {}'
      .format(m5.curTick(), exit_event.getCause()))

