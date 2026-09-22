import os
import signal
import time


def handle_and_ignore(signum, frame):
    print(f"\n[!] Received signal {signum}. Now ignoring future interruptions...")


if __name__ == "__main__":
    signal.signal(signal.SIGINT, handle_and_ignore)
    signal.signal(signal.SIGTERM, handle_and_ignore)

    print(f"Program running. Process ID (PID): {os.getpid()}")

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("Caught KeyboardInterrupt")
