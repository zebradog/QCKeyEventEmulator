//
//  KeyEventEmulatorPlugIn.h
//  KeyEventEmulator
//
//  Created by Brad Orego <brad@zebradog.com> & Matt Cook <matt@zebradog.com>.
//  Copyright (c) 2012 ZD Studios, Inc. All rights reserved.
//

#import <Quartz/Quartz.h>
#include <ApplicationServices/ApplicationServices.h>
#include <Carbon/Carbon.h>

@interface KeyEventEmulatorPlugIn : QCPlugIn{}

@property(assign) NSString* inputCharacter;
@property(assign) BOOL inputShift;
@property(assign) BOOL inputFunction;
@property(assign) BOOL inputControl;
@property(assign) BOOL inputOption;
@property(assign) BOOL inputCommand;
@property(assign) BOOL inputTrigger;
@property(assign) BOOL keyPressed; 
@property(assign) CGEventSourceRef source;
@property(assign) CGEventRef keyDown;
@property(assign) CGEventRef keyUp;

void postKeyWithModifiers(CGKeyCode key, CGEventFlags modifiers);
char * keyStringForKeyCode(int keyCode);
int keyCodeForKeyString(const char * keyString);

@end