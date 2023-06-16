"use strict";
const { assert } = require("chai");
const { execSync } = require("child_process");
const fs = require("fs");
const path = require("path");

const directory = require("../cairo-campaigns/directory.json");
const campaignPath = path.resolve(__dirname, "..", "cairo-campaigns");

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
    const result = execSync("scarb run test");
    process.chdir("../../..");
}
