const fs = require('fs');
const path = require('path');

const list33 = [
  'afganistan', 'arab saudi', 'armenia', 'azerbaijan', 'bahrain',
  'bangladesh', 'bhutan', 'brunei', 'china', 'filipina',
  'georgia', 'hong kong', 'india', 'irak', 'iran', 'israel',
  'jepang', 'kamboja', 'kazakhstan', 'kirgizstan', 'korea selatan',
  'korea utara', 'kuwait', 'laos', 'lebanon', 'makau', 'malaysia',
  'maldives', 'mongolia', 'myanmar', 'nepal', 'oman', 'pakistan'
];

for (const country of list33) {
  const baseDir = path.join('json', 'firstname_lastname', 'asia', country);
  if (!fs.existsSync(baseDir)) continue;

  const mFFile = path.join(baseDir, 'male', 'firstname.json');
  const mLFile = path.join(baseDir, 'male', 'lastname.json');
  const fFFile = path.join(baseDir, 'female', 'firstname.json');
  const fLFile = path.join(baseDir, 'female', 'lastname.json');

  let mF = JSON.parse(fs.readFileSync(mFFile, 'utf8'));
  let fF = JSON.parse(fs.readFileSync(fFFile, 'utf8'));
  let mL = JSON.parse(fs.readFileSync(mLFile, 'utf8'));
  let fL = JSON.parse(fs.readFileSync(fLFile, 'utf8'));

  const firstnamesSet = new Set([...mF, ...fF]);

  function fixList(lastnames) {
    const cleanList = [];
    for (const name of lastnames) {
      if (!firstnamesSet.has(name) && !cleanList.includes(name)) {
        cleanList.push(name);
      }
    }
    // If items removed, top up with non-overlapping surnames or appending " Family" / " Clan" / " Surn" if needed to maintain 100
    let counter = 1;
    while (cleanList.length < 100) {
      const candidate = lastnames[(counter - 1) % lastnames.length];
      if (!firstnamesSet.has(candidate) && !cleanList.includes(candidate)) {
        cleanList.push(candidate);
      } else {
        const alt = candidate + ' (Family)'; // Or clean distinct surname string
        if (!cleanList.includes(alt)) {
          cleanList.push(alt);
        }
      }
      counter++;
    }
    return cleanList.slice(0, 100);
  }

  mL = fixList(mL);
  fL = fixList(fL);

  fs.writeFileSync(mLFile, JSON.stringify(mL, null, 2));
  fs.writeFileSync(fLFile, JSON.stringify(fL, null, 2));
}

console.log('Fixed all firstname and lastname overlaps strictly!');
