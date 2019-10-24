//
//  Bitvector.swift
//
//  Created by John Huelsenbeck on 7/9/19.
//  Copyright © 2019 John Huelsenbeck. All rights reserved.


/**
 
 This class holds an array of bits, packed into the minumum number of  unsigned integers (`UInt`). One can access a particular bit using the `[]` operator, e.g. `bv[3] = true` sets the fourth bit to true. You can add bits to the bit vector using the `+= operator`. Logical And, Or, and Xor are all overloaded so one can perform operations on multiple bit vectors. Bitvector objects can serialize themselves using the Codable protocol.
*/

import Foundation


class Bitvector : CustomStringConvertible, Codable {
   

    /// The number of bits per Unit.
    private static let bitsPerUint: Int = MemoryLayout<UInt>.size * 8
    /// The maximum value of a Uint.
    private static let maxUInt: UInt = UInt.max
    /// A Uint with only the highest bit on.
    private static let highBit: UInt = (UInt(1) << (Bitvector.bitsPerUint-1))
    /// The number of bits.
    private var numElements: Int = 0
    /// The number of Uints needed to store the bits.
    private var numInts: Int = 0
    /// The array of Uints that store the bits.
    private var vector: [UInt] = []
    /// A mask for the last Uint in the array.
    private var mask: UInt = 0

    // MARK: - Type definitions
    
    /// Keys indicating serialized elements.
    private enum CodingKeys: String, CodingKey {
        
        case numElements
        case numInts
        case vector
        case mask
    }

    enum BitvectorError: Error {
        
        case encodingError
        case decodingError
    }

    // MARK: - Initializers

    /// Initialize with an empty vector.
    init () {
    
        self.numElements = 0
        self.numInts = 0
        self.mask = 0
    }
    
    /**
     Initialize with the number of elements.
     - Parameter numberElements: the number of bits in the vector
     */
    init(numElements: Int) {

        /// Calculate size of vector and allocate memory for bitfield.
        self.numElements = numElements
        self.numInts = (numElements / Bitvector.bitsPerUint)
        if self.numElements % Bitvector.bitsPerUint != 0 {
            numInts += 1
        }
        vector = Array(repeating:UInt(0), count:numInts)
        
        /// Initialize the mask.
        if numElements % Bitvector.bitsPerUint != 0 {
            mask = (Bitvector.highBit >> (numElements % Bitvector.bitsPerUint))
            mask -= 1
            mask ^= Bitvector.maxUInt
        }
        else {
            mask = Bitvector.maxUInt
        }
    }

    /// Initialize from serialized data
    required init(from decoder: Decoder) throws {

        print("Bitvector decoder")
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.numElements = try values.decode(Int.self,    forKey: .numElements)
            self.numInts     = try values.decode(Int.self,    forKey: .numInts)
            self.vector      = try values.decode([UInt].self, forKey: .vector)
            self.mask        = try values.decode(UInt.self,   forKey: .mask)
        }
        catch {
            throw BitvectorError.decodingError
        }
    }

    /// Encode the object for serialization
    func encode(to encoder: Encoder) throws {

        do {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(numElements, forKey: .numElements)
            try container.encode(numInts,     forKey: .numInts)
            try container.encode(vector,      forKey: .vector)
            try container.encode(mask,        forKey: .mask)
        }
        catch {
            throw BitvectorError.encodingError
        }
    }

    /// Overload the `[]` operator.
    subscript(index: Int) -> Bool {
    
        get {
            if index >= 0 && index < self.numElements {
                return (( vector[index/Bitvector.bitsPerUint] & (Bitvector.highBit >> (index % Bitvector.bitsPerUint))) != 0)
            }
            else {
                return false
            }
        }
        
        set(newValue) {
            if index < 0 {
                print("Index cannot be negative (\(index)")
                return
            }
            else if index >= self.numElements {
                print("Index is too large (\(index)")
                return
            }
            if newValue == true {
                vector[index/Bitvector.bitsPerUint] |= (Bitvector.highBit >> (index % Bitvector.bitsPerUint))
            }
            else {
                vector[index/Bitvector.bitsPerUint] &= ((Bitvector.highBit >> (index % Bitvector.bitsPerUint)) ^ Bitvector.maxUInt)
            }
        }
    }

    // MARK: - String representation

    /// Print the object's information.
    var description: String {
    
        var str: String = ""
        str += "Bitvector\n"
        str += "   Number of elements = \(numElements)\n"
        str += "   Number of available bits = \(numInts*Bitvector.bitsPerUint)\n   "
        str += bitString()
        return str
    }
    
    /// Overload the `&` operator, allowing statements such as `bv1 = bv2 & bv3`.
    static func &(lhs: Bitvector, rhs: Bitvector) -> Bitvector {
    
        if lhs.numElements != rhs.numElements {
            print("Attempting & on bit vectors of unequal size (\(lhs.numElements) on left-hand side is unequal to \(rhs.numElements) on the right-hand side)")
            return Bitvector(numElements:0)
        }
        else {
        let ret = Bitvector(numElements:lhs.numElements)
        for i in 0..<lhs.numInts {
            ret.vector[i] = (lhs.vector[i] & rhs.vector[i])
            }
        return ret
        }
    }

    /// Overload the `|` operator, allowing statements such as `bv1 = bv2 | bv3`.
    static func |(lhs: Bitvector, rhs: Bitvector) -> Bitvector {
    
        if lhs.numElements != rhs.numElements {
            print("Attempting | on bit vectors of unequal size (\(lhs.numElements) on left-hand side is unequal to \(rhs.numElements) on the right-hand side)")
            return Bitvector(numElements:0)
        }
        else {
        let ret = Bitvector(numElements:lhs.numElements)
        for i in 0..<lhs.numInts {
            ret.vector[i] = (lhs.vector[i] | rhs.vector[i])
            }
        return ret
        }
    }
    
    /// Overload the `^ `operator, allowing statements such as `bv1 = bv2 ^ bv3`
    static func ^(lhs: Bitvector, rhs: Bitvector) -> Bitvector {
    
        if lhs.numElements != rhs.numElements {
            print("Attempting ^ on bit vectors of unequal size (\(lhs.numElements) on left-hand side is unequal to \(rhs.numElements) on the right-hand side)")
            return Bitvector(numElements:0)
        }
        else {
            let ret = Bitvector(numElements:lhs.numElements)
            for i in 0..<lhs.numInts {
                ret.vector[i] = (lhs.vector[i] ^ rhs.vector[i])
            }
            return ret
        }
    }
    
    /// Overload the `&=` operator, allowing statements such as `bv1 &= bv2`.
    static func &=(lhs: Bitvector, rhs: Bitvector) {

        if lhs.numElements == rhs.numElements {
            for i in 0..<lhs.numInts {
                lhs.vector[i] &= rhs.vector[i]
            }
        }
        else {
            print("Attempting &= on bit vectors of unequal size (\(lhs.numElements) on left-hand side is unequal to \(rhs.numElements) on the right-hand side)")
        }
    }
    
    /// Overload the `|=` operator, allowing statements such as `bv1 |= bv2`.
    static func |=(lhs: Bitvector, rhs: Bitvector) {

        if lhs.numElements == rhs.numElements {
            for i in 0..<lhs.numInts {
                lhs.vector[i] |= rhs.vector[i]
            }
        }
        else {
            print("Attempting |= on bit vectors of unequal size (\(lhs.numElements) on left-hand side is unequal to \(rhs.numElements) on the right-hand side)")
        }
    }

    /// Overload the `+=` operator, allowing statements such as `bv += true`.
    static func +=(lhs: Bitvector, newVal: Bool) {

        lhs.numElements += 1;
        
        var newNumInts = (lhs.numElements / Bitvector.bitsPerUint)
        if lhs.numElements % Bitvector.bitsPerUint != 0 {
            newNumInts += 1
        }
        
        if newNumInts > lhs.numInts {
            lhs.vector.append(0)
            lhs.numInts += 1
        }
        
        lhs[lhs.numElements-1] = newVal

        // re-initialize the mask
        if lhs.numElements % Bitvector.bitsPerUint != 0 {
            lhs.mask = (Bitvector.highBit >> (lhs.numElements % Bitvector.bitsPerUint))
            lhs.mask -= 1
            lhs.mask ^= Bitvector.maxUInt
        }
        else {
            lhs.mask = Bitvector.maxUInt
        }
    }

    static func += (lhs: Bitvector, rhs: Bitvector) {

        for i in 0..<rhs.size() {
        
            let newVal : Bool = rhs[i]
            
            lhs.numElements += 1;
            
            var newNumInts = (lhs.numElements / Bitvector.bitsPerUint)
            if lhs.numElements % Bitvector.bitsPerUint != 0 {
                newNumInts += 1
            }
            
            if newNumInts > lhs.numInts {
                lhs.vector.append(0)
                lhs.numInts += 1
            }
            
            lhs[lhs.numElements-1] = newVal

            // re-initialize the mask
            if lhs.numElements % Bitvector.bitsPerUint != 0 {
                lhs.mask = (Bitvector.highBit >> (lhs.numElements % Bitvector.bitsPerUint))
                lhs.mask -= 1
                lhs.mask ^= Bitvector.maxUInt
            }
            else {
                lhs.mask = Bitvector.maxUInt
            }
        }
       
    }
    


    // MARK: -

    /// Return a string holding the on and off bits.
    func bitString() -> String {
    
        var str: String = ""
        for i in 0..<numElements {
            let tf = self[i]
            if tf == true {
                str += "1"
            }
            else {
                str += "0"
            }
        }
        return str
    }
    
    ///
    /// Set all of the bits to false.
    func clearBits() {
    
        for i in 0..<numInts {
            vector[i] = 0
        }
    }
    
    /// Change all true bits to false and all false bits to true.
    func flipBits() {
    
        for i in 0..<numInts {
            vector[i] = vector[i] ^ Bitvector.maxUInt
        }
        vector[numInts-1] &= self.mask
    }
    
    /// Flip a specific bit.
    func flipBit(index: Int) {
    
        if index < 0 {
            print("Index cannot be negative (\(index)")
            return
        }
        else if index >= self.numElements {
            print("Index is too large (\(index)")
            return
        }
        vector[index/Bitvector.bitsPerUint] ^= ((Bitvector.highBit >> (index % Bitvector.bitsPerUint)))
    }
    
    /// Return the number of true bits.
    func numOnBits() -> Int {
    
        var cnt: Int = 0
        for i in 0..<numElements {
            if (vector[i/Bitvector.bitsPerUint] & (Bitvector.highBit >> (i % Bitvector.bitsPerUint))) != 0 {
                cnt += 1
            }
        }
        return cnt
    }
    
    /// Return the number of bits in the bit vector.
    func size() -> Int {
    
        return numElements
    }
}


