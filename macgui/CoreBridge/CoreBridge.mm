//
//  CoreBridge.mm
//  macgui
//
//  Created by Svetlana Krasikova on 10/14/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppKit/AppKit.h"
#import "CoreBridge.h"
#import "macgui-Swift.h"

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

- (NSMutableArray*)readMatrixFrom:(NSString*)fileToRead {
    
    std::string variableName = RevLanguage::Workspace::userWorkspace().generateUniqueVariableName();
    NSString* nsVariableName = [NSString stringWithCString:variableName.c_str() encoding:NSUTF8StringEncoding];
    const char* cmdAsCStr = [fileToRead UTF8String];
    std::string cmdAsStlStr = cmdAsCStr;
    std::string line = variableName + " = readCharacterData(\"" + cmdAsStlStr + "\",alwaysReturnAsVector=TRUE)";
    int coreResult = RevLanguage::Parser::getParser().processCommand(line, &RevLanguage::Workspace::userWorkspace());
    if (coreResult != 0)
        {
        [self eraseVariableFromCore:nsVariableName];
        return [NSMutableArray array];
        }
    const RevLanguage::RevObject& dv = RevLanguage::Workspace::userWorkspace().getRevObject(variableName);
    if ( dv == RevLanguage::RevNullObject::getInstance() )
        [self eraseVariableFromCore:nsVariableName];
    
    const WorkspaceVector<RevObject> *dnc = dynamic_cast<const WorkspaceVector<RevObject> *>( &dv );

    NSMutableArray* jsonStringArray = [NSMutableArray array];
    if (dnc != NULL)
        {
        for (int i=0; i<(int)dnc->size(); i++)
            {
            std::string jsonStr = "";
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
                return [NSMutableArray array];
                }
            
            // homology must be established for Standard and Continuous data types
            if (cd->isHomologyEstablished() == false && (cd->getDataType() == "Continuous" || cd->getDataType() == "Standard"))
                {
                [self eraseVariableFromCore:nsVariableName];
                return [NSMutableArray array];
                }
        
            jsonStr += cd->getJsonRepresentation();
            [jsonStringArray addObject: [NSString stringWithUTF8String:jsonStr.c_str()] ];
            }
        }
    else
        {
        [self eraseVariableFromCore:nsVariableName];
        return [NSMutableArray array];
        }

    // no errors, so we can return the JSON string representation
    [self eraseVariableFromCore:nsVariableName];

    return jsonStringArray;
}

- (void)eraseVariableFromCore:(NSString*)variableName  {
    std::string tempName = [variableName UTF8String];
    if ( RevLanguage::Workspace::userWorkspace().existsVariable(tempName) )
        RevLanguage::Workspace::userWorkspace().eraseVariable(tempName);
}

- (void)makeNewGuiDataMatrixFromCoreMatrixWithAddress:(const RevBayesCore::AbstractCharacterData&)cd andDataType:(const std::string&)dt {

    std::string fn = cd.getFileName();
    
    //Cat *cat = Cat.create;
    

    
#   if 0
    NSString* nsfn = [NSString stringWithCString:(fn.c_str()) encoding:NSUTF8StringEncoding];
    RbData* m = [[RbData alloc] init];
    [m setNumTaxa:(int)(cd.getNumberOfTaxa())];
    if ( cd.isHomologyEstablished() == true )
        {
        [m setIsHomologyEstablished:YES];
        const RevBayesCore::HomologousCharacterData* hd = dynamic_cast<const RevBayesCore::HomologousCharacterData*>(&cd);
        if (!hd)
            {
            
            }
        [m setNumCharacters:(int)(hd->getNumberOfCharacters())];
        }
    else
        {
        [m setIsHomologyEstablished:NO];
        const RevBayesCore::NonHomologousCharacterData* nhd = dynamic_cast<const RevBayesCore::NonHomologousCharacterData*>(&cd);
        if (!nhd)
            {
            
            }
        std::vector<size_t> sequenceLengths = nhd->getNumberOfCharacters();
        size_t maxLen = 0;
        for (int i=0; i<sequenceLengths.size(); i++)
            {
            if (sequenceLengths[i] > maxLen)
                maxLen = sequenceLengths[i];
            }
        [m setNumCharacters:(int)maxLen];
        }
    
    // get the state labels
    std::string stateLabels = cd.getStateLabels();
    NSString* sl = [NSString stringWithCString:(stateLabels.c_str()) encoding:NSUTF8StringEncoding];
    [m setStateLabels:sl];
    
    [m setName:nsfn];
    if ( dt == "DNA" )
        [m setDataType:DNA];
    else if ( dt == "RNA" )
        [m setDataType:RNA];
    else if ( dt == "Protein" )
        [m setDataType:AA];
    else if ( dt == "Standard" )
        [m setDataType:STANDARD];
    else if ( dt == "Continuous" )
        [m setDataType:CONTINUOUS];

    for (size_t i=0; i<cd.getNumberOfTaxa(); i++)
        {
        const RevBayesCore::AbstractTaxonData& td = cd.getTaxonData(i);
        NSString* taxonName = [NSString stringWithCString:td.getTaxonName().c_str() encoding:NSUTF8StringEncoding];
        [m cleanName:taxonName];
        [m addTaxonName:taxonName];
        RbTaxonData* rbTaxonData = [[RbTaxonData alloc] init];
        [rbTaxonData setTaxonName:taxonName];
        for (size_t j=0; j<td.getNumberOfCharacters(); j++)
            {
            RbDataCell* cell = [[RbDataCell alloc] init];
            [cell setDataType:[m dataType]];
            if ( [m dataType] != CONTINUOUS )
                {
                const RevBayesCore::DiscreteCharacterState& theChar = static_cast<const RevBayesCore::AbstractDiscreteTaxonData &>(td).getCharacter(j);
                //unsigned int x = (unsigned int)static_cast<const RevBayesCore::DiscreteCharacterState &>(theChar).getState();
                RevBayesCore::RbBitSet bs = (RevBayesCore::RbBitSet)static_cast<const RevBayesCore::DiscreteCharacterState &>(theChar).getState();
                std::string sv = (std::string)static_cast<const RevBayesCore::DiscreteCharacterState &>(theChar).getStringValue();

                unsigned x = 0;
                if (dt == "DNA")
                    x = [cell dnaToUnsigned:sv];
                else if (dt == "RNA")
                    x = [cell rnaToUnsigned:sv];
                else if (dt == "Protein")
                    x = [cell aaToUnsigned:sv];
                else if (dt == "Standard")
                    x = [cell standardToUnsigned:sv withLabels:sl];

                NSNumber* n = [NSNumber numberWithUnsignedInt:x];
                [cell setVal:n];
                [cell setIsDiscrete:YES];
                [cell setNumStates:((int)theChar.getNumberOfStates())];
                if ( theChar.isAmbiguous() == true )
                    [cell setIsAmbig:YES];
                if (theChar.isGapState() == true)
                    [cell setIsGapState:YES];
                else
                    [cell setIsGapState:NO];
                }
            else
                {
                const double x = static_cast<const RevBayesCore::ContinuousCharacterData &>(cd).getCharacter(i, j);
                if ( RevBayesCore::RbMath::isNan(x) )
                    {
                    [cell setIsAmbig:YES];
                    }
                else
                    {
                    NSNumber* n = [NSNumber numberWithDouble:x];
                    [cell setVal:n];
                    [cell setIsDiscrete:NO];
                    [cell setNumStates:0];
                    }
                }
            [cell setRow:i];
            [cell setColumn:j];
            [rbTaxonData addObservation:cell];
            }
        [m addTaxonData:rbTaxonData];
        }
    
    return m;
    
#   endif
}
@end
