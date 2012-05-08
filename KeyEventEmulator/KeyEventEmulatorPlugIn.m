//
//  KeyEventEmulatorPlugIn.m
//  KeyEventEmulator
//
//  Created by Brad Orego on 5/8/12.
//  Copyright (c) 2012 ZD Studios, Inc. All rights reserved.
//

// It's highly recommended to use CGL macros instead of changing the current context for plug-ins that perform OpenGL rendering
#import <OpenGL/CGLMacro.h>
#import "KeyEventEmulatorPlugIn.h"

#define	kQCPlugIn_Name				@"Key Event Emulator"
#define	kQCPlugIn_Description		@"Input: ASCII value of the key pressed and a series of booleans [0,1] representing the various accessory keys (derived from Freeboard).\n\nOutput: A string representation of the keys pressed (e.g. 'command option r'), as well as those keys having been executed at a system level via AppleScript.\n\nUse: Keys in Quartz typically fire every frame, as opposed to only once per key press. This patch fixes that issue, and runs the key commands entered as a keyboard command to the system via AppleScript. Keyboard events can also be simulated (e.g. with Javascript) by passing the ASCII values (character and 48/49 for 0/1 for the special keys) value into the patch."

@implementation KeyEventEmulatorPlugIn
// Here you need to declare the input / output properties as dynamic as Quartz Composer will handle their implementation
//@dynamic inputFoo, outputBar;
@dynamic inputCharacter, inputShift, inputFunction, inputControl, inputOption, inputCommand, outputText;

+ (NSDictionary *)attributes
{
	// Return a dictionary of attributes describing the plug-in (QCPlugInAttributeNameKey, QCPlugInAttributeDescriptionKey...).
	return [NSDictionary dictionaryWithObjectsAndKeys:kQCPlugIn_Name, QCPlugInAttributeNameKey, kQCPlugIn_Description, QCPlugInAttributeDescriptionKey, nil];
}

+ (NSDictionary *)attributesForPropertyPortWithKey:(NSString *)key
{
    if([key isEqualToString:@"inputCharacter"])
        return [NSDictionary dictionaryWithObjectsAndKeys:
                @"Input Character", QCPortAttributeNameKey,
                @"",  QCPortAttributeDefaultValueKey,
                nil];
    if([key isEqualToString:@"inputShift"])
        return [NSDictionary dictionaryWithObjectsAndKeys:
                @"Shift", QCPortAttributeNameKey,
                [NSNumber numberWithUnsignedInteger:48],    QCPortAttributeDefaultValueKey,
                nil];
    if([key isEqualToString:@"inputFunction"])
        return [NSDictionary dictionaryWithObjectsAndKeys:
                @"Function", QCPortAttributeNameKey,
                [NSNumber numberWithUnsignedInteger:48],  QCPortAttributeDefaultValueKey,
                nil];
    if([key isEqualToString:@"inputControl"])
        return [NSDictionary dictionaryWithObjectsAndKeys:
                @"Control", QCPortAttributeNameKey,
                [NSNumber numberWithUnsignedInteger:48],  QCPortAttributeDefaultValueKey,
                nil];
    if([key isEqualToString:@"inputOption"])
        return [NSDictionary dictionaryWithObjectsAndKeys:
                @"Option", QCPortAttributeNameKey,
                [NSNumber numberWithUnsignedInteger:48],  QCPortAttributeDefaultValueKey,
                nil];
    if([key isEqualToString:@"inputCommand"])
        return [NSDictionary dictionaryWithObjectsAndKeys:
                @"Command", QCPortAttributeNameKey,
                [NSNumber numberWithUnsignedInteger:48],  QCPortAttributeDefaultValueKey,
                nil];
    //////
    if([key isEqualToString:@"outputText"])
        return [NSDictionary dictionaryWithObjectsAndKeys:
                @"Output String", QCPortAttributeNameKey,
                nil];
	return nil;
}

+ (QCPlugInExecutionMode)executionMode
{
	return kQCPlugInExecutionModeProcessor;
}

+ (QCPlugInTimeMode)timeMode
{
	return kQCPlugInTimeModeNone;
}

- (id)init
{
	self = [super init];
	if (self) {
        previousASCII=0;
        previousShift=0;
        previousFunction=0;
        previousControl=0;
        previousOption=0;
        previousCommand=0;
	}
	
	return self;
}
@end

@implementation KeyEventEmulatorPlugIn (Execution)

- (BOOL)startExecution:(id <QCPlugInContext>)context
{
	return YES;
}

- (void)enableExecution:(id <QCPlugInContext>)context { }

- (BOOL)execute:(id <QCPlugInContext>)context atTime:(NSTimeInterval)time withArguments:(NSDictionary *)arguments
{
    if (!(self.inputCharacter == (id)[NSNull null] ||self.inputCharacter.length == 0 )){
        currentASCII=[self.inputCharacter characterAtIndex:0];
	}
    if (!(self.inputOption == (id)[NSNull null] ||self.inputOption.length == 0 )){
        currentOption=[self.inputOption characterAtIndex:0];
	}
    if (!(self.inputCommand == (id)[NSNull null] ||self.inputCommand.length == 0 )){
        currentCommand=[self.inputCommand characterAtIndex:0];
	}
    if (!(self.inputControl == (id)[NSNull null] ||self.inputControl.length == 0 )){
        currentControl=[self.inputControl characterAtIndex:0];
	}
    if (!(self.inputFunction == (id)[NSNull null] ||self.inputFunction.length == 0 )){
        currentFunction=[self.inputFunction characterAtIndex:0];
	}
    if (!(self.inputShift == (id)[NSNull null] ||self.inputShift.length == 0 )){
        currentShift=[self.inputShift characterAtIndex:0];
	}
    if (currentASCII != previousASCII || currentOption!=previousOption || currentCommand!=previousCommand || currentControl!= previousControl || currentFunction != previousFunction || currentShift != previousShift) {
        previousASCII = currentASCII;
        previousOption = currentOption;
        previousCommand = currentCommand;
        previousControl = currentControl;
        previousFunction = currentFunction;
        previousShift = currentShift;
        
        //execute applescript command for keystroke
        
        NSMutableString *output = [NSMutableString stringWithString:@""];
        NSDictionary *error = nil;
        NSMutableString *scriptText = [NSMutableString stringWithString:@"tell application \"System Events\" to"];
        [scriptText appendFormat:@"keystroke \"%@\" using {\n",self.inputCharacter];
        if (currentControl==49) {
            [scriptText appendString:@"control down "];
            [output appendString:@"control "];
        }
        if (currentFunction==49) {
            [scriptText appendString:@"function down "];
            [output appendString:@"function "];
        }
        if (currentOption==49) {
            [scriptText appendString:@"option down "];
            [output appendString:@"option "];
        }
        if (currentShift==49) {
            [scriptText appendString:@"shift down "];
            [output appendString:@"shift "];
        }
        if (currentCommand==49) {
            [scriptText appendString:@"command down "];
            [output appendString:@"command "];
        }
        [scriptText appendString:@"}\n"];
        [scriptText appendString:@"tell application \"QuickTime Player\"\n "];
        [scriptText appendString:@"end tell\n"];
        [output appendString:self.inputCharacter];
        
        NSAppleScript *script = [[[NSAppleScript alloc] initWithSource:scriptText] autorelease];
        [script executeAndReturnError:&error];
        self.outputText=[NSString stringWithString:scriptText];
        
    }
    return YES;
}

- (void)disableExecution:(id <QCPlugInContext>)context { }

- (void)stopExecution:(id <QCPlugInContext>)context { }

@end
