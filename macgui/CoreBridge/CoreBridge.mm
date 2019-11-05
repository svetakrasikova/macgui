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
#include "RevLanguageMain.h"
#include "RlCommandLineOutputStream.h"
#include "RlUserInterface.h"
#include "CharacterState.h"
#include "AbstractCharacterData.h"
#include "HomologousDiscreteCharacterData.h"
#include "ModelVector.h"
#include "NclReader.h"
#include "Parser.h"
#include "RbFileManager.h"
#include "RevNullObject.h"
#include "RlAminoAcidState.h"
#include "DnaState.h"
#include "RlDnaState.h"
#include "RlRnaState.h"
#include "RlStandardState.h"
#include "Workspace.h"
#include "WorkspaceVector.h"
#include "RlAbstractCharacterData.h"
#include "RlNonHomologousDiscreteCharacterData.h"
#include "RlContinuousCharacterData.h"



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
     */
    
    const WorkspaceVector<RevObject> *dnc = dynamic_cast<const WorkspaceVector<RevObject> *>( &dv );
    if (dnc != NULL){
        for (int i=0; i<dnc->size(); i++){
           
            const RevBayesCore::AbstractCharacterData* cd = NULL;

            if ( dynamic_cast<const ModelObject<RevBayesCore::AbstractHomologousDiscreteCharacterData> *>( &((*dnc)[i] ) ) != NULL )
            {
                cd = &dynamic_cast<const ModelObject<RevBayesCore::AbstractHomologousDiscreteCharacterData> *>( &((*dnc)[i] ) )->getValue();
            }
            else if ( dynamic_cast<const ModelObject<RevBayesCore::AbstractNonHomologousDiscreteCharacterData> *>( &((*dnc)[i] ) ) != NULL )
            {
                cd = &dynamic_cast<const ModelObject<RevBayesCore::AbstractNonHomologousDiscreteCharacterData> *>( &((*dnc)[i] ) )->getValue();
            }
            else if ( dynamic_cast<const ModelObject<RevBayesCore::ContinuousCharacterData> *>( &((*dnc)[i] ) ) != NULL )
            {
                cd = &dynamic_cast<const ModelObject<RevBayesCore::ContinuousCharacterData> *>( &((*dnc)[i] ) )->getValue();
            }
            else
            {
               [self eraseVariableFromCore:nsVariableName];
               return false;
            }
            
            // homology must be established for Standard and Continuous data types
            if (cd->isHomologyEstablished() == false && (cd->getDataType() == "Continuous" || cd->getDataType() == "Standard")) {
                [self eraseVariableFromCore:nsVariableName];
                return false;
            }
        
            // make GUI version of the data matrix that is in the core
            if (cd->getDataType() == "RNA") {
                std::string type = "RNA";
                }
            else if (cd->getDataType() == "DNA") {
                std::string type = "DNA";
                }
            else if (cd->getDataType() == "Protein") {
                std::string type = "Protein";
            }
            else if (cd->getDataType() == "Standard") {
                    std::string type = "Standard";
                    }
            else if (cd->getDataType() == "Continuous") {
                    std::string type = "Continuous";
                    }
            else {
                // Output error: Unrecognized data type
                    }
        }

    } else {
        [self eraseVariableFromCore:nsVariableName];
        return false;
    }
    
    [self eraseVariableFromCore:nsVariableName];
    return true;
}

- (void)eraseVariableFromCore:(NSString*)variableName  {
    std::string tempName = [variableName UTF8String];
    if ( RevLanguage::Workspace::userWorkspace().existsVariable(tempName) )
        RevLanguage::Workspace::userWorkspace().eraseVariable(tempName);
}


@end
