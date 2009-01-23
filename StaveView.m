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

@implementation StaveView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib {
  textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Apple Symbols" size:96],NSFontAttributeName,nil];
  trebleClef     = [NSString stringWithCharacters:gclef length:2];
  trebleClefSize = [trebleClef sizeWithAttributes:textAttributes];
  bassClef       = [NSString stringWithCharacters:fclef length:2];
  bassClefSize   = [bassClef sizeWithAttributes:textAttributes];
}

@dynamic showNote;

- (BOOL)showNote {
  return showNote;
}

- (void)setShowNote:(BOOL)shouldShowNote {
  [self willChangeValueForKey:@"showNote"];
  showNote = shouldShowNote;
  [self didChangeValueForKey:@"showNote"];
  [self setNeedsDisplay:YES];
}

@dynamic nameNote;

- (BOOL)nameNote {
  return nameNote;
}

- (void)setNameNote:(BOOL)shouldNameNote {
  [self willChangeValueForKey:@"nameNote"];
  nameNote = shouldNameNote;
  [self didChangeValueForKey:@"nameNote"];
  [self setNeedsDisplay:YES];
}

@dynamic note;

- (int)note {
  return note;
}

- (void)setNote:(int)newNote {
  [self willChangeValueForKey:@"note"];
  note = newNote - 36;
  [self setShowNote:YES];
  [self didChangeValueForKey:@"note"];
  [self setNeedsDisplay:YES];
}

// Draw 5-line stave
- (void)drawRect:(NSRect)rect {
  NSRect bounds = [self bounds];
  float padding = bounds.size.height * 0.1; // 10% padding top and bottom
  float spacing = (bounds.size.height - 2 * padding) / 12; // 12 spaces for the treble + bass and inbetween
  
  // NSLog( @"Bounds = %f,%f -> %f,%f", bounds.origin.x,bounds.origin.y,bounds.origin.x+bounds.size.width,bounds.origin.y+bounds.size.height );
  // NSLog( @"Padding = %f / Spacing = %f", padding, spacing );
  
  NSBezierPath *path = [NSBezierPath bezierPath];
  for( int i = 0; i <= 12; i++ ) {
    if( i == 0 || i == 6 || i == 12 ) {
      continue;
    }
    NSPoint leftEdge = NSMakePoint(bounds.origin.x,(i*spacing)+padding);
    [path moveToPoint:leftEdge];
    NSPoint rightEdge = NSMakePoint(bounds.origin.x+bounds.size.width,(i*spacing)+padding);
    [path lineToPoint:rightEdge];
    
    // NSLog( @"Line from %f,%f -> %f,%f", leftEdge.x, leftEdge.y, rightEdge.x, rightEdge.y );
  }
  
  [path setLineWidth:3];
  [path stroke];
  
  if( [self showNote] ) {
    float noteSpacing = spacing / 2;
    float noteSize = noteSpacing / 1.6;
    NSPoint noteCentre = NSMakePoint( bounds.origin.x + (bounds.size.width / 2), (note * noteSpacing) + padding );
    NSRect noteFrame = NSMakeRect( noteCentre.x - (noteSize * 1.4), noteCentre.y - noteSize, (noteSize * 2.4), noteSize * 2 );
    
    path = [NSBezierPath bezierPath];
    
    if( note == 0 || note == 6 || note == 12 ) {
      [path moveToPoint:NSMakePoint( noteFrame.origin.x-(noteSize*3),(note*spacing)+padding)];
      [path lineToPoint:NSMakePoint( noteFrame.origin.x+(noteSize*5),(note*spacing)+padding)];
    }
    [path setLineWidth:3];
    [path stroke];
    
    path = [NSBezierPath bezierPath];
    [path appendBezierPathWithOvalInRect:noteFrame];
    [path fill];
  }
  
  // Draw Treble Clef
  NSRect clefRect = NSMakeRect( bounds.origin.x + (trebleClefSize.width/2), (8*spacing)-(trebleClefSize.height/8), trebleClefSize.width, trebleClefSize.height );
  [trebleClef drawInRect:clefRect withAttributes:textAttributes];
}

@end
