//
//  KeyEventEmulatorPlugIn.m
//  KeyEventEmulator
//
//  Created by Brad Orego <brad@zebradog.com> & Matt Cook <matt@zebradog.com>.
//  Copyright (c) 2012 ZD Studios, Inc. All rights reserved.
//

#import "KeyEventEmulatorPlugIn.h"

#define	kQCPlugIn_Name				@"Key Event Emulator"
#define	kQCPlugIn_Description		@"Input: ASCII value of the key pressed and a series of booleans [0,1] representing the various accessory keys (derived from Freeboard).\n\nOutput: A string representation of the keys pressed (e.g. 'command option r'), as well as those keys having been executed at a system level via AppleScript."

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

- (BOOL)startExecution:(id <QCPlugInContext>)context
{
	return YES;
}

- (void)enableExecution:(id <QCPlugInContext>)context { }

- (BOOL)execute:(id<QCPlugInContext>)context atTime:(NSTimeInterval)time withArguments:(NSDictionary*)arguments
{
    if ([self didValueForInputKeyChange:@"inputTrigger"] && self.inputTrigger) {

        NSMutableString *scriptText = [NSMutableString stringWithString:@"tell application \"System Events\" to "];
        [scriptText appendFormat:@"keystroke \"%@\" using {",self.inputCharacter];
        if (self.inputControl)  [scriptText appendString:@"control down, "];
        if (self.inputFunction) [scriptText appendString:@"function down, "];
        if (self.inputOption)[scriptText appendString:@"option down, "];
        if (self.inputShift) [scriptText appendString:@"shift down, "];
        if (self.inputCommand) [scriptText appendString:@"command down, "];
		[scriptText replaceCharactersInRange:NSMakeRange([scriptText length]-2, 1) withString:@""];
        [scriptText appendString:@"}"];

		NSAppleScript *script = [[[NSAppleScript alloc] initWithSource:scriptText] autorelease];
		[script executeAndReturnError:nil];
             
    }
    return YES;
}

- (void)disableExecution:(id <QCPlugInContext>)context { }

- (void)stopExecution:(id <QCPlugInContext>)context { }

@end
