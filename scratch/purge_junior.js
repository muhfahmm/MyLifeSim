const fs = require('fs');
const path = require('path');

function processDir(dir) {
  const files = fs.readdirSync(dir);
  for (const f of files) {
    const fullPath = path.join(dir, f);
    const stat = fs.statSync(fullPath);
    if (stat.isDirectory()) {
      processDir(fullPath);
    } else if (f.endsWith('.json')) {
      let content = fs.readFileSync(fullPath, 'utf8');
      if (/junior/i.test(content)) {
        let json = JSON.parse(content);
        if (Array.isArray(json)) {
          let updated = false;
          let newSet = new Set();
          let cleanedList = [];
          for (let item of json) {
            let cleanItem = item.replace(/\s+Junior$/i, '').trim();
            if (cleanItem !== item) updated = true;
            
            // Avoid duplicate in file if removing Junior causes collision
            let finalItem = cleanItem;
            let counter = 1;
            while (newSet.has(finalItem)) {
              finalItem = `${cleanItem} Bint-${counter}`;
              counter++;
              updated = true;
            }
            newSet.add(finalItem);
            cleanedList.push(finalItem);
          }
          if (updated) {
            fs.writeFileSync(fullPath, JSON.stringify(cleanedList, null, 2));
            console.log('Cleaned Junior from:', fullPath);
          }
        }
      }
    }
  }
}

const baseFolder = path.join('json', 'firstname_lastname');
processDir(baseFolder);
console.log('Finished purging all Junior occurrences across all json files!');
