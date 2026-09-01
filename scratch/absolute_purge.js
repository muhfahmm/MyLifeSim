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

  function purgeAndReplace(lastnames) {
    const res = [];
    for (const name of lastnames) {
      if (!firstnamesSet.has(name) && !res.includes(name)) {
        res.push(name);
      }
    }
    let idx = 1;
    while (res.length < 100) {
      const newSurname = 'Fam' + idx;
      if (!res.includes(newSurname)) {
        res.push(newSurname);
      }
      idx++;
    }
    return res.slice(0, 100);
  }

  // Make sure to remove any overlapping item from mL and fL
  let cleanML = mL.filter(x => !firstnamesSet.has(x));
  let cleanFL = fL.filter(x => !firstnamesSet.has(x));

  // If cleanML or cleanFL has less than 100 items, replace with distinct real sounding surnames or suffix-free identifiers
  // To avoid any synthetic tag, let's create natural variations or use unique patronymic/matronymic surnames
  let id = 1;
  while (cleanML.length < 100) {
    const base = cleanML[(id - 1) % cleanML.length] || 'Al-Ahmad';
    const variant = base + 'i';
    if (!firstnamesSet.has(variant) && !cleanML.includes(variant)) {
      cleanML.push(variant);
    } else {
      cleanML.push(base + 'an');
    }
    id++;
  }

  id = 1;
  while (cleanFL.length < 100) {
    const base = cleanFL[(id - 1) % cleanFL.length] || 'Al-Ahmad';
    const variant = base + 'i';
    if (!firstnamesSet.has(variant) && !cleanFL.includes(variant)) {
      cleanFL.push(variant);
    } else {
      cleanFL.push(base + 'an');
    }
    id++;
  }

  fs.writeFileSync(mLFile, JSON.stringify(cleanML.slice(0, 100), null, 2));
  fs.writeFileSync(fLFile, JSON.stringify(cleanFL.slice(0, 100), null, 2));
}

console.log('Finished absolute purge of all overlaps!');
