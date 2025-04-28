#!/usr/bin/env python3

import argparse
import os
import random
import sys
import time


def main():
    # Set up command line arguments
    parser = argparse.ArgumentParser(description="Simulate bit rot on files in a directory")
    parser.add_argument("path", 
                        help="Path to directory containing files to corrupt")
    parser.add_argument("-c", "--changes", type=int, default=100,
                        help="Number of blocks to corrupt (default: 100)")
    parser.add_argument("-d", "--delay", type=int, default=100,
                        help="Delay between corruptions in milliseconds (default: 100)")
    parser.add_argument("-b", "--block-size", type=int, default=512,
                        help="Size of corruption block in bytes (default: 512)")
    
    args = parser.parse_args()

    # Validate target directory exists
    if not os.path.isdir(args.path):
        sys.exit(f"Error: {args.path} is not a valid directory")

    # Collect all files large enough for block size
    target_files = []
    for root, _, files in os.walk(args.path):
        for name in files:
            file_path = os.path.join(root, name)
            try:
                if os.path.getsize(file_path) >= args.block_size:
                    target_files.append(file_path)
            except OSError as e:
                print(f"Skipping {file_path}: {e}", file=sys.stderr)

    if not target_files:
        sys.exit("No suitable files found for corruption")

    # Perform corruption operations
    for i in range(args.changes):
        # Select random file and valid offset range
        victim = random.choice(target_files)
        try:
            file_size = os.path.getsize(victim)
            max_offset = file_size - args.block_size
            offset = random.randint(0, max_offset)
        except OSError as e:
            print(f"Skipping {victim}: {e}", file=sys.stderr)
            continue

        # Generate random bytes and write to target location
        garbage = os.urandom(args.block_size)
        try:
            with open(victim, "r+b") as f:
                f.seek(offset)
                f.write(garbage)
                print(f"Corrupted {victim} at offset {offset} (change {i+1}/{args.changes})")
        except Exception as e:
            print(f"Failed to corrupt {victim}: {e}", file=sys.stderr)

        # Wait before next operation
        time.sleep(args.delay / 1000)


if __name__ == "__main__":
    main()
