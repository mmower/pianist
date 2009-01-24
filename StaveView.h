//
//  StaveView.h
//  Pianist
//
//  Created by Matt Mower on 22/01/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface StaveView : NSView {
  NSString      *trebleClef;
  NSSize        trebleClefSize;
  NSDictionary  *trebleClefAttributes;
  NSString      *bassClef;
  NSSize        bassClefSize;
  NSDictionary  *bassClefAttributes;
  BOOL          showNote;
  BOOL          showNoteName;
  BOOL          isCorrect;
  NSArray       *noteNames;
  NSDictionary  *noteAttributes;
  int           note;
}

@property BOOL showNote;
@property BOOL showNoteName;
@property BOOL isCorrect;
@property int note;

@end
