/*
Copyright (c) 2011 tgerm.com
All rights reserved.
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:
1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. The name of the author may not be used to endorse or promote products
   derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, 
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
/**
    Utility class to provide efficient sorting of Apex SelectOption instances. 
    Efficient as all the heavy lifting of sorting is internally handled by native List.sort(),
    so this leads to fast sorting and lesser consumption of script statements and one is more safe from Governor. 
    
    @author Abhinav Gupta (abhinav@tgerm.com)
*/
global class SelectOptionSorterNew {
    
    /**
        Sort field to use in SelectOption i.e. Label or Value
    */
    global enum FieldToSort {
        Label, Value
    }
    
    global static void doSort(List<Selectoption> opts, FieldToSort sortField) {
        
        Map<String, Selectoption> mapping = new Map<String, Selectoption>();
        // Suffix to avoid duplicate values like same labels or values are in inbound list 
        Integer suffix = 1;
        for (Selectoption opt : opts) {
            if (sortField == FieldToSort.Label) {
                mapping.put(    // Done this cryptic to save scriptlines, if this loop executes 10000 times
                                // it would every script statement would add 1, so 3 would lead to 30000.
                             (opt.getLabel() + suffix++), // Key using Label + Suffix Counter  
                             opt);   
            } else {
                mapping.put(    
                             (opt.getValue() + suffix++), // Key using Label + Suffix Counter  
                             opt);   
            }
        }
        
        List<String> sortKeys = new List<String>();
        sortKeys.addAll(mapping.keySet());
        sortKeys.sort();
        // clear the original collection to rebuilt it
        opts.clear();
        
        for (String key : sortKeys) {
            opts.add(mapping.get(key));
        }
    }
    
    
    /////
    // ZONE of Test Cases //
    /////

    
}