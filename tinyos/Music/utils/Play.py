import socket
import Sensing
import re
import sys
import pygame
from threading import Thread
import time

port = 7000
pygame.init()
sbuff = []
single = True

a = pygame.mixer.Sound("samples/piano/a1.wav")
b = pygame.mixer.Sound("samples/piano/b1.wav")
c = pygame.mixer.Sound("samples/piano/c1.wav")
d = pygame.mixer.Sound("samples/piano/d1.wav")
e = pygame.mixer.Sound("samples/piano/e1.wav")
f = pygame.mixer.Sound("samples/piano/f1.wav")
g = pygame.mixer.Sound("samples/piano/g1.wav")
coir = pygame.mixer.Sound("samples/ambi_choir.wav")


def play(sender=None, instrument=None):
    if instrument == 1:
        c.play()
    elif instrument == 2:
        d.play()
    elif instrument == 3:
        e.play()
    elif instrument == 4:
        f.play()
    elif instrument == 5:
        g.play()
    elif instrument == 6:
        a.play()
    elif instrument == 7:
        b.play()
    elif instrument == 100:
        coir.play()

    time.sleep(0.3)

    if sender != None:
        sbuff.remove(sender)
    else:
        global single
        single = True


if __name__ == '__main__':

    s = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)
    s.bind(('', port))

    while True:
        data, addr = s.recvfrom(1024)
        if (len(data) > 0):

            rpt = Sensing.Sensing(data=data, data_length=len(data))

            instrument = rpt.get_instrument()
            sender = rpt.get_sender()
            print (instrument, sender)

            if sender not in sbuff and instrument != 100:
                sbuff.append(sender)
                Thread(target=play, args=[sender, instrument]).start()
            elif single == True and instrument == 100:
                single = False
                Thread(target=play, args=[None, instrument]).start()
