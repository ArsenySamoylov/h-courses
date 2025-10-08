import matplotlib.pyplot as plt
from collections import Counter
import argparse

def read_trace_from_file(file_path: str) -> list:
    with open(file_path, 'r') as f:
        lines = [line.strip() for line in f]
    return lines

def extract_patterns(trace_lines: list, pattern_length: int) -> list:
    patterns = []
    
    for i in range(len(trace_lines) - pattern_length + 1):
        pattern = '\n'.join(trace_lines[i:i + pattern_length])
        patterns.append(pattern)
    
    return patterns

def find_top_patterns(trace_lines: list, max_pattern_length: int) -> dict:
    all_patterns = {}
    
    for length in range(1, max_pattern_length + 1):
        patterns = extract_patterns(trace_lines, length)
        pattern_counter = Counter(patterns)
        top_patterns = pattern_counter.most_common(5)
        all_patterns[length] = top_patterns
    
    return all_patterns

def create_bar_charts(top_patterns: dict, output_file: str = None):
    
    for length, patterns in top_patterns.items():
        if not patterns:
            continue
            
        _, ax = plt.subplots(figsize=(12, 6))
        
        pattern_names, counts = zip(*patterns)
        
        ax.barh(pattern_names, counts)
        ax.set_title(f'Top 5 patterns for window: {length}')
        ax.set_xlabel('Number')
        ax.set_ylabel('Pattern')
        
        plt.tight_layout()
        plt.savefig(f"{output_file}_length_{length}.png", dpi=300, bbox_inches='tight')
        

def main():
    parser = argparse.ArgumentParser()

    parser.add_argument('-t', help='Path to the trace file', required=True)
    parser.add_argument('-o', help='Output file for charts', required=True)
    parser.add_argument('-w', type=int, default=5, 
                       help='Maximum pattern length to analyze (default: 5)')
    
    args = parser.parse_args()
    
    trace_lines = read_trace_from_file(args.t)
    top_patterns = find_top_patterns(trace_lines, args.w)
    
    create_bar_charts(top_patterns, args.o)

if __name__ == "__main__":
    main()
