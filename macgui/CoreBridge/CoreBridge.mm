//
//  CoreBridge.mm
//  macgui
//
//  Created by Svetlana Krasikova on 10/14/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreBridge.h"

#include <string>
#include <vector>
#include "Parser.h"
#include "RevLanguageMain.h"
#include "RevNullObject.h"
#include "RlCommandLineOutputStream.h"
#include "RlUserInterface.h"
#include "Workspace.h"



@implementation CoreBridge : NSObject

- (void)startCore {
    
    NSLog(@"Initializing core...");
    RevLanguageMain rl = RevLanguageMain(false);
    CommandLineOutputStream* rev_output = new CommandLineOutputStream();
    RevLanguage::UserInterface::userInterface().setOutputStream( rev_output );
    std::vector<std::string> rb_args;
    std::vector<std::string> source_files;
    rl.startRevLanguageEnvironment(rb_args, source_files);
}

- (int)sendParser:(NSString*)theCommand {

    std::string commandLine( [theCommand UTF8String] );
    int result = RevLanguage::Parser::getParser().processCommand(commandLine, &RevLanguage::Workspace::userWorkspace());
    return result;
    
}

- (Boolean)readMatrixFrom:(NSString*)fileToRead {
    
    [self startCore];
    std::string variableName = RevLanguage::Workspace::userWorkspace().generateUniqueVariableName();
    NSString* nsVariableName = [NSString stringWithCString:variableName.c_str() encoding:NSUTF8StringEncoding];
    const char* cmdAsCStr = [fileToRead UTF8String];
    std::string cmdAsStlStr = cmdAsCStr;
    std::string line = variableName + " = readCharacterData(\"" + cmdAsStlStr + "\",alwaysReturnAsVector=TRUE)";

    int coreResult = RevLanguage::Parser::getParser().processCommand(line, &RevLanguage::Workspace::userWorkspace());
    
    if (coreResult != 0) {
        [self eraseVariableFromCore:nsVariableName];
        return false;
    }
    const RevLanguage::RevObject& dv = RevLanguage::Workspace::userWorkspace().getRevObject(variableName);
    if ( dv == RevLanguage::RevNullObject::getInstance() )
        [self eraseVariableFromCore:nsVariableName];
    
    /**
        TODO: Pass the reference to the read-in data for initialisation on the gui side.
                    Maybe instead 'Boolean' return a dictionary with a boolean return code and the dataload
     */

 
    if ( RevLanguage::Workspace::userWorkspace().existsVariable(variableName) )
        RevLanguage::Workspace::userWorkspace().eraseVariable(variableName);
    
    return true;
}

- (void)eraseVariableFromCore:(NSString*)variableName  {
    std::string tempName = [variableName UTF8String];
    if ( RevLanguage::Workspace::userWorkspace().existsVariable(tempName) )
        RevLanguage::Workspace::userWorkspace().eraseVariable(tempName);
}


@end
