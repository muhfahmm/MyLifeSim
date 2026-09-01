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

// 6. BANGLADESH
const bgd = {
  mF: makePool(
    ['Abul', 'Adnan', 'Afsar', 'Ahsan', 'Akram', 'Alamgir', 'Ali', 'Aminul', 'Anwar', 'Arefin', 'Arif', 'Ashraful', 'Badrul', 'Delwar', 'Farhan', 'Habibur', 'Hafiz', 'Hasan', 'Hossain', 'Ibrahim', 'Imtiaz', 'Jahangir', 'Kamrul', 'Khaled', 'Mahfuz', 'Mahmud', 'Mashrafe', 'Mizanur', 'Mustafizur', 'Nazmul', 'Nurul', 'Rafiqul', 'Rahim', 'Rashid', 'Razaul', 'Riyad', 'Rubel', 'Sabbir', 'Saiful', 'Shakib', 'Shariful', 'Sohel', 'Suhail', 'Sumon', 'Tamim', 'Tariqul', 'Taskin', 'Touhid', 'Zakir', 'Ziaur'],
    ['Abdur', 'Abu', 'Ainul', 'Alim', 'Al-Amin', 'Amzad', 'Asad', 'Ashik', 'Azizul', 'Babul', 'Belal', 'Biplob', 'Dipu', 'Faisal', 'Golam', 'Habib', 'Humayun', 'Imran', 'Iqbal', 'Kabir', 'Kamal', 'Kazi', 'Kibriya', 'Liton', 'Mamun', 'Manzur', 'Masud', 'Matin', 'Moinul', 'Monir', 'Motiur', 'Munir', 'Nasir', 'Nayon', 'Obaidul', 'Parvez', 'Qamrul', 'Rabiul', 'Rafiq', 'Raju', 'Rana', 'Reza', 'Riaz', 'Robiul', 'Sajid', 'Salim', 'Sanwar', 'Shahadat', 'Shahid', 'Sirajul', 'Soleman', 'Tanvir', 'Tariq', 'Zahid', 'Arafat', 'Arman-BD', 'Badal', 'Baten', 'Chowdhury-BD', 'Emon', 'Fahim', 'Firoz', 'Hedayet', 'Hiron', 'Ishtiaque', 'Jubayer', 'Kaiser', 'Lal-BD', 'Mehedi', 'Nayeem', 'Omar-BD', 'Polash', 'Ratul', 'Sabbir-BD', 'Tawhid', 'Zaman-BD']
  ),
  fF: makePool(
    ['Afreen', 'Ayesha', 'Dilruba', 'Fariha', 'Farzana', 'Fatema', 'Hasina', 'Jannatul', 'Khadija', 'Laila', 'Mahbuba', 'Meherun', 'Moushumi', 'Nusrat', 'Pori', 'Popy', 'Rabeya', 'Rashida', 'Runa', 'Sabina', 'Sadia', 'Salma', 'Samira', 'Sharmin', 'Shirin', 'Shireen', 'Sultana', 'Tanjin', 'Tasnim', 'Tisha'],
    ['Afroza', 'Amena', 'Anowara', 'Asma', 'Bithi', 'Champa', 'Dalia', 'Fahmida', 'Farhana', 'Hosne', 'Ismat', 'Jesmin', 'Kamrun', 'Kohl', 'Kuhinur', 'Laboni', 'Lipika', 'Mahmuda', 'Mariam-BD', 'Meher', 'Momena', 'Monira', 'Mustari', 'Nahrin', 'Nazma', 'Nilufar', 'Nurjahan', 'Parveen', 'Rahima', 'Rokeya', 'Roxana', 'Rozina', 'Rumana', 'Sabiha', 'Sajeda', 'Salina', 'Samia', 'Sanida', 'Sayeda', 'Shahana', 'Shahnaz', 'Shaheen', 'Shamima', 'Shanta', 'Shefali', 'Shomi', 'Sohely', 'Suraiya', 'Tahmina-BD', 'Tania', 'Taslima', 'Ummey', 'Zinat', 'Anika-BD', 'Bipasha', 'Dola', 'Farida-BD', 'Gita', 'Jahanara', 'Kalyani-BD', 'Lina-BD', 'Mimi', 'Nipa', 'Oishi', 'Priya-BD', 'Rupa', 'Shampa', 'Tuba']
  ),
  mL: makePool(
    ['Ahmed', 'Alam', 'Bhuiyan', 'Huda', 'Islam', 'Khan', 'Mia', 'Miah', 'Rahman', 'Sarkar', 'Siddique', 'Sikder', 'Uddin', 'Zaman'],
    ['Ahsan-L', 'Akhand', 'Arefin-L', 'Bhowmik', 'Chakraborty', 'Chowdhury-M', 'Gazi', 'Halder', 'Haque', 'Howlader', 'Kazi-L', 'Khandakar', 'Laskar', 'Majumder', 'Mandal', 'Mollah', 'Monshi', 'Mostafa', 'Munshi', 'Nandy', 'Patwary', 'Paul', 'Pramanik', 'Quddus', 'Saha', 'Samad', 'Sheikh', 'Talukder', 'Tarafdar', 'Wahab', 'Wadud', 'Zahedi', 'Baqi', 'Chisti', 'Dewan', 'Inam', 'Jaman', 'Naved', 'Qadir', 'Salam', 'Tarafder', 'Ullah', 'Zia-L', 'Adhikary', 'Barua', 'Biswas', 'Brahma', 'Dasgupta', 'Dhar', 'Dutta-L', 'Guha', 'Kabir-L', 'Kar', 'Mazumder', 'Mitra', 'Nag', 'Pal', 'Roy-L', 'Sengupta', 'Talukdar']
  ),
  fL: makePool(
    ['Begum', 'Banu', 'Khatun', 'Nessa', 'Parvin', 'Sultana-L', 'Yasmin', 'Ara', 'Nahar', 'Jahan', 'Siddiqua', 'Akter', 'Ferdous', 'Khanom'],
    ['Abedin', 'Anjum', 'Afroz', 'Azim', 'Bibi', 'Dilshad', 'Ferdousi', 'Gulshan', 'Hosneara', 'Kamrunnessa', 'Khanum', 'Khaleque', 'Mowla', 'Nasreen', 'Rani', 'Razzaque', 'Tabassum', 'Tazreen', 'Yasmeen', 'Zahed', 'Zohra-L', 'Anika-L', 'Barua-F', 'Biswas-F', 'Bhowmik-F', 'Chakraborty-F', 'Chowdhury-FL', 'Das-FL', 'Dhar-F', 'Dutta-FL', 'Guha-F', 'Haque-FL', 'Islam-FL', 'Kazi-FL', 'Kar-F', 'Khan-FL', 'Majumder-F', 'Mitra-F', 'Nandy-F', 'Pal-F', 'Paul-F', 'Rahman-FL', 'Roy-FL', 'Saha-F', 'Sarkar-FL', 'Sengupta-F', 'Siddique-FL', 'Uddin-FL', 'Zaman-FL']
  )
};

// 7. BHUTAN
const btn = {
  mF: makePool(
    ['Chimi', 'Dawa', 'Dorji', 'Jigme', 'Karma', 'Kinley', 'Kuenza', 'Lhendup', 'Nima', 'Pema', 'Phuntsho', 'Rinchen', 'Thinley', 'Ugyen', 'Wangchuk', 'Yeshey'],
    ['Chewang', 'Gyeltshen', 'Jamyang', 'Khandu', 'Kuenga', 'Kunzang', 'Loday', 'Lotay', 'Lubdak', 'Namgyal', 'Nidup', 'Norbu', 'Passang', 'Penjor', 'Phurba', 'Samdrup', 'Tobgay', 'Tshewang', 'Yonten', 'Zangpo', 'Chhogyel', 'Choda', 'Gayley', 'Gembo', 'Kinzang', 'Lhakpa', 'Mingbo', 'Phub', 'Sampa', 'Singye', 'Tenpa', 'Tobgyel', 'Tshendu', 'Wangdi', 'Yeshi', 'Bumthap', 'Chogyal', 'Daw-M', 'Gyaltson', 'Jigme-M', 'Khandu-M', 'Lhakpa-M', 'Nidup-M', 'Passang-M', 'Phuntsho-M', 'Rinchen-M', 'Sonam-Male', 'Tashi-Male', 'Tenpa-M', 'Tenzin-Male', 'Thinley-Male', 'Tshering-Male', 'Ugyen-Male', 'Wangchuk-Male', 'Yeshi-M', 'Yonten-Male']
  ),
  fF: makePool(
    ['Choki', 'Dechen', 'Deki', 'Kezang', 'Lhamo', 'Mendrel', 'Namgay', 'Om', 'Peldon', 'Pem', 'Sangay', 'Sonam', 'Tandin', 'Tashi', 'Tenzin', 'Tshomo', 'Tshering', 'Yangchen', 'Yangki', 'Yendon', 'Zangmo'],
    ['Beda', 'Choden', 'Dema', 'Doma', 'Lhaden', 'Meto', 'Ringzin', 'Seldon', 'Wangmo', 'Yangdon', 'Yangkyi', 'Yangzom', 'Yidon', 'Yuden', 'Bida', 'Damchoe', 'Dolma', 'Lhadon', 'Rigzin', 'Beda-F', 'Bida-F', 'Chhimi', 'Choden-F', 'Dechen-F', 'Deki-F', 'Dema-F', 'Dolma-F', 'Karma-F', 'Kinley-F', 'Kunzang-F', 'Lhamo-F', 'Namgay-F', 'Nima-F', 'Norbu-F', 'Passang-F', 'Pema-F', 'Phuntsho-F', 'Rinchen-F', 'Sangay-F', 'Sonam-Female', 'Tandin-F', 'Tashi-Female', 'Tenzin-Female', 'Thinley-F', 'Tshering-Female', 'Ugyen-Female', 'Wangmo-F', 'Yangchen-F', 'Yangkyi-F', 'Yangzom-F', 'Yendon-F', 'Zangmo-Female']
  ),
  mL: makePool(
    ['Dorji-ML', 'Gyeltshen-ML', 'Jigme-ML', 'Namgyal-ML', 'Nidup-ML', 'Norbu-ML', 'Penjor-ML', 'Phuntsho-ML', 'Rinchen-ML', 'Samdrup-ML', 'Tenzin-ML', 'Thinley-ML', 'Tobgay-ML', 'Tshering-ML', 'Wangchuk-ML'],
    ['Chhoeda', 'Dukpa', 'Ghale', 'Gurung', 'Khatiwada', 'Lama-BH', 'Limbus', 'Palden', 'Pradhan-BH', 'Rai-BH', 'Sherpa', 'Tamang', 'Thapa-BH', 'Tshewang-L', 'Wangdi-L', 'Yonten-L', 'Bhandari-BH', 'Chetri', 'Dahal', 'Giri-BH', 'Karki-BH', 'Koirala', 'Magar', 'Neupane', 'Subba', 'Timsina', 'Acharja', 'Adhikari-BH', 'Basnet', 'Bhattarai', 'Gautam-BH', 'Poudel', 'Rijal', 'Shrestha-BH', 'Tiwari-BH', 'Upadhyaya', 'Bahadur', 'Bara', 'Bista', 'Chhetri-BH', 'Devkota', 'Ghimire', 'Khati', 'Koirala-BH', 'Mainali', 'Pandey-BH', 'Pokhrel', 'Rana-BH', 'Regmi', 'Rizal', 'Sharma-BH', 'Thakur-BH', 'Acharya-BH', 'Aryal', 'Baral', 'Bhatta', 'Bhujel', 'Bhurtel', 'Chaudhary-BH', 'Dhungana', 'Gautam-B', 'Kadel', 'Kandel', 'Khanal', 'Khatiwoda', 'Khadka', 'Lamsal', 'Oli', 'Pant-BH', 'Parajuli', 'Poudyal', 'Rai-B', 'Rimal', 'Sapkota', 'Sharma-BHL', 'Shrestha-BL', 'Thapa-BL']
  ),
  fL: makePool(
    ['Choden', 'Dema', 'Lhamo', 'Om', 'Peldon', 'Pem', 'Tshomo', 'Wangmo', 'Yangchen', 'Yangzom', 'Zangmo'],
    ['Bida-L', 'Choki-L', 'Dechen-L', 'Deki-L', 'Doma-L', 'Kezang-L', 'Kunzang-L', 'Lhaden-L', 'Mendrel-L', 'Namgay-L', 'Pema-L', 'Phuntsho-L', 'Ringzin-L', 'Sangay-L', 'Seldon-L', 'Sonam-L', 'Tandin-L', 'Tashi-L', 'Tenzin-L', 'Tshering-L', 'Yangdon-L', 'Yangki-L', 'Yendon-L', 'Yuden-L', 'Beda-L', 'Dolma-L', 'Lhadon-L', 'Meto-L', 'Chhoden', 'Dolkar', 'Lham-L', 'Meto-FL', 'Rinchen-FL', 'Adhikari-F', 'Bhandari-F', 'Bhattarai-F', 'Basnet-F', 'Chaudhary-F', 'Chetri-F', 'Dahal-F', 'Devkota-F', 'Gautam-F', 'Ghimire-F', 'Giri-F', 'Gurung-F', 'Karki-F', 'Khadka-F', 'Koirala-F', 'Lama-F', 'Magar-F', 'Neupane-F', 'Pandey-F', 'Pokhrel-F', 'Poudel-F', 'Pradhan-F', 'Rai-F', 'Rana-F', 'Regmi-F', 'Sharma-F', 'Sherpa-F', 'Shrestha-F', 'Subba-F', 'Tamang-F', 'Thapa-F', 'Timsina-F', 'Tiwari-F']
  )
};

// 8. BRUNEI
const brn = {
  mF: makePool(
    ['Abdul', 'Ahmad', 'Azman', 'Fadilah', 'Faizal', 'Hafiz', 'Hapidz', 'Hassanal', 'Hazim', 'Ibrahim', 'Khairul', 'Mahmud', 'Mohammad', 'Muizzuddin', 'Nazirul', 'Nabil', 'Nordin', 'Rahman', 'Rosli', 'Saiful', 'Shahril', 'Suhaili', 'Sufri', 'Syahmi', 'Zainal', 'Zulkifli'],
    ['Aiman', 'Akmal', 'Amiruddin', 'Anuar', 'Asri', 'Azhar', 'Azmi', 'Bahrin', 'Basir', 'Danial', 'Fadhil', 'Fadzil', 'Fikri', 'Hamdan', 'Hamzah', 'Hanif', 'Helmi', 'Hisham', 'Izam', 'Khairuddin', 'Luqman', 'Marzuki', 'Mazlan', 'Nazri', 'Noor', 'Razak', 'Rizal', 'Sabri', 'Saifuddin', 'Shahdan', 'Shukri', 'Sofian', 'Syukri', 'Wafi', 'Zaini', 'Zakaria', 'Zulhilmi', 'Afif-BN', 'Amir-BN', 'Arif-BN', 'Ashraf-BN', 'Badrul-BN', 'Danish-BN', 'Farid-BN', 'Faris-BN', 'Fauzi', 'Hakim-BN', 'Halim-BN', 'Hasan-BN', 'Husaini', 'Ikhwan', 'Imran-BN', 'Irfan-BN', 'Ismat-BN', 'Izwan', 'Kamal-BN', 'Khairi', 'Luqman-BN', 'Naim-BN', 'Nasruddin', 'Nazmi', 'Qawiem', 'Rafiq', 'Rashid-BN', 'Ridzwan', 'Raziq', 'Shafiq-BN', 'Syakir', 'Taufik', 'Zul-Fadhli']
  ),
  fF: makePool(
    ['Amal', 'Azizah', 'Dayangku', 'Farah', 'Fatin', 'Hajah', 'Halimah', 'Izzah', 'Khairunnisa', 'Latifah', 'Maimunah', 'Mariam', 'Nabilah', 'Nadiah', 'Noraini', 'Nurul', 'Raihana', 'Rashidah', 'Sabrina', 'Siti', 'Syazwana', 'Zaharah', 'Zulfa'],
    ['Adilah', 'Afifah', 'Aisyah', 'Aliah', 'Anis', 'Asmah', 'Atikah', 'Azilah', 'Dayang', 'Diana', 'Ezah', 'Fadhilah', 'Fadzilah', 'Hafizah', 'Hamizah', 'Hanis', 'Hasnah', 'Hazirah', 'Izzati', 'Jamilah', 'Kartini', 'Khairiah', 'Liyana', 'Marlina', 'Maznah', 'Munirah', 'Nadhirah', 'Naimah', 'Nazirah', 'Noor-F', 'Norafizah', 'Norazlina', 'Norhafizah', 'Norkhairiah', 'Norsiah', 'Nur', 'Nurdiana', 'Rabiatul', 'Rafidah', 'Rahmah', 'Rohana', 'Rosnah', 'Ruziah', 'Sabariah', 'Safiah', 'Salbiah', 'Salmah', 'Salwa', 'Sarimah', 'Shakirah', 'Sharifah', 'Syahira', 'Syafiqah', 'Syakirah', 'Zaimah', 'Zalina', 'Zeti', 'Zubaidah', 'Zunah', 'Amirah-BN', 'Aqilah', 'Athirah', 'Atiqah', 'Azra', 'Fizah', 'Hafizah-BN', 'Husna-BN', 'Irdina', 'Maysarah', 'Nadia-BN', 'Najwa-BN', 'Nuraqilah', 'Nurul-BN', 'Rania-BN', 'Sabrina-BN', 'Shafiqah', 'Syahinda', 'Wafaa', 'Wardah', 'Zahirah', 'Zulaikha']
  ),
  mL: makePool(
    ['Abdullah', 'Ariffin', 'Jafar', 'Limbang', 'Matali', 'Mohiddin', 'Muhammad', 'Mustapa', 'Othman', 'Ramli', 'Sabli', 'Salleh', 'Yusof'],
    ['Abas', 'Bidin', 'Bohari', 'Daud', 'Gapar', 'Hussin', 'Jalil', 'Jumat', 'Kadir', 'Kiprawi', 'Laji', 'Mahari', 'Matusin', 'Metali', 'Minudin', 'Mumin', 'Pungut', 'Radin', 'Rajab', 'Ramlee', 'Said', 'Serudin', 'Shaari', 'Sidek', 'Umar', 'Yassin', 'Yunos', 'Zulkipli', 'Ahmad-BNL', 'Ali-BNL', 'Arshad-M', 'Awang-BNL', 'Aziz-BNL', 'Bakar-BNL', 'Basir-BNL', 'Hassan-BNL', 'Hamid-BNL', 'Harun-BNL', 'Hashim-BNL', 'Idris-BNL', 'Ismail-BNL', 'Jamil-BNL', 'Kamal-BNL', 'Karim-BNL', 'Kassim-BNL', 'Latif-BNL', 'Mahmud-BNL', 'Majid-BNL', 'Naim-BNL', 'Nasir-BNL', 'Omar-BNL', 'Osman-BNL', 'Rahman-BNL', 'Rashid-BNL', 'Suhaili-BNL', 'Sulaiman-BNL', 'Tahir-BNL', 'Wahab-BNL', 'Yaakub-BNL', 'Zain-BNL', 'Zakaria-BNL']
  ),
  fL: makePool(
    ['Abang', 'Awang', 'Badaruddin', 'Bakar', 'Bolkiah', 'Damit', 'Ghafar', 'Harun', 'Hashim', 'Idris', 'Kassim', 'Latif', 'Pengiran', 'Sapar', 'Sulaiman', 'Taha', 'Yaakub'],
    ['Aminah-L', 'Azizah-L', 'Baharuddin', 'Basar', 'Daudd', 'Hadjah', 'Salimah', 'Abas-F', 'Arshad', 'Asmat-F', 'Bidin-F', 'Bolkiah-F', 'Fadzil-F', 'Ghafar-F', 'Jafar-F', 'Jumat-F', 'Khairuddin-F', 'Matali-F', 'Metali-F', 'Rajab-F', 'Ramlee-F', 'Said-F', 'Sidek-F', 'Yassin-F', 'Yunos-F', 'Abdullah-F', 'Ahmad-F', 'Ali-F', 'Ariffin-F', 'Awang-F', 'Aziz-F', 'Bakar-FL', 'Basir-F', 'Hamid-F', 'Hassan-F', 'Ibrahim-F', 'Ismail-F', 'Jamil-F', 'Kamal-F', 'Karim-F', 'Kassim-FL', 'Latif-FL', 'Mahmud-F', 'Majid-F', 'Muhammad-F', 'Mustapa-F', 'Naim-F', 'Nasir-F', 'Omar-F', 'Osman-F', 'Othman-F', 'Pengiran-FL', 'Rahman-F', 'Ramli-F', 'Rashid-F', 'Sabli-F', 'Saiful-F', 'Salleh-FL', 'Sapar-FL', 'Suhaili-F', 'Sulaiman-FL', 'Tahir-F', 'Wahab-F', 'Yaakub-FL', 'Yusof-F', 'Zainal-F', 'Zakaria-FL']
  )
};

// 9. CHINA
const chn = {
  mF: makePool(
    ['Bo', 'Chen', 'Cheng', 'Cong', 'Feng', 'Gang', 'Guang', 'Hai', 'Hao', 'Jian', 'Jie', 'Jun', 'Lei', 'Liang', 'Long', 'Ming', 'Peng', 'Qiang', 'Tao', 'Wei', 'Xiaolong', 'Xin', 'Yi', 'Yong', 'Yu', 'Zhe', 'Zheng', 'Zhi'],
    ['Bao', 'Bin', 'Chao', 'Da', 'Dong', 'Fan', 'Fu', 'Guo', 'Han', 'Hui', 'Jianjun', 'Jianwei', 'Jin', 'Kai', 'Kang', 'Ke', 'Kun', 'Quan', 'Ru', 'Rui', 'Sheng', 'Shuai', 'Song', 'Tian', 'Weidong', 'Weng', 'Xiao', 'Xiaobo', 'Xiaofeng', 'Xiaojun', 'Xiaoming', 'Xing', 'Xu', 'Xue', 'Yao', 'Yuan', 'Zeyu', 'Zhen', 'Zhong', 'Zihao', 'An-CN', 'Biao', 'Bowen', 'Chang-CN', 'Dian', 'Ding-CN', 'Guangming', 'Guoliang', 'Hongjun', 'Hongwei', 'Jianfeng', 'Jianguo', 'Jianhua', 'Jiaming', 'Jianping', 'Junwei', 'Ming-CN', 'Pei-CN', 'Qing-CN', 'Ruifeng', 'Shaohua', 'Song-CN', 'Wei-CN', 'Weihua', 'Weimin', 'Wenhua', 'Wenjun', 'Xiang-CN', 'Xiaogang', 'Xinhai', 'Yilin', 'Yongjun', 'Yongqiang', 'Zhaohui', 'Zhenhua', 'Zhiqiang', 'Zhiwei']
  ),
  fF: makePool(
    ['Dan', 'Fang', 'Fei', 'Hong', 'Huan', 'Jia', 'Jing', 'Juan', 'Lan', 'Li', 'Lijuan', 'Ling', 'Mei', 'Meiling', 'Min', 'Na', 'Ning', 'Ping', 'Qian', 'Qing', 'Rong', 'Shuang', 'Ting', 'Wen', 'Xiang', 'Xiu', 'Yan', 'Yang', 'Ying', 'Yue', 'Yun'],
    ['Fen', 'Fenfen', 'Jiahui', 'Jiali', 'Jiamin', 'Jiaqi', 'Jingjing', 'Lihua', 'Lili', 'Lina', 'Lu', 'Meifang', 'Mei-Ling', 'Niu', 'Pei', 'Qiao', 'Qin', 'Qiu', 'Shan', 'Shanshan', 'Shu', 'Shufen', 'Shuting', 'Tingting', 'Xia', 'Xiaodan', 'Xiaofang', 'Xiaohong', 'Xiaoli', 'Xiaoling', 'Xiaomei', 'Xiaona', 'Xiaoping', 'Xiaoyan', 'Xiaoying', 'Xinyi', 'Xiulan', 'Xiuying', 'Yanan', 'Yingying', 'Yufen', 'Yuting', 'Ailing', 'Biyu', 'Chang-FCN', 'Chunhua', 'Chunyan', 'Cuifang', 'Cuiping', 'Haiyan', 'Hongmei', 'Hongyan', 'Huifang', 'Huimin', 'Jianhua-F', 'Jianmei', 'Jiawei-F', 'Jinghua', 'Jingmei', 'Li-FCN', 'Lihong', 'Limin', 'Liwei', 'Liying', 'Liyuan', 'Meihua', 'Meiying', 'Peifang', 'Ping-FCN', 'Qinghua', 'Qingmei', 'Ronghua', 'Shuhua', 'Shumei', 'Ting-FCN', 'Weihong', 'Weili', 'Wen-FCN', 'Xiaohua', 'Xiaohui', 'Xiaomin', 'Xiaoping-F', 'Xiaowen', 'Xiumei', 'Xiuing', 'Yali', 'Yan-FCN', 'Yanhong', 'Yanling', 'Ying-FCN', 'Yufen-F', 'Yun-FCN']
  ),
  mL: makePool(
    ['Chen', 'Cheng', 'Deng', 'Feng', 'Gao', 'Guo', 'He', 'Huang', 'Li', 'Lin', 'Liu', 'Luo', 'Ma', 'Sun', 'Wang', 'Wu', 'Xie', 'Yang', 'Zhang', 'Zhao', 'Zheng', 'Zhou', 'Zhu'],
    ['An', 'Bai', 'Bi', 'Chang', 'Dai', 'Ding', 'Du', 'Gu', 'Hou', 'Hu', 'Lai', 'Lang', 'Liao', 'Meng', 'Mo', 'Ren', 'Shen', 'Su', 'Xiong', 'Ye', 'Yin', 'Zhan', 'Zou', 'Cai-MCN', 'Cao-MCN', 'Dong-MCN', 'Fan-MCN', 'Fang-MCN', 'Fu-MCN', 'Han-MCN', 'Hao-MCN', 'Jia-MCN', 'Jiang-MCN', 'Jin-MCN', 'Kang-MCN', 'Liang-MCN', 'Lu-MCN', 'Pan-MCN', 'Peng-MCN', 'Qian-MCN', 'Qin-MCN', 'Qiu-MCN', 'Song-MCN', 'Tang-MCN', 'Tian-MCN', 'Wan-MCN', 'Wei-MCN', 'Wen-MCN', 'Xia-MCN', 'Xiao-MCN', 'Xu-MCN', 'Xue-MCN', 'Yan-MCN', 'Yu-MCN', 'Yuan-MCN', 'Zeng-MCN', 'Zhong-MCN']
  ),
  fL: makePool(
    ['Cai', 'Cao', 'Dong', 'Fan', 'Han', 'Jiang', 'Liang', 'Lu', 'Pan', 'Peng', 'Song', 'Tang', 'Tian', 'Wan', 'Wei', 'Xiao', 'Xu', 'Yuan', 'Zeng', 'Zhong'],
    ['An-FCN', 'Bai-FCN', 'Bi-FCN', 'Chang-FCN', 'Chen-FCN', 'Cheng-FCN', 'Dai-FCN', 'Deng-FCN', 'Ding-FCN', 'Du-FCN', 'Fang-FCN', 'Feng-FCN', 'Fu-FCN', 'Gao-FCN', 'Gu-FCN', 'Guo-FCN', 'He-FCN', 'Hou-FCN', 'Hu-FCN', 'Huang-FCN', 'Jin-FCN', 'Kang-FCN', 'Lai-FCN', 'Lang-FCN', 'Li-FCN', 'Liao-FCN', 'Lin-FCN', 'Liu-FCN', 'Luo-FCN', 'Ma-FCN', 'Meng-FCN', 'Mo-FCN', 'Qian-FCN', 'Qin-FCN', 'Qiu-FCN', 'Ren-FCN', 'Shen-FCN', 'Su-FCN', 'Sun-FCN', 'Wang-FCN', 'Wen-FCN', 'Wu-FCN', 'Xia-FCN', 'Xie-FCN', 'Xiong-FCN', 'Xue-FCN', 'Yan-FCN', 'Yang-FCN', 'Ye-FCN', 'Yin-FCN', 'Yu-FCN', 'Zhan-FCN', 'Zhang-FCN', 'Zhao-FCN', 'Zheng-FCN', 'Zhou-FCN', 'Zhu-FCN', 'Zou-FCN']
  )
};

// 10. FILIPINA
const phl = {
  mF: makePool(
    ['Alejandro', 'Angelo', 'Antonio', 'Bambang', 'Benito', 'Christian', 'Crisanto', 'Danilo', 'Dante', 'Efren', 'Eduardo', 'Emmanuel', 'Enrique', 'Fernando', 'Francis', 'Gabriel', 'Gerardo', 'Ismael', 'Jayson', 'Jerome', 'Jesus', 'Joel', 'John', 'Jose', 'Juan', 'Junior', 'Leandro', 'Manuel', 'Mark', 'Mateo', 'Miguel', 'Nicanor', 'Paolo', 'Pedro', 'Rafael', 'Ramon', 'Rene', 'Reynaldo', 'Ricardo', 'Roberto', 'Rodrigo', 'Rolando', 'Ruben', 'Salvador', 'Vicentico'],
    ['Adolfo', 'Adrian', 'Albert', 'Alfonso', 'Alfredo', 'Alvin', 'Amado', 'Andres', 'Aniceto', 'Apolinario', 'Archie', 'Arman', 'Armando', 'Arnel', 'Arturo', 'Benjamin', 'Bernardo', 'Bonifacio', 'Bryan', 'Carlito', 'Carlos', 'Cesar', 'Claudio', 'Crispin', 'Crisostomo', 'Dakila', 'Daryl', 'Dennis', 'Diego', 'Diosdado', 'Dominador', 'Donato', 'Edgar', 'Edgardo', 'Edilberto', 'Edison', 'Edmundo', 'Eduard', 'Elpidio', 'Emilio', 'Ernesto', 'Esteban', 'Eugenio', 'Felipe', 'Felix', 'Ferdinand', 'Fidel', 'Florentino', 'Francisco', 'Franco', 'Freddie', 'Generoso', 'Gil', 'Gregorio', 'Guillermo', 'Hector', 'Hermogenes', 'Hilario', 'Ignacio', 'Isagani', 'Jaime', 'Jay', 'Jefferson', 'Jericho', 'Jerry', 'Jim', 'Jimmy', 'Job', 'Jovito', 'Julio', 'Justo', 'Lance', 'Lauro', 'Lito', 'Lorenzo', 'Louie', 'Lucio', 'Luis', 'Macario', 'Marc', 'Marcelo', 'Marciano', 'Mario', 'Marvin', 'Maximo', 'Modesto', 'Moises', 'Noli', 'Norberto', 'Orlando', 'Oscar', 'Pablo', 'Pacifico', 'Pascual', 'Philip', 'Placido', 'Primitivo', 'Rainer', 'Ralph', 'Ramil', 'Ramiro', 'Raymundo', 'Regino', 'Remigio', 'Renato', 'Rey', 'Reyante', 'Rizalino', 'Rodel', 'Rogelio', 'Roly', 'Rommel', 'Romulo', 'Ronnie', 'Roque', 'Rosauro', 'Ruffo', 'Rufino', 'Rupert', 'Ruperto', 'Severino', 'Sexto', 'Silvestre', 'Simeon', 'Teodoro', 'Teofilo', 'Tirso', 'Tomas', 'Tristan', 'Urbano', 'Valentin', 'Vicente', 'Victor', 'Victorino', 'Virgilio', 'Wilfredo', 'Wenceslao']
  ),
  fF: makePool(
    ['Althea', 'Angel', 'Angelica', 'Angela', 'Anita', 'Bea', 'Carmela', 'Cristina', 'Divina', 'Elena', 'Esperanza', 'Estrella', 'Flordeliza', 'Imelda', 'Jacqueline', 'Jasmine', 'Jennifer', 'Josefina', 'Joy', 'Katrina', 'Kristine', 'Liza', 'Lourdes', 'Luwalhati', 'Mae', 'Maria', 'Maricar', 'Mercy', 'Milagros', 'Nenita', 'Patricia', 'Princess', 'Rosa', 'Rosario', 'Teresita'],
    ['Abigail', 'Adelpha', 'Agnes', 'Aileen', 'Aira', 'Aleli', 'Alicia', 'Alma', 'Amelia', 'Amparo', 'Analyn', 'Anatolia', 'Andrea', 'Annalyn', 'Araceli', 'Arlene', 'Audrey', 'Aurea', 'Aurora', 'Bernadette', 'Bernice', 'Beth', 'Bianca', 'Blessing', 'Camilla', 'Carla', 'Carlota', 'Carmen', 'Carolina', 'Casandra', 'Catalina', 'Cecilia', 'Celeste', 'Charito', 'Charlene', 'Charmina', 'Cherry', 'Cielo', 'Clara', 'Clarissa', 'Claudia', 'Consuelo', 'Corazon', 'Daisy', 'Dahlia', 'Darlene', 'Delfina', 'Dolores', 'Dominique', 'Doris', 'Editha', 'Elaine', 'Eleanor', 'Elisa', 'Elizabeth', 'Elvira', 'Elysia', 'Emily', 'Erica', 'Erlinda', 'Estefania', 'Evelyn', 'Evangeline', 'Faith', 'Fe', 'Felisa', 'Fiona', 'Florante', 'Florencia', 'Gail', 'Gemma', 'Genoveva', 'Giselle', 'Glenda', 'Gloria', 'Gwendolyn', 'Hazel', 'Helen', 'Honorata', 'Iluminada', 'Immaculada', 'Ines', 'Irene', 'Iris', 'Isabella', 'Isadora', 'Jacinta', 'Jade', 'Janie', 'Jean', 'Jenny', 'Joana', 'Joan', 'Joanna', 'Jocelyn', 'Josephine', 'Judith', 'Julia', 'Juliet', 'Katherine', 'Kathleen', 'Kimberly', 'Kristel', 'Kyla', 'Laarni', 'Lady', 'Lea', 'Leilani', 'Leonora', 'Leticia', 'Ligaya', 'Lilia', 'Lilibeth', 'Linda', 'Loida', 'Lorena', 'Loreto', 'Lucia', 'Lucila', 'Luisa', 'Luz', 'Luzviminda', 'Lyra', 'Madeline', 'Magdalena', 'Maileen', 'Manuela', 'Margarita', 'Marian', 'Marianne', 'Maricel', 'Maricon', 'Marilou', 'Marina', 'Maris', 'Marissa', 'Marita', 'Marivic', 'Marlene', 'Marta', 'Martha', 'Mary', 'Matilde', 'Maura', 'Melanie', 'Melba', 'Melissa', 'Mercedes', 'Minerva', 'Mira', 'Miranda', 'Miriam', 'Monina', 'Monica', 'Myra', 'Nancie', 'Natividad', 'Nelia', 'Nery', 'Nicanora', 'Nida', 'Nieves', 'Nilda', 'Noemi', 'Nora', 'Norma', 'Ofelia', 'Olivia', 'Paloma', 'Pamela', 'Patrocinio', 'Paula', 'Paulina', 'Pearl', 'Perla', 'Pia', 'Pilar', 'Prescilla', 'Purificacion', 'Rachel', 'Ramona', 'Raquel', 'Rebecca', 'Regina', 'Remedios', 'Rhea', 'Rita', 'Rizalina', 'Rochelle', 'Romy', 'Rosalia', 'Rosalina', 'Rosalinda', 'Rosana', 'Rose', 'Rosemarie', 'Rowena', 'Ruby', 'Ruth', 'Salvalora', 'Samantha', 'Sandra', 'Santa', 'Sheila', 'Silvia', 'Sonia', 'Sophia', 'Stella', 'Stephanie', 'Susan', 'Susana', 'Sylvia', 'Teresa', 'Trinidad', 'Valentina', 'Valerie', 'Vanessa', 'Veronica', 'Victoria', 'Vilma', 'Violeta', 'Virginia', 'Vivian', 'Winnifred', 'Xandra', 'Yolanda', 'Yvette', 'Yvonne', 'Zenaida', 'Zoe']
  ),
  mL: makePool(
    ['Abad', 'Aguilar', 'Alcantara', 'Aquino', 'Bautista', 'Castillo', 'Cruz', 'De Castro', 'De Leon', 'De Los Reyes', 'Del Rosario', 'Dela Cruz', 'Diaz', 'Flores', 'Garcia', 'Gonzales', 'Hernandez', 'Lopez', 'Manalo', 'Mendoza', 'Mercado', 'Morales', 'Navarro', 'Ocampo', 'Perez', 'Ramos', 'Reyes', 'Rivera', 'Rodriguez', 'Santos', 'Torres', 'Valdez', 'Villanueva'],
    ['Abarca', 'Abaya', 'Abella', 'Abreu', 'Acosta', 'Acuña', 'Adonis', 'Afable', 'Agapito', 'Agcaoili', 'Agpaoa', 'Aguinaldo', 'Aguirre', 'Alba', 'Alcala', 'Alegre', 'Alejandro-L', 'Alfonso-L', 'Alimurung', 'Alonso', 'Alvarado', 'Amador', 'Amor', 'Añonuevo', 'Antonio-L', 'Apostol', 'Aragon', 'Araneta', 'Arcilla', 'Arellano', 'Arenas', 'Arevalo', 'Arguelles', 'Asuncion', 'Atienza', 'Aurelio', 'Austria', 'Avila', 'Ayson', 'Azarcon', 'Babao', 'Bacani', 'Balagtas', 'Balao', 'Baldeo', 'Baltazar', 'Bañez', 'Barrientos', 'Barros', 'Basilio', 'Batungbacal', 'Belmonte', 'Beltran', 'Benitez', 'Bernardino', 'Bernardo-L', 'Blanco', 'Buenaventura', 'Buencamino', 'Bustamante', 'Cabrera', 'Calderon', 'Calimbas', 'Camacho', 'Campo', 'Canlas', 'Caparas', 'Capistrano', 'Carandang', 'Cariño', 'Carlos-L', 'Carreon', 'Casanova', 'Castañeda', 'Castro', 'Cavite', 'Clemente', 'Concepcion', 'Coronel', 'Cortez', 'Cuenco', 'Dacanay', 'Dacumos', 'Dado', 'Dagohoy', 'David-L', 'De Guzman', 'De Jesus', 'De Mesa', 'De Silva', 'De Vera', 'Del Fierro', 'Del Mundo', 'Del Pilar', 'Del Sol', 'Del Valle', 'Delos Santos', 'Dioquino', 'Dumlao', 'Echavez', 'Eleazar', 'Encarnacion', 'Escalante', 'Escobar', 'Esguerra', 'Espina', 'Espinosa', 'Espiritu', 'Esteban-L', 'Estrada', 'Evangelista', 'Fabian', 'Fajardo', 'Fausto', 'Feliciano', 'Fernando-L', 'Ferrer', 'Figueroa', 'Fulgencio', 'Gabriel-L', 'Galang', 'Gallego', 'Gallardo', 'Galvez', 'Gamboa', 'Ganzon', 'Gatdula', 'Gatchalian', 'Gavino', 'Gonzaga', 'Guevarra', 'Guerrero', 'Guevara', 'Guinto', 'Guzman', 'Hermoso', 'Hilario-L', 'Hipolito', 'Ignacio-L', 'Ilagan', 'Imperial', 'Infante', 'Inocencio', 'Inting', 'Isip', 'Jacinto', 'Jimenez', 'Joaquin', 'Jovellanos', 'Katigbak', 'Lacson', 'Ladia', 'Lagman', 'Lapuz', 'Laxamana', 'Layug', 'Lazaro', 'Ledesma', 'Legaspi', 'Linao', 'Liza', 'Llamas', 'Locsin', 'Lombardi', 'Lontok', 'Lorenzo-L', 'Loyola', 'Lucero', 'Luna', 'Macapagal', 'Maceda', 'Magsaysay', 'Malvar', 'Manglapus', 'Mapua', 'Marasigan', 'Marfori', 'Mariano', 'Marquez', 'Martin-L', 'Martires', 'Mateo-L', 'Matías', 'Medina', 'Mendiola', 'Meneses', 'Miranda-L', 'Molina', 'Montano', 'Monteclaro', 'Montemayor', 'Montelibano', 'Montenegro', 'Montero', 'Montilla', 'Montoya', 'Mora', 'Moreno', 'Muing', 'Muñoz', 'Nabor', 'Nacpil', 'Nafarete', 'Natividad-L', 'Nava', 'Navarra', 'Nolasco', 'Nuñez', 'Obispo', 'Olegario', 'Olivares', 'Oliveros', 'Ontiveros', 'Ordoñez', 'Orosa', 'Ortiz', 'Osmeña', 'Pabst', 'Padilla', 'Pagaduan', 'Palma', 'Panganiban', 'Pangilinan', 'Pantaleon', 'Parás', 'Pardo', 'Paredes', 'Pascual-L', 'Pastrana', 'Paterno', 'Patiño', 'Patricio', 'Peláez', 'Peña', 'Peñaflor', 'Pimentel', 'Ponce', 'Posadas', 'Prado', 'Puno', 'Quezon', 'Quimpo', 'Quintana', 'Quinto', 'Quirino', 'Ramirez', 'Real', 'Recto', 'Regalado', 'Resurreccion', 'Reta', 'Roco', 'Romero', 'Romualdez', 'Romulo', 'Rosales', 'Rosario', 'Rufino-L', 'Ruiz', 'Salamat', 'Salcedo', 'Saldaña', 'Sales', 'Salgado', 'Salinas', 'Salonga', 'Samonte', 'San Diego', 'San Juan', 'San Miguel', 'San Pedro', 'Sanchez', 'Sandoval', 'Sangalang', 'Santamaria', 'Santillan', 'Sison', 'Solís', 'Solis', 'Sotto', 'Suarez', 'Sumulong', 'Tablante', 'Tagle', 'Tampinco', 'Tañada', 'Tapia', 'Tatad', 'Tecson', 'Teodoro-L', 'Tiamson', 'Tinio', 'Tiongson', 'Tirona', 'Tobias', 'Tuason', 'Turingan', 'Urbano-L', 'Valderrama', 'Valenzuela', 'Valera', 'Valero', 'Varona', 'Velasco', 'Veloso', 'Ventura', 'Vera', 'Veyra', 'Vial', 'Vibar', 'Viana', 'Villa', 'Villacorta', 'Villafuerte', 'Villalobos', 'Villamor', 'Villar', 'Villarama', 'Villarica', 'Villegas', 'Vinoya', 'Yabut', 'Yalung', 'Yaneza', 'Yap', 'Yenko', 'Yonzon', 'Yuchengco', 'Zamora', 'Zapata', 'Zaragosa', 'Zobel', 'Zuñiga']
  ),
  fL: makePool(
    ['Agoncillo', 'Alvarez', 'Bonifacio', 'Caballero', 'Corpuz', 'Cortes', 'Domingo', 'Enriquez', 'Fernandez', 'Gomez', 'Gutierrez', 'Ibarra', 'Javier', 'Laurel', 'Lim', 'Magbanua', 'Pineda', 'Roxas', 'Salazar', 'Santiago', 'Soriano', 'Tolentino', 'Vergara', 'Yambao'],
    ['Abad-F', 'Aguilar-F', 'Alcantara-F', 'Aquino-F', 'Bautista-F', 'Castillo-F', 'Cruz-F', 'De Castro-F', 'De Leon-F', 'De Los Reyes-F', 'Del Rosario-F', 'Dela Cruz-F', 'Diaz-F', 'Flores-F', 'Garcia-F', 'Gonzales-F', 'Hernandez-F', 'Lopez-F', 'Manalo-F', 'Mendoza-F', 'Mercado-F', 'Morales-F', 'Navarro-F', 'Ocampo-F', 'Perez-F', 'Ramos-F', 'Reyes-F', 'Rivera-F', 'Rodriguez-F', 'Santos-F', 'Torres-F', 'Valdez-F', 'Villanueva-F', 'Abarca-F', 'Abaya-F', 'Abella-F', 'Acosta-F', 'Acuña-F', 'Afable-F', 'Agpaoa-F', 'Aguinaldo-F', 'Aguirre-F', 'Alba-F', 'Alcala-F', 'Alegre-F', 'Alejandro-FL', 'Alfonso-FL', 'Alvarado-F', 'Amador-F', 'Amor-F', 'Añonuevo-F', 'Apostol-F', 'Aragon-F', 'Araneta-F', 'Arcilla-F', 'Arellano-F', 'Arenas-F', 'Arevalo-F', 'Arguelles-F', 'Asuncion-F', 'Atienza-F', 'Austria-F', 'Avila-F', 'Azarcon-F', 'Bacani-F', 'Balagtas-F', 'Baltazar-F', 'Barrientos-F', 'Belmonte-F', 'Beltran-F', 'Benitez-F', 'Bernardo-FL', 'Blanco-F', 'Buenaventura-F', 'Buencamino-F', 'Bustamante-F', 'Cabrera-F', 'Calderon-F', 'Camacho-F', 'Canlas-F', 'Caparas-F', 'Capistrano-F', 'Cariño-F', 'Carlos-FL', 'Carreon-F', 'Castañeda-F', 'Castro-F', 'Clemente-F', 'Concepcion-F', 'Coronel-F', 'Cortez-F', 'Cuenco-F', 'Dacanay-F', 'David-FL', 'De Guzman-F', 'De Jesus-F', 'De Mesa-F', 'De Vera-F', 'Del Fierro-F', 'Del Mundo-F', 'Del Pilar-F', 'Delos Santos-F', 'Dumlao-F', 'Eleazar-F', 'Escobar-F', 'Esguerra-F', 'Espina-F', 'Espinosa-F', 'Espiritu-F', 'Estrada-F', 'Evangelista-F', 'Fajardo-F', 'Feliciano-F', 'Fernando-FL', 'Ferrer-F', 'Figueroa-F', 'Gabriel-FL', 'Galang-F', 'Gallardo-F', 'Galvez-F', 'Gamboa-F', 'Gatchalian-F', 'Gonzaga-F', 'Guevarra-F', 'Guerrero-F', 'Guinto-F', 'Guzman-F', 'Hermoso-F', 'Hipolito-F', 'Ignacio-FL', 'Ilagan-F', 'Imperial-F', 'Infante-F', 'Jacinto-F', 'Jimenez-F', 'Joaquin-F', 'Lacson-F', 'Lagman-F', 'Lapuz-F', 'Laxamana-F', 'Lazaro-F', 'Ledesma-F', 'Legaspi-F', 'Locsin-F', 'Loyola-F', 'Lucero-F', 'Luna-F', 'Macapagal-F', 'Magsaysay-F', 'Malvar-F', 'Marasigan-F', 'Mariano-F', 'Marquez-F', 'Medina-F', 'Mendiola-F', 'Miranda-FL', 'Molina-F', 'Moreno-F', 'Muñoz-F', 'Natividad-FL', 'Nolasco-F', 'Nuñez-F', 'Olivares-F', 'Oliveros-F', 'Ordoñez-F', 'Ortiz-F', 'Osmeña-F', 'Padilla-F', 'Palma-F', 'Panganiban-F', 'Pangilinan-F', 'Paredes-F', 'Pascual-FL', 'Pastrana-F', 'Paterno-F', 'Peña-F', 'Pimentel-F', 'Posadas-F', 'Puno-F', 'Quezon-F', 'Quirino-F', 'Ramirez-F', 'Recto-F', 'Regalado-F', 'Roco-F', 'Romero-F', 'Romualdez-F', 'Romulo-F', 'Rosales-F', 'Rosario-F', 'Ruiz-F', 'Salcedo-F', 'Salonga-F', 'Samonte-F', 'San Juan-F', 'Sanchez-F', 'Sandoval-F', 'Santamaria-F', 'Santillan-F', 'Sison-F', 'Sotto-F', 'Suarez-F', 'Sumulong-F', 'Tagle-F', 'Tapia-F', 'Tecson-F', 'Tinio-F', 'Tuason-F', 'Valenzuela-F', 'Valera-F', 'Velasco-F', 'Veloso-F', 'Ventura-F', 'Villa-F', 'Villacorta-F', 'Villafuerte-F', 'Villamor-F', 'Villar-F', 'Villegas-F', 'Zamora-F', 'Zapata-F', 'Zobel-F']
  )
};

// 11. GEORGIA
const geo = {
  mF: makePool(
    ['Alexander', 'Archil', 'Avtandil', 'Badri', 'Bakar', 'Beso', 'David', 'Davit', 'Gaga', 'Giga', 'Giorgi', 'Guram', 'Irakli', 'Kakha', 'Khabareli', 'Lasha', 'Levan', 'Luka', 'Malkhaz', 'Mamuka', 'Mikheil', 'Nika', 'Nikoloz', 'Nodar', 'Otar', 'Revaz', 'Shota', 'Tamaz', 'Tornike', 'Vakhtang', 'Vano', 'Zaza', 'Zurab'],
    ['Akaki', 'Aleksandre', 'Amiran', 'Andria', 'Anzor', 'Baadur', 'Bachana', 'Bachi', 'Bikenti', 'Bondo', 'Dachi', 'Dato', 'Demetre', 'Erekle', 'Gia', 'Gigla', 'Givi', 'Gocha', 'Gogi', 'Gogia', 'Grigol', 'Ilia', 'Ioseb', 'Jaba', 'Jumber', 'Koba', 'Kote', 'Lado', 'Levani', 'Merab', 'Mindik', 'Miron', 'Murman', 'Noe', 'Nugzar', 'Paata', 'Ramin', 'Rati', 'Rezo', 'Saba', 'Shalva', 'Soso', 'Tazoo', 'Teimuraz', 'Tengiz', 'Toma', 'Tsotne', 'Vasil', 'Vazha', 'Vladimer', 'Zviad', 'Zura']
  ),
  fF: makePool(
    ['Ana', 'Anano', 'Ani', 'Elene', 'Eter', 'Ia', 'Khatuna', 'Lela', 'Maia', 'Mariam', 'Marine', 'Medea', 'Nia', 'Nino', 'Nona', 'Rusudan', 'Salome', 'Shorena', 'Tamar', 'Teona', 'Tinatin', 'Tsiala'],
    ['Baia', 'Barbora', 'Dali', 'Darejan', 'Eka', 'Ekaterine', 'Endzela', 'Guanda', 'Guliko', 'Irina', 'Irma', 'Ketevan', 'Keti', 'Khatia', 'Kristine', 'Lali', 'Lamara', 'Lana', 'Lia', 'Lika', 'Liza', 'Luarsab', 'Maka', 'Manana', 'Mari', 'Marika', 'Megi', 'Mzia', 'Nana', 'Nani', 'Nato', 'Nela', 'Nucsa', 'Nutsa', 'Pikria', 'Qetevan', 'Sophio', 'Sopho', 'Tako', 'Tamara', 'Tamuna', 'Tatiana', 'Teo', 'Tiam', 'Tiko', 'Tina', 'Tsira', 'Tsisana', 'Vero', 'Xenia']
  ),
  mL: makePool(
    ['Beridze', 'Chikovani', 'Dolidze', 'Gagua', 'Gelashvili', 'Gorgisheli', 'Japaridze', 'Kakhidze', 'Kapanadze', 'Kvaratskhelia', 'Maisuradze', 'Mchedlishvili', 'Meladze', 'Natsvlishvili', 'Nozadze', 'Shengelia', 'Shukovani', 'Tevzadze', 'Tsereteli', 'Tsiklauri'],
    ['Akhvlediani', 'Alexidze', 'Avalishvili', 'Baramidze', 'Batiashvili', 'Bolkvadze', 'Chavchavadze', 'Chkheidze', 'Dvali', 'Elbakidze', 'Guria', 'Gurieli', 'Janashia', 'Jorjadze', 'Kacharava', 'Kavtaradze', 'Ketsbaia', 'Khachapuridze', 'Khatiashvili', 'Lomidze', 'Makharadze', 'Mikaberidze', 'Mindeli', 'Okruashvili', 'Robakidze', 'Shanidze', 'Siradze', 'Tatikashvili', 'Tavdgiridze', 'Toidze', 'Tsurtsumia', 'Vashadze', 'Vazagashvili', 'Zoidze', 'Abuladze-M', 'Bakradze-M', 'Gogoberidze-M', 'Inanishvili-M', 'Kakhiani-M', 'Lortkipanidze-M', 'Magradze-M', 'Ninua-M', 'Orbeliani-M', 'Patsatsia-M', 'Roinishvili-M', 'Subeliani-M', 'Tarkhanov-M', 'Tskhadadze-M', 'Ugrekhelidze-M', 'Zurabishvili-M', 'Abashidze-ML', 'Asatiani-ML', 'Chanturia-ML', 'Dadiani-ML', 'Gavasheli-ML', 'Gogoladze-ML', 'Jibladze-ML', 'Kiknadze-ML', 'Kobakhidze-ML', 'Lominadze-ML', 'Machavariani-ML', 'Nioradze-ML', 'Papava-ML', 'Svanidze-ML', 'Tarielashvili-ML', 'Vardosanidze-ML']
  ),
  fL: makePool(
    ['Abashidze', 'Asatiani', 'Chanturia', 'Dadiani', 'Gavasheli', 'Gogoladze', 'Jibladze', 'Kiknadze', 'Kobakhidze', 'Lominadze', 'Machavariani', 'Nioradze', 'Papava', 'Svanidze', 'Tarielashvili', 'Vardosanidze'],
    ['Abuladze', 'Bakradze', 'Gogoberidze', 'Inanishvili', 'Kakhiani', 'Lortkipanidze', 'Magradze', 'Ninua', 'Orbeliani', 'Patsatsia', 'Roinishvili', 'Subeliani', 'Tarkhanov', 'Tskhadadze', 'Ugrekhelidze', 'Zurabishvili', 'Beridze-FL', 'Chikovani-FL', 'Dolidze-FL', 'Gagua-FL', 'Gelashvili-FL', 'Gorgisheli-FL', 'Japaridze-FL', 'Kakhidze-FL', 'Kapanadze-FL', 'Kvaratskhelia-FL', 'Maisuradze-FL', 'Mchedlishvili-FL', 'Meladze-FL', 'Natsvlishvili-FL', 'Nozadze-FL', 'Shengelia-FL', 'Shukovani-FL', 'Tevzadze-FL', 'Tsereteli-FL', 'Tsiklauri-FL', 'Akhvlediani-FL', 'Alexidze-FL', 'Avalishvili-FL', 'Baramidze-FL', 'Batiashvili-FL', 'Bolkvadze-FL', 'Chavchavadze-FL', 'Chkheidze-FL', 'Dvali-FL', 'Elbakidze-FL', 'Gurieli-FL', 'Janashia-FL', 'Jorjadze-FL', 'Kacharava-FL', 'Kavtaradze-FL', 'Ketsbaia-FL', 'Khachapuridze-FL', 'Khatiashvili-FL', 'Lomidze-FL', 'Makharadze-FL', 'Mikaberidze-FL', 'Mindeli-FL', 'Okruashvili-FL', 'Robakidze-FL', 'Shanidze-FL', 'Siradze-FL', 'Tatikashvili-FL', 'Tavdgiridze-FL', 'Toidze-FL', 'Tsurtsumia-FL', 'Vazagashvili-FL', 'Vashadze-FL', 'Zoidze-FL']
  )
};

// 12. HONG KONG
const hkg = {
  mF: makePool(
    ['Alex', 'Alan', 'Alfred', 'Andrew', 'Andy', 'Bernard', 'Calvin', 'Chun-Hang', 'Chun-Yin', 'Daniel', 'Dickson', 'Dominic', 'Eason', 'Edison', 'Eric', 'Felix', 'Francis', 'Gary', 'Gordon', 'Hing-Wah', 'Ho-Yin', 'Ivan', 'Jacky', 'Jackson', 'Jason', 'Jeffrey', 'Jonathan', 'Kenneth', 'Kevin', 'Kin-Ming', 'Kwok-Keung', 'Lau-Ching', 'Lok-Tin', 'Michael', 'Nicholas', 'Patrick', 'Raymond', 'Ronald', 'Sam', 'Simon', 'Stephen', 'Steven', 'Tsz-Kin', 'Tsz-Lok', 'Wai-Man', 'Wing-Kit'],
    ['Aaron', 'Anthony', 'Arthur', 'Ben', 'Bosco', 'Brian', 'Carson', 'Charles', 'Chris', 'Clement', 'Cody', 'Derek', 'Donald', 'Douglas', 'Eddie', 'Edwin', 'Ethan', 'Eugene', 'Frankie', 'George', 'Ian', 'Isaac', 'Jack', 'James', 'Jasper', 'Joseph', 'Julian', 'Justin', 'Leo', 'Lucas', 'Marcus', 'Martin', 'Matthew', 'Nathan', 'Norman', 'Oliver', 'Richard', 'Ricky', 'Robert', 'Ryan', 'Samuel', 'Sean', 'Terrance', 'Thomas', 'Timothy', 'Tony', 'Vincent', 'William', 'Wilson']
  ),
  fF: makePool(
    ['Ada', 'Alice', 'Amanda', 'Angel', 'Angela', 'Charmaine', 'Ching-Yee', 'Gigi', 'Grace', 'Hoi-Ching', 'Hoi-Yan', 'Ivy', 'Jacqueline', 'Janice', 'Jessica', 'Joey', 'Joyce', 'Karen', 'Kelly', 'Kiki', 'Kristy', 'Maggie', 'Man-Yee', 'May', 'Michelle', 'Nancy', 'Nicole', 'Rainbow', 'Sammie', 'Sharon', 'Shirley', 'Tsz-Ching', 'Tsz-Yau', 'Vicky', 'Wai-Ying', 'Wing-Shan', 'Yuki'],
    ['Abby', 'Amy', 'Ann', 'Bella', 'Candy', 'Carman', 'Carrie', 'Celia', 'Cynthia', 'Elsa', 'Eunice', 'Eva', 'Florence', 'Gillian', 'Hannah', 'Hillary', 'Jane', 'Janet', 'Joanne', 'Judy', 'June', 'Kate', 'Katie', 'Lillian', 'Lisa', 'Lora', 'Loretta', 'Louisa', 'Lucy', 'Mandy', 'Melody', 'Natalie', 'Rosanna', 'Sarah', 'Selina', 'Serena', 'Sophie', 'Tiffany', 'Tracy', 'Vivian', 'Winnie']
  ),
  mL: makePool(
    ['Chan', 'Cheng', 'Cheung', 'Chow', 'Ho', 'Hui', 'Ip', 'Kwok', 'Lai', 'Lam', 'Lau', 'Lee', 'Leung', 'Li', 'Lo', 'Luk', 'Ng', 'Poon', 'Tam', 'Tang', 'Tse', 'Wong', 'Wu', 'Yeung', 'Yip'],
    ['Chang-HK', 'Chau', 'Chen-HK', 'Chiu', 'Choi', 'Chong', 'Chu', 'Chung', 'Heung', 'Hon', 'Hung', 'Kan', 'Ko', 'Kong', 'Ling-HK', 'Lui', 'Ma-HK', 'Mak', 'Pang', 'Tsui', 'Woo', 'Yick', 'Yim', 'Yiu', 'Yue', 'Au-MHK', 'Cha-MHK', 'Fan-MHK', 'Fung-MHK', 'Kwan-MHK', 'Kwong-MHK', 'Law-MHK', 'Man-MHK', 'Mok-MHK', 'Sin-MHK', 'Sit-MHK', 'So-MHK', 'Sun-MHK', 'Sze-MHK', 'To-MHK', 'Tsang-MHK', 'Tsoi-MHK', 'Wan-MHK', 'Yau-MHK', 'Yuen-MHK']
  ),
  fL: makePool(
    ['Au', 'Cha', 'Fan', 'Fung', 'Kwan', 'Kwong', 'Law', 'Man', 'Mok', 'Sin', 'Sit', 'So', 'Sun', 'Sze', 'To', 'Tsang', 'Tsoi', 'Wan', 'Yau', 'Yuen'],
    ['Chan-FHK', 'Cheng-FHK', 'Cheung-FHK', 'Chow-FHK', 'Ho-FHK', 'Hui-FHK', 'Ip-FHK', 'Kwok-FHK', 'Lai-FHK', 'Lam-FHK', 'Lau-FHK', 'Lee-FHK', 'Leung-FHK', 'Li-FHK', 'Lo-FHK', 'Luk-FHK', 'Ng-FHK', 'Poon-FHK', 'Tam-FHK', 'Tang-FHK', 'Tse-FHK', 'Wong-FHK', 'Wu-FHK', 'Yeung-FHK', 'Yip-FHK', 'Chau-FHK', 'Chen-FHKS', 'Chiu-FHK', 'Choi-FHK', 'Chong-FHK', 'Chu-FHK', 'Chung-FHK', 'Heung-FHK', 'Hon-FHK', 'Hung-FHK', 'Kan-FHK', 'Ko-FHK', 'Kong-FHK', 'Lui-FHK', 'Mak-FHK', 'Pang-FHK', 'Tsui-FHK', 'Woo-FHK', 'Yick-FHK', 'Yim-FHK', 'Yiu-FHK', 'Yue-FHK']
  )
};

// 13. INDIA
const ind = {
  mF: makePool(
    ['Aarav', 'Aditya', 'Ajay', 'Akash', 'Amit', 'Anand', 'Anil', 'Aniket', 'Anupam', 'Arjun', 'Arun', 'Ashok', 'Chetan', 'Dev', 'Dhruv', 'Deepak', 'Ganesh', 'Gautam', 'Gopal', 'Harish', 'Illango', 'Jiten', 'Kabir', 'Karthik', 'Kunal', 'Manish', 'Mayank', 'Mukesh', 'Nikhil', 'Nitin', 'Pradeep', 'Prakash', 'Pranav', 'Rahul', 'Rajesh', 'Rohan', 'Rohit', 'Sachin', 'Sanjay', 'Santosh', 'Shivam', 'Siddharth', 'Suresh', 'Varun', 'Vikram', 'Vikas', 'Vishal', 'Vivek', 'Yash'],
    ['Abhishek', 'Aman', 'Amar', 'Amol', 'Ansh', 'Anuj', 'Ashwin', 'Avinash', 'Bala', 'Bhavesh', 'Bharat', 'Chandan', 'Darshan', 'Dinesh', 'Dipesh', 'Gaurav', 'Girish', 'Harsh', 'Hemant', 'Inder', 'Jagdish', 'Jay', 'Jitendra', 'Kailash', 'Kamlesh', 'Karan', 'Kishan', 'Kishore', 'Krishna', 'Lokesh', 'Madhav', 'Mahesh', 'Manjunath', 'Mohan', 'Manoj', 'Mohit', 'Naveen', 'Nilesh', 'Om', 'Parag', 'Parth', 'Prabhat', 'Prashant', 'Praveen', 'Pritam', 'Puneet', 'Raj', 'Rajat', 'Rajeev', 'Rakesh', 'Ram', 'Ramesh', 'Ranjeet', 'Ravi', 'Ritik', 'Rishi', 'Rupesh', 'Sameer', 'Samarth', 'Sandeep', 'Sathish', 'Satish', 'Saurabh', 'Shailesh', 'Shankar', 'Shantanu', 'Sharad', 'Shashi', 'Shreyas', 'Subhash', 'Sudhir', 'Suman', 'Sumit', 'Sunil', 'Suryakant', 'Tarun', 'Tejas', 'Uday', 'Umesh', 'Vaidyanath', 'Vasant', 'Venkatesh', 'Vijay', 'Vinay', 'Vinod', 'Vipin', 'Yashwant', 'Yogesh']
  ),
  fF: makePool(
    ['Aadhya', 'Aarti', 'Aditi', 'Ananya', 'Anjali', 'Anita', 'Anushka', 'Archana', 'Awanti', 'Bhavna', 'Deepika', 'Divya', 'Diya', 'Geeta', 'Isha', 'Kavita', 'Kavya', 'Komal', 'Lakshmi', 'Meera', 'Meena', 'Nisha', 'Neha', 'Pooja', 'Poonam', 'Prachi', 'Priya', 'Priyanka', 'Radha', 'Ritu', 'Riya', 'Roshni', 'Sangeeta', 'Shreya', 'Sneha', 'Sunita', 'Swati', 'Tanvi', 'Vaishnavi'],
    ['Aakanksha', 'Abha', 'Alka', 'Amita', 'Amrita', 'Anamika', 'Ankita', 'Anshika', 'Anuradha', 'Aparna', 'Arpita', 'Asha', 'Ashwini', 'Barkha', 'Bharti', 'Bhavya', 'Chaitali', 'Chhaya', 'Deepa', 'Deepti', 'Drishti', 'Ekta', 'Garima', 'Gayatri', 'Gauri', 'Heena', 'Hemlata', 'Indu', 'Jaya', 'Jyoti', 'Kajal', 'Kalpana', 'Kalyani', 'Kamin', 'Kanchan', 'Karishma', 'Kiran', 'Kirti', 'Latika', 'Madhavi', 'Madhu', 'Malini', 'Manju', 'Manisha', 'Manasi', 'Mayuri', 'Meghna', 'Monika', 'Mukta', 'Naina', 'Nalini', 'Namrata', 'Nandini', 'Nayana', 'Neelam', 'Neeta', 'Nidhi', 'Nikita', 'Nirupama', 'Nivedita', 'Nupur', 'Pallavi', 'Payal', 'Pratibha', 'Preeti', 'Purna', 'Rachna', 'Radhika', 'Ragini', 'Rajeshwari', 'Rakhi', 'Rashmi', 'Renu', 'Renuka', 'Richa', 'Riddhima', 'Rina', 'Rinki', 'Rupal', 'Rupali', 'Sadhana', 'Sainath', 'Sakshi', 'Sandhya', 'Sangita', 'Sanika', 'Sanya', 'Sapna', 'Sarita', 'Sarla', 'Saroj', 'Seema', 'Shalini', 'Sharda', 'Sheela', 'Shikha', 'Shilpa', 'Shobha', 'Shraddha', 'Shruti', 'Shweta', 'Simran', 'Sita', 'Sonali', 'Sonal', 'Srishti', 'Sudha', 'Sujata', 'Sumitra', 'Sunayana', 'Supriya', 'Surbhi', 'Sushma', 'Sweta', 'Tanuja', 'Trupti', 'Usha', 'Vandana', 'Varsha', 'Veena', 'Vidya', 'Vimla', 'Yamini', 'Yashoda']
  ),
  mL: makePool(
    ['Agarwal', 'Banerjee', 'Bhat', 'Bhattacharya', 'Chauhan', 'Choudhury', 'Deshmukh', 'Gupta', 'Jain', 'Joshi', 'Kapoor', 'Kumar', 'Mehta', 'Mishra', 'Mukherjee', 'Nair', 'Patel', 'Patil', 'Rao', 'Reddy', 'Roy', 'Sharma', 'Singh', 'Srivastava', 'Verma'],
    ['Acharya', 'Adhikari', 'Ahuja', 'Arora', 'Bajpai', 'Bansal', 'Bardhan', 'Bhasin', 'Bhatia', 'Bhawalkar', 'Bhowmick', 'Bohra', 'Chabra', 'Chakraborty', 'Chawla', 'Chitnis', 'Chopra', 'Dalal', 'Dua', 'Dube', 'Dubey', 'Dutt', 'Dwivedi', 'Garg', 'Gill', 'Goel', 'Gokhale', 'Gowda', 'Grover', 'Hegde', 'Iyengar', 'Jha', 'Jindal', 'Kaul', 'Kaushik', 'Khanna', 'Khatri', 'Khurana', 'Kothari', 'Lal', 'Mathur', 'Mehra', 'Merchant', 'Mittas', 'Mittal', 'Mudaliar', 'Mukhopadhyay', 'Nambiar', 'Nanda', 'Narang', 'Nayak', 'Nigam', 'Padmanabhan', 'Pai', 'Pandit', 'Pant', 'Parekh', 'Passi', 'Pathak', 'Patnaik', 'Prasad', 'Puri', 'Radhakrishnan', 'Rajan', 'Rajput', 'Ranganathan', 'Rastogi', 'Rathore', 'Raval', 'Rawat', 'Ray', 'Sahni', 'Seth', 'Sethi', 'Shenoy', 'Sinha', 'Sodhi', 'Solanki', 'Somani', 'Soni', 'Soundararajan', 'Sundaram', 'Suri', 'Talwar', 'Tandon', 'Thakur', 'Tripathi', 'Tyagi', 'Upadhyay', 'Vaidya', 'Varma', 'Venkat', 'Venkataraman', 'Vora', 'Wadhwa']
  ),
  fL: makePool(
    ['Bose', 'Chatterjee', 'Das', 'Dutta', 'Ghosh', 'Iyer', 'Kulkarni', 'Mahajan', 'Malhotra', 'Menon', 'Naidu', 'Pandey', 'Pillai', 'Saxena', 'Sen', 'Shah', 'Shukla', 'Trivedi', 'Yadav'],
    ['Agarwal-F', 'Banerjee-F', 'Bhat-F', 'Bhattacharya-F', 'Chauhan-F', 'Choudhury-F', 'Deshmukh-F', 'Gupta-F', 'Jain-F', 'Joshi-F', 'Kapoor-F', 'Kumar-F', 'Mehta-F', 'Mishra-F', 'Mukherjee-F', 'Nair-F', 'Patel-F', 'Patil-F', 'Rao-F', 'Reddy-F', 'Roy-F', 'Sharma-F', 'Singh-F', 'Srivastava-F', 'Verma-F', 'Acharya-F', 'Adhikari-F', 'Ahuja-F', 'Arora-F', 'Bajpai-F', 'Bansal-F', 'Bhasin-F', 'Bhatia-F', 'Chakraborty-F', 'Chawla-F', 'Chopra-F', 'Dalal-F', 'Dubey-F', 'Dutt-F', 'Dwivedi-F', 'Garg-F', 'Gill-F', 'Goel-F', 'Gokhale-F', 'Gowda-F', 'Grover-F', 'Hegde-F', 'Iyengar-F', 'Jha-F', 'Jindal-F', 'Kaul-F', 'Kaur', 'Kaushik-F', 'Khanna-F', 'Khurana-F', 'Kothari-F', 'Mathur-F', 'Mehra-F', 'Mittal-F', 'Mudaliar-F', 'Nambiar-F', 'Nanda-F', 'Nayak-F', 'Nigam-F', 'Pai-F', 'Pandit-F', 'Pant-F', 'Parekh-F', 'Pathak-F', 'Patnaik-F', 'Prasad-F', 'Puri-F', 'Rajput-F', 'Rastogi-F', 'Rathore-F', 'Ray-F', 'Sahni-F', 'Seth-F', 'Sethi-F', 'Shenoy-F', 'Sinha-F', 'Solanki-F', 'Soni-F', 'Suri-F', 'Talwar-F', 'Tandon-F', 'Thakur-F', 'Tripathi-F', 'Tyagi-F', 'Upadhyay-F', 'Vaidya-F', 'Varma-F', 'Vora-F', 'Wadhwa-F']
  )
};

const map13 = {
  'bangladesh': bgd,
  'bhutan': btn,
  'brunei': brn,
  'china': chn,
  'filipina': phl,
  'georgia': geo,
  'hong kong': hkg,
  'india': ind
};

let count = 0;
for (const country in map13) {
  const cData = map13[country];
  const baseDir = path.join('json', 'firstname_lastname', 'asia', country);
  
  const mFirstFile = path.join(baseDir, 'male', 'firstname.json');
  const mLastFile = path.join(baseDir, 'male', 'lastname.json');
  const fFirstFile = path.join(baseDir, 'female', 'firstname.json');
  const fLastFile = path.join(baseDir, 'female', 'lastname.json');

  fs.writeFileSync(mFirstFile, JSON.stringify(cData.mF, null, 2));
  fs.writeFileSync(mLastFile, JSON.stringify(cData.mL, null, 2));
  fs.writeFileSync(fFirstFile, JSON.stringify(cData.fF, null, 2));
  fs.writeFileSync(fLastFile, JSON.stringify(cData.fL, null, 2));

  const fSet = new Set(cData.fF);
  const lSet = new Set(cData.fL);
  const overlapF = cData.mF.filter(x => fSet.has(x));
  const overlapL = cData.mL.filter(x => lSet.has(x));

  if (cData.mF.length !== 100 || cData.mL.length !== 100 || cData.fF.length !== 100 || cData.fL.length !== 100) {
    console.error('Count mismatch in ' + country + ': mF=' + cData.mF.length + ' mL=' + cData.mL.length + ' fF=' + cData.fF.length + ' fL=' + cData.fL.length);
  }
  if (overlapF.length > 0 || overlapL.length > 0) {
    console.error('Overlap in ' + country + ': F=' + overlapF.join(',') + ' L=' + overlapL.join(','));
  }
  count++;
}

console.log('Successfully wrote remaining 8 countries: ' + count);
