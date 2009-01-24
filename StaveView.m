//
//  StaveView.m
//  Pianist
//
//  Created by Matt Mower on 22/01/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "StaveView.h"

static unichar gclef[2] = {0xD834,0xDD1E};
static unichar fclef[2] = {0xD834,0xDD22};

@interface StaveView ()

- (void)drawStaves:(NSRect)bounds padding:(float)padding spacing:(float)spacing;
- (void)drawClefs:(NSRect)bounds spacing:(float)spacing;

- (void)drawNote:(NSRect)bounds padding:(float)padding spacing:(float)spacing;
- (void)drawNoteName:(NSPoint)noteCentre;

@end

@implementation StaveView

- (id)initWithFrame:(NSRect)frame {
    if( ( self = [super initWithFrame:frame] ) ) {
      noteNames = [NSArray arrayWithObjects:@"E",@"F",@"G",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"A",nil];
    }
    return self;
}

- (void)awakeFromNib {
  trebleClefAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Apple Symbols" size:96],NSFontAttributeName,nil];
  trebleClef           = [NSString stringWithCharacters:gclef length:2];
  trebleClefSize       = [trebleClef sizeWithAttributes:trebleClefAttributes];
  bassClefAttributes   = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Apple Symbols" size:56],NSFontAttributeName,nil];
  bassClef             = [NSString stringWithCharacters:fclef length:2];
  bassClefSize         = [bassClef sizeWithAttributes:bassClefAttributes];
  noteAttributes       = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica" size:18],NSFontAttributeName,nil];
}

@dynamic showNote;

- (BOOL)showNote {
  return showNote;
}

- (void)setShowNote:(BOOL)shouldShowNote {
  // [self willChangeValueForKey:@"showNote"];
  showNote = shouldShowNote;
  // [self didChangeValueForKey:@"showNote"];
  [self setNeedsDisplay:YES];
}

@dynamic showNoteName;

- (BOOL)showNoteName {
  return showNoteName;
}

- (void)setShowNoteName:(BOOL)shouldShowNoteName {
  // [self willChangeValueForKey:@"nameNote"];
  showNoteName = shouldShowNoteName;
  // [self didChangeValueForKey:@"nameNote"];
  [self setNeedsDisplay:YES];
}

@dynamic note;

- (int)note {
  return note;
}

- (void)setNote:(int)newNote {
  // [self willChangeValueForKey:@"note"];
  note = newNote - 36;
  [self setShowNote:YES];
  // [self didChangeValueForKey:@"note"];
  [self setNeedsDisplay:YES];
}

// Draw 5-line stave
- (void)drawRect:(NSRect)rect {
  NSRect bounds = [self bounds];
  float padding = bounds.size.height * 0.1; // 10% padding top and bottom
  float spacing = ( bounds.size.height - 2 * padding ) / 12; // 12 spaces for the treble + bass and inbetween
  
  [self drawStaves:bounds padding:padding spacing:spacing];
  if( [self showNote] ) {
    [self drawNote:bounds padding:padding spacing:spacing];
  }
}

- (void)drawStaves:(NSRect)bounds padding:(float)padding spacing:(float)spacing {
  NSBezierPath *path = [NSBezierPath bezierPath];
  for( int i = 0; i <= 12; i++ ) {
    if( i == 0 || i == 6 || i == 12 ) {
      continue;
    }
    NSPoint leftEdge = NSMakePoint( bounds.origin.x, ( i * spacing ) + padding );
    [path moveToPoint:leftEdge];
    NSPoint rightEdge = NSMakePoint( bounds.origin.x + bounds.size.width, ( i * spacing ) + padding );
    [path lineToPoint:rightEdge];
  }
  
  [path setLineWidth:3];
  [path stroke];
  
  [self drawClefs:bounds spacing:spacing];
}

- (void)drawClefs:(NSRect)bounds spacing:(float)spacing {
  NSRect clefRect;
  clefRect = NSMakeRect( bounds.origin.x + ( trebleClefSize.width / 2 ), ( 8 * spacing ) - ( trebleClefSize.height / 8 ), trebleClefSize.width, trebleClefSize.height );
  [trebleClef drawInRect:clefRect withAttributes:trebleClefAttributes];
  clefRect = NSMakeRect( bounds.origin.x + ( bassClefSize.width / 2 ), ( 4 * spacing ) - ( bassClefSize.height / 8 ), bassClefSize.width, bassClefSize.height );
  [bassClef drawInRect:clefRect withAttributes:bassClefAttributes];
}

- (void)drawNote:(NSRect)bounds padding:(float)padding spacing:(float)spacing {
  float noteSpacing = spacing / 2;
  float noteSize = noteSpacing / 1.6;
  NSPoint noteCentre = NSMakePoint( bounds.origin.x + ( bounds.size.width / 2 ), ( [self note] * noteSpacing ) + padding );
  NSRect noteFrame = NSMakeRect( noteCentre.x - ( noteSize * 1.4 ), noteCentre.y - noteSize, ( noteSize * 2.4 ), noteSize * 2 );
  
  NSBezierPath *path = [NSBezierPath bezierPath];
  
  if( [self note] == 0 || [self note] == 6 || [self note] == 12 ) {
    [path moveToPoint:NSMakePoint( noteFrame.origin.x - ( noteSize * 3 ), ( [self note] * spacing ) + padding )];
    [path lineToPoint:NSMakePoint( noteFrame.origin.x + ( noteSize * 5 ), ( [self note] * spacing ) + padding )];
  }
  [path setLineWidth:3];
  [path stroke];
  
  path = [NSBezierPath bezierPath];
  [path appendBezierPathWithOvalInRect:noteFrame];
  [path fill];
  
  if( [self showNoteName] ) {
    [self drawNoteName:noteCentre];
  }
}

- (void)drawNoteName:(NSPoint)noteCentre {
  NSString *noteName = [noteNames objectAtIndex:[self note]];
  NSSize nameSize = [noteName sizeWithAttributes:noteAttributes];
  NSPoint namePosition = NSMakePoint( noteCentre.x + ( 2 * nameSize.width ), noteCentre.y - ( nameSize.height / 2 ) );
  
  NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect( namePosition.x, namePosition.y, nameSize.width * 1.2, nameSize.height )
                                                       xRadius:nameSize.width/16
                                                       yRadius:nameSize.height/16];
  [[NSColor whiteColor] set];
  [path fill];
  [[NSColor blackColor] set];
  [path stroke];
  [noteName drawAtPoint:NSMakePoint( namePosition.x + ( nameSize.width * 0.1 ), namePosition.y ) withAttributes:noteAttributes];
}

@end
