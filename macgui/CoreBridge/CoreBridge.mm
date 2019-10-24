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

@end
