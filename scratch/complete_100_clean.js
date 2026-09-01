const fs = require('fs');
const path = require('path');

const extraNamesToComplete = {
  'armenia': {
    mL: ['Vardanyan', 'Hakobyan', 'Stepanyan', 'Baghdasaryan', 'Danielyan'],
    fL: ['Hakobyan', 'Harutyunyan', 'Hovhannisyan', 'Khachatryan', 'Manukyan']
  },
  'azerbaijan': {
    mF: ['Eldar'],
    fF: ['Aysel', 'Aytan', 'Aygun', 'Ayna', 'Gunay', 'Gultakin', 'Gunel', 'Leyla'],
    fL: ['Ahmadova', 'Aliyeva', 'Asadova', 'Babayeva']
  },
  'bahrain': {
    mL: ['Fakhro'],
    fL: ['Janahi', 'Kanoo', 'Al-Alawi', 'Al-Hassan']
  },
  'bangladesh': {
    mL: ['Chowdhury', 'Hossain', 'Rahman', 'Sarkar', 'Siddique', 'Uddin', 'Zaman'],
    fL: ['Bhuiyan', 'Chowdhury', 'Hossain', 'Islam', 'Rahman', 'Sarkar']
  },
  'bhutan': {
    mF: ['Sangay', 'Sonam', 'Tashi', 'Tenzin', 'Tshering', 'Ugyen', 'Kinley', 'Karma', 'Jigme', 'Dorji', 'Lhendup', 'Phuntsho', 'Rinchen', 'Thinley', 'Yeshey', 'Dawa', 'Nima', 'Pema', 'Kuenga', 'Kunzang', 'Lotay', 'Lubdak', 'Namgyal', 'Nidup', 'Norbu', 'Passang', 'Penjor', 'Phurba', 'Samdrup', 'Tobgay', 'Tshewang', 'Zangpo', 'Chhogyel', 'Choda', 'Gayley', 'Gembo', 'Kinzang'],
    fF: ['Choki', 'Dechen', 'Deki', 'Kezang', 'Lhamo', 'Mendrel', 'Namgay', 'Om', 'Peldon', 'Pem', 'Sangay', 'Sonam', 'Tandin', 'Tashi', 'Tenzin', 'Tshomo', 'Tshering', 'Yangchen', 'Yangki', 'Yendon', 'Zangmo', 'Beda', 'Bida', 'Chhimi', 'Choden', 'Dema', 'Dolma', 'Karma', 'Kinley', 'Kunzang', 'Nima', 'Norbu', 'Passang', 'Pema', 'Phuntsho', 'Rinchen', 'Wangmo', 'Yangkyi', 'Yangzom', 'Doma', 'Lhaden', 'Meto', 'Ringzin', 'Seldon', 'Yangdon', 'Yidon', 'Yuden'],
    mL: ['Dorji', 'Gyeltshen', 'Jigme', 'Namgyal', 'Nidup', 'Norbu', 'Penjor', 'Phuntsho', 'Rinchen', 'Samdrup', 'Tenzin', 'Thinley', 'Tobgay', 'Tshering']
  },
  'brunei': {
    mF: ['Hassanal'],
    mL: ['Abdullah', 'Ariffin', 'Matali'],
    fL: ['Amina', 'Azizah', 'Halimah', 'Latifah', 'Mariam']
  },
  'china': {
    mL: ['Chen', 'Cheng', 'Deng', 'Feng', 'Gao'],
    fL: ['Chen', 'Cheng', 'Deng', 'Feng', 'Gao', 'Guo', 'He']
  },
  'georgia': {
    mF: ['Badri', 'Bakar', 'Beso', 'Davit', 'Gaga', 'Giga', 'Giorgi', 'Guram', 'Irakli', 'Kakha', 'Khabareli', 'Lasha', 'Levan', 'Luka'],
    mL: ['Beridze', 'Chikovani', 'Dolidze', 'Gagua', 'Gelashvili', 'Gorgisheli', 'Japaridze', 'Kakhidze', 'Kapanadze', 'Kvaratskhelia', 'Maisuradze', 'Mchedlishvili'],
    fF: ['Ana', 'Anano', 'Ani', 'Elene', 'Eter', 'Ia', 'Khatuna', 'Lela', 'Maia', 'Mariam', 'Marine', 'Medea', 'Nia', 'Nino', 'Nona', 'Rusudan', 'Salome', 'Shorena', 'Tamar', 'Teona', 'Tinatin', 'Tsiala', 'Baia', 'Barbora', 'Dali', 'Darejan', 'Eka', 'Ekaterine'],
    fL: ['Beridze', 'Chikovani', 'Dolidze', 'Gagua', 'Gelashvili', 'Gorgisheli', 'Japaridze', 'Kakhidze', 'Kapanadze', 'Kvaratskhelia', 'Maisuradze', 'Mchedlishvili', 'Meladze', 'Natsvlishvili', 'Nozadze']
  },
  'hong kong': {
    mL: ['Chan', 'Cheng', 'Cheung', 'Chow', 'Ho', 'Hui', 'Ip', 'Kwok', 'Lai', 'Lam', 'Lau', 'Lee', 'Leung', 'Li', 'Lo', 'Luk', 'Ng', 'Poon', 'Tam', 'Tang', 'Tse', 'Wong', 'Wu', 'Yeung', 'Yip', 'Au', 'Cha', 'Fan', 'Fung', 'Kwan'],
    fL: ['Au', 'Cha', 'Fan', 'Fung', 'Kwan', 'Kwong', 'Law', 'Man', 'Mok', 'Sin', 'Sit', 'So', 'Sun', 'Sze', 'To', 'Tsang', 'Tsoi', 'Wan', 'Yau', 'Yuen', 'Chan', 'Cheng', 'Cheung', 'Chow', 'Ho', 'Hui', 'Ip', 'Kwok', 'Lai', 'Lam', 'Lau', 'Lee', 'Leung']
  }
};

const list13 = [
  'afganistan', 'arab saudi', 'armenia', 'azerbaijan', 'bahrain',
  'bangladesh', 'bhutan', 'brunei', 'china', 'filipina',
  'georgia', 'hong kong', 'india'
];

for (const country of list13) {
  const baseDir = path.join('json', 'firstname_lastname', 'asia', country);
  
  const files = {
    mF: path.join(baseDir, 'male', 'firstname.json'),
    mL: path.join(baseDir, 'male', 'lastname.json'),
    fF: path.join(baseDir, 'female', 'firstname.json'),
    fL: path.join(baseDir, 'female', 'lastname.json')
  };

  for (const key in files) {
    let list = JSON.parse(fs.readFileSync(files[key], 'utf8'));
    const extras = (extraNamesToComplete[country] && extraNamesToComplete[country][key]) || [];

    for (const item of extras) {
      if (list.length >= 100) break;
      if (!list.includes(item)) {
        list.push(item);
      }
    }

    fs.writeFileSync(files[key], JSON.stringify(list, null, 2));
  }
}

console.log('Completeness top up finished!');
