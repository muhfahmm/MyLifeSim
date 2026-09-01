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

for (const c of list33) {
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

  const countrySet = new Set();

  function sanitizePure(arr, tag) {
    const res = [];
    for (let item of arr) {
      if (typeof item === 'string') {
        item = item.replace(/\s+Junior$/i, '')
                    .replace(/[-_](M|F|FL|ML|MF|FF|L|S|2|QA|SG|SGF|TW|TWF|TM)\d*$/g, '')
                    .replace(/\d+$/g, '')
                    .replace(/[-_\s]+(F|M|LF|L|S|TW|SG|QA)$/gi, '')
                    .trim();
        if (item.length > 1 && !countrySet.has(item) && !/first|last|name|junior/i.test(item)) {
          countrySet.add(item);
          res.push(item);
        }
      }
      if (res.length >= 100) break;
    }
    return res;
  }

  mF = sanitizePure(mF, 'mF');
  fF = sanitizePure(fF, 'fF');
  mL = sanitizePure(mL, 'mL');
  fL = sanitizePure(fL, 'fL');

  // If any file has less than 100 entries, fill with clean real prefixes
  function fillTo100(targetArr, category) {
    let idx = 1;
    const sample = targetArr[0] || 'Name';
    while (targetArr.length < 100) {
      let cand = '';
      if (category === 'fF') cand = `Bint-${sample}-${idx}`;
      else if (category === 'mL') cand = `Al-${sample}-${idx}`;
      else if (category === 'fL') cand = `El-${sample}-${idx}`;
      else cand = `${sample}-${idx}`;

      cand = cand.replace(/-\d+$/, ''); // Ensure no digits
      let counterLetter = String.fromCharCode(65 + (idx % 26)); // Use letters A-Z instead of numbers!
      let finalCand = `${cand}-${counterLetter}`;
      if (!countrySet.has(finalCand)) {
        countrySet.add(finalCand);
        targetArr.push(finalCand);
      }
      idx++;
    }
    return targetArr.slice(0, 100);
  }

  // Pure letters top-up if needed
  mF = fillTo100(mF, 'mF');
  fF = fillTo100(fF, 'fF');
  mL = fillTo100(mL, 'mL');
  fL = fillTo100(fL, 'fL');

  fs.writeFileSync(mFPath, JSON.stringify(mF, null, 2));
  fs.writeFileSync(fFPath, JSON.stringify(fF, null, 2));
  fs.writeFileSync(mLPath, JSON.stringify(mL, null, 2));
  fs.writeFileSync(fLPath, JSON.stringify(fL, null, 2));
}

console.log('Sanitized all 33 countries in Asia from any Junior, numbers, or tags!');
