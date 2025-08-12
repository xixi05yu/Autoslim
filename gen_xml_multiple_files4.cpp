#include <iostream>
#include <fstream>
#include <tinyxml2.h>
#include <random>
#include <string>
#include <cstdlib> // For std::stoi
#include <unordered_set> // To keep track of unique states for transitions
#include <filesystem>    // For handling file paths

namespace fs = std::filesystem;
using namespace tinyxml2;

// Random number generator
std::random_device rd;
std::mt19937 gen(rd());
std::uniform_real_distribution<> scoreDist(0.0, 1.0);
std::uniform_int_distribution<> stateDist;  // Defined per file

// Generate random score between 0.0 and 1.0
double generateRandomScore() {
    return scoreDist(gen);
}

// Generate XML transitions
void generateXML(const std::string& filename, int numStates, int maxTransitionsPerState) {
    stateDist = std::uniform_int_distribution<>(0, numStates - 1);
    std::uniform_int_distribution<> numTransitionsDist(0, maxTransitionsPerState); // FIXED here

    XMLDocument doc;
    XMLDeclaration* decl = doc.NewDeclaration();
    doc.InsertFirstChild(decl);

    XMLElement* root = doc.NewElement("Transitions");
    doc.InsertEndChild(root);

    // Create state names
    std::vector<std::string> states;
    for (int i = 0; i < numStates; ++i) {
        states.push_back("s_" + std::to_string(i + 1));
    }

    std::unordered_set<std::string> createdTransitions;

    for (int i = 0; i < numStates; ++i) {
        std::string fromState = states[i];
        int numTransitions = numTransitionsDist(gen);

        for (int j = 0; j < numTransitions; ++j) {
            int toStateIndex = stateDist(gen);
            while (toStateIndex == i) {
                toStateIndex = stateDist(gen);
            }
            std::string toState = states[toStateIndex];
            std::string transitionKey = fromState + "->" + toState;

            if (createdTransitions.find(transitionKey) == createdTransitions.end()) {
                createdTransitions.insert(transitionKey);

                XMLElement* transition = doc.NewElement("Transition");

                XMLElement* from = doc.NewElement("From");
                from->SetText(fromState.c_str());
                transition->InsertEndChild(from);

                XMLElement* to = doc.NewElement("To");
                to->SetText(toState.c_str());
                transition->InsertEndChild(to);

                XMLElement* score = doc.NewElement("Score");
                score->SetText(generateRandomScore());
                transition->InsertEndChild(score);

                root->InsertEndChild(transition);
            }
        }
    }

    doc.SaveFile(filename.c_str());
}

int main(int argc, char* argv[]) {
    if (argc != 5) {
        std::cerr << "Usage: " << argv[0] << " <numStates> <maxTransitionsPerState> <numFiles> <outputFolder>" << std::endl;
        return 1;
    }

    int numStates, maxTransitionsPerState, numFiles;
    try {
        numStates = std::stoi(argv[1]);
        maxTransitionsPerState = std::stoi(argv[2]);
        numFiles = std::stoi(argv[3]);
    } catch (const std::invalid_argument& e) {
        std::cerr << "Error: Invalid number provided." << std::endl;
        return 1;
    }

    std::string outputFolder = argv[4];
    if (!fs::exists(outputFolder)) {
        std::cerr << "Output folder does not exist. Creating folder: " << outputFolder << std::endl;
        fs::create_directory(outputFolder);
    }

    for (int i = 0; i < numFiles; ++i) {
        std::string filename = outputFolder + "/file" + std::to_string(i + 1) + ".xml";
        generateXML(filename, numStates, maxTransitionsPerState);
        std::cout << "XML file generated: " << filename << std::endl;
    }

    return 0;
}

