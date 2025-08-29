#include <fstream>
#include <vector>
#include <string>
#include <sstream>

namespace aoc {
    const std::string INPUT_PATH = "../Input/";

	std::vector<std::string> ReadInputFile(std::string name, bool removeEmpty);
	std::vector<std::vector<std::string> > ReadGroupedInputFile(std::string name);

}