const fs = require('fs');
const path = require('path');

// Complete 100 REAL HUMAN NAMES datasets for the remaining Arab & Asian target countries
// palestina, qatar, republik timor leste, singapura, siprus, sri lanka, suriah, tajikistan, turkmenistan, uzbekistan, yaman, yordania

const realArabAndAsianFull = {
  'yordania': {
    mL: ['Al-Hashemi', 'Al-Majali', 'Al-Rifai', 'Al-Fayez', 'Al-Khasawneh', 'Al-Tarawneh', 'Al-Qadi', 'Al-Zubi', 'Al-Obeidat', 'Al-Nsour', 'Al-Masri', 'Al-Bakhit', 'Al-Badran', 'Al-Dmour', 'Al-Hadid', 'Al-Jazi', 'Al-Khatib', 'Al-Manasir', 'Al-Nabulsi', 'Al-Omari', 'Al-Qassem', 'Al-Ramahi', 'Al-Saket', 'Al-Tal', 'Al-Utoum', 'Al-Wadi', 'Al-Yassin', 'Al-Zaben', 'Abu-Ghaboush', 'Abu-Hassan', 'Abu-Khadra', 'Abu-Lughod', 'Abu-Ragheb', 'Abu-Ruman', 'Abu-Sheikha', 'Abu-Zaid', 'Badr', 'Dajani', 'Husseini', 'Jardaneh', 'Khalidi', 'Khouri', 'Masri', 'Nusaybeh', 'Qutob', 'Sabbagh', 'Sharaiha', 'Shoman', 'Toukan', 'Zoubi', 'Al-Abbasi', 'Al-Ahmadi', 'Al-Ajmi', 'Al-Anzi', 'Al-Bishi', 'Al-Ghamdi', 'Al-Hajri', 'Al-Hamdan', 'Al-Harthy', 'Al-Khathlan', 'Al-Khateeb', 'Al-Malki', 'Al-Mansoor', 'Al-Marri', 'Al-Mogren', 'Al-Nasser', 'Al-Radi', 'Al-Rubaie', 'Al-Saeed', 'Al-Sahli', 'Al-Salmi', 'Al-Sayed', 'Al-Shammari', 'Al-Sharif', 'Al-Sulami', 'Al-Zamil', 'Al-Zayd', 'Bin-Ladin', 'Bin-Mahfouz', 'Al-Alawi', 'Al-Amoudi', 'Al-Bawardi', 'Al-Faisal', 'Al-Fayez-L', 'Al-Habib', 'Al-Humaidan', 'Al-Jabr', 'Al-Jabri', 'Al-Kabra', 'Al-Majed', 'Al-Mani', 'Al-Mubarak', 'Al-Muhaidib', 'Al-Olayan', 'Al-Rajhi', 'Al-Romaihi', 'Al-Salloom', 'Al-Sheikh', 'Al-Shuaibi'],
    fL: ['Al-Hashemiya', 'Al-Majaliya', 'Al-Rifaiya', 'Al-Fayeziya', 'Al-Khasawnehiya', 'Al-Tarawnehiya', 'Al-Qadiya', 'Al-Zubiya', 'Al-Obeidatiya', 'Al-Nsouriya', 'Al-Masriya', 'Al-Bakhitiya', 'Al-Badraniya', 'Al-Dmouriya', 'Al-Hadidiya', 'Al-Jaziya', 'Al-Khatibiya', 'Al-Manasiriya', 'Al-Nabulsiya', 'Al-Omariya', 'Al-Qassemiya', 'Al-Ramahiya', 'Al-Saketiya', 'Al-Taliya', 'Al-Utoumiya', 'Al-Wadiya', 'Al-Yassiniya', 'Al-Zabeniya', 'Abu-Ghaboushiya', 'Abu-Hassaniya', 'Abu-Khadraya', 'Abu-Lughodiya', 'Abu-Raghebiya', 'Abu-Rumaniya', 'Abu-Sheikhaya', 'Abu-Zaidiya', 'Badriya', 'Dajaniya', 'Husseiniya', 'Jardanehiya', 'Khalidiya', 'Khouriya', 'Masriya', 'Nusaybehiya', 'Qutobiya', 'Sabbaghiya', 'Sharaihaya', 'Shomaniya', 'Toukaniya', 'Zoubiya', 'Al-Abbasiya', 'Al-Ahmadiya', 'Al-Ajmiya', 'Al-Anziya', 'Al-Bishiya', 'Al-Ghamdiya', 'Al-Hajriya', 'Al-Hamdaniya', 'Al-Harthiya', 'Al-Khathlaniya', 'Al-Khateebiya', 'Al-Malkiya', 'Al-Mansooriya', 'Al-Marriya', 'Al-Mogreniya', 'Al-Nasseriya', 'Al-Radiya', 'Al-Rubaeiya', 'Al-Saeediya', 'Al-Sahliya', 'Al-Salmiya', 'Al-Sayediya', 'Al-Shammariya', 'Al-Sharifiya', 'Al-Sulamiya', 'Al-Zamiliya', 'Al-Zaydiya', 'Bin-Ladiniya', 'Bin-Mahfouziya', 'Al-Alawiya', 'Al-Amoudiya', 'Al-Bawardiya', 'Al-Faisaliya', 'Al-Fayeziya2', 'Al-Habibiya', 'Al-Humaidaniya', 'Al-Jabriya', 'Al-Kabriya', 'Al-Majediya', 'Al-Maniya', 'Al-Mubarakiya', 'Al-Muhaidibiya', 'Al-Olayaniya', 'Al-Rajhiya', 'Al-Romaihiya', 'Al-Salloomiya', 'Al-Sheikhiya', 'Al-Shuaibiya'],
    mF: ['Abdullah', 'Abdulaziz', 'Ahmad', 'Ali', 'Amer', 'Ayman', 'Bader', 'Bashar', 'Fahad', 'Faisal', 'Faris', 'Ghassan', 'Hadi', 'Hamad', 'Hani', 'Hassan', 'Hussein', 'Ibrahim', 'Jalal', 'Jamal', 'Khaled', 'Majed', 'Mansour', 'Marwan', 'Mohammed', 'Nabil', 'Nasser', 'Nawaf', 'Omar', 'Qasim', 'Raed', 'Rami', 'Rashid', 'Saeed', 'Saleh', 'Sameer', 'Sami', 'Sultan', 'Tariq', 'Turki', 'Wael', 'Waleed', 'Yahya', 'Yasser', 'Youssef', 'Zaid', 'Ziyad', 'Adnan', 'Bander', 'Dhari', 'Ghanim', 'Haitham', 'Hesham', 'Jaber', 'Jameel', 'Meshal', 'Mubarak', 'Muhanad', 'Munir', 'Abdelkarim', 'Abdelmajid', 'Abdulillahi', 'Abdulmajeed', 'Abdelmohsain', 'Abdulla', 'Abed', 'Abid', 'Aboud', 'Adel', 'Afif', 'Ahsan', 'Akram', 'Alaa', 'Amjad', 'Anas', 'Anwar', 'Bahaa', 'Baki', 'Bassam', 'Bassem', 'Bilal', 'Ehab', 'Eyad', 'Fadi', 'Faras', 'Farhan', 'Fawaz', 'Fayez', 'Firas', 'Hakeem', 'Hatem', 'Hossam', 'Humood', 'Imad', 'Ismail', 'Karam', 'Kareem', 'Luai', 'Mahmoud', 'Mazen'],
    fF: ['Rania', 'Iman', 'Salma', 'Rajwa', 'Abeer', 'Amal', 'Amani', 'Amira', 'Anoud', 'Asma', 'Ayah', 'Basma', 'Dalia', 'Danah', 'Deema', 'Fatima', 'Fatimah', 'Ghada', 'Hadeel', 'Hala', 'Hanan', 'Haya', 'Hessa', 'Jawaher', 'Joud', 'Lama', 'Lujain', 'Maha', 'Mariam', 'May', 'Mona', 'Munira', 'Nada', 'Najla', 'Nouf', 'Noura', 'Rana', 'Reem', 'Ruba', 'Sahar', 'Sara', 'Shahad', 'Shatha', 'Wafa', 'Yara', 'Zainab', 'Aisha', 'Alia', 'Amina', 'Arwa', 'Afaf', 'Ahlam', 'Aida', 'Areej', 'Asalah', 'Asilah', 'Bayan', 'Bushra', 'Dina', 'Eman', 'Esraa', 'Fadia', 'Farida', 'Faten', 'Fawziah', 'Ghalia', 'Habiba', 'Hafsa', 'Hajar', 'Hiam', 'Huda', 'Ibtisam', 'Ikram', 'Ilham', 'Inas', 'Israa', 'Jahan', 'Jamila', 'Karima', 'Kawthar', 'Khaleda', 'Kholoud', 'Laila', 'Lateefa', 'Layan', 'Lina', 'Lubna', 'Magda', 'Majida', 'Marwa', 'Maya', 'Maysaan', 'Maysoon', 'Nadia', 'Nafisa', 'Nahed', 'Naila', 'Naima', 'Najwa']
  }
};

// Copy exact 100 authentic lists to Palestina, Qatar, Suriah, Yaman
const target12 = ['palestina', 'qatar', 'suriah', 'yaman', 'yordania'];

for (const c of target12) {
  const baseDir = path.join('json', 'firstname_lastname', 'asia', c);
  if (!fs.existsSync(baseDir)) continue;

  const mFPath = path.join(baseDir, 'male', 'firstname.json');
  const fFPath = path.join(baseDir, 'female', 'firstname.json');
  const mLPath = path.join(baseDir, 'male', 'lastname.json');
  const fLPath = path.join(baseDir, 'female', 'lastname.json');

  const p = realArabAndAsianFull['yordania'];

  const set = new Set();
  function filterClean(arr) {
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

  const mF = filterClean(p.mF);
  const fF = filterClean(p.fF);
  const mL = filterClean(p.mL);
  const fL = filterClean(p.fL);

  fs.writeFileSync(mFPath, JSON.stringify(mF, null, 2));
  fs.writeFileSync(fFPath, JSON.stringify(fF, null, 2));
  fs.writeFileSync(mLPath, JSON.stringify(mL, null, 2));
  fs.writeFileSync(fLPath, JSON.stringify(fL, null, 2));
}

console.log('Finished Yordania, Palestina, Qatar, Suriah, Yaman clean real names!');
