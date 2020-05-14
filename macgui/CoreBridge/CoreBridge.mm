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
#include "ConstructorFunction.h"
#include "RevLanguageMain.h"
#include "RlCommandLineOutputStream.h"
#include "RlDistribution.h"
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
#include "RlFunction.h"
#include "RlMove.h"
#include "DnaState.h"
#include "RlDnaState.h"
#include "RlRnaState.h"
#include "RlStandardState.h"
#include "Workspace.h"
#include "WorkspaceVector.h"
#include "RlAbstractCharacterData.h"
#include "RlNonHomologousDiscreteCharacterData.h"
#include "RlContinuousCharacterData.h"
#include "json.hpp"

using json = nlohmann::json;



@implementation CoreBridge : NSObject

- (NSMutableArray*)getVariablesFromCore {

    // query the workspace for all REV language components
    RevLanguage::Workspace& myWorkspace = RevLanguage::Workspace::globalWorkspace();
    std::map<std::string, RevLanguage::RevObject*> list = myWorkspace.getTypeTable();
    
    // construct the list of variables for the random variable and constants pallets
    NSMutableArray* variables = [NSMutableArray array];
    for (std::map<std::string, RevLanguage::RevObject*>::iterator it = list.begin(); it != list.end(); it++)
        {
        RevLanguage::AbstractModelObject* varPtr = dynamic_cast<RevLanguage::AbstractModelObject*>(it->second);
        if (varPtr != NULL)
            {
            // is it a vector of a scalar?
            bool isVector = false;
            RevLanguage::Container* containerPtr = dynamic_cast<RevLanguage::Container*>(it->second);
            if (containerPtr != NULL)
                isVector = true;

            // if it's a vector, find the base class
            std::string baseName = "";
            for (size_t i=0; i<it->first.size(); i++)
                {
                if (it->first[i] != '[' && it->first[i] != ']')
                    baseName += it->first[i];
                }
            RevLanguage::AbstractModelObject* baseObj = NULL;
            std::map<std::string, RevLanguage::RevObject*>::iterator itf = list.find(baseName);
            if (itf != list.end())
                baseObj = dynamic_cast<RevLanguage::AbstractModelObject*>(itf->second);
            
            std::string vType = varPtr->getType();
            size_t n = std::count(vType.begin(), vType.end(), '['); // dimension of variable

            // get information on the variable
            std::string varName = (it)->first;

            // fillout JSON string
            json j;
            j["type"] = baseName;
            j["symbol"] = "";
            j["dimension"] = n;
            std::string jsonStr = j.dump();

            [variables addObject: [NSString stringWithUTF8String:jsonStr.c_str()]];
            }
        }
    return variables;
}

- (NSMutableArray*)getPalletItems {

    NSMutableArray* palletItems = [NSMutableArray array];

    RevLanguage::Workspace& myWorkspace = RevLanguage::Workspace::globalWorkspace();
    std::map<std::string, RevLanguage::RevObject*> list = myWorkspace.getTypeTable();
    
    // construct the list of variables for the random variable and constants pallets
    for (std::map<std::string, RevLanguage::RevObject*>::iterator it = list.begin(); it != list.end(); it++)
        {
        RevLanguage::AbstractModelObject* varPtr = dynamic_cast<RevLanguage::AbstractModelObject*>(it->second);
        if (varPtr != NULL)
            {
            // is it a vector of a scalar?
            bool isVector = false;
            RevLanguage::Container* containerPtr = dynamic_cast<RevLanguage::Container*>(it->second);
            if (containerPtr != NULL)
                isVector = true;

            // if it's a vector, find the base class
            std::string baseName = "";
            for (size_t i=0; i<it->first.size(); i++)
                {
                if (it->first[i] != '[' && it->first[i] != ']')
                    baseName += it->first[i];
                }
            RevLanguage::AbstractModelObject* baseObj = NULL;
            std::map<std::string, RevLanguage::RevObject*>::iterator itf = list.find(baseName);
            if (itf != list.end())
                baseObj = dynamic_cast<RevLanguage::AbstractModelObject*>(itf->second);
            
            std::string vType     = varPtr->getType();
            size_t n              = std::count(vType.begin(), vType.end(), '['); // dimension of variable

            // get information on the variable
            std::string varName = (it)->first;

            // fillout JSON string
            json j;
            j["type"] = "Variable";
            j["name"] = baseName;
            j["dimension"] = n;
            std::string jsonStr = j.dump();

            [palletItems addObject: [NSString stringWithUTF8String:jsonStr.c_str()]];
            }
        }

    // construct the list of moves
    for (std::map<std::string, RevLanguage::RevObject*>::iterator it = list.begin(); it != list.end(); it++)
        {
        RevLanguage::Move* movePtr = dynamic_cast<RevLanguage::Move*>(it->second);
        if (movePtr != NULL)
            {
            // it's a move!
            
            // get information on the move
            std::string moveName = (it)->first;
            std::string s = "Move_";
            std::string::size_type i = moveName.find(s);
            if (i != std::string::npos)
               moveName.erase(i, s.length());
            
            // fillout JSON string
            std::string jsonStr = "{";
            jsonStr += "\"type\": \"Move\", ";
            jsonStr += "\"name\": \"";
            jsonStr += moveName + "\", ";
            jsonStr += "\"dimension\": 0";
            jsonStr += "}";

            [palletItems addObject: [NSString stringWithUTF8String:jsonStr.c_str()]];
            }
        }
        
        
    // construct the list of distributions
    RevLanguage::FunctionTable& funcList = myWorkspace.getFunctionTable();
    for (RevLanguage::FunctionTable::iterator it = funcList.begin(); it != funcList.end(); it++)
        {
        RevLanguage::ConstructorFunction* conFunc = dynamic_cast<RevLanguage::ConstructorFunction*>(it->second);
        std::cout << it->first << std::endl;
        if (conFunc != NULL)
            {
//            std::cout << "   " << it->first << std::endl;
            RevLanguage::RevObject* revObj = conFunc->getRevObject();
            RevLanguage::Distribution* distPtr = dynamic_cast<RevLanguage::Distribution*>(revObj);
            if (distPtr != NULL)
                {
                // it's a distribution!

                // get information on the distribution
                std::string distName = (it)->first;
                std::string s = "dn";
                std::string::size_type i = distName.find(s);
                if (i != std::string::npos)
                   distName.erase(i, s.length());
                    
                    
                    
                std::string constructorName = distPtr->getConstructorFunctionName();
                std::string distributionName = distPtr->getDistributionFunctionName();
                std::vector<std::string> aliases = distPtr->getDistributionFunctionAliases();
                TypeSpec typeSpec = distPtr->getVariableTypeSpec();
                MemberRules memberRules = distPtr->getParameterRules();
                
                std::cout << "   constructorName  = " << constructorName << std::endl;
                std::cout << "   distributionName = " << distributionName << std::endl;
                std::cout << "   typeSpec         = " << typeSpec << std::endl;
                std::cout << "   memberRules      = " << &memberRules << std::endl;
                std::cout << "   aliases          = ";
                for (int i=0; i<aliases.size(); i++)
                    std::cout << aliases[i] << " ";
                std::cout << std::endl;



                // fillout JSON string
                std::string jsonStr = "{";
                jsonStr += "\"type\": \"Distribution\", ";
                jsonStr += "\"name\": \"";
                jsonStr += distName + "\", ";
                jsonStr += "\"dimension\": 0";
                jsonStr += "}";

                [palletItems addObject: [NSString stringWithUTF8String:jsonStr.c_str()]];
                }
            }
       }


    // construct the list of functions
    for (RevLanguage::FunctionTable::iterator it = funcList.begin(); it != funcList.end(); it++)
        {
        std::vector<Function*> funcs = funcList.findFunctions(it->first);
        //std::cout << it->first << " " << funcs.size() << std::endl;
        }


    return palletItems;
}

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

@end
