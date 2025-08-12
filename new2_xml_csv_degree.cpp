#include <iostream>
#include <fstream>
#include <map>
#include <vector>
#include <sstream>
#include <string>
//#include <filesystem>
#include "tinyxml2.h"

using namespace tinyxml2;
using namespace std;
//namespace fs = std::filesystem;

struct Transition {
    string to;
    double score;
};

void processFile(int fileNum, const string& inputFolder, const string& outputFolder) {
    // Construct full input file path
    ostringstream filePathStream;
    filePathStream << inputFolder << "/file" << fileNum << ".xml";
    string filePath = filePathStream.str();

    XMLDocument doc;
    if (doc.LoadFile(filePath.c_str()) != XML_SUCCESS) {
        cerr << "Failed to load XML file: " << filePath << endl;
        return;
    }

    map<string, vector<Transition>> transitionsMap;

    XMLElement* root = doc.FirstChildElement("Transitions");
    if (!root) {
        cerr << "Missing <Transitions> root in " << filePath << endl;
        return;
    }

    for (XMLElement* trans = root->FirstChildElement("Transition"); trans != nullptr; trans = trans->NextSiblingElement("Transition")) {
        const char* from = trans->FirstChildElement("From")->GetText();
        const char* to = trans->FirstChildElement("To")->GetText();
        double score = atof(trans->FirstChildElement("Score")->GetText());

        if (from && to) {
            transitionsMap[from].push_back({to, score});
        }
    }
/*
    // Create output folder if it doesn't exist (optional)
    if (!fs::exists(outputFolder)) {
        cerr << "Output folder '" << outputFolder << "' does not exist.\n";
        return;
    }
*/
    // Construct output file path
    ostringstream outFileNameStream;
    outFileNameStream << outputFolder << "/state_transitions" << fileNum << ".csv";
    ofstream outFile(outFileNameStream.str());

    outFile << "State,Total Degree,Score\n";
    for (const auto& entry : transitionsMap) {
        const string& state = entry.first;
        int totalDegree = entry.second.size();
        for (const auto& t : entry.second) {
            outFile << state << "," << totalDegree << "," << t.score << "\n";
        }
    }

    outFile.close();
    cout << "Generated CSV: " << outFileNameStream.str() << endl;
}

int main(int argc, char* argv[]) {
    if (argc != 5) {
        cout << "Usage: " << argv[0] << " <startFileNum> <endFileNum> <inputFolder> <outputFolder>\n";
        return 1;
    }

    int startFileNum = atoi(argv[1]);
    int endFileNum = atoi(argv[2]);
    string inputFolder = argv[3];
    string outputFolder = argv[4];

    if (startFileNum > endFileNum) {
        cerr << "Error: startFileNum should be less than or equal to endFileNum.\n";
        return 1;
    }

    for (int i = startFileNum; i <= endFileNum; ++i) {
        processFile(i, inputFolder, outputFolder);
    }

    return 0;
}

