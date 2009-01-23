//
//  AppController.h
//  Pianist
//
//  Created by Matt Mower on 22/01/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "StaveView.h"

@class MIDIController;

@interface AppController : NSObject {
            NSTimer         *timer;
  IBOutlet  StaveView       *stave;
  IBOutlet  NSMenu          *midiMenu;
            int             counter;
            int             currentRound;
            int             score;
            
            BOOL            notePlayed;
            int             currentNote;
            int             playedNote;
            
            MIDIController  *midiController;
}

@property int counter;
@property int currentRound;
@property int score;

@property (assign) StaveView *stave;

- (IBAction)rescanMidi:(id)sender;
- (IBAction)startGame:(id)sender;
- (IBAction)setMidiSource:(id)sender;

- (void)noteReceived:(int)noteNumber withVelocity:(int)velocity;

@end
