import socket
import Sensing
import re
import sys
import pygame
from threading import Thread
import time

port = 7000
pygame.init()
buff = []

drum_splash = pygame.mixer.Sound("samples/drum_splash_hard.wav") #1
drum_bass = pygame.mixer.Sound("samples/drum_bass_hard.wav")     #2
drum_snare = pygame.mixer.Sound("samples/drum_snare_hard.wav")   #3
guit = pygame.mixer.Sound("samples/guit_e_fifths.wav")           #4
choir = pygame.mixer.Sound("samples/ambi_choir.wav")             #5
cymbal = pygame.mixer.Sound("samples/elec_cymbal.wav")           #6
guit_slide = pygame.mixer.Sound("samples/guit_e_slide.wav")      #100

def play(instrument):
    if instrument == 1:
        drum_splash.play()
    elif instrument == 2:
        drum_bass.play()
    elif instrument == 3:
        drum_snare.play()
    elif instrument == 4:
        guit.play()
    elif instrument == 5:
        choir.play()
    elif instrument == 6:
        cymbal.play()
    elif instrument == 100:
        guit_slide.play()
    
    time.sleep(0.3)
    buff.remove(instrument)


if __name__ == '__main__':

    s = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)
    s.bind(('', port))

    while True:
        data, addr = s.recvfrom(1024)
        if (len(data) > 0):

            rpt = Sensing.Sensing(data=data, data_length=len(data))
            print(rpt)

            instrument = rpt.get_instrument()
            if instrument not in buff:
                buff.append(instrument)
                Thread(target=play, args=[instrument]).start()
                
            
           

