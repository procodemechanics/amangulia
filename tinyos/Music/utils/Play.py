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

drum_splash = pygame.mixer.Sound("samples/drum_splash_hard.wav") #1
drum_bass = pygame.mixer.Sound("samples/drum_bass_hard.wav")     #2
drum_snare = pygame.mixer.Sound("samples/drum_snare_hard.wav")   #3
guit = pygame.mixer.Sound("samples/guit_e_fifths.wav")           #4
choir = pygame.mixer.Sound("samples/ambi_choir.wav")             #5
cymbal = pygame.mixer.Sound("samples/elec_cymbal.wav")           #6
guit_slide = pygame.mixer.Sound("samples/guit_e_slide.wav")      #100

def play(sender=None, instrument=None):
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


            
           

