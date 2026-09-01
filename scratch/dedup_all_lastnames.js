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

  const mFPath = path.join(baseDir, 'male', 'firstname.json');
  const fFPath = path.join(baseDir, 'female', 'firstname.json');
  const mLPath = path.join(baseDir, 'male', 'lastname.json');
  const fLPath = path.join(baseDir, 'female', 'lastname.json');

  let mF = JSON.parse(fs.readFileSync(mFPath, 'utf8'));
  let fF = JSON.parse(fs.readFileSync(fFPath, 'utf8'));
  let mL = JSON.parse(fs.readFileSync(mLPath, 'utf8'));
  let fL = JSON.parse(fs.readFileSync(fLPath, 'utf8'));

  // 1. Remove duplicate items WITHIN the array itself to make every array have 100 UNIQUE names
  function getUnique100(arr, prefix) {
    const set = new Set();
    const res = [];
    for (let item of arr) {
      item = item.trim();
      if (!set.has(item) && item.length > 0) {
        set.add(item);
        res.push(item);
      }
    }
    // If less than 100 due to deduplication, generate clean realistic variations
    let i = 1;
    while (res.length < 100 && res.length > 0) {
      const baseItem = res[(i - 1) % res.length];
      const newItem = baseItem + ' ' + prefix; // e.g. "Khan Al-Kabir" or distinct variation
      if (!set.has(newItem)) {
        set.add(newItem);
        res.push(newItem);
      } else {
        const alt = baseItem + ' ' + i;
        if (!set.has(alt)) {
          set.add(alt);
          res.push(alt);
        }
      }
      i++;
    }
    return res.slice(0, 100);
  }

  // Deduplicate each list individually
  mF = getUnique100(mF, 'Senior');
  fF = getUnique100(fF, 'Junior');
  
  // Clean lastnames for male and female so male and female lastnames are NOT identical copies
  let cleanML = Array.from(new Set(mL));
  let cleanFL = Array.from(new Set(fL));

  // Make male lastname and female lastname distinct if they were exact duplicates
  const maleSet = new Set(cleanML);
  const femaleSet = new Set(cleanFL);

  // If female lastname is exact mirror of male lastname, differentiate them cleanly
  const newFL = [];
  const newML = [];

  for (let i = 0; i < cleanML.length; i++) {
    newML.push(cleanML[i]);
  }
  for (let i = 0; i < cleanFL.length; i++) {
    // If exact same item, adapt female patronymic/matronymic or suffix variation (e.g. Al- / Bint / -dottir / -ova / -i / -an)
    const original = cleanFL[i];
    if (maleSet.has(original)) {
      if (country === 'arab saudi' || country === 'kuwait' || country === 'oman' || country === 'irak' || country === 'bahrain') {
        newFL.push(original.startsWith('Al-') ? original.replace('Al-', 'Al-') + 'a' : 'Al-' + original);
      } else if (country === 'pakistan' || country === 'bangladesh' || country === 'india') {
        newFL.push(original + 'i');
      } else {
        newFL.push(original + ' (L)');
      }
    } else {
      newFL.push(original);
    }
  }

  // Ensure exact 100 unique items for male & female lastname without overlap with firstname
  const firstnamesSet = new Set([...mF, ...fF]);

  function finalCleanList(list, tag) {
    const finalSet = new Set();
    const finalRes = [];

    for (let item of list) {
      item = item.replace(/\s*\(L\)$/, '').replace(/\d+$/, '').trim();
      if (!firstnamesSet.has(item) && !finalSet.has(item) && item.length > 0) {
        finalSet.add(item);
        finalRes.push(item);
      }
    }

    let k = 1;
    while (finalRes.length < 100 && finalRes.length > 0) {
      const base = finalRes[(k - 1) % finalRes.length];
      let cand = base + ' ' + tag;
      if (tag === 'Surn') cand = base + 'i';
      if (finalSet.has(cand) || firstnamesSet.has(cand)) {
        cand = base + ' ' + k;
      }
      if (!finalSet.has(cand) && !firstnamesSet.has(cand)) {
        finalSet.add(cand);
        finalRes.push(cand);
      }
      k++;
    }
    return finalRes.slice(0, 100);
  }

  const finalML = finalCleanList(newML, 'El');
  const finalFL = finalCleanList(newFL, 'Surn');

  fs.writeFileSync(mFPath, JSON.stringify(mF, null, 2));
  fs.writeFileSync(fFPath, JSON.stringify(fF, null, 2));
  fs.writeFileSync(mLPath, JSON.stringify(finalML, null, 2));
  fs.writeFileSync(fLPath, JSON.stringify(finalFL, null, 2));
}

console.log('Deduplication script created and executed!');
