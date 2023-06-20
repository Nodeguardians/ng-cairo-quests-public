"use strict";
const { execSync } = require("child_process");
const path = require("path");

const directory = require("../campaigns/directory.json");
const campaignPath = path.resolve(__dirname, "..", "campaigns");

for (const campaign of directory) {
  describe(campaign.name, async function() {

    for (const quest of campaign.quests) {

      it(`${quest.name} should pass tests`, async function() {
        const questPath = path.resolve(
            campaignPath, campaign.name, quest.name);
        runScarbTests(questPath)
      });

    }

  });
}

function runScarbTests(questPath) {
    process.chdir(questPath);
    execSync("scarb test");
    process.chdir("../../..");
}
