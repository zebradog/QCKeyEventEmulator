//
//  KeyEventEmulatorPlugIn.m
//  KeyEventEmulator
//
//  Created by Brad Orego <brad@zebradog.com> & Matt Cook <matt@zebradog.com>.
//  Copyright (c) 2012 ZD Studios, Inc. All rights reserved.
//

#import "KeyEventEmulatorPlugIn.h"

#define	kQCPlugIn_Name				@"Key Event Emulator"
#define	kQCPlugIn_Description		@"Input: ASCII value of the key pressed and a series of booleans [0,1] representing the various accessory keys."

@implementation KeyEventEmulatorPlugIn

@dynamic inputCharacter, inputShift, inputFunction, inputControl, inputOption, inputCommand, inputTrigger;

+ (NSDictionary *)attributes
{
	return [NSDictionary dictionaryWithObjectsAndKeys:kQCPlugIn_Name, QCPlugInAttributeNameKey, kQCPlugIn_Description, QCPlugInAttributeDescriptionKey, nil];
}

+ (NSDictionary *)attributesForPropertyPortWithKey:(NSString *)key
{
    if([key isEqualToString:@"inputCharacter"])
        return [NSDictionary dictionaryWithObjectsAndKeys: @"Input Character", QCPortAttributeNameKey, nil];
    if([key isEqualToString:@"inputShift"])
        return [NSDictionary dictionaryWithObjectsAndKeys: @"Shift", QCPortAttributeNameKey, nil];
    if([key isEqualToString:@"inputFunction"])
        return [NSDictionary dictionaryWithObjectsAndKeys: @"Function", QCPortAttributeNameKey, nil];
    if([key isEqualToString:@"inputControl"])
        return [NSDictionary dictionaryWithObjectsAndKeys: @"Control", QCPortAttributeNameKey, nil];
    if([key isEqualToString:@"inputOption"])
        return [NSDictionary dictionaryWithObjectsAndKeys: @"Option", QCPortAttributeNameKey, nil];
    if([key isEqualToString:@"inputCommand"])
        return [NSDictionary dictionaryWithObjectsAndKeys: @"Command", QCPortAttributeNameKey, nil];
	if([key isEqualToString:@"inputTrigger"])
        return [NSDictionary dictionaryWithObjectsAndKeys: @"Trigger Event", QCPortAttributeNameKey, nil];
	return nil;
}

+ (QCPlugInExecutionMode)executionMode
{
	return kQCPlugInExecutionModeConsumer;
}

+ (QCPlugInTimeMode)timeMode
{
	return kQCPlugInTimeModeNone;
}
@end

@implementation KeyEventEmulatorPlugIn (Execution)

- (BOOL)startExecution:(id <QCPlugInContext>)context{ return YES; }

- (void)enableExecution:(id <QCPlugInContext>)context { }

- (BOOL)execute:(id<QCPlugInContext>)context atTime:(NSTimeInterval)time withArguments:(NSDictionary*)arguments
{
    if ([self didValueForInputKeyChange:@"inputTrigger"] && self.inputTrigger && [self.inputCharacter length] > 0) {

			CGEventSourceRef source = CGEventSourceCreate(kCGEventSourceStateCombinedSessionState);
		
			CGEventFlags flags = 0;
			if (self.inputControl)  flags = (flags | kCGEventFlagMaskControl);
			if (self.inputFunction) flags = (flags | kCGEventFlagMaskSecondaryFn);
			if (self.inputOption) flags = (flags | kCGEventFlagMaskAlternate);
			if (self.inputShift) flags = (flags | kCGEventFlagMaskShift);
			if (self.inputCommand) flags = (flags | kCGEventFlagMaskCommand);
			
			CGKeyCode key = (CGKeyCode)keyCodeForKeyString([self.inputCharacter UTF8String]);
			
			CGEventRef keyDown = CGEventCreateKeyboardEvent(source, key, TRUE);
			CGEventSetFlags(keyDown, flags);
			CGEventRef keyUp = CGEventCreateKeyboardEvent(source, key, FALSE);
			
			CGEventPost(kCGHIDEventTap, keyDown);
			CGEventPost(kCGHIDEventTap, keyUp);
			
			CFRelease(keyUp);
			CFRelease(keyDown);
			CFRelease(source);
			
    }
    return YES;
}

- (void)disableExecution:(id <QCPlugInContext>)context { }

- (void)stopExecution:(id <QCPlugInContext>)context { }

//from: http://ritter.ist.psu.edu/projects/RUI/macosx/rui.c
//  Created by Bill Stevenson on 3 January 2005
int keyCodeForKeyString(const char * keyString)
{
	if (strcmp(keyString, "a") == 0) return 0;
	if (strcmp(keyString, "s") == 0) return 1;
	if (strcmp(keyString, "d") == 0) return 2;
	if (strcmp(keyString, "f") == 0) return 3;
	if (strcmp(keyString, "h") == 0) return 4;
	if (strcmp(keyString, "g") == 0) return 5;
	if (strcmp(keyString, "z") == 0) return 6;
	if (strcmp(keyString, "x") == 0) return 7;
	if (strcmp(keyString, "c") == 0) return 8;
	if (strcmp(keyString, "v") == 0) return 9;
	// what is 10?
	if (strcmp(keyString, "b") == 0) return 11;
	if (strcmp(keyString, "q") == 0) return 12;
	if (strcmp(keyString, "w") == 0) return 13;
	if (strcmp(keyString, "e") == 0) return 14;
	if (strcmp(keyString, "r") == 0) return 15;
	if (strcmp(keyString, "y") == 0) return 16;
	if (strcmp(keyString, "t") == 0) return 17;
	if (strcmp(keyString, "1") == 0) return 18;
	if (strcmp(keyString, "2") == 0) return 19;
	if (strcmp(keyString, "3") == 0) return 20;
	if (strcmp(keyString, "4") == 0) return 21;
	if (strcmp(keyString, "6") == 0) return 22;
	if (strcmp(keyString, "5") == 0) return 23;
	if (strcmp(keyString, "=") == 0) return 24;
	if (strcmp(keyString, "9") == 0) return 25;
	if (strcmp(keyString, "7") == 0) return 26;
	if (strcmp(keyString, "-") == 0) return 27;
	if (strcmp(keyString, "8") == 0) return 28;
	if (strcmp(keyString, "0") == 0) return 29;
	if (strcmp(keyString, "]") == 0) return 30;
	if (strcmp(keyString, "o") == 0) return 31;
	if (strcmp(keyString, "u") == 0) return 32;
	if (strcmp(keyString, "[") == 0) return 33;
	if (strcmp(keyString, "i") == 0) return 34;
	if (strcmp(keyString, "p") == 0) return 35;
	if (strcmp(keyString, "RETURN") == 0) return 36;
	if (strcmp(keyString, "l") == 0) return 37;
	if (strcmp(keyString, "j") == 0) return 38;
	if (strcmp(keyString, "'") == 0) return 39;
	if (strcmp(keyString, "k") == 0) return 40;
	if (strcmp(keyString, ";") == 0) return 41;
	if (strcmp(keyString, "\\") == 0) return 42;
	if (strcmp(keyString, ",") == 0) return 43;
	if (strcmp(keyString, "/") == 0) return 44;
	if (strcmp(keyString, "n") == 0) return 45;
	if (strcmp(keyString, "m") == 0) return 46;
	if (strcmp(keyString, ".") == 0) return 47;
	if (strcmp(keyString, "TAB") == 0) return 48;
	if (strcmp(keyString, "SPACE") == 0) return 49;
	if (strcmp(keyString, "`") == 0) return 50;
	if (strcmp(keyString, "DELETE") == 0) return 51;
	if (strcmp(keyString, "ENTER") == 0) return 52;
	if (strcmp(keyString, "ESCAPE") == 0) return 53;
	
	// some more missing codes abound, reserved I presume, but it would
	// have been helpful for Apple to have a document with them all listed
	
	if (strcmp(keyString, ".") == 0) return 65;
	
	if (strcmp(keyString, "*") == 0) return 67;
	
	if (strcmp(keyString, "+") == 0) return 69;
	
	if (strcmp(keyString, "CLEAR") == 0) return 71;
	
	if (strcmp(keyString, "/") == 0) return 75;
	if (strcmp(keyString, "ENTER") == 0) return 76;  // numberpad on full kbd
	
	if (strcmp(keyString, "=") == 0) return 78;
	
	if (strcmp(keyString, "=") == 0) return 81;
	if (strcmp(keyString, "0") == 0) return 82;
	if (strcmp(keyString, "1") == 0) return 83;
	if (strcmp(keyString, "2") == 0) return 84;
	if (strcmp(keyString, "3") == 0) return 85;
	if (strcmp(keyString, "4") == 0) return 86;
	if (strcmp(keyString, "5") == 0) return 87;
	if (strcmp(keyString, "6") == 0) return 88;
	if (strcmp(keyString, "7") == 0) return 89;
	
	if (strcmp(keyString, "8") == 0) return 91;
	if (strcmp(keyString, "9") == 0) return 92;
	
	if (strcmp(keyString, "F5") == 0) return 96;
	if (strcmp(keyString, "F6") == 0) return 97;
	if (strcmp(keyString, "F7") == 0) return 98;
	if (strcmp(keyString, "F3") == 0) return 99;
	if (strcmp(keyString, "F8") == 0) return 100;
	if (strcmp(keyString, "F9") == 0) return 101;
	
	if (strcmp(keyString, "F11") == 0) return 103;
	
	if (strcmp(keyString, "F13") == 0) return 105;
	
	if (strcmp(keyString, "F14") == 0) return 107;
	
	if (strcmp(keyString, "F10") == 0) return 109;
	
	if (strcmp(keyString, "F12") == 0) return 111;
	
	if (strcmp(keyString, "F15") == 0) return 113;
	if (strcmp(keyString, "HELP") == 0) return 114;
	if (strcmp(keyString, "HOME") == 0) return 115;
	if (strcmp(keyString, "PGUP") == 0) return 116;
	if (strcmp(keyString, "DELETE") == 0) return 117;
	if (strcmp(keyString, "F4") == 0) return 118;
	if (strcmp(keyString, "END") == 0) return 119;
	if (strcmp(keyString, "F2") == 0) return 120;
	if (strcmp(keyString, "PGDN") == 0) return 121;
	if (strcmp(keyString, "F1") == 0) return 122;
	if (strcmp(keyString, "LEFT") == 0) return 123;
	if (strcmp(keyString, "RIGHT") == 0) return 124;
	if (strcmp(keyString, "DOWN") == 0) return 125;
	if (strcmp(keyString, "UP") == 0) return 126;
	
	exit(EXIT_FAILURE);
}

@end
