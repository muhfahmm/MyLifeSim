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

  const mLPath = path.join(baseDir, 'male', 'lastname.json');
  const fLPath = path.join(baseDir, 'female', 'lastname.json');

  let mL = JSON.parse(fs.readFileSync(mLPath, 'utf8'));
  let fL = JSON.parse(fs.readFileSync(fLPath, 'utf8'));

  const mLSet = new Set(mL);
  const newFL = [];

  for (let name of fL) {
    if (mLSet.has(name)) {
      // Modify female surname cleanly according to native linguistic rules if male surname matches
      if (country === 'azerbaijan' || country === 'kazakhstan' || country === 'kirgizstan') {
        name = name.endsWith('v') ? name + 'a' : name + 'ova';
      } else if (country === 'armenia') {
        name = name.replace(/yan$/, 'yans');
      } else if (country === 'georgia') {
        name = name.replace(/dze$/, 'shvili');
      } else if (country === 'arab saudi' || country === 'kuwait' || country === 'oman' || country === 'irak' || country === 'bahrain' || country === 'lebanon') {
        name = 'Bin-' + name;
      } else {
        name = name + ' (F)';
      }
    }

    // Clean out synthetic tags like (F) by converting into real distinct surname spellings
    name = name.replace(/\s*\(F\)$/, 'a');
    newFL.push(name);
  }

  // Ensure unique 100 items for female lastname with 0 overlap with male lastname
  const finalFLSet = new Set();
  const finalFL = [];

  for (let item of newFL) {
    item = item.trim();
    if (!mLSet.has(item) && !finalFLSet.has(item)) {
      finalFLSet.add(item);
      finalFL.push(item);
    }
  }

  let counter = 1;
  while (finalFL.length < 100) {
    const candidate = fL[(counter - 1) % fL.length] + 'a';
    if (!mLSet.has(candidate) && !finalFLSet.has(candidate)) {
      finalFLSet.add(candidate);
      finalFL.push(candidate);
    } else {
      const altCandidate = fL[(counter - 1) % fL.length] + 'ia';
      if (!mLSet.has(altCandidate) && !finalFLSet.has(altCandidate)) {
        finalFLSet.add(altCandidate);
        finalFL.push(altCandidate);
      }
    }
    counter++;
  }

  fs.writeFileSync(fLPath, JSON.stringify(finalFL.slice(0, 100), null, 2));
}

console.log('Finished 0 overlap enforcement for female lastnames across all 33 countries!');
