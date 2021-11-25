import Foundation
import CoreServices
import AppKit

func getAvailableDictionaries() -> [String : DCSDictionary] {
	var result = [String : DCSDictionary]()
    let availableDictionaries = DCSCopyAvailableDictionaries().takeUnretainedValue() as NSArray
	for dictionary in availableDictionaries {
        let dict = dictionary as! DCSDictionary
        let name: String = DCSDictionaryGetName(dict).takeUnretainedValue() as String
        result[name] = dict
    }
    return result
}

func getOxfordDictionary() -> DCSDictionary? {
    let availableDictionaries = DCSCopyAvailableDictionaries().takeUnretainedValue() as NSArray
	for dictionary in availableDictionaries {
        let dict = dictionary as! DCSDictionary
        let name: String = DCSDictionaryGetName(dict).takeUnretainedValue() as String
        if name == "New Oxford American Dictionary" {
            return dict
        }
    }
    return nil
}

func listDictionaries() {
	for name in getAvailableDictionaries().keys.sorted() {
		print(name)
	}
}

func remove_ids(_ html: String) -> String {
	let regex = try! NSRegularExpression(pattern: "id=\"[a-zA-Z0-9_.]*\" ", options: NSRegularExpression.Options.caseInsensitive)
	let range = NSMakeRange(0, html.count)
	let styled = regex.stringByReplacingMatches(in: html, options: [], range: range, withTemplate: "")
	return styled
}

func add_newlines(_ html: String) -> String {
	let new_def_tag = "<span class=\"se1 x_xd0\">"
	let styled = html.replacingOccurrences(of: new_def_tag, with: "<br/><br/>" + new_def_tag)
	return styled
}

func add_colon_after_pos(_ html: String) -> String {
	let after_pos = " </span><d:pos/>"
	let styled = html.replacingOccurrences(of: after_pos, with: ": " + after_pos)
	return styled
}

func lookup3(_ word: String) {
    let dictionary = getOxfordDictionary()
	
	let dictResults = DCSCopyRecordsForSearchString(dictionary, word as NSString, nil, nil)
	
	if dictResults == nil {
		print("No results for \"\(word)\"")
		return
	}
	
	for dictResult in dictResults?.takeUnretainedValue() ?? [] as NSArray {

		let html = DCSRecordCopyData(dictResult as CFTypeRef)
		let render = html?.takeUnretainedValue() as! String
		//let style = DCSDictionaryGetStyleSheetURL(dictionary)?.takeUnretainedValue()
		// Interesting... can get stylesheet, but can't seem to use it. Tried:
		// 	- replacing <head/> to include <link ..> to stylesheet.
		//  - replacing <head/> to include <style> with context of stylesheet inserted.
		// Neither have improved appearance / readability of the generated text. 
        // Conclusion: nsattributed html to string doesn't care about styling.

        // Basically: the html that comes out is complicated... and not exactly semantic.
        // If converted directly to text, you'd get the result of the public 
        // DCSCopyTextDefinition function. So, to improve presentation of the text
        // for terminal display, resort to some hacky stuff ultimately inserting some extra
        // newlines (via <br/>s).
        // 1. Remove all ids from the html, the seem to be unique and make it hard to 
        //    strict matching for elements of the definition.
        // 2. With ids removed, look for <span class=\"se1 x_xd0\">, which indicates the
        //    start of a new meaning (sense?). Insert newlines before this. (This separates the
        //    headword also).
        // 3. Part of speech markup ends with  </span><d:pos/>, add a colon to separate part of
        //    speech from the definition body.
		let styled = add_newlines(add_colon_after_pos(remove_ids(render)))

        let nsattstr = try? NSAttributedString(
			data: styled.data(using: .unicode) ?? Data(),
			options: [.documentType: NSAttributedString.DocumentType.html],
			documentAttributes: nil
		)
		
		print(nsattstr?.string ?? "Error!")
		print()
	}

	return
}

let args = CommandLine.arguments;

if (args.count < 2 || args[1] == "-h" || args[1] == "--help") {
	print("usage: \(args[0]) [word]");
} else {
	for word in args[1...] {
		lookup3(word);
	}
}

