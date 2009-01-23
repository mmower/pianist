//
//  MIDIController.m
//  Pianist
//
//  Created by Matt Mower on 23/01/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import <CoreMIDI/CoreMIDI.h>
#import <PYMIDI/PYMIDI.h>

#import "MIDIController.h"

@interface MIDIController ()

- (void)processMIDIPacketList:(MIDIPacketList *)packetList sender:(id)sender;
- (void)handleMIDIMessage:(Byte*)message ofSize:(int)size;

@end

@implementation MIDIController

- (id)initWithDestination:(id)theDestination {
  if( ( self = [self init] ) ) {
    destination = theDestination;
  }
  
  return self;
}

@dynamic source;

- (PYMIDIEndpoint *)source {
  return source;
}

- (void)setSource:(PYMIDIEndpoint *)newSource {
  [source removeReceiver:self];
  source = newSource;
  [source addReceiver:self];
}

- (void)processMIDIPacketList:(MIDIPacketList *)packetList sender:(id)sender {
  int   i, j;
  const MIDIPacket* packet;
  Byte  message[256];
  int   messageSize = 0;
  
  // Step through each packet
  packet = packetList->packet;
  for( i = 0; i < packetList->numPackets; i++ ) {
      for( j = 0; j < packet->length; j++ ) {
          if( packet->data[j] >= 0xF8 ) {
            // skip over real-time data
            continue;
          }
          
          // Hand off the packet for processing when the next one starts
          if( ( packet->data[j] & 0x80 ) != 0 && messageSize > 0 ) {
              [self handleMIDIMessage:message ofSize:messageSize];
              messageSize = 0;
          }
          
          message[messageSize++] = packet->data[j];			// push the data into the message
      }
      
      packet = MIDIPacketNext( packet );
  }
  
  if( messageSize > 0 ) {
    [self handleMIDIMessage:message ofSize:messageSize];
  }
}

/* Handle routing MIDI control messages to the foreground player.
 * The message is bundled into a struct for easy passing.
 */
- (void)handleMIDIMessage:(Byte*)message ofSize:(int)size {
  if( message[0] == 0x90 ) {
    [destination noteReceived:message[1] withVelocity:message[2]];
  }
}

@end
