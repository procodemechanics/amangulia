import socket
import Sensing
import re
import sys
import pygame

port = 7000
pygame.init()

drum = pygame.mixer.Sound("samples/drum_tom_mid_hard.wav")
cymbal = pygame.mixer.Sound("samples/elec_cymbal.wav")

if __name__ == '__main__':

    s = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)
    s.bind(('', port))

    while True:
        data, addr = s.recvfrom(1024)
        if (len(data) > 0):

            rpt = Sensing.Sensing(data=data, data_length=len(data))

            instrument = rpt.get_instrument()
            print(rpt)
            
            if instrument == 1:
                drum.play()
            elif instrument == 2:
                cymbal.play()

