from math import sqrt, ceil
import matplotlib.pyplot as plt
import numpy as np
import sys


def plot(data1: list, data2: list, titles: list, y_labels: list) -> None:
    n = len(data1)

    for x, (d1, d2, title, y_label) in enumerate(zip(data1, data2, titles, y_labels)):
        plt.subplot(ceil(sqrt(n)) - 1, ceil(sqrt(n)), x + 1)
        plt.title(title)
        plt.bar('Normal', d1)
        plt.bar('Enhanced', d2)
        plt.ylabel(y_label)

    plt.show()

def read_file(filename: str) -> str:
    with open(filename, 'r') as file:
        return file.read().split('\n')

def parse_information(lines: list) -> list:
    result: list = []

    for line in lines:
        if 'host_inst_rate' in line:
            line = line.replace(' ', '').replace('\t', '')
            index = line.index('#')
            result.append(eval(line[len('host_inst_rate'):index])/1000)
            
        elif 'system.l2.overall_hits::total' in line:
            line = line.replace(' ', '').replace('\t', '')
            index = line.index('#')
            result.append(eval(line[len('system.l2.overall_hits::total'):index]))
            
        elif 'system.l2.overall_misses::total' in line:
            line = line.replace(' ', '').replace('\t', '')
            index = line.index('#')
            result.append(eval(line[len('system.l2.overall_misses::total'):index]))
            
        elif 'system.l2.demand_accesses::total' in line:
            line = line.replace(' ', '').replace('\t', '')
            index = line.index('#')
            result.append(eval(line[len('system.l2.demand_accesses::total'):index]))
            
        elif 'system.cpu.icache.overall_hits::total' in line:
            line = line.replace(' ', '').replace('\t', '')
            index = line.index('#')
            result.append(eval(line[len('system.cpu.icache.overall_hits::total'):index]))
            
        elif 'system.cpu.icache.overall_misses::total' in line:
            line = line.replace(' ', '').replace('\t', '')
            index = line.index('#')
            result.append(eval(line[len('system.cpu.icache.overall_misses::total'):index]))
            
        elif 'system.cpu.icache.overall_accesses::total' in line:
            line = line.replace(' ', '').replace('\t', '')
            index = line.index('#')
            result.append(eval(line[len('system.cpu.icache.overall_accesses::total'):index]))
            
        elif 'system.cpu.dcache.overall_hits::total' in line:
            line = line.replace(' ', '').replace('\t', '')
            index = line.index('#')
            result.append(eval(line[len('system.cpu.dcache.overall_hits::total'):index]))
            
        elif 'system.cpu.dcache.overall_misses::total' in line:
            line = line.replace(' ', '').replace('\t', '')
            index = line.index('#')
            result.append(eval(line[len('system.cpu.dcache.overall_misses::total'):index]))
            
        elif 'system.cpu.dcache.overall_accesses::total' in line:
            line = line.replace(' ', '').replace('\t', '')
            index = line.index('#')
            result.append(eval(line[len('system.cpu.icache.overall_accesses::total'):index]))

    return result


if __name__ == '__main__':
    # Get file names
    normal_filename, enhanced_filename = sys.argv[1:]
    
    # Get info
    normal_info = read_file(normal_filename)
    enhanced_info = read_file(enhanced_filename)

    # Parsing data
    normal_data = parse_information(normal_info)
    enhanced_data = parse_information(enhanced_info)

    # Titles
    titles = ['Instructions/s',
            'L2 Cache Hits',  'L2 Cache Misses',  'L2 Cache Total Access',
            'L1 ICache Hits', 'L1 ICache Misses', 'L1 ICache Total Access',
            'L1 DCache Hits', 'L1 DCache Misses', 'L1 DCache Total Access']
    
    # Y Labels
    y_labels = ['kInstr/s', 'hits', 'miss', 'access', 'hits', 'miss',
                'access', 'hit', 'miss', 'access']

    # Show data
    i = 0

    for (d1, d2, tag) in zip(normal_data, enhanced_data, titles):
        print(tag, end='\t\t' if i not in [3, 6, 9] else '\t')
        print(d1, d2, (100*(d2 - d1)/max(d1, d2), 2), sep='\t\t')

        i += 1

    # Show plot
    plot(normal_data, enhanced_data, titles, y_labels)
