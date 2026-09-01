const fs = require('fs');
const path = require('path');

const list13 = [
  'afganistan', 'arab saudi', 'armenia', 'azerbaijan', 'bahrain',
  'bangladesh', 'bhutan', 'brunei', 'china', 'filipina',
  'georgia', 'hong kong', 'india'
];

for (const country of list13) {
  const baseDir = path.join('json', 'firstname_lastname', 'asia', country);
  const files = [
    path.join(baseDir, 'male', 'firstname.json'),
    path.join(baseDir, 'male', 'lastname.json'),
    path.join(baseDir, 'female', 'firstname.json'),
    path.join(baseDir, 'female', 'lastname.json')
  ];

  for (const file of files) {
    if (!fs.existsSync(file)) continue;
    let list = JSON.parse(fs.readFileSync(file, 'utf8'));

    // Strip out all suffix tags (-F, -M, -L, -FL, -BD, -BH, -CN, -HK, -AZ, -IN, -PH, -GE, Alt1, Female, Male, etc.)
    const cleaned = list.map(name => {
      let n = name;
      // Remove -suffixes like -F, -M, -FL, -Female, -Male, -BD, -BH, -CN, -HK, -AZ, -IN, -PH, -GE, -AZL, -BHL, etc.
      n = n.replace(/-(F|M|L|FL|ML|Female|Male|FHK|MHK|FHKS|BD|BH|CN|HK|AZ|IN|PH|GE|B|L|FL|FLL|BL|BHL|BN|BNL|ALT\d+|Alt\d+)/gi, '');
      // Remove Alt tags
      n = n.replace(/Alt\d+/gi, '');
      return n.trim();
    });

    // Remove duplicates within the same file while keeping exact casing
    const set = new Set();
    const result = [];
    for (const item of cleaned) {
      if (!set.has(item) && item.length > 0) {
        set.add(item);
        result.push(item);
      }
    }

    fs.writeFileSync(file, JSON.stringify(result, null, 2));
    console.log(`${country} - ${path.relative(baseDir, file)}: ${result.length} items`);
  }
}
