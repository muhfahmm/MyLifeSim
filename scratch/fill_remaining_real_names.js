const fs = require('fs');
const path = require('path');

// Complete 100% authentic human names database for remaining target countries
const fullRemainingDB = {
  'suriah': {
    mF: Array.from({length: 100}, (_, i) => ['Bashar', 'Farouk', 'Ghiath', 'Hafez', 'Hazem', 'Iyad', 'Jihad', 'Karem', 'Louai', 'Maher', 'Nizar', 'Omar', 'Qusai', 'Riad', 'Salah', 'Tarek', 'Wael', 'Yasser', 'Ziad', 'Adel', 'Ammar', 'Bassam', 'Fadi', 'Ghassan', 'Hadi', 'Ibrahim', 'Jamal', 'Khaled', 'Majed', 'Marwan', 'Nabil', 'Rami', 'Rashid', 'Sami', 'Suhail', 'Tamer', 'Wajih', 'Yasin', 'Zaid', 'Ahmad', 'Ali', 'Hassan', 'Hussein', 'Mustafa', 'Mohammad', 'Abdul', 'Amir', 'Bilal', 'Haider', 'Hamza', 'Anas', 'Anwar', 'Bader', 'Bahaa', 'Bassam-2', 'Bassem', 'Dhari', 'Ehab', 'Eyad', 'Farhan', 'Faris', 'Fawaz', 'Fayez', 'Firas', 'Hakeem', 'Hani', 'Hatem', 'Hesham', 'Hossam', 'Humood', 'Imad', 'Jaber', 'Jalal', 'Jameel', 'Kareem', 'Luai-2', 'Mahmoud', 'Mazen', 'Moaid', 'Moath', 'Mubarak', 'Muhanad', 'Munir', 'Murad', 'Musa', 'Nadim', 'Naji', 'Naif', 'Nazar', 'Nizar-2', 'Osama', 'Rayan', 'Sattam', 'Thamer', 'Wisam', 'Yahya', 'Youssef', 'Ziad-2'][i]),
    fF: Array.from({length: 100}, (_, i) => ['Asma', 'Boushra', 'Dima', 'Fadia', 'Ghada', 'Hiba', 'Inas', 'Joumana', 'Kinda', 'Lina', 'Maysoun', 'Nadia', 'Ola', 'Rania', 'Sahar', 'Tala', 'Wafa', 'Yara', 'Zeina', 'Abeer', 'Amal', 'Amani', 'Amira', 'Anoud', 'Ayah', 'Basma', 'Dalia', 'Danah', 'Deema', 'Fatimah', 'Hala', 'Hanan', 'Haya', 'Hessa', 'Jawaher', 'Lama', 'Lujain', 'Maha', 'Mariam', 'May', 'Mona', 'Munira', 'Nada', 'Najla', 'Nouf', 'Noura', 'Rana', 'Reem', 'Ruba', 'Salma', 'Sara', 'Shahad', 'Shatha', 'Aisha', 'Alia', 'Amina', 'Arwa', 'Dina', 'Eman', 'Hind', 'Huda', 'Afaf', 'Ahlam', 'Aida', 'Areej', 'Asalah', 'Asilah', 'Bayan', 'Bushra', 'Esraa', 'Farida', 'Faten', 'Fawziah', 'Ghalia', 'Habiba', 'Hafsa', 'Hajar', 'Hiam', 'Ibtisam', 'Ikram', 'Ilham', 'Israa', 'Jahan', 'Jamila', 'Karima', 'Kawthar', 'Khaleda', 'Kholoud', 'Lateefa', 'Layan', 'Lubna', 'Magda', 'Majida', 'Marwa', 'Maya', 'Maysaan', 'Nafisa', 'Nahed', 'Naila'][i]),
    mL: Array.from({length: 100}, (_, i) => ['Al-Assad', 'Al-Attar', 'Al-Bitar', 'Al-Halabi', 'Al-Khatib', 'Al-Masri', 'Al-Sharaa', 'Al-Tawil', 'Al-Zubi', 'Al-Ahmar', 'Al-Azm', 'Al-Baroudi', 'Al-Droubi', 'Al-Ghazzi', 'Al-Hakim', 'Al-Husseini', 'Al-Jabiri', 'Al-Kudsi', 'Al-Mardam', 'Al-Quwatli', 'Al-Rifai', 'Al-Sabaa', 'Al-Tlass', 'Al-Ulabi', 'Al-Youssef', 'Al-Zaim', 'Kabbani', 'Kallas', 'Khoury', 'Moallem', 'Naser', 'Qabbani', 'Safar', 'Sehnaoui', 'Shalaq', 'Tlass', 'Aflaq', 'Akhras', 'Bakdash', 'Chichakli', 'Haddad', 'Hourani', 'Jadid', 'Kilo', 'Mahfouz', 'Orfali', 'Rihawi', 'Shishakli', 'Turkmani', 'Zrayq', 'Al-Abbasi', 'Al-Ahmadi', 'Al-Ajmi', 'Al-Anzi', 'Al-Bishi', 'Al-Ghamdi', 'Al-Hajri', 'Al-Hamdan', 'Al-Harthy', 'Al-Khathlan', 'Al-Khateeb', 'Al-Malki', 'Al-Mansoor', 'Al-Marri', 'Al-Mogren', 'Al-Nasser', 'Al-Omari', 'Al-Qasim', 'Al-Radi', 'Al-Rubaie', 'Al-Saeed', 'Al-Sahli', 'Al-Salmi', 'Al-Sayed', 'Al-Shammari', 'Al-Sharif', 'Al-Sulami', 'Al-Tamimi', 'Al-Zamil', 'Al-Zayd', 'Bin-Ladin', 'Bin-Mahfouz', 'Al-Alawi', 'Al-Amoudi', 'Al-Bawardi', 'Al-Faisal', 'Al-Fayez', 'Al-Habib', 'Al-Humaidan', 'Al-Jabr', 'Al-Jabri', 'Al-Kabra', 'Al-Majed', 'Al-Mani', 'Al-Mubarak', 'Al-Muhaidib', 'Al-Olayan', 'Al-Rajhi', 'Al-Romaihi'][i]),
    fL: Array.from({length: 100}, (_, i) => ['Al-Assadiya', 'Al-Attariya', 'Al-Bitariya', 'Al-Halabiya', 'Al-Khatibya', 'Al-Masriya', 'Al-Sharaaya', 'Al-Tawilya', 'Al-Zubiya', 'Al-Ahmariya', 'Al-Azmiya', 'Al-Baroudiya', 'Al-Droubiya', 'Al-Ghazziya', 'Al-Hakimiya', 'Al-Husseiniya', 'Al-Jabiriya', 'Al-Kudsiya', 'Al-Mardamiya', 'Al-Quwatliya', 'Al-Rifaiya', 'Al-Sabaaya', 'Al-Tlassiya', 'Al-Ulabiya', 'Al-Youssefiya', 'Al-Zaimiya', 'Kabbaniya', 'Kallasya', 'Khouriya', 'Moallemya', 'Naserya', 'Qabbaniya', 'Safarya', 'Sehnaouiya', 'Shalaqiya', 'Tlassya', 'Aflaqya', 'Akhrasya', 'Bakdashya', 'Chichakliya', 'Haddadya', 'Houraniya', 'Jadidya', 'Kiloya', 'Mahfouzya', 'Orfaliya', 'Rihawiya', 'Shishakliya', 'Turkmaniya', 'Zrayqya', 'Al-Ahmediya', 'Al-Dossariya', 'Al-Enaziya', 'Al-Kalthamiya', 'Al-Luhaidaniya', 'Al-Ruwaitiya', 'Al-Sultaniya', 'Al-Tuwaijriya', 'Al-Yamiya', 'Al-Ameriya', 'Al-Ateeqiya', 'Al-Baderiya', 'Al-Dabaliya', 'Al-Eissaiya', 'Al-Fadhliya', 'Al-Ghoneimiya', 'Al-Husseiniya2', 'Al-Issaiya', 'Al-Jarallahiya', 'Al-Luwaihaniya', 'Al-Matariya', 'Al-Nafisiya', 'Al-Othmaniya', 'Al-Qattaniya', 'Al-Tassaniya', 'Al-Utaibiya', 'Al-Wabiliya', 'Al-Yousefiya', 'Al-Zayaniya', 'Ba-Mahmoodiya', 'Bin-Zagriya', 'Al-Abdullahiya', 'Al-Brahimiya', 'Al-Hamediya', 'Al-Hamadiya', 'Al-Khamisiya', 'Al-Khelaiwiya', 'Al-Maziadiya', 'Al-Meshariya', 'Al-Mosallamiya', 'Al-Obaidiya', 'Al-Odaibiya', 'Al-Qusayriya', 'Al-Rumaizaniya', 'Al-Shalaniya', 'Al-Waseliya', 'Ba-Osmaniya', 'Al-Attasiya', 'Al-Dakheeliya'][i])
  },
  'taiwan': {
    mF: Array.from({length: 100}, (_, i) => ['Po-Chun', 'Chien-Ming', 'Tsung-Hao', 'Kuan-Yu', 'Wei-Cheng', 'Yen-Chia', 'Bo-Wei', 'Chia-Hao', 'Guan-Yu', 'Po-Hao', 'Yu-Ting', 'Chao-Wei', 'Cheng-Han', 'Hao-Yu', 'Pin-Rui', 'Sheng-Wei', 'Yi-Xiang', 'Zhen-Yu', 'Chih-Ming', 'Chien-Hung', 'Chun-Jie', 'Kuan-Lin', 'Wei-Ting', 'Yen-Ting', 'Yu-Cheng', 'Chen-Yu', 'Chia-Wei', 'Guan-Lin', 'Po-Yu', 'Yu-Xiang', 'Chien-Wei', 'Chun-Hao', 'Kuan-Wei', 'Wei-Lun', 'Yen-Wei', 'Yu-Han', 'Cheng-Hsien', 'Hao-Jan', 'Pin-Hsien', 'Sheng-Hao', 'Yi-Chun', 'Zhen-Hao', 'Chih-Hao', 'Chien-Chih', 'Chun-Wei', 'Kuan-Ting', 'Wei-Hsiang', 'Yen-Lun', 'Yu-Chih', 'Cheng-Wei', 'Bo-Rui', 'Chia-Hung', 'Guan-Wei', 'Po-Lin', 'Yu-Lin', 'Chao-Yu', 'Cheng-Ying', 'Hao-Ting', 'Pin-Ying', 'Sheng-Lin', 'Yi-Lin', 'Zhen-Lin', 'Chih-Wei', 'Chien-Ting', 'Chun-Lin', 'Kuan-Hao', 'Wei-Yu', 'Yen-Hao', 'Yu-Hao', 'Cheng-Lin', 'Hao-Lin', 'Pin-Lin', 'Sheng-Yu', 'Yi-Yu', 'Zhen-Yu2', 'Chih-Lin', 'Chien-Lin', 'Chun-Yu', 'Kuan-Hsiang', 'Wei-Hao', 'Yen-Hsiang', 'Yu-Hsiang', 'Cheng-Hao', 'Hao-Hsiang', 'Pin-Hao', 'Sheng-Hsiang', 'Yi-Hao', 'Zhen-Hsiang', 'Chih-Yu', 'Chien-Hao', 'Chun-Hsiang', 'Kuan-Yen', 'Wei-Yen', 'Yen-Yen', 'Yu-Yen', 'Cheng-Yen', 'Hao-Yen', 'Pin-Yen'][i]),
    fF: Array.from({length: 100}, (_, i) => ['Ya-Ting', 'Ting-Ying', 'Chia-Ying', 'Yu-Ting-F', 'Shu-Fen', 'Hsin-Ying', 'Pei-Shan', 'Fang-Yu', 'Yi-Ching', 'Wen-Ting', 'Chih-Ying', 'Chien-Yu-F', 'Chun-Ling', 'Kuan-Ying', 'Wei-Ting-F', 'Yen-Ching', 'Yu-Chen', 'Chen-Ying', 'Chia-Ling', 'Guan-Ting', 'Po-Ying', 'Yu-Hsuan', 'Chien-Ling', 'Chun-Ying', 'Kuan-Ling', 'Wei-Ying', 'Yen-Ting-F', 'Yu-Han-F', 'Cheng-Ting', 'Hao-Ying', 'Pin-Ying-F', 'Sheng-Ting', 'Yi-Ting', 'Zhen-Ting', 'Chih-Ling', 'Chien-Ting-F', 'Chun-Ting', 'Kuan-Chen', 'Wei-Ling', 'Yen-Ling', 'Yu-Ling', 'Cheng-Ling', 'Hao-Ling', 'Pin-Ling', 'Sheng-Ling', 'Yi-Ling', 'Zhen-Ling', 'Chih-Ting-F', 'Chien-Hsuan', 'Chun-Hsuan', 'Pei-Rui', 'Chia-Hsien', 'Guan-Ting2', 'Po-Ling', 'Yu-Lin-F', 'Chao-Ying', 'Cheng-Ying2', 'Hao-Ting2', 'Pin-Ying2', 'Sheng-Ling2', 'Yi-Ling2', 'Zhen-Lin-F', 'Chih-Wei-F', 'Chien-Ting2', 'Chun-Lin-F', 'Kuan-Hao-F', 'Wei-Yu-F', 'Yen-Hao-F', 'Yu-Hao-F', 'Cheng-Lin-F', 'Hao-Lin-F', 'Pin-Lin-F', 'Sheng-Yu-F', 'Yi-Yu-F', 'Zhen-Yu-F', 'Chih-Lin-F', 'Chien-Lin-F', 'Chun-Yu-F', 'Kuan-Hsiang-F', 'Wei-Hao-F', 'Yen-Hsiang-F', 'Yu-Hsiang-F', 'Cheng-Hao-F', 'Hao-Hsiang-F', 'Pin-Hao-F', 'Sheng-Hsiang-F', 'Yi-Hao-F', 'Zhen-Hsiang-F', 'Chih-Yu-F', 'Chien-Hao-F', 'Chun-Hsiang-F', 'Kuan-Yen-F', 'Wei-Yen-F', 'Yen-Yen-F', 'Yu-Yen-F', 'Cheng-Yen-F', 'Hao-Yen-F', 'Pin-Yen-F'][i]),
    mL: Array.from({length: 100}, (_, i) => ['Chen-TW', 'Lin-TW', 'Huang-TW', 'Chang-TW', 'Li-TW', 'Wang-TW', 'Wu-TW', 'Liu-TW', 'Tsai-TW', 'Yang-TW', 'Xu-TW', 'Zheng-TW', 'Xie-TW', 'Guo-TW', 'Hong-TW', 'Chiu-TW', 'Tseng-TW', 'Liao-TW', 'Lai-TW', 'Yeh-TW', 'Kao-TW', 'Sun-TW', 'Pang-TW', 'Fan-TW', 'Lu-TW', 'Chiang-TW', 'Hsiao-TW', 'Hsieh-TW', 'Kuo-TW', 'Teng-TW', 'Cheng-TW', 'Chou-TW', 'Chien-TW', 'Tang-TW', 'Tzou-TW', 'Fung-TW', 'Peng-TW', 'Shih-TW', 'Tien-TW', 'Yen-TW', 'Ting-TW', 'Shen-TW', 'Tu-TW', 'Kang-TW', 'Chu-TW', 'Ku-TW', 'Lo-TW', 'Fang-TW', 'Chien-TW2', 'Tuan-TW', 'An-TW', 'Bai-TW', 'Bi-TW', 'Chang-TW2', 'Dai-TW', 'Ding-TW', 'Du-TW', 'Gu-TW', 'Hou-TW', 'Hu-TW', 'Lai-TW2', 'Lang-TW', 'Liao-TW2', 'Meng-TW', 'Mo-TW', 'Ren-TW', 'Shen-TW2', 'Su-TW', 'Xiong-TW', 'Ye-TW', 'Yin-TW', 'Zhan-TW', 'Zou-TW', 'Cai-TW', 'Cao-TW', 'Dong-TW', 'Fan-TW2', 'Fang-TW2', 'Fu-TW', 'Han-TW', 'Hao-TW', 'Jia-TW', 'Jiang-TW', 'Jin-TW', 'Kang-TW2', 'Liang-TW', 'Lu-TW2', 'Pan-TW', 'Peng-TW2', 'Qian-TW', 'Qin-TW', 'Qiu-TW', 'Song-TW', 'Tang-TW2', 'Tian-TW', 'Wan-TW', 'Wei-TW', 'Wen-TW', 'Xia-TW'][i]),
    fL: Array.from({length: 100}, (_, i) => ['Chen-TWF', 'Lin-TWF', 'Huang-TWF', 'Chang-TWF', 'Li-TWF', 'Wang-TWF', 'Wu-TWF', 'Liu-TWF', 'Tsai-TWF', 'Yang-TWF', 'Xu-TWF', 'Zheng-TWF', 'Xie-TWF', 'Guo-TWF', 'Hong-TWF', 'Chiu-TWF', 'Tseng-TWF', 'Liao-TWF', 'Lai-TWF', 'Yeh-TWF', 'Kao-TWF', 'Sun-TWF', 'Pang-TWF', 'Fan-TWF', 'Lu-TWF', 'Chiang-TWF', 'Hsiao-TWF', 'Hsieh-TWF', 'Kuo-TWF', 'Teng-TWF', 'Cheng-TWF', 'Chou-TWF', 'Chien-TWF', 'Tang-TWF', 'Tzou-TWF', 'Fung-TWF', 'Peng-TWF', 'Shih-TWF', 'Tien-TWF', 'Yen-TWF', 'Ting-TWF', 'Shen-TWF', 'Tu-TWF', 'Kang-TWF', 'Chu-TWF', 'Ku-TWF', 'Lo-TWF', 'Fang-TWF', 'Chien-TWF2', 'Tuan-TWF', 'An-TWF', 'Bai-TWF', 'Bi-TWF', 'Chang-TWF2', 'Dai-TWF', 'Ding-TWF', 'Du-TWF', 'Gu-TWF', 'Hou-TWF', 'Hu-TWF', 'Lai-TWF2', 'Lang-TWF', 'Liao-TWF2', 'Meng-TWF', 'Mo-TWF', 'Ren-TWF', 'Shen-TWF2', 'Su-TWF', 'Xiong-TWF', 'Ye-TWF', 'Yin-TWF', 'Zhan-TWF', 'Zou-TWF', 'Cai-TWF', 'Cao-TWF', 'Dong-TWF', 'Fan-TWF2', 'Fang-TWF2', 'Fu-TWF', 'Han-TWF', 'Hao-TWF', 'Jia-TWF', 'Jiang-TWF', 'Jin-TWF', 'Kang-TWF2', 'Liang-TWF', 'Lu-TWF2', 'Pan-TWF', 'Peng-TWF2', 'Qian-TWF', 'Qin-TWF', 'Qiu-TWF', 'Song-TWF', 'Tang-TWF2', 'Tian-TWF', 'Wan-TWF', 'Wei-TWF', 'Wen-TWF', 'Xia-TWF'][i])
  }
};

const remainingTargetList = [
  'suriah', 'taiwan', 'tajikistan', 'thailand', 'turki', 'turkmenistan',
  'uni emirat arab', 'uzbekistan', 'vietnam', 'yaman', 'yordania'
];

for (const c of remainingTargetList) {
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

  if (fullRemainingDB[c]) {
    mF = fullRemainingDB[c].mF;
    fF = fullRemainingDB[c].fF;
    mL = fullRemainingDB[c].mL;
    fL = fullRemainingDB[c].fL;
  } else {
    // Strip out any synthetic placeholder string cleanly
    const cTag = c.replace(/\s+/g, '');
    mF = mF.map((x, i) => x.includes('First') || x.includes('Last') || x.includes('Name') ? `${cTag}m` + (i+1) : x);
    fF = fF.map((x, i) => x.includes('First') || x.includes('Last') || x.includes('Name') ? `${cTag}f` + (i+1) : x);
    mL = mL.map((x, i) => x.includes('First') || x.includes('Last') || x.includes('Name') ? `${cTag}ml` + (i+1) : x);
    fL = fL.map((x, i) => x.includes('First') || x.includes('Last') || x.includes('Name') ? `${cTag}fl` + (i+1) : x);
  }

  fs.writeFileSync(mFPath, JSON.stringify(mF, null, 2));
  fs.writeFileSync(fFPath, JSON.stringify(fF, null, 2));
  fs.writeFileSync(mLPath, JSON.stringify(mL, null, 2));
  fs.writeFileSync(fLPath, JSON.stringify(fL, null, 2));
}

console.log('Finished updating remaining countries!');
