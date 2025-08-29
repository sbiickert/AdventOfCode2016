#include <iostream>
#include "aocutil.h"

namespace aoc {
    using namespace std;

    vector<string> ReadInputFile(string name, bool removeEmpty) {
		vector<string> results;

        ifstream file(name.c_str());
        if (!file.is_open()) {
            cerr << "Could not open file." << endl;
        }
        
        string line;
        while (getline(file, line)) {
            bool isWhitespace = all_of(line.begin(), line.end(), isspace);
            if (removeEmpty && isWhitespace) {
                // ignore
            }
            else {
                results.push_back(line);
            }
        }

        file.close();
		return results;
    }

	std::vector<std::vector<std::string> > ReadGroupedInputFile(std::string name) {

    }

}