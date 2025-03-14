import subprocess
import sys

def main(new_version):
    if new_version[0] == 'v':
        new_version = new_version[1:]
    
    subprocess.run(['git', 'tag', f'v{new_version}'], check=True)
    subprocess.run(['git', 'push', 'origin', f'v{new_version}'], check=True)

if __name__ == '__main__':
    if len(sys.argv) > 1:
        main(sys.argv[1])
    else:
        main(input(f'enter new version(e.g. 1.2.3)>>>'))