const fs = require('fs');
const path = require('path');

function makePool(primary, secondary) {
  const set = new Set(primary);
  for (const item of secondary) {
    if (set.size >= 100) break;
    if (!set.has(item)) set.add(item);
  }
  let extra = 1;
  while (set.size < 100) {
    set.add(primary[0] + 'Alt' + extra);
    extra++;
  }
  return Array.from(set).slice(0, 100);
}

// 1. AFGANISTAN
const afg = {
  mF: makePool(
    ['Ahmad', 'Ahmadullah', 'Aimal', 'Ali', 'Amanullah', 'Amir', 'Asadullah', 'Aziz', 'Bilal', 'Dawud', 'Eshan', 'Farhad', 'Farid', 'Habibullah', 'Hamid', 'Haroon', 'Hasib', 'Humayun', 'Ibrahim', 'Idris', 'Ikram', 'Inayat', 'Ismail', 'Jamil', 'Javid', 'Karim', 'Khalid', 'Mahmud', 'Mansoor', 'Massoud', 'Mirwais', 'Mohammad', 'Mustafa', 'Nabi', 'Nadir', 'Naim', 'Nasir', 'Noman', 'Omar', 'Qais', 'Rafi', 'Rahim', 'Rahmat', 'Rashid', 'Raza', 'Reza', 'Saeed', 'Sami', 'Sardar', 'Shafiq', 'Shah', 'Shahpur', 'Sharif', 'Suhail', 'Suleiman', 'Tariq', 'Wahid', 'Wali', 'Yaseen', 'Zabihullah', 'Zahir', 'Zia', 'Zubair', 'Zulmai'],
    ['Abasin', 'Ajmal', 'Akhtar', 'Alauddin', 'Aslam', 'Ataullah', 'Atiq', 'Baryalai', 'Bashir', 'Baz', 'Faiz', 'Fazal', 'Ghani', 'Gul', 'Hedayat', 'Hikmat', 'Jan', 'Kawa', 'Khushal', 'Khyber', 'Lal', 'Mir', 'Niamat', 'Obaid', 'Palwal', 'Qudrat', 'Rahmatullah', 'Rohullah', 'Saif', 'Sayed', 'Shahzaib', 'Sher', 'Sufyan', 'Wais', 'Wazir', 'Zamarai', 'Zarif', 'Abdul', 'Adil', 'Afzal', 'Agha', 'Ahsan', 'Anwar', 'Ashraf', 'Ayoub', 'Azam', 'Bahram', 'Baktash', 'Danish', 'Ehsanullah']
  ),
  fF: makePool(
    ['Afsona', 'Anahita', 'Arezo', 'Aria', 'Asila', 'Aziza', 'Bahora', 'Breshna', 'Fereshteh', 'Frohar', 'Frozan', 'Gazal', 'Helai', 'Homaira', 'Husna', 'Jamila', 'Khadija', 'Khujasta', 'Laili', 'Laila', 'Lima', 'Madina', 'Mahjabin', 'Malalai', 'Manizha', 'Mariam', 'Marwa', 'Meena', 'Mina', 'Muzhdah', 'Nadia', 'Naghma', 'Nargis', 'Nasrin', 'Nazia', 'Nilofar', 'Palwasha', 'Parwana', 'Rana', 'Roba', 'Robina', 'Rona', 'Roya', 'Sadaf', 'Sahar', 'Salma', 'Samira', 'Sanobar', 'Shabnam', 'Shafiqa', 'Shakeela', 'Shila', 'Shogofa', 'Sohaila', 'Soraya', 'Spogmai', 'Tahmina', 'Tamana', 'Wazhma', 'Yalda', 'Zabrina', 'Zainab', 'Zarghona', 'Zarlasht', 'Zeba', 'Zohra'],
    ['Aqila', 'Basira', 'Durkhani', 'Fahima', 'Farida', 'Farzana', 'Ghotai', 'Habiba', 'Kamila', 'Kawkab', 'Khojasta', 'Latifa', 'Mahira', 'Maimoona', 'Nabila', 'Naheed', 'Najiba', 'Parween', 'Rasia', 'Razia', 'Ruqiya', 'Sabira', 'Safia', 'Sajida', 'Sediqa', 'Shajai', 'Shukria', 'Simin', 'Sultana', 'Suraya', 'Wadooda', 'Zubaida', 'Atifa', 'Balkhis', 'Benafsha', 'Friba', 'Guita', 'Humaira', 'Khatira', 'Mahwash', 'Nelofer', 'Parvin', 'Rabab', 'Rokhshana', 'Safura', 'Sima', 'Taranah']
  ),
  mL: makePool(
    ['Ahmadi', 'Ahmadzai', 'Akbari', 'Alizai', 'Andar', 'Durrani', 'Ghanizada', 'Habibi', 'Haideri', 'Hassani', 'Ibrahimi', 'Jalali', 'Karimi', 'Kakar', 'Kazemi', 'Khattak', 'Kohistani', 'Lodi', 'Mansoor', 'Mohammadi', 'Mukhtar', 'Noorzai', 'Panjshiri', 'Popalzai', 'Qaderi', 'Rahimi', 'Rezai', 'Saadat', 'Sadat', 'Safi', 'Shinwari', 'Suleimankhil', 'Stanikzai', 'Tani', 'Tariq', 'Tarzi', 'Wardak', 'Yousafzai', 'Zadran', 'Zahirzai'],
    ['Babakarkhil', 'Barakzai', 'Daudzai', 'Ghilzai', 'Ishaqzai', 'Jabarkhil', 'Kakarzai', 'Kharoti', 'Mohmand', 'Niazi', 'Orakzai', 'Sadozai', 'Surkhrodi', 'Tarakai', 'Utmanzai', 'Wazir', 'Zazai', 'Afridi', 'Bangash', 'Jaji', 'Mangal', 'Safizai', 'Suleimani', 'Surani', 'Tajik', 'Taniwal', 'Zurmti', 'Badakhshi', 'Balkhi', 'Farahi', 'Ghori', 'Herawi', 'Kabul', 'Kandahari', 'Khosti', 'Kunar', 'Laghmani', 'Logari', 'Nangarhari', 'Paktia', 'Paktika', 'Parwani', 'Samangani', 'Takhari', 'Wardaki', 'Bamiani', 'Daikundi', 'Faryabi', 'Helmandi', 'Jowzjani', 'Kapisa', 'Kunduzi', 'Nimrouzi', 'Nurestani', 'Oruzgani', 'Samangan', 'Sar-e-Pol', 'Uruzgani', 'Zabuli', 'Achakzai', 'Alikozai', 'Atmar', 'Ayubi', 'Azizi', 'Bamyani', 'Farooqi', 'Ghani', 'Ghilji', 'Gulzar', 'Hakim', 'Hashimi', 'Inayatullah', 'Jabarkhel', 'Jami', 'Khaliq', 'Khamab', 'Lawang', 'Mahmoodi', 'Nabil', 'Niaz', 'Omar']
  ),
  fL: makePool(
    ['Abawi', 'Azimi', 'Barekzai', 'Hakimi', 'Husseini', 'Khademi', 'Khurram', 'Mahmoudi', 'Mirzaee', 'Naderi', 'Najafi', 'Nazari', 'Noori', 'Osmani', 'Qasemi', 'Rahmani', 'Rasa', 'Rostami', 'Saberi', 'Salehi', 'Samadi', 'Sarwari', 'Sayed', 'Shafiq', 'Sharifi', 'Siddiqui', 'Sultani', 'Taheri', 'Wakili', 'Wasifi', 'Yaqoobi', 'Yousufi', 'Zahir', 'Ziai'],
    ['Alkozai', 'Ansari', 'Ghafouri', 'Hashemi', 'Homayoun', 'Jamil', 'Kamali', 'Latifi', 'Majrooh', 'Naseer', 'Omarzai', 'Popal', 'Qayyumi', 'Rabbani', 'Sirat', 'Tawab', 'Wahidi', 'Younosi', 'Zmarai', 'Zewari', 'Ariaee', 'Baheer', 'Chakhansuri', 'Danish', 'Ehsan', 'Frozan', 'Habib', 'Ismat', 'Jawad', 'Lmar', 'Masood', 'Najeeb', 'Omaid', 'Paimani', 'Qadeer', 'Rashidi', 'Saba', 'Ulfat', 'Wadan', 'Yamani', 'Zarifi', 'Afzali', 'Bahrami', 'Faqiri', 'Ghafoori', 'Hamidi', 'Inayaty', 'Keshwari', 'Noor', 'Omeri', 'Pardis', 'Qadiri', 'Sidiqi', 'Tamannai', 'Wafa', 'Yousuf', 'Zaland', 'Amani', 'Batori', 'Dawar', 'Faik', 'Hikmati', 'Irfan', 'Jalaly', 'Khurrami', 'Luqman', 'Mustafawi', 'Nijrabi', 'Osman', 'Paghmani', 'Quraishi', 'Rigi', 'Sahil', 'Usmani', 'Wadood', 'Yari', 'Adib', 'Dadfar', 'Farahmand', 'Gharwal', 'Hatif', 'Ismati', 'Jahida', 'Lemar', 'Naser', 'Paikar', 'Qani', 'Razi', 'Taraki', 'Wesa', 'Yaftali', 'Zari']
  )
};

// 2. ARAB SAUDI
const sau = {
  mF: makePool(
    ['Abdullah', 'Abdulaziz', 'Abdulrahman', 'Adel', 'Ahmad', 'Ali', 'Alwaleed', 'Bandar', 'Fahd', 'Faisal', 'Hamad', 'Hassan', 'Hussain', 'Ibrahim', 'Khalid', 'Majed', 'Mansour', 'Meshal', 'Mohammed', 'Mohannad', 'Nasser', 'Nawaf', 'Omar', 'Rakan', 'Saad', 'Saud', 'Sultan', 'Tariq', 'Turki', 'Waleed', 'Yahya', 'Yasser', 'Youssef', 'Ziyad'],
    ['Abdelkarim', 'Abdelmajid', 'Abdulillahi', 'Abdulmajeed', 'Abdelmohsain', 'Abdulla', 'Abed', 'Abid', 'Aboud', 'Adnan', 'Afif', 'Ahsan', 'Akram', 'Alaa', 'Amjad', 'Anas', 'Anwar', 'Ayman', 'Bader', 'Bahaa', 'Baki', 'Bassam', 'Bassem', 'Bilal', 'Dhari', 'Ehab', 'Eyad', 'Fadi', 'Faras', 'Farhan', 'Faris', 'Fawaz', 'Fayez', 'Firas', 'Ghassan', 'Hadi', 'Haitham', 'Hakeem', 'Hani', 'Hatem', 'Hesham', 'Hossam', 'Humood', 'Hussein', 'Imad', 'Ismail', 'Iyad', 'Jaber', 'Jalal', 'Jamal', 'Jameel', 'Karam', 'Kareem', 'Khaled', 'Luai', 'Mahmoud', 'Marwan', 'Mazen', 'Moaid', 'Moath', 'Mubarak', 'Muhanad', 'Munir', 'Murad', 'Musa', 'Mustafa', 'Nabil', 'Nadim', 'Naji', 'Naif', 'Nazar', 'Nizar', 'Osama', 'Qasim', 'Raed', 'Rami', 'Rashid', 'Rayan', 'Riyad', 'Saeed', 'Saleh', 'Sameer', 'Sami', 'Sattam', 'Shadi', 'Sharif', 'Suhail', 'Sulaiman', 'Talal', 'Tamim', 'Tamer', 'Thamer', 'Wael', 'Wajdi', 'Wisam', 'Yasin', 'Zaid', 'Zuhair']
  ),
  fF: makePool(
    ['Abeer', 'Amal', 'Amani', 'Amira', 'Anoud', 'Asma', 'Ayah', 'Basma', 'Dalia', 'Danah', 'Deema', 'Fatimah', 'Ghada', 'Hadeel', 'Hala', 'Hanan', 'Haya', 'Hessa', 'Jawaher', 'Joud', 'Lama', 'Lujain', 'Maha', 'Malak', 'Manal', 'Mariam', 'May', 'Mona', 'Munira', 'Nada', 'Najla', 'Nouf', 'Noura', 'Rana', 'Rania', 'Reem', 'Ruba', 'Sahar', 'Salma', 'Sara', 'Shahad', 'Shatha', 'Wafa', 'Yara', 'Zainab'],
    ['Afaf', 'Ahlam', 'Aida', 'Aisha', 'Alia', 'Amina', 'Areej', 'Arwa', 'Asalah', 'Asilah', 'Atefeh', 'Bayan', 'Bushra', 'Dina', 'Eman', 'Esraa', 'Fadia', 'Farida', 'Faten', 'Fawziah', 'Ghalia', 'Habiba', 'Hafsa', 'Hajar', 'Hiam', 'Hind', 'Huda', 'Ibtisam', 'Ikram', 'Ilham', 'Inas', 'Israa', 'Jahan', 'Jamila', 'Karima', 'Kawthar', 'Khaleda', 'Kholoud', 'Laila', 'Lateefa', 'Layan', 'Lina', 'Lubna', 'Magda', 'Majida', 'Marwa', 'Maya', 'Maysaan', 'Maysoon', 'Nadia', 'Nafisa', 'Nahed', 'Naila', 'Naima', 'Najwa', 'Nermin', 'Nisreen', 'Noha', 'Nuha', 'Ola', 'Radwa', 'Raghda', 'Raja', 'Randa', 'Rasha', 'Rawan', 'Reeman', 'Riham', 'Rola', 'Roqaya', 'Sabreen', 'Safa', 'Safiyyah', 'Saja', 'Samar', 'Samira', 'Sana', 'Shadia', 'Shaikha', 'Shams', 'Siham', 'Somaya', 'Sora', 'Suhad', 'Suhair', 'Sumaya', 'Tahani', 'Tala', 'Taraf', 'Thuraiya', 'Wadad', 'Warda', 'Wijdane', 'Yasmin', 'Yousra', 'Zahra', 'Zeina']
  ),
  mL: makePool(
    ['Al-Amri', 'Al-Asmari', 'Al-Dawsari', 'Al-Ghamdi', 'Al-Harbi', 'Al-Hazmi', 'Al-Juhani', 'Al-Khtani', 'Al-Maliki', 'Al-Mutairi', 'Al-Otaibi', 'Al-Qahtani', 'Al-Qarni', 'Al-Rashid', 'Al-Saud', 'Al-Sayari', 'Al-Shahrani', 'Al-Shehri', 'Al-Subaie', 'Al-Zahrani'],
    ['Al-Abbasi', 'Al-Ahmadi', 'Al-Ajmi', 'Al-Anzi', 'Al-Bishi', 'Al-Ghamidi', 'Al-Hajri', 'Al-Hamdan', 'Al-Harthy', 'Al-Karni', 'Al-Khathlan', 'Al-Khateeb', 'Al-Malki', 'Al-Mansoor', 'Al-Marri', 'Al-Mogren', 'Al-Nasser', 'Al-Omari', 'Al-Qasim', 'Al-Radi', 'Al-Rubaie', 'Al-Saeed', 'Al-Sahli', 'Al-Saleh', 'Al-Salmi', 'Al-Sayed', 'Al-Shammari', 'Al-Sharif', 'Al-Sulami', 'Al-Tamimi', 'Al-Zamil', 'Al-Zayd', 'Bin-Ladin', 'Bin-Mahfouz', 'Al-Alawi', 'Al-Amoudi', 'Al-Bawardi', 'Al-Faisal', 'Al-Fayez', 'Al-Habib', 'Al-Humaidan', 'Al-Isa', 'Al-Jabr', 'Al-Jabri', 'Al-Kabra', 'Al-Majed', 'Al-Mani', 'Al-Mubarak', 'Al-Muhaidib', 'Al-Olayan', 'Al-Rajhi', 'Al-Romaihi', 'Al-Salloom', 'Al-Sheikh', 'Al-Shuaibi', 'Al-Subeaei', 'Al-Suwailem', 'Al-Torki', 'Al-Turki', 'Al-Yahya', 'Al-Zuhair', 'Ba-Naja', 'Bin-Saeed', 'Al-Akeel', 'Al-Ali', 'Al-Awwad', 'Al-Bassam', 'Al-Dahlawi', 'Al-Faris', 'Al-Homaizi', 'Al-Jarbou', 'Al-Kanhal', 'Al-Khudair', 'Al-Madani', 'Al-Matrouk', 'Al-Naim', 'Al-Qudaibi', 'Al-Rabiah', 'Al-Senaidy', 'Al-Thani', 'Al-Afaliq', 'Al-Arifi', 'Al-Baiz', 'Al-Duraibi', 'Al-Gosaibi', 'Al-Humaid', 'Al-Jadaan', 'Al-Jasser', 'Al-Kulaib', 'Al-Maghlouth', 'Al-Melhem', 'Al-Muqrin', 'Al-Qurashi', 'Al-Rashed', 'Al-Rabiee', 'Al-Saadoon', 'Al-Shalhoub', 'Al-Thunayan', 'Al-Zaid']
  ),
  fL: makePool(
    ['Al-Ahmedi', 'Al-Dossary', 'Al-Enazi', 'Al-Kaltham', 'Al-Luhaidan', 'Al-Ruwaiti', 'Al-Sultan', 'Al-Tuwaijri', 'Al-Yami'],
    ['Al-Amer', 'Al-Ateeq', 'Al-Bader', 'Al-Dabal', 'Al-Eissa', 'Al-Fadhli', 'Al-Ghoneim', 'Al-Husseini', 'Al-Issa', 'Al-Jarallah', 'Al-Luwaihan', 'Al-Matar', 'Al-Nafisi', 'Al-Othman', 'Al-Qattan', 'Al-Tassan', 'Al-Utaibi', 'Al-Wabil', 'Al-Yousef', 'Al-Zayani', 'Ba-Mahmood', 'Bin-Zagr', 'Al-Abdullah', 'Al-Brahim', 'Al-Hamed', 'Al-Hamad', 'Al-Khamis', 'Al-Khelaiwi', 'Al-Maziad', 'Al-Meshari', 'Al-Mosallam', 'Al-Obaid', 'Al-Odaib', 'Al-Qusayer', 'Al-Rumaizan', 'Al-Shalan', 'Al-Wasel', 'Ba-Osman', 'Al-Attas', 'Al-Dakheel', 'Al-Dukair', 'Al-Hokair', 'Al-Juffali', 'Al-Khereiji', 'Al-Maghraby', 'Al-Muhaideb', 'Al-Othaim', 'Al-Qosaibi', 'Al-Rushaid', 'Al-Sulaiman', 'Al-Tawil', 'Al-Zaidan', 'Bin-Zayed', 'Al-Ammar', 'Al-Bandar', 'Al-Dawish', 'Al-Fozan', 'Al-Hathloul', 'Al-Jeraisy', 'Al-Kharafi', 'Al-Misfer', 'Al-Mutlaq', 'Al-Otaishan', 'Al-Quraishi', 'Al-Rumaih', 'Al-Shathri', 'Al-Thinayan', 'Al-Zamilian', 'Ba-Haidar', 'Bin-Salim', 'Al-Arrayed', 'Al-Jomaih', 'Al-Mutawa', 'Al-Reshaid', 'Al-Alshaikh', 'Al-Fouzan', 'Al-Humaidhi', 'Al-Jalajel', 'Al-Khodari', 'Al-Moammar', 'Al-Nemer', 'Al-Quraish', 'Al-Rashedy', 'Al-Shaya', 'Al-Turbak', 'Al-Zubaidi', 'Al-Anazi', 'Al-Bwardi', 'Al-Furaih', 'Al-Ghaith', 'Al-Hadlaq', 'Al-Jedaie', 'Al-Khashan', 'Al-Mane', 'Al-Mulaifi']
  )
};

// 3. ARMENIA
const arm = {
  mF: makePool(
    ['Aram', 'Arman', 'Armen', 'Arsen', 'Artak', 'Artavazd', 'Artyom', 'Artur', 'Avet', 'Davit', 'Gagik', 'Garegin', 'Gevorg', 'Gor', 'Grigor', 'Hayk', 'Hovhannes', 'Karen', 'Levon', 'Manuk', 'Mikayel', 'Narek', 'Ruben', 'Samvel', 'Sargis', 'Shant', 'Tigran', 'Vahan', 'Vardan', 'Vazgen', 'Vgen'],
    ['Areg', 'Arshak', 'Artashes', 'Ashot', 'Avetik', 'Babken', 'Hakob', 'Hovsep', 'Hrahat', 'Hrayr', 'Jivan', 'Khosrov', 'Khachatur', 'Malkhas', 'Martiros', 'Mesrop', 'Mihran', 'Misak', 'Mkrtich', 'Mkhitar', 'Norayr', 'Paruyr', 'Raffi', 'Razmik', 'Sahak', 'Suren', 'Taron', 'Vahagn', 'Vahram', 'Vaspurak', 'Vrej', 'Yeghishe', 'Yervand', 'Zaven', 'Zohrab', 'Ara', 'Aramais', 'Arbak', 'Aris', 'Aristakes', 'Armenak', 'Arshavir', 'Artush', 'Arush', 'Arzt', 'Avag', 'Barsegh', 'Berdj', 'Derren', 'Garni', 'Gurgen', 'Gus', 'Hamazasp', 'Hmayak', 'Hovatan', 'Kajazn', 'Karekin', 'Kevork', 'Komitas', 'Koriun', 'Loris', 'Melkon', 'Movses', 'Nazar', 'Oshin', 'Pailak', 'Rupen', 'Sebuh', 'Shavarsh', 'Toros', 'Vatche', 'Voskan', 'Yura', 'Zorair']
  ),
  fF: makePool(
    ['Anahit', 'Anna', 'Anush', 'Arevik', 'Armine', 'Arpine', 'Astghik', 'Gayane', 'Hasmik', 'Karine', 'Lilit', 'Lousine', 'Mane', 'Mariam', 'Narine', 'Nelli', 'Satenik', 'Seda', 'Shushan', 'Sirush', 'Sofi', 'Tatevik', 'Varduhi', 'Zara'],
    ['Alisa', 'Aida', 'Angele', 'Anie', 'Antaram', 'Arda', 'Armenouhi', 'Arshaluys', 'Asht', 'Azatuhi', 'Bared', 'Bayzar', 'Berjouhi', 'Dzovinar', 'Elina', 'Gohar', 'Heghine', 'Hermine', 'Hripsime', 'Isabel', 'Kohar', 'Lousin', 'Margarit', 'Marits', 'Nairi', 'Nanar', 'Nane', 'Noyemi', 'Parandzem', 'Ruzanna', 'Sevan', 'Shoghakat', 'Siranush', 'Sirvard', 'Syuzanna', 'Takuhi', 'Tamar', 'Veronika', 'Voske', 'Yeghisabet', 'Zabel', 'Zvart', 'Almast', 'Amalia', 'Anjel', 'Arsin', 'Biayna', 'Flora', 'Knarik', 'Lili', 'Lusine', 'Manushak', 'Maral', 'Nare', 'Nazeli', 'Nvard', 'Prapion', 'Rubina', 'Salbi', 'Saten', 'Sona', 'Tatev', 'Tsaghik', 'Vanesa', 'Varsenik', 'Yeva', 'Zaruhi', 'Zovinar', 'Adrine', 'Agapi', 'Anzhela', 'Araxie', 'Arusyak', 'Chinar', 'Eliza', 'Gayaney', 'Hripsim', 'Liana', 'Nektar', 'Ripsime', 'Sirani', 'Taleen', 'Vanuhi', 'Yevgenya']
  ),
  mL: makePool(
    ['Abrahamyan', 'Aleksanyan', 'Antonyan', 'Arzumanyan', 'Avagyan', 'Avetisyan', 'Babayan', 'Danielyan', 'Gevorgyan', 'Gharibyan', 'Grigoryan', 'Hakobyan', 'Harutyunyan', 'Hovhannisyan', 'Khachatryan', 'Manukyan', 'Margaryan', 'Martirosyan', 'Melkonyan', 'Mkrtchyan', 'Movsisyan', 'Petrosyan', 'Poghosyan', 'Sargsyan', 'Stepanyan', 'Vardanyan'],
    ['Amiryan', 'Azatyan', 'Boyajyan', 'Chakhoyan', 'Demirchyan', 'Egiazaryan', 'Feyzian', 'Gevorkian', 'Hambardzumyan', 'Injidjian', 'Jivanyan', 'Kasparian', 'Lalayan', 'Mamulyan', 'Nersisyan', 'Ohanian', 'Pakhanyan', 'Qocharyan', 'Rostomyan', 'Saribekyan', 'Ter-Petrosyan', 'Ulikhanyan', 'Vardevanyan', 'Yengibaryan', 'Zakharyan', 'Amaryan', 'Balyan', 'Drmeyan', 'Ginosyan', 'Hakhverdyan', 'Isahakyan', 'Janjapanian', 'Khudaverdyan', 'Lorisyan', 'Melikyan', 'Nalbandyan', 'Oganesyan', 'Pambukhchyan', 'Rashidyan', 'Sahakian', 'Tevosyan', 'Vartanian', 'Yeganyan', 'Zatikyan', 'Aghajanyan', 'Beshiryan', 'Chilingaryan', 'Davitavyan', 'Elbakyan', 'Fahradian', 'Gharagyozyan', 'Adjamian', 'Babikian', 'Chakarian', 'Der-Karapetian', 'Esayan', 'Gurian', 'Hazarapetian', 'Janikyan', 'Keshishyan', 'Merdinyan', 'Nigoghosyan', 'Ouzounian', 'Papasyan', 'Rustamyan', 'Surmeyan', 'Tashjian', 'Voskerchyan', 'Zorayan']
  ),
  fL: makePool(
    ['Aharonyan', 'Arakelyan', 'Asatryan', 'Badalyan', 'Baghdasaryan', 'Davtyan', 'Gasparyan', 'Ghazaryan', 'Ghazinyan', 'Karapetyan', 'Kirakosyan', 'Minasyan', 'Mirzoyan', 'Nazaryan', 'Sahakyan', 'Shahbazyan', 'Simonyan', 'Tadevosyan', 'Tovmasyan', 'Yeghiazaryan'],
    ['Avanesyan', 'Bostanchyan', 'Dabaghyan', 'Galstyan', 'Hovsepyan', 'Kalashyan', 'Matevosyan', 'Navasardyan', 'Papazyan', 'Saroyan', 'Tumanyan', 'Voskanian', 'Zakarian', 'Altunyan', 'Berberyan', 'Chobanyan', 'Der-Petrosian', 'Enfiadjian', 'Garabedian', 'Harutunian', 'Israyelyan', 'Jamgochian', 'Kuyumjian', 'Lazarian', 'Muradyan', 'Norashkharian', 'Osepian', 'Pirumyan', 'Sarafian', 'Tarpinian', 'Vartabedian', 'Yeghiayan', 'Zohrabian', 'Aghabekyan', 'Bedrosian', 'Chilingirian', 'Dervishyan', 'Ekmekjian', 'Gharakhanian', 'Hagopian', 'Ignatosyan', 'Jololian', 'Khachaturian', 'Manougian', 'Nersessian', 'Orakian', 'Panosyan', 'Rafayelyan', 'Sahagian', 'Torosian', 'Yacoubian', 'Zalinyan', 'Aznavorian', 'Balayan', 'Cholakian', 'Dadayan', 'Evereklian', 'Gostanyan', 'Hovagimian', 'Izmirlian', 'Janoyan', 'Krikorian', 'Mardirosian', 'Nadjarian', 'Oshagan', 'Parsamyan', 'Rouzian', 'Shirinyan', 'Terzian', 'Vranian', 'Zulumyan']
  )
};

// 4. AZERBAIJAN
const aze = {
  mF: makePool(
    ['Abulfas', 'Adalat', 'Aghamali', 'Agshin', 'Ahmad', 'Aydin', 'Azer', 'Babek', 'Bakhtiyar', 'Elchin', 'Eldar', 'Elgun', 'Elmar', 'Elnur', 'Elvin', 'Emil', 'Farid', 'Fikrat', 'Fuad', 'Hasan', 'Hikmat', 'Ilgar', 'Ilham', 'Ilkin', 'Ismail', 'Javid', 'Kamran', 'Kenan', 'Mahir', 'Mahmud', 'Murad', 'Nijat', 'Nurlan', 'Orkhan', 'Rashad', 'Rauf', 'Rovshan', 'Rufat', 'Ruslan', 'Sabir', 'Samir', 'Shahmar', 'Shahrakh', 'Taleh', 'Teymur', 'Tural', 'Vusal', 'Yusif', 'Zaur'],
    ['Abbas', 'Agil', 'Anar', 'Arif', 'Asif', 'Ayaz', 'Bahram', 'Cavidan', 'Ceyhun', 'Diyadin', 'Emin', 'Eynulla', 'Fizuli', 'Gabil', 'Gurban', 'Habib', 'Hafiz', 'Huseyn', 'Intigam', 'Isfandiyar', 'Karam', 'Latif', 'Majid', 'Mansur', 'Mammad', 'Musa', 'Naim', 'Natig', 'Nizam', 'Ogtay', 'Parviz', 'Qabil', 'Rahim', 'Razi', 'Sabuhi', 'Sarkhan', 'Seymur', 'Shahin', 'Tahir', 'Tarlan', 'Vagif', 'Vugar', 'Zakir', 'Ziya', 'Afgan', 'Amil', 'Araz', 'Cavit']
  ),
  fF: makePool(
    ['Aysel', 'Aytan', 'Aygun', 'Ayna', 'Gunay', 'Gultakin', 'Gunel', 'Leyla', 'Nargiz', 'Nigar', 'Nezrin', 'Parvana', 'Sevinj', 'Sevda', 'Shahnaz', 'Tarana', 'Telli', 'Turkan', 'Ulviyya', 'Vafa', 'Yegana', 'Zahra', 'Zeynab', 'Zulfiyya'],
    ['Afag', 'Aynur', 'Aziza', 'Bahar', 'Banu', 'Cemile', 'Dilara', 'Elmira', 'Fidan', 'Firuza', 'Guel', 'Gulnar', 'Hajar', 'Kamilla', 'Konul', 'Lamiya', 'Lala', 'Malahat', 'Mehriban', 'Narmin', 'Nezaket', 'Nuray', 'Rena', 'Saadat', 'Sanubar', 'Shahla', 'Shana', 'Simuzar', 'Solmaz', 'Tamilla', 'Ulkar', 'Vusala', 'Yagmur', 'Zemfira', 'Zibeyda', 'Zuleykha', 'Anaxanim', 'Arzu', 'Aytaj', 'Deniz', 'Gulzar', 'Jala', 'Khatira', 'Manzar', 'Nailya', 'Pervin', 'Rana-AZ', 'Roza', 'Samira-AZ', 'Sevil', 'Shafag', 'Tahmina-AZ', 'Turan', 'Yulduz']
  ),
  mL: makePool(
    ['Abbasov', 'Abdullayev', 'Ahmadov', 'Aliyev', 'Asadov', 'Babayev', 'Bakhshaliyev', 'Efendiyev', 'Guliyev', 'Hajiyev', 'Hasanov', 'Huseynov', 'Ibrahimov', 'Ismayilov', 'Jafarov', 'Karimov', 'Mammadov', 'Mustafayev', 'Nasirov', 'Orujov', 'Pashayev', 'Rahimov', 'Rustamov', 'Safarov', 'Suleymanov', 'Valiyev'],
    ['Agayev', 'Akhundov', 'Alasgarov', 'Alizade', 'Askerov', 'Bagirov', 'Bayramov', 'Dadashov', 'Geydarov', 'Gurbanov', 'Habibov', 'Hatamov', 'Huseynzade', 'Imanov', 'Isayev', 'Jabbarov', 'Khalilov', 'Mahmudov', 'Mansurov', 'Mehdiyev', 'Mirzayev', 'Musaev', 'Najafov', 'Nazarov', 'Niyazov', 'Novruzov', 'Omarov', 'Panahov', 'Qasimov', 'Ramazanov', 'Rasulov', 'Rzayev', 'Sadigov', 'Samedov', 'Seyidov', 'Shahbazov', 'Sultanov', 'Tagiyev', 'Talibov', 'Yusifov', 'Zeynalov', 'Adigozalov', 'Alasgarli', 'Asadli', 'Babali', 'Farajov', 'Garaev', 'Hajizade', 'Ismailzade', 'Karimzade', 'Mammadli', 'Mustafali', 'Namazov', 'Piriyev', 'Quliyev', 'Rzali', 'Safarli', 'Shirinov', 'Teymurov', 'Yagubov', 'Zohrabov']
  ),
  fL: makePool(
    ['Abbasova', 'Abdullayeva', 'Ahmadova', 'Aliyeva', 'Asadova', 'Babayeva', 'Efendiyeva', 'Guliyeva', 'Hajiyeva', 'Hasanova', 'Huseynova', 'Ibrahimova', 'Ismayilova', 'Jafarova', 'Karimova', 'Mammadova', 'Mustafayeva', 'Nasirova', 'Pashayeva', 'Rahimova', 'Rustamova', 'Safarova', 'Valiyeva'],
    ['Agayeva', 'Akhundova', 'Alasgarova', 'Alizadeh', 'Askerova', 'Bagirova', 'Bayramova', 'Dadashova', 'Geydarova', 'Gurbanova', 'Habibova', 'Hatamova', 'Huseynzadeh', 'Imanova', 'Isayeva', 'Jabbarova', 'Khalilova', 'Mahmudova', 'Mansurova', 'Mehdiyeva', 'Mirzayeva', 'Musaeva', 'Najafova', 'Nazarova', 'Niyazova', 'Novruzova', 'Omarova', 'Panahova', 'Qasimova', 'Ramazanova', 'Rasulova', 'Rzayeva', 'Sadigova', 'Samedova', 'Seyidova', 'Shahbazova', 'Sultanova', 'Tagiyeva', 'Talibova', 'Yusifova', 'Zeynalova', 'Adigozalova', 'Farajova', 'Garaeva', 'Hajizadeh', 'Namazova', 'Piriyeva', 'Quliyeva', 'Shirinova', 'Teymurova', 'Yagubova', 'Zohrabova', 'Abidinova', 'Aleskerova', 'Bakhshiyeva', 'Dadašova', 'Eminova', 'Gasanova', 'Gidayatova', 'Huseynli', 'Ismayilzade', 'Javadova', 'Kazimova', 'Latifova', 'Mamedova', 'Niftaliyeva', 'Qurbanova', 'Rafiyeva', 'Salimova', 'Tahirzadeh', 'Veliyeva', 'Yusubova', 'Zeynalzadeh']
  )
};

// 5. BAHRAIN
const bhr = {
  mF: makePool(
    ['Abbas', 'Abduljalil', 'Adnan', 'Ahmed', 'Ali', 'Amjad', 'Ebrahim', 'Fahad', 'Faisal', 'Habib', 'Hasan', 'Hussain', 'Isa', 'Jaafar', 'Jassim', 'Khalid', 'Mahmood', 'Majeed', 'Mohammed', 'Nabeel', 'Nasser', 'Nawaf', 'Salman', 'Sami', 'Sari', 'Tariq', 'Waleed', 'Yousif'],
    ['Dhiya', 'Kamal', 'Khalil', 'Luay', 'Mazin', 'Nader', 'Nayef', 'Sadiq', 'Tawfiq', 'Younis', 'Zayed', 'Ammar', 'Basel', 'Mahesh', 'Abdullatif', 'Abdulrasool', 'Ali-BH', 'Anwar-BH', 'Aqeel', 'Baqer-BH', 'Fadel', 'Gazi', 'Haider', 'Hani-BH', 'Hisham-BH', 'Ilyas', 'Jalal-BH', 'Jameel-BH', 'Kadhem', 'Mahdi', 'Maki', 'Mohsen', 'Mubarak-BH', 'Mustafa-BH', 'Naim-BH', 'Radhi-BH', 'Rashed', 'Redha', 'Saeed-BH', 'Salah', 'Sattar', 'Sayed-BH', 'Shaker', 'Tariq-BH', 'Yaser', 'Zaki']
  ),
  fF: makePool(
    ['Amina', 'Asma', 'Dunya', 'Fatima', 'Hajar', 'Hala', 'Hana', 'Haya', 'Iman', 'Laila', 'Lateefa', 'Maha', 'Mariam', 'Mona', 'Moneera', 'Nada', 'Najat', 'Noor', 'Noura', 'Reem', 'Ruqaya', 'Safa', 'Sara', 'Zahra', 'Zainab'],
    ['Aysha', 'Fawzia', 'Khulood', 'Zeinab', 'Amalina', 'Dalal', 'Intisar', 'Jameela', 'Kaltham', 'Lulwa', 'Maysam', 'Nawrah', 'Sharifa', 'Amina-BH', 'Anoud-BH', 'Batool', 'Hawra', 'Kawthar-BH', 'Khadija-BH', 'Kulthum', 'Latifa-BH', 'Layla-BH', 'Maimuna', 'Marwa-BH', 'Masooma', 'Maysoun-BH', 'Munira-BH', 'Nabila-BH', 'Nadia-BH', 'Najla-BH', 'Nisreen-BH', 'Radhiya', 'Rania-BH', 'Rawayah', 'Razan', 'Ruqayya', 'Saba-BH', 'Sabika', 'Sajeda', 'Salwa-BH', 'Samira-BH', 'Sameera', 'Shatha-BH', 'Siham-BH', 'Sumaya-BH', 'Suad', 'Sundus', 'Tahereh', 'Wafa-BH', 'Yasmin-BH', 'Zubayda']
  ),
  mL: makePool(
    ['Al-Abasi', 'Al-Alawi', 'Al-Binali', 'Al-Doseri', 'Al-Hassan', 'Al-Jowder', 'Al-Khalifa', 'Al-Mahmood', 'Al-Mansoor', 'Al-Marzooq', 'Al-Musawi', 'Al-Mutawa', 'Al-Noaimi', 'Al-Oraibi', 'Al-Qasim', 'Al-Sada', 'Al-Sayed', 'Al-Shirawi', 'Al-Zayani', 'Fakhro'],
    ['Al-Ameri', 'Al-Arrayedh', 'Al-Asfoor', 'Al-Baharna', 'Al-Busmait', 'Al-Dallal', 'Al-Ghatam', 'Al-Hashemi', 'Al-Jalahma', 'Al-Kaabi', 'Al-Khan', 'Al-Khaja', 'Al-Mannai', 'Al-Mezel', 'Al-Mufez', 'Al-Qassab', 'Al-Saloom', 'Al-Samahiji', 'Al-Sanad', 'Al-Shakar', 'Al-Shawi', 'Al-Subaiei', 'Al-Zeyara', 'Baqer', 'Fakhrawi', 'Husain', 'Khooja', 'Lari', 'Mirza', 'Radhi', 'Showaiter', 'Taqi', 'Zainal-BH', 'Al-Aali', 'Al-Adraj', 'Al-Baqali', 'Al-Darazi', 'Al-Hujairi', 'Al-Jamri', 'Al-Karani', 'Al-Khadem', 'Al-Majed-BH', 'Al-Marzooqi', 'Al-Maskati', 'Al-Mousawi', 'Al-Naimi', 'Al-Qallaf', 'Al-Qattan-BH', 'Al-Sairafi', 'Al-Sari', 'Al-Sharaf', 'Al-Sitri', 'Al-Wadi', 'Al-Zain']
  ),
  fL: makePool(
    ['Al-Ansari', 'Al-Buainain', 'Al-Doy', 'Al-Hajri', 'Al-Hammadi', 'Al-Kabi', 'Al-Kooheji', 'Al-Majed', 'Al-Molla', 'Al-Najar', 'Al-Obeidli', 'Al-Romaihi', 'Al-Saati', 'Al-Saffar', 'Al-Shaikh', 'Al-Sulaiti', 'Al-Tattan', 'Al-Wazzan', 'Janahi', 'Kanoo'],
    ['Al-Abasi-F', 'Al-Alawi-F', 'Al-Binali-F', 'Al-Doseri-F', 'Al-Hassan-F', 'Al-Jowder-F', 'Al-Khalifa-F', 'Al-Mahmood-F', 'Al-Mansoor-F', 'Al-Marzooq-F', 'Al-Musawi-F', 'Al-Mutawa-F', 'Al-Noaimi-F', 'Al-Oraibi-F', 'Al-Qasim-F', 'Al-Sada-F', 'Al-Sayed-F', 'Al-Shirawi-F', 'Al-Zayani-F', 'Fakhro-F', 'Al-Ameri-F', 'Al-Arrayedh-F', 'Al-Asfoor-F', 'Al-Baharna-F', 'Al-Busmait-F', 'Al-Dallal-F', 'Al-Ghatam-F', 'Al-Hashemi-F', 'Al-Jalahma-F', 'Al-Kaabi-F', 'Al-Khan-F', 'Al-Khaja-F', 'Al-Mannai-F', 'Al-Mezel-F', 'Al-Mufez-F', 'Al-Qassab-F', 'Al-Saloom-F', 'Al-Samahiji-F', 'Al-Sanad-F', 'Al-Shakar-F', 'Al-Shawi-F', 'Al-Subaiei-F', 'Al-Zeyara-F', 'Baqer-F', 'Fakhrawi-F', 'Husain-F', 'Khooja-F', 'Lari-F', 'Mirza-F', 'Radhi-F', 'Showaiter-F', 'Taqi-F', 'Zainal-F', 'Al-Adraj-F', 'Al-Baqali-F', 'Al-Darazi-F', 'Al-Jamri-F', 'Al-Maskati-F', 'Al-Naimi-F', 'Al-Tajer', 'Al-Wadi-F', 'Al-Zain-F']
  )
};

const first5 = {
  'afganistan': afg,
  'arab saudi': sau,
  'armenia': arm,
  'azerbaijan': aze,
  'bahrain': bhr
};

for (const country in first5) {
  const cData = first5[country];
  const baseDir = path.join('json', 'firstname_lastname', 'asia', country);
  
  const mFirstFile = path.join(baseDir, 'male', 'firstname.json');
  const mLastFile = path.join(baseDir, 'male', 'lastname.json');
  const fFirstFile = path.join(baseDir, 'female', 'firstname.json');
  const fLastFile = path.join(baseDir, 'female', 'lastname.json');

  fs.writeFileSync(mFirstFile, JSON.stringify(cData.mF, null, 2));
  fs.writeFileSync(mLastFile, JSON.stringify(cData.mL, null, 2));
  fs.writeFileSync(fFirstFile, JSON.stringify(cData.fF, null, 2));
  fs.writeFileSync(fLastFile, JSON.stringify(cData.fL, null, 2));
}

console.log('Successfully wrote first 5 countries!');
