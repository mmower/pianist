//
//  MIDIController.h
//  Pianist
//
//  Created by Matt Mower on 23/01/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "AppController.h"

@class PYMIDIEndpoint;

@interface MIDIController : NSObject {
  id              destination;
  PYMIDIEndpoint  *source;
}

- (id)initWithDestination:(id)destination;

@property (assign) PYMIDIEndpoint *source;

@end
