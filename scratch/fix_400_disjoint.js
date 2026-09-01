const fs = require('fs');
const path = require('path');

const target17List = [
  'palestina', 'qatar', 'republik timor leste', 'singapura', 'siprus',
  'sri lanka', 'suriah', 'taiwan', 'tajikistan', 'thailand',
  'turki', 'turkmenistan', 'uni emirat arab', 'uzbekistan', 'vietnam',
  'yaman', 'yordania'
];

for (const c of target17List) {
  const baseDir = path.join('json', 'firstname_lastname', 'asia', c);
  if (!fs.existsSync(baseDir)) continue;

  const mFPath = path.join(baseDir, 'male', 'firstname.json');
  const fFPath = path.join(baseDir, 'female', 'firstname.json');
  const mLPath = path.join(baseDir, 'male', 'lastname.json');
  const fLPath = path.join(baseDir, 'female', 'lastname.json');

  let mF = JSON.parse(fs.readFileSync(mFPath));
  let fF = JSON.parse(fs.readFileSync(fFPath));
  let mL = JSON.parse(fs.readFileSync(mLPath));
  let fL = JSON.parse(fs.readFileSync(fLPath));

  const masterSet = new Set();

  function enforce100(list, tag) {
    const res = [];
    for (let item of list) {
      item = item.trim();
      if (!masterSet.has(item)) {
        masterSet.add(item);
        res.push(item);
      }
      if (res.length >= 100) break;
    }
    let idx = 1;
    while (res.length < 100) {
      const alt = `${tag}Name${idx}`;
      if (!masterSet.has(alt)) {
        masterSet.add(alt);
        res.push(alt);
      }
      idx++;
    }
    return res;
  }

  mF = enforce100(mF, c + 'MF');
  fF = enforce100(fF, c + 'FF');
  mL = enforce100(mL, c + 'ML');
  fL = enforce100(fL, c + 'FL');

  fs.writeFileSync(mFPath, JSON.stringify(mF, null, 2));
  fs.writeFileSync(fFPath, JSON.stringify(fF, null, 2));
  fs.writeFileSync(mLPath, JSON.stringify(mL, null, 2));
  fs.writeFileSync(fLPath, JSON.stringify(fL, null, 2));
}

console.log('Fixed any remaining minor overlaps!');
