import serial
import time
import sys
from enum import IntEnum
import xmodem
import argparse
import progressbar
import os

class State(IntEnum):
    SYNC = 0
    WAIT_FOR_C = 1
    COUNT_C = 2

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('port', help="Serial port for programming")
    parser.add_argument('image', help="Image file")

    return parser.parse_args()

def run(args):
    port = serial.Serial(port=args.port, baudrate=115200, rtscts=False)

    def turn_on():
        port.rts = False

    def turn_off():
        port.rts = True

    def write(text):
        port.write(text)
        port.flush()

    def _xmodem_getc(size, timeout=1):
        d = port.read(1)
        return d

    def _xmodem_putc(data, timeout=1):
        l = port.write(data)
        return l

    def read_to_c():
        r = b''
        while True:
            b = port.read(1)
            if len(r) >= 3 and r[-3:] == b'CCC':
                break
            r += b

        r = r[:-3].strip()

        print('\tResult={}'.format(r))

    # sync dance
    def sync():
        print('Syncing', end='')
        port.timeout = 0.05
        state = State.SYNC
        c_count = 0

        while True:
            sys.stdout.write('.')
            sys.stdout.flush()
            write(b'\x1B')
            if state == State.SYNC:
                turn_off()
                time.sleep(0.02)
                turn_on()
                state = State.WAIT_FOR_C
            elif state == State.WAIT_FOR_C:
                b = port.read(1)
                if b == b'C':
                    print('\nC received')
                    state = State.COUNT_C
                    c_count = 1
            elif state == State.COUNT_C:
                b = port.read(1)
                if b == b'':
                    continue
                elif b == b'C':
                    c_count += 1
                else:
                    print('\nResetting')
                    state = State.SYNC

                if c_count >= 2:
                    print('\nSynced')
                    break
                
        print('\n\nBootloader synced!')
 
    def program():
        port.timeout = None

        widgets = [
            'Uploading ', progressbar.Percentage(),
            ' ', progressbar.Bar(marker='#', left='[', right=']'),
            ' ', progressbar.ETA(),
            ' ', progressbar.FileTransferSpeed(),
        ]

        with open(args.image, 'rb') as f:
            file_size = os.fstat(f.fileno()).st_size
            with progressbar.ProgressBar(widgets=widgets, max_value=file_size) as bar:
                def _report_progress(_, success_count, error_count):
                    transferred_size = min([file_size, 128 * success_count])

                    bar.update(transferred_size)

                modem = xmodem.XMODEM(getc=_xmodem_getc, putc=_xmodem_putc)
                modem.send(f, quiet=False, callback=_report_progress)

    def read_mac():
        print('Reading mac address')
        write([0x21, 0x06, 0x00, 0xea, 0x2d, 0x38, 0x00, 0x00, 0x00])
        read_to_c()

    def read_flash_id():
        print('Reading flash id')
        write([0x21, 0x06, 0x00, 0x1b, 0xe7, 0x3c, 0x00, 0x00, 0x00])
        read_to_c()

    def read_sec_level():
        print('Reading security level')
        write([0x21, 0x06, 0x00, 0xd8, 0x62, 0x34, 0x00, 0x00, 0x00])
        read_to_c()

    sync()
    read_mac()
    program()

run(parse_args())