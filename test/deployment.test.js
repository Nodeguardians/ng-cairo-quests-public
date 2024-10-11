/**
 * These tests check that directory.json and quest-to-test.json are correctly configured for public deployment.
 * Specifically:
 *    1. directory.json should contain all quests with matching version numbers
 *    2. directory.json should not contain extraneous quests
 *    3. All entries in each files-to-test.json should be valid paths
 *    4. All public contracts and scripts (i.e. in "/_src" and "/_scripts") not in files-to-test.json
 *       must match their private counterparts
 *    5. Tests should be organized in the format expected by the backend verification system
 */

"use strict";
const { assert } = require("chai");
const fs = require("fs");
const path = require("path");
const { getFiles, equalFiles, getTrimmedContent, readToml } = require("./helpers/filehelper.js");

const directory = require("../campaigns/directory.json");

const campaignDirectoryPath = path.resolve(__dirname, "..", "campaigns");

const TEST_INDEX_REGEX = /(?<=_)[0-9]*(?=\.cairo$)/;

/**
* Asserts files in public `src` matches files in private `_src`.
* Excludes files found in toExclude.
*/
async function compareFiles(questPath, toExclude) {

  const userFiles = await getFiles(path.join(questPath, "_src"));
  const solutionFiles = (await getFiles(path.join(questPath, "src")))
    .filter(f => !f.includes("/private"));
  var unionContracts = [...new Set([...userFiles, ...solutionFiles])];

  for (const contract of unionContracts) {
    
    if (toExclude.some(filepath => filepath.endsWith(contract))) { continue; }

    const userFile = path.resolve(questPath, "_src", contract);
    const solutionFile = path.resolve(questPath, "src", contract);

    assert(
      equalFiles(userFile, solutionFile), 
      `User contract mismatch with solution: ${contract}`
    );

  }
}

/* Extract the part indices from a test folder */
async function getTestIndices(testFolder) {
    const testFiles = fs.readdirSync(testFolder);
    return testFiles
        .map(filename => TEST_INDEX_REGEX.exec(filename))
        .filter(results => results != null)
        .map(result => parseInt(result[0]));
}

describe("Deployment Configuration Test", async function() {

  it("directory.json should be correctly configured", async function() {

    for (const campaign of directory) {

      const campaignPath = path.resolve(campaignDirectoryPath, campaign.name);
      
      for (const quest of campaign.quests) {
        const questPath = path.resolve(campaignPath, quest.name);

        // Test valid name
        assert(fs.existsSync(questPath), `${questPath} does not exist`);

        // Test valid name
        const version = readToml(path.resolve(questPath, "Scarb.toml")).package.version;
        assert(version == quest.version, `"${quest.name}" has mismatched versions`);

        // Test valid type
        assert(
            quest.type == "ctf" || quest.type == "build", 
            `${quest.name} has an invalid type`
        );

        // Test valid number of parts
        const lastPartPath = path.join(questPath, `description/part${quest.parts}.md`);
        const invalidPartPath = path.join(questPath, `description/part${quest.parts + 1}.md`);
        assert(
          fs.existsSync(lastPartPath) && !fs.existsSync(invalidPartPath),
          `${quest.name} might have an incorrect number of parts`
        );
        
      }

      const numQuests = fs.readdirSync(campaignPath, { withFileTypes: true })
        .filter(entry => entry.isDirectory() && entry.name != "media")
        .length;
      
      // TODO: Re-enable
      // assert(
      //  numQuests == campaign.quests.length, 
      //  `"${campaign.name}" has mismatched number of quests`
      // );
      
    }

  });

  it("files-to-test.json should be correctly configured", async function() {

    for (const campaign of directory) {

      for (const quest of campaign.quests) {

        const questPath = path.resolve(campaignDirectoryPath, campaign.name, quest.name);

        // If quest is CTF, skip
        if (quest.type == "ctf") { continue; }

        // Ensure build quest has files-to-test.json
        const filesToTestPath = path.resolve(questPath, "files-to-test.json");
        assert(fs.existsSync(filesToTestPath), `${quest.name} is missing files-to-test.json`); 
        
        const filesToTest = require(filesToTestPath)
          .map(fileName => path.resolve(questPath, fileName))
          for (const filePath of filesToTest) {
        
          assert(fs.existsSync(filePath), `Invalid file path: ${filePath} in ${filesToTestPath}`);
          assert(
            filePath.endsWith(".cairo") || filePath.endsWith(".json"), 
            `File must either be *.cairo or *.json: ${filePath} in ${filesToTestPath}`
          );
        }

        for (const filePath of filesToTest) {
          assert(fs.existsSync(filePath), `Invalid file path: ${filePath} in ${filesToTestPath}`);
        }

        // Test that all other common contracts/scripts 
        // between public and private folder share the same code
        // (This ensures there is no missing file in files-to-test.json)
        await compareFiles(questPath, ["lib.cairo", ...filesToTest]);

      }
    }

  })

  it("tests should be correctly formatted", async function() {
    for (const campaign of directory) {

      for (const quest of campaign.quests) {
        const questPath = path.resolve(campaignDirectoryPath, campaign.name, quest.name);
        
        // If quest is CTF
        if (quest.type == "ctf") { 
          // Ensure no public test files or utils
          assert(
            !fs.existsSync(path.resolve(questPath, "_src/tests/")), 
            `${questPath} should not have public tests`
          );

          assert(
            !fs.existsSync(path.resolve(questPath, "_src/utils/")), 
            `${questPath} should not have public utils`
          );

          continue; 
        }

        // Else, ensure build tests respect backend format

        // Ensure `lib.cairo` and `lib_private.cairo` matches
        const publicLibConfig = getTrimmedContent(path.resolve(questPath, "_src/lib.cairo"));
        let privateLibConfig = getTrimmedContent(path.resolve(questPath, "src/lib.cairo"));
        
        privateLibConfig = privateLibConfig.replace(/modprivate{[^}]*}/, ""); // Remove private { } block

        assert(
            publicLibConfig == privateLibConfig, 
            `${questPath} has mismatched test lib configs`
        );

        if (quest.name == "build-tutorial-cairo") continue;

        // Public tests should be available for all parts (except maybe part 1)
        const publicTestIndices = 
            await getTestIndices(path.resolve(questPath, "_src/tests"));
        for (let i = 2; i < quest.parts; i++) {
            assert(
                publicTestIndices.includes(i), 
                `${questPath} is missing public test ${i}`
            );
        }
      }

    }
  });


});