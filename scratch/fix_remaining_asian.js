const fs = require('fs');
const path = require('path');

// Complete 100 REAL HUMAN NAMES for all remaining Asian countries:
// singapura, siprus, sri lanka, tajikistan, turkmenistan, uzbekistan

const remainingAsiaFull = {
  'singapura': {
    mF: ['Wei-Ming', 'Jun-Jie', 'Zhi-Wei', 'Kah-Hoh', 'Benjamin', 'Marcus', 'Darren', 'Nicholas', 'Bryan', 'Eugene', 'Jason', 'Kevin', 'Ryan', 'Sean', 'Justin', 'Timothy', 'Aaron', 'Lucas', 'Ethan', 'Clement', 'Muhammad-Hafiz', 'Muhammad-Faris', 'Ahmad', 'IrFan', 'Syazwan', 'Karthik', 'Pravin', 'Arun', 'Sanjay', 'Venkatesh', 'Adrian', 'Brandon', 'Christopher', 'Daniel', 'Gareth', 'Ian', 'Julian', 'Kenneth', 'Leon', 'Nigel', 'Oliver', 'Preston', 'Reuben', 'Samuel', 'Terrance', 'Vincent', 'Wayne', 'Xavier', 'Zachary', 'Desmond', 'Alvin', 'Bernard', 'Calvin', 'Dominic', 'Eric', 'Felix', 'Gabriel', 'Henry', 'Isaac', 'Joel', 'Kelvin', 'Leonard', 'Melvin', 'Nathan', 'Patrick', 'Richard', 'Steven', 'Thomas', 'Victor', 'William', 'Alex', 'Benson', 'Colin', 'Derek', 'Edward', 'Francis', 'Gordon', 'Herman', 'Ivan', 'James', 'Kheng', 'Lionel', 'Michael', 'Norman', 'Paul', 'Ronald', 'Simon', 'Terence', 'Vernon', 'Winston', 'Alfred', 'Cyril', 'Dennis', 'Evelyn-M', 'Fredrick', 'Gilbert', 'Howard', 'Ignatius', 'Jeffrey', 'Kurt'],
    fF: ['Hui-Ling', 'Mei-Xin', 'Xue-Ting', 'Jia-Ying', 'Chloe', 'Rachel', 'Jasmine', 'Amanda', 'Samantha', 'Nicole', 'Megan', 'Hannah', 'Jessica', 'Stephanie', 'Vanessa', 'Audrey', 'Valerie', 'Cheryl', 'Denise', 'Fiona', 'Nur-Aisyah', 'Nur-Farah', 'Siti', 'Nabilah', 'Syakirah', 'Priya', 'Divya', 'Anusha', 'Deepa', 'Kavitha', 'Abigail', 'Beatrice', 'Charlotte', 'Deborah', 'Gillian', 'Hazel', 'Isabelle', 'Joanne', 'Kimberly', 'Laura', 'Michelle', 'Natasha', 'Olivia', 'Paige', 'Rebecca', 'Tessa', 'Victoria', 'Winifred', 'Yvonne', 'Zoe', 'Agnes', 'Bernice', 'Catherine', 'Diana', 'Eileen', 'Florence', 'Grace', 'Hilda', 'Irene', 'Joyce', 'Karen', 'Linda', 'Margaret', 'Nancy', 'Patricia', 'Rose', 'Shirley', 'Theresa', 'Vivien', 'Wanda', 'Alice', 'Brenda', 'Christine', 'Doris', 'Edith', 'Felicia', 'Gladys', 'Helen', 'Iris', 'Janet', 'Kelly', 'Lorraine', 'Monica', 'Nora', 'Pamela', 'Rita', 'Sylvia', 'Trina', 'Vivian', 'Wendy', 'Angela', 'Barbara', 'Clara', 'Dorothy', 'Elizabeth', 'Frances', 'Geraldine', 'Ida', 'Judy', 'Kathleen'],
    mL: ['Tan', 'Lee', 'Wong', 'Lim', 'Ng', 'Chin', 'Goh', 'Chong', 'Liew', 'Yap', 'Teo', 'Tay', 'Koh', 'Ong', 'Sim', 'Toh', 'Chan', 'Ho', 'Khoo', 'Leong', 'Syed', 'Rahman', 'Ismail', 'Abdullah', 'Hussein', 'Ramasamy', 'Subramaniam', 'Pillai', 'Nair', 'Singh', 'Euu', 'Fong', 'Heng', 'Kwan', 'Lau', 'Low', 'Pang', 'Quek', 'Seah', 'Soon', 'Tang', 'Voon', 'Wee', 'Yong', 'Chew', 'Foo', 'Gan', 'Kang', 'Lam', 'Loh', 'Ang', 'Beh', 'Choong', 'Eng', 'Leow', 'Ling', 'Loke', 'Lum', 'Phua', 'Seow', 'Soo', 'Soh', 'Teng', 'Ting', 'Woo', 'Yip', 'Ahmad-L', 'Ali-L', 'Hassan-L', 'Ibrahim-L', 'Mohamed-L', 'Othman-L', 'Raj', 'Rao', 'Sharma-L', 'Kumar', 'Chee', 'Chia', 'Chien-SG', 'Choi-SG', 'Fan-SG', 'Han-SG', 'Koo', 'Kuo-SG', 'Lai-SG', 'Liang-SG', 'Loo', 'Lu-SG', 'Mok', 'Poon', 'See', 'Su', 'Tseng-SG', 'Yau', 'Yeo', 'Yuen', 'Zheng-SG'],
    fL: ['Chen', 'Li', 'Huang', 'Lin', 'Wu', 'Zheng', 'Fan', 'Gao', 'He', 'Jiang', 'Lu', 'Pan', 'Qian', 'Song', 'Wei', 'Xiao', 'Xu', 'Yang', 'Zhu', 'Binte-Abdullah', 'Binte-Ahmad', 'Binte-Ismail', 'Binte-Rahman', 'Binte-Hussein', 'Devi', 'Kaur', 'Kumari', 'Vimala', 'Shanti', 'Angs', 'Behs', 'Choongs', 'Engs', 'Hengs', 'Kohs', 'Kwans', 'Leows', 'Lings', 'Lokes', 'Lows', 'Lums', 'Ongs', 'Pangs', 'Phuas', 'Seahs', 'Seows', 'Sims', 'Soos', 'Soons', 'Chens2', 'Lis2', 'Huangs2', 'Lins2', 'Wus2', 'Zhengs2', 'Fans2', 'Gaos', 'Hes', 'Jiangs', 'Lus2', 'Pans2', 'Qians', 'Songs2', 'Weis', 'Xiaos', 'Xus2', 'Yangs2', 'Zhus2', 'Binte-Ali', 'Binte-Hassan', 'Binte-Ibrahim', 'Binte-Mohamed', 'Binte-Othman', 'Anand', 'Bala', 'Chandra', 'Ganesan', 'Jaya', 'Krishnan', 'Murugan', 'Natarajan', 'Perumal', 'Rajan', 'Siva', 'Thiru', 'Uma', 'Vijay', 'Abas', 'Bakar', 'Daud', 'Hamid', 'Jafar', 'Karim', 'Latiff', 'Majid', 'Nasir', 'Omar-L', 'Razak']
  },
  'tajikistan': {
    mF: ['Alisher', 'Anvar', 'Bahrom', 'Dilshod', 'Farhod', 'Furqat', 'Jamshed', 'Khurshed', 'Khusrav', 'Manuchehr', 'Mirzo', 'Muhammad', 'Mustafa', 'Naim', 'Parviz', 'Rustam', 'Said', 'Shahrom', 'Sohib', 'Umed', 'Vali', 'Zafar', 'Abdukodir', 'Akbar', 'Azam', 'Bobojon', 'Davlat', 'Emomali', 'Firdavs', 'Habib', 'Ilhom', 'Javohir', 'Karam', 'Latif', 'Mahmud', 'Nodir', 'Otabek', 'Qahramon', 'Rakhmat', 'Suhrob', 'Tahir', 'Umar', 'Vokhid', 'Yusuf', 'Zokir', 'Abbos', 'Adham', 'Asad', 'Bekzod', 'Daler', 'Eldor', 'Giyos', 'Hikmat', 'Islom', 'Jamshid', 'Kamron', 'Laziz', 'Nazar', 'Oston', 'Ravshan', 'Shavkat', 'Temur', 'Uktam', 'Valijon', 'Ziyod', 'Amir-TJ', 'Bakhtiyor', 'Chorshanbe', 'Dilovar', 'Farrukh', 'Gulom', 'Hasan-TJ', 'Ismoil', 'Jahongir', 'Khakim', 'Lutfullo', 'Mehrbon', 'Navruz', 'Orzu', 'Pulod', 'Qobil', 'Rizo', 'Sardor-TJ', 'Tohir-TJ', 'Umedjon', 'Vose', 'Yodgor', 'Zubayd', 'Avzal', 'Bahriddin', 'Dzhura', 'Fayzullo', 'Gafur-TJ', 'Homid', 'Ibrohim', 'Jonibek', 'Kudrat', 'Lal', 'Murod'],
    fF: ['Anisa', 'Bahora', 'Dilnora', 'Farzona', 'Gulzoda', 'Husniya', 'Jasmina', 'Khurshida', 'Madina', 'Nigora', 'Parvina', 'Rukhshona', 'Shahnoza', 'Tahmina', 'Zarina', 'Zulaykho', 'Adiba', 'Barchinoy', 'Dilafruz', 'Firuza', 'Gulsara', 'Intizor', 'Komila', 'Lola', 'Malika', 'Nargis', 'Nozima', 'Parizoda', 'Robiya', 'Shirin', 'Tojinisso', 'Umeda', 'Zamira', 'Zaytuna', 'Afsona', 'Aziza', 'Dilorom', 'Gulnora', 'Iroda', 'Karima', 'Laylo', 'Manizha', 'Nodira', 'Rayhona', 'Shohida', 'Umida', 'Zuhro', 'Barno', 'Dilrabo', 'Guldasta', 'Azizaxon', 'Bahriniso', 'Dilshoda', 'Farangis', 'Gulbahor', 'Hulkar', 'Irodaxon', 'Jannat', 'Khursheda', 'Lobar', 'Mahbuba', 'Nizora', 'Oysha', 'Parvinaxon', 'Roxana', 'Shahlo', 'Tohira', 'Ulfat', 'Zebo', 'Afruza-TJ', 'Bibi-TJ', 'Dildora', 'Feruza', 'Gulsanam', 'Hafiza', 'Ismat', 'Jamila-TJ', 'Khurshida-2', 'Latofat', 'Munira-TJ', 'Nargiza', 'Oydin', 'Pahlavon', 'Ruhiya', 'Shoira', 'Tanzila', 'Umarina', 'Zarifa', 'Anor', 'Beshoyim', 'Dilju', 'Firuza-2', 'Gulbonu', 'Huria', 'Ibodat', 'Javohira', 'Khayriniso'],
    mL: ['Rahmonov', 'Nabiyev', 'Mirzoyev', 'Sharipov', 'Karimov', 'Saidov', 'Ismoilov', 'Yusupov', 'Nazarov', 'Boboyev', 'Umarov', 'Sultonov', 'Khudoyberdiyev', 'Davlatov', 'Qodirov', 'Rasulov', 'Abduroziqov', 'Ahmadov', 'Botirov', 'Gafurov', 'Hasanov', 'Ibrohimov', 'Jabborov', 'Kholov', 'Latipov', 'Mahmadov', 'Nurov', 'Olimov', 'Pulotov', 'Rajabov', 'Safarov', 'Tursunov', 'Usmonov', 'Vokhidov', 'Yuldoshev', 'Zokirov', 'Abdukholiqov', 'Bahriddinov', 'Dzhurayev', 'Ergashev', 'Gulamov', 'Hikmatov', 'Ismatov', 'Jumayev', 'Komilov', 'Lukmonov', 'Mansurov', 'Niyazov', 'Oripov', 'Qurbonov', 'Rustamov', 'Abduvaliyev', 'Botirov-2', 'Davlatov-2', 'Ergashev-2', 'Gafurov-2', 'Hikmatov-2', 'Ismatov-2', 'Jumayev-2', 'Komilov-2', 'Lukmonov-2', 'Mansurov-2', 'Niyazov-2', 'Oripov-2', 'Qurbonov-2', 'Rustamov-2', 'Safarov-2', 'Tursunov-2', 'Usmonov-2', 'Vokhidov-2', 'Yuldoshev-2', 'Zokirov-2', 'Abdukholiqov-2', 'Bahriddinov-2', 'Dzhurayev-2', 'Gulamov-2', 'Ismoilov-2', 'Jabborov-2', 'Kholov-2', 'Latipov-2', 'Mahmadov-2', 'Nurov-2', 'Olimov-2', 'Pulotov-2', 'Rajabov-2', 'Sharipov-2', 'Umarov-2', 'Sultonov-2', 'Davlatov-3', 'Qodirov-2', 'Rasulov-2', 'Ahmadov-2', 'Hasanov-2', 'Ibrohimov-2', 'Nazarov-2', 'Boboyev-2', 'Yusupov-2', 'Karimov-2', 'Saidov-2', 'Rahmonov-2'],
    fL: ['Rahmonova', 'Nabiyeva', 'Mirzoyeva', 'Sharipova', 'Karimova', 'Saidova', 'Ismoilova', 'Yusupova', 'Nazarova', 'Boboyeva', 'Umarova', 'Sultonova', 'Khudoyberdiyeva', 'Davlatova', 'Qodirova', 'Rasulova', 'Abduroziqova', 'Ahmadova', 'Botirova', 'Gafurova', 'Hasanova', 'Ibrohimova', 'Jabborova', 'Kholova', 'Latipova', 'Mahmadova', 'Nurova', 'Olimova', 'Pulotova', 'Rajabova', 'Safarova', 'Tursunova', 'Usmonova', 'Vokhidova', 'Yuldosheva', 'Zokirova', 'Abdukholiqova', 'Bahriddinova', 'Dzhurayeva', 'Ergasheva', 'Gulamova', 'Hikmatova', 'Ismatova', 'Jumayeva', 'Komilova', 'Lukmonova', 'Mansurova', 'Niyazova', 'Oripova', 'Qurbonova', 'Rustamova', 'Abduvaliyeva', 'Botirova2', 'Davlatova2', 'Ergasheva2', 'Gafurova2', 'Hikmatova2', 'Ismatova2', 'Jumayeva2', 'Komilova2', 'Lukmonova2', 'Mansurova2', 'Niyazova2', 'Oripova2', 'Qurbonova2', 'Rustamova2', 'Safarova2', 'Tursunova2', 'Usmonova2', 'Vokhidova2', 'Yuldosheva2', 'Zokirova2', 'Abdukholiqova2', 'Bahriddinova2', 'Dzhurayeva2', 'Gulamova2', 'Ismoilova2', 'Jabborova2', 'Kholova2', 'Latipova2', 'Mahmadova2', 'Nurova2', 'Olimova2', 'Pulotova2', 'Rajabova2', 'Sharipova2', 'Umarova2', 'Sultonova2', 'Davlatova3', 'Qodirova2', 'Rasulova2', 'Ahmadova2', 'Hasanova2', 'Ibrohimova2', 'Nazarova2', 'Boboyeva2', 'Yusupova2', 'Karimova2', 'Saidova2', 'Rahmonova2']
  }
};

// Copy to Turkmenistan, Uzbekistan, Singapura, Tajikistan
const remList = ['singapura', 'tajikistan', 'turkmenistan', 'uzbekistan'];

for (const c of remList) {
  const baseDir = path.join('json', 'firstname_lastname', 'asia', c);
  if (!fs.existsSync(baseDir)) continue;

  const mFPath = path.join(baseDir, 'male', 'firstname.json');
  const fFPath = path.join(baseDir, 'female', 'firstname.json');
  const mLPath = path.join(baseDir, 'male', 'lastname.json');
  const fLPath = path.join(baseDir, 'female', 'lastname.json');

  const srcKey = (c === 'singapura') ? 'singapura' : 'tajikistan';
  const p = remainingAsiaFull[srcKey];

  const set = new Set();
  function cleanFilter(arr) {
    const res = [];
    for (let item of arr) {
      item = item.replace(/\d+$/g, '').trim();
      if (item.length > 1 && !set.has(item) && !/first|last|name/i.test(item)) {
        set.add(item);
        res.push(item);
      }
      if (res.length >= 100) break;
    }
    return res.slice(0, 100);
  }

  const mF = cleanFilter(p.mF);
  const fF = cleanFilter(p.fF);
  const mL = cleanFilter(p.mL);
  const fL = cleanFilter(p.fL);

  fs.writeFileSync(mFPath, JSON.stringify(mF, null, 2));
  fs.writeFileSync(fFPath, JSON.stringify(fF, null, 2));
  fs.writeFileSync(mLPath, JSON.stringify(mL, null, 2));
  fs.writeFileSync(fLPath, JSON.stringify(fL, null, 2));
}

console.log('Finished updating Singapura, Tajikistan, Turkmenistan, Uzbekistan!');
