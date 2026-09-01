const fs = require('fs');
const path = require('path');

// Unique natural full real names dictionaries for each country to top up to 100 with zero suffixes/suffixes

const extraRealNames = {
  'armenia': {
    mL: ['Arakelyan', 'Avetyan', 'Asatryan', 'Badalyan', 'Baghdasaryan', 'Davtyan', 'Gasparyan', 'Ghazaryan', 'Ghazinyan', 'Karapetyan', 'Kirakosyan', 'Minasyan', 'Mirzoyan', 'Nazaryan', 'Sahakyan', 'Shahbazyan', 'Simonyan', 'Tadevosyan', 'Tovmasyan', 'Yeghiazaryan'],
    fL: ['Abrahamyan', 'Aleksanyan', 'Antonyan', 'Arzumanyan', 'Avagyan', 'Avetisyan', 'Babayan', 'Danielyan', 'Gevorgyan', 'Gharibyan', 'Grigoryan', 'Hakobyan', 'Harutyunyan', 'Hovhannisyan', 'Khachatryan', 'Manukyan', 'Margaryan', 'Martirosyan', 'Melkonyan', 'Mkrtchyan', 'Movsisyan', 'Petrosyan', 'Poghosyan', 'Sargsyan', 'Stepanyan', 'Vardanyan']
  },
  'azerbaijan': {
    mF: ['Araz', 'Cavit', 'Farhad', 'Gadir', 'Intigam', 'Jamil', 'Karam', 'Latif', 'Majid', 'Mansur', 'Naim', 'Natig', 'Nizam', 'Ogtay', 'Parviz', 'Qabil', 'Rahim', 'Razi', 'Sabuhi', 'Sarkhan'],
    mL: ['Agayev', 'Akhundov', 'Alasgarov', 'Alizade', 'Askerov', 'Bagirov', 'Bayramov', 'Dadashov', 'Geydarov', 'Gurbanov', 'Habibov', 'Hatamov', 'Huseynzade', 'Imanov', 'Isayev', 'Jabbarov', 'Khalilov', 'Mahmudov', 'Mansurov', 'Mehdiyev'],
    fF: ['Gulzar', 'Jala', 'Khatira', 'Manzar', 'Nailya', 'Pervin', 'Roza', 'Sevil', 'Shafag', 'Turan', 'Yulduz', 'Aytaj', 'Deniz', 'Ela', 'Fidan', 'Gulara', 'Inci', 'Laman', 'Maral', 'Nisa', 'Nur', 'Roya', 'Sadaf', 'Tahmina', 'Ziba'],
    fL: ['Agayeva', 'Akhundova', 'Alasgarova', 'Alizadeh', 'Askerova', 'Bagirova', 'Bayramova', 'Dadashova', 'Geydarova', 'Gurbanova', 'Habibova', 'Hatamova', 'Huseynzadeh', 'Imanova', 'Isayeva', 'Jabbarova', 'Khalilova', 'Mahmudova', 'Mansurova', 'Mehdiyeva']
  },
  'bahrain': {
    mF: ['Abdullatif', 'Abdulrasool', 'Aqeel', 'Fadel', 'Gazi', 'Haider', 'Hisham', 'Ilyas', 'Kadhem', 'Mahdi', 'Maki', 'Mohsen', 'Rashed', 'Redha', 'Salah', 'Sattar', 'Shaker', 'Yaser', 'Zaki', 'Adnan', 'Baqer', 'Fahad', 'Hani', 'Jalal', 'Mubarak', 'Naim', 'Radhi', 'Saeed', 'Sayed', 'Tariq'],
    mL: ['Al-Aali', 'Al-Adraj', 'Al-Baqali', 'Al-Darazi', 'Al-Hujairi', 'Al-Jamri', 'Al-Karani', 'Al-Khadem', 'Al-Marzooqi', 'Al-Maskati', 'Al-Mousawi', 'Al-Naimi', 'Al-Qallaf', 'Al-Sairafi', 'Al-Sari', 'Al-Sharaf', 'Al-Sitri', 'Al-Wadi', 'Al-Zain', 'Al-Abasi', 'Al-Alawi', 'Al-Binali', 'Al-Doseri', 'Al-Hassan', 'Al-Jowder', 'Al-Khalifa', 'Al-Mahmood', 'Al-Mansoor', 'Al-Marzooq', 'Al-Musawi'],
    fF: ['Batool', 'Hawra', 'Kulthum', 'Maimuna', 'Masooma', 'Radhiya', 'Rawayah', 'Razan', 'Ruqayya', 'Sabika', 'Sajeda', 'Sameera', 'Suad', 'Sundus', 'Tahereh', 'Zubayda', 'Amina', 'Anoud', 'Kawthar', 'Khadija', 'Latifa', 'Layla', 'Marwa', 'Maysoun', 'Munira', 'Nabila', 'Nadia', 'Najla', 'Nisreen', 'Rania', 'Saba', 'Salwa', 'Samira', 'Shatha', 'Siham', 'Sumaya', 'Wafa', 'Yasmin'],
    fL: ['Al-Abasi', 'Al-Alawi', 'Al-Binali', 'Al-Doseri', 'Al-Hassan', 'Al-Jowder', 'Al-Khalifa', 'Al-Mahmood', 'Al-Mansoor', 'Al-Marzooq', 'Al-Musawi', 'Al-Mutawa', 'Al-Noaimi', 'Al-Oraibi', 'Al-Qasim', 'Al-Sada', 'Al-Sayed', 'Al-Shirawi', 'Al-Zayani', 'Fakhro', 'Al-Ameri', 'Al-Arrayedh', 'Al-Asfoor', 'Al-Baharna', 'Al-Busmait', 'Al-Dallal', 'Al-Ghatam', 'Al-Hashemi', 'Al-Jalahma', 'Al-Kaabi', 'Al-Khan', 'Al-Khaja', 'Al-Mannai']
  },
  'bangladesh': {
    mL: ['Adhikary', 'Barua', 'Biswas', 'Brahma', 'Dasgupta', 'Dhar', 'Guha', 'Kabir', 'Kar', 'Mazumder', 'Mitra', 'Nag', 'Pal', 'Roy', 'Sengupta', 'Talukdar', 'Acharya', 'Bagchi', 'Bhattacharjee', 'Chakraborti', 'Chatterjee', 'Chaudhury', 'Choudhury', 'Dev', 'Dutt', 'Dutta', 'Ganguly', 'Ghosal', 'Kundu', 'Majumdar', 'Mukherjee', 'Nandi', 'Nath', 'Ray', 'Sanyal', 'Sen'],
    fF: ['Anika', 'Bipasha', 'Dola', 'Gita', 'Jahanara', 'Kalyani', 'Lina', 'Mimi', 'Nipa', 'Oishi', 'Rupa', 'Shampa', 'Tuba', 'Afreen', 'Barna', 'Dipa', 'Iffat', 'Jui', 'Kanta', 'Lipi', 'Mithila', 'Nisha', 'Orpa', 'Puja', 'Riya', 'Sonia', 'Trisha'],
    fL: ['Abedin', 'Anjum', 'Afroz', 'Azim', 'Bibi', 'Dilshad', 'Ferdousi', 'Gulshan', 'Hosneara', 'Kamrunnessa', 'Khanum', 'Khaleque', 'Mowla', 'Nasreen', 'Rani', 'Razzaque', 'Tabassum', 'Tazreen', 'Yasmeen', 'Zahed', 'Zohra', 'Barua', 'Biswas', 'Bhowmik', 'Chakraborty', 'Chowdhury', 'Das', 'Dhar', 'Dutta', 'Guha', 'Haque', 'Islam', 'Kazi', 'Kar', 'Khan', 'Majumder', 'Mitra', 'Nandy', 'Pal', 'Paul', 'Rahman', 'Roy', 'Saha', 'Sarkar', 'Sengupta', 'Siddique', 'Uddin', 'Zaman']
  },
  'bhutan': {
    mF: ['Bumthap', 'Chogyal', 'Daw', 'Gyaltson', 'Jigme', 'Khandu', 'Lhakpa', 'Nidup', 'Passang', 'Phuntsho', 'Rinchen', 'Sonam', 'Tashi', 'Tenpa', 'Tenzin', 'Thinley', 'Tshering', 'Ugyen', 'Wangchuk', 'Yeshi', 'Yonten', 'Kezang', 'Kuenga', 'Kunzang', 'Loday', 'Lotay', 'Lubdak', 'Namgyal', 'Norbu', 'Penjor', 'Phurba', 'Samdrup', 'Tobgay', 'Tshewang', 'Zangpo', 'Chhogyel', 'Choda', 'Gayley', 'Gembo', 'Kinzang', 'Mingbo', 'Phub', 'Sampa', 'Singye', 'Tobgyel', 'Tshendu', 'Wangdi'],
    fF: ['Beda', 'Bida', 'Chhimi', 'Choden', 'Dechen', 'Deki', 'Dema', 'Dolma', 'Karma', 'Kinley', 'Kunzang', 'Lhamo', 'Namgay', 'Nima', 'Norbu', 'Passang', 'Pema', 'Phuntsho', 'Rinchen', 'Sangay', 'Sonam', 'Tandin', 'Tashi', 'Tenzin', 'Thinley', 'Tshering', 'Ugyen', 'Wangmo', 'Yangchen', 'Yangkyi', 'Yangzom', 'Yendon', 'Zangmo', 'Doma', 'Lhaden', 'Meto', 'Ringzin', 'Seldon', 'Yangdon', 'Yidon', 'Yuden', 'Damchoe', 'Lhadon', 'Rigzin', 'Dolkar', 'Lham', 'Chhoden'],
    mL: ['Acharya', 'Aryal', 'Baral', 'Bhatta', 'Bhujel', 'Bhurtel', 'Chaudhary', 'Dhungana', 'Gautam', 'Kadel', 'Kandel', 'Khanal', 'Khatiwoda', 'Khadka', 'Lamsal', 'Oli', 'Pant', 'Parajuli', 'Poudyal', 'Rai', 'Rimal', 'Sapkota', 'Sharma', 'Shrestha', 'Thapa'],
    fL: ['Adhikari', 'Bhandari', 'Bhattarai', 'Basnet', 'Chaudhary', 'Chetri', 'Dahal', 'Devkota', 'Gautam', 'Ghimire', 'Giri', 'Gurung', 'Karki', 'Khadka', 'Koirala', 'Lama', 'Magar', 'Neupane', 'Pandey', 'Pokhrel', 'Poudel', 'Pradhan', 'Rai', 'Rana', 'Regmi', 'Sharma', 'Sherpa', 'Shrestha', 'Subba', 'Tamang', 'Thapa', 'Timsina', 'Tiwari']
  },
  'brunei': {
    mF: ['Afif', 'Amir', 'Arif', 'Ashraf', 'Badrul', 'Danish', 'Farid', 'Faris', 'Fauzi', 'Hakim', 'Halim', 'Hasan', 'Husaini', 'Ikhwan', 'Imran', 'Irfan', 'Ismat', 'Izwan', 'Kamal', 'Khairi', 'Luqman', 'Naim', 'Nasruddin', 'Nazmi', 'Qawiem', 'Rafiq', 'Rashid', 'Ridzwan', 'Raziq', 'Shafiq', 'Syakir', 'Taufik', 'Zulfadhli'],
    mL: ['Ahmad', 'Ali', 'Arshad', 'Awang', 'Aziz', 'Bakar', 'Basir', 'Hassan', 'Hamid', 'Harun', 'Hashim', 'Idris', 'Ismail', 'Jamil', 'Kamal', 'Karim', 'Kassim', 'Latif', 'Mahmud', 'Majid', 'Naim', 'Nasir', 'Omar', 'Osman', 'Rahman', 'Rashid', 'Suhaili', 'Sulaiman', 'Tahir', 'Wahab', 'Yaakub', 'Zain', 'Zakaria'],
    fL: ['Abdullah', 'Ahmad', 'Ali', 'Ariffin', 'Awang', 'Aziz', 'Bakar', 'Basir', 'Hamid', 'Hassan', 'Ibrahim', 'Ismail', 'Jamil', 'Kamal', 'Karim', 'Kassim', 'Latif', 'Mahmud', 'Majid', 'Muhammad', 'Mustapa', 'Naim', 'Nasir', 'Omar', 'Osman', 'Othman', 'Pengiran', 'Rahman', 'Ramli', 'Rashid', 'Sabli', 'Saiful', 'Salleh', 'Sapar', 'Suhaili', 'Sulaiman', 'Tahir', 'Wahab', 'Yaakub', 'Yusof', 'Zainal', 'Zakaria']
  },
  'china': {
    mF: ['An', 'Biao', 'Bowen', 'Chang', 'Dian', 'Ding', 'Guangming', 'Guoliang', 'Hongjun', 'Hongwei', 'Jianfeng', 'Jianguo', 'Jianhua', 'Jiaming', 'Jianping', 'Junwei', 'Ming', 'Pei', 'Qing', 'Ruifeng', 'Shaohua', 'Song', 'Wei', 'Weihua', 'Weimin', 'Wenhua', 'Wenjun', 'Xiang', 'Xiaogang', 'Xinhai', 'Yilin', 'Yongjun', 'Yongqiang', 'Zhaohui', 'Zhenhua', 'Zhiqiang', 'Zhiwei'],
    mL: ['Cai', 'Cao', 'Dong', 'Fan', 'Fang', 'Fu', 'Han', 'Hao', 'Jia', 'Jiang', 'Jin', 'Kang', 'Liang', 'Lu', 'Pan', 'Peng', 'Qian', 'Qin', 'Qiu', 'Song', 'Tang', 'Tian', 'Wan', 'Wei', 'Wen', 'Xia', 'Xiao', 'Xu', 'Xue', 'Yan', 'Yu', 'Yuan', 'Zeng', 'Zhong'],
    fL: ['An', 'Bai', 'Bi', 'Chang', 'Chen', 'Cheng', 'Dai', 'Deng', 'Ding', 'Du', 'Fang', 'Feng', 'Fu', 'Gao', 'Gu', 'Guo', 'He', 'Hou', 'Hu', 'Huang', 'Jin', 'Kang', 'Lai', 'Lang', 'Li', 'Liao', 'Lin', 'Liu', 'Luo', 'Ma', 'Meng', 'Mo', 'Qian', 'Qin', 'Qiu', 'Ren', 'Shen', 'Su', 'Sun', 'Wang', 'Wen', 'Wu', 'Xia', 'Xie', 'Xiong', 'Xue', 'Yan', 'Yang', 'Ye', 'Yin', 'Yu', 'Zhan', 'Zhang', 'Zhao', 'Zheng', 'Zhou', 'Zhu', 'Zou']
  },
  'georgia': {
    mF: ['Akaki', 'Aleksandre', 'Amiran', 'Andria', 'Anzor', 'Baadur', 'Bachana', 'Bachi', 'Bikenti', 'Bondo', 'Dachi', 'Dato', 'Demetre', 'Erekle', 'Gia', 'Gigla', 'Givi', 'Gocha', 'Gogi', 'Gogia', 'Grigol', 'Ilia', 'Ioseb', 'Jaba', 'Jumber', 'Koba', 'Kote', 'Lado', 'Levani', 'Merab', 'Mindik', 'Miron', 'Murman', 'Noe', 'Nugzar', 'Paata', 'Ramin', 'Rati', 'Rezo', 'Saba', 'Shalva', 'Soso', 'Tazoo', 'Teimuraz', 'Tengiz', 'Toma', 'Tsotne', 'Vasil', 'Vazha', 'Vladimer', 'Zviad', 'Zura'],
    mL: ['Abuladze', 'Bakradze', 'Gogoberidze', 'Inanishvili', 'Kakhiani', 'Lortkipanidze', 'Magradze', 'Ninua', 'Orbeliani', 'Patsatsia', 'Roinishvili', 'Subeliani', 'Tarkhanov', 'Tskhadadze', 'Ugrekhelidze', 'Zurabishvili', 'Abashidze', 'Asatiani', 'Chanturia', 'Dadiani', 'Gavasheli', 'Gogoladze', 'Jibladze', 'Kiknadze', 'Kobakhidze', 'Lominadze', 'Machavariani', 'Nioradze', 'Papava', 'Svanidze', 'Tarielashvili', 'Vardosanidze'],
    fF: ['Baia', 'Barbora', 'Dali', 'Darejan', 'Eka', 'Ekaterine', 'Endzela', 'Guanda', 'Guliko', 'Irina', 'Irma', 'Ketevan', 'Keti', 'Khatia', 'Kristine', 'Lali', 'Lamara', 'Lana', 'Lia', 'Lika', 'Liza', 'Luarsab', 'Maka', 'Manana', 'Mari', 'Marika', 'Megi', 'Mzia', 'Nana', 'Nani', 'Nato', 'Nela', 'Nucsa', 'Nutsa', 'Pikria', 'Qetevan', 'Sophio', 'Sopho', 'Tako', 'Tamara', 'Tamuna', 'Tatiana', 'Teo', 'Tiam', 'Tiko', 'Tina', 'Tsira', 'Tsisana', 'Vero', 'Xenia'],
    fL: ['Beridze', 'Chikovani', 'Dolidze', 'Gagua', 'Gelashvili', 'Gorgisheli', 'Japaridze', 'Kakhidze', 'Kapanadze', 'Kvaratskhelia', 'Maisuradze', 'Mchedlishvili', 'Meladze', 'Natsvlishvili', 'Nozadze', 'Shengelia', 'Shukovani', 'Tevzadze', 'Tsereteli', 'Tsiklauri', 'Akhvlediani', 'Alexidze', 'Avalishvili', 'Baramidze', 'Batiashvili', 'Bolkvadze', 'Chavchavadze', 'Chkheidze', 'Dvali', 'Elbakidze', 'Gurieli', 'Janashia', 'Jorjadze', 'Kacharava', 'Kavtaradze', 'Ketsbaia', 'Khachapuridze', 'Khatiashvili', 'Lomidze', 'Makharadze', 'Mikaberidze', 'Mindeli', 'Okruashvili', 'Robakidze', 'Shanidze', 'Siradze', 'Tatikashvili', 'Tavdgiridze', 'Toidze', 'Tsurtsumia', 'Vazagashvili', 'Vashadze', 'Zoidze']
  },
  'hong kong': {
    mF: ['Aaron', 'Anthony', 'Arthur', 'Ben', 'Bosco', 'Brian', 'Carson', 'Charles', 'Chris', 'Clement', 'Cody', 'Derek', 'Donald', 'Douglas', 'Eddie', 'Edwin', 'Ethan', 'Eugene', 'Frankie', 'George', 'Ian', 'Isaac', 'Jack', 'James', 'Jasper', 'Joseph', 'Julian', 'Justin', 'Leo', 'Lucas', 'Marcus', 'Martin', 'Matthew', 'Nathan', 'Norman', 'Oliver', 'Richard', 'Ricky', 'Robert', 'Ryan', 'Samuel', 'Sean', 'Terrance', 'Thomas', 'Timothy', 'Tony', 'Vincent', 'William', 'Wilson'],
    mL: ['Au', 'Cha', 'Fan', 'Fung', 'Kwan', 'Kwong', 'Law', 'Man', 'Mok', 'Sin', 'Sit', 'So', 'Sun', 'Sze', 'To', 'Tsang', 'Tsoi', 'Wan', 'Yau', 'Yuen', 'Chang', 'Chau', 'Chen', 'Chiu', 'Choi', 'Chong', 'Chu', 'Chung', 'Heung', 'Hon', 'Hung', 'Kan', 'Ko', 'Kong', 'Ling', 'Lui', 'Ma', 'Mak', 'Pang', 'Tsui', 'Woo', 'Yick', 'Yim', 'Yiu', 'Yue'],
    fF: ['Abby', 'Amy', 'Ann', 'Bella', 'Candy', 'Carman', 'Carrie', 'Celia', 'Cynthia', 'Elsa', 'Eunice', 'Eva', 'Florence', 'Gillian', 'Hannah', 'Hillary', 'Jane', 'Janet', 'Joanne', 'Judy', 'June', 'Kate', 'Katie', 'Lillian', 'Lisa', 'Lora', 'Loretta', 'Louisa', 'Lucy', 'Mandy', 'Melody', 'Natalie', 'Rosanna', 'Sarah', 'Selina', 'Serena', 'Sophie', 'Tiffany', 'Tracy', 'Vivian', 'Winnie'],
    fL: ['Chan', 'Cheng', 'Cheung', 'Chow', 'Ho', 'Hui', 'Ip', 'Kwok', 'Lai', 'Lam', 'Lau', 'Lee', 'Leung', 'Li', 'Lo', 'Luk', 'Ng', 'Poon', 'Tam', 'Tang', 'Tse', 'Wong', 'Wu', 'Yeung', 'Yip', 'Chau', 'Chen', 'Chiu', 'Choi', 'Chong', 'Chu', 'Chung', 'Heung', 'Hon', 'Hung', 'Kan', 'Ko', 'Kong', 'Lui', 'Mak', 'Pang', 'Tsui', 'Woo', 'Yick', 'Yim', 'Yiu', 'Yue']
  }
};

const list13 = [
  'afganistan', 'arab saudi', 'armenia', 'azerbaijan', 'bahrain',
  'bangladesh', 'bhutan', 'brunei', 'china', 'filipina',
  'georgia', 'hong kong', 'india'
];

for (const country of list13) {
  const baseDir = path.join('json', 'firstname_lastname', 'asia', country);
  
  const mFPath = path.join(baseDir, 'male', 'firstname.json');
  const mLPath = path.join(baseDir, 'male', 'lastname.json');
  const fFPath = path.join(baseDir, 'female', 'firstname.json');
  const fLPath = path.join(baseDir, 'female', 'lastname.json');

  let mF = JSON.parse(fs.readFileSync(mFPath));
  let mL = JSON.parse(fs.readFileSync(mLPath));
  let fF = JSON.parse(fs.readFileSync(fFPath));
  let fL = JSON.parse(fs.readFileSync(fLPath));

  const extras = extraRealNames[country] || {};

  function topUp(list, sourceList) {
    const set = new Set(list);
    if (sourceList) {
      for (const item of sourceList) {
        if (set.size >= 100) break;
        if (!set.has(item)) {
          set.add(item);
          list.push(item);
        }
      }
    }
    return list.slice(0, 100);
  }

  mF = topUp(mF, extras.mF);
  mL = topUp(mL, extras.mL);
  fF = topUp(fF, extras.fF);
  fL = topUp(fL, extras.fL);

  fs.writeFileSync(mFPath, JSON.stringify(mF, null, 2));
  fs.writeFileSync(mLPath, JSON.stringify(mL, null, 2));
  fs.writeFileSync(fFPath, JSON.stringify(fF, null, 2));
  fs.writeFileSync(fLPath, JSON.stringify(fL, null, 2));
}

console.log('Top up complete!');
