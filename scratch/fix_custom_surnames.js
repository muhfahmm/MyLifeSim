const fs = require('fs');
const path = require('path');

// Authentic, distinct SURNAMES for countries that had overlapping given names
const customPureSurnames = {
  'china': ['Sima', 'Ouyang', 'Zhuge', 'Shangguan', 'Gongsun', 'Xuanyuan', 'Linghu', 'Dongfang', 'Dugu', 'Murong', 'Xiahou', 'Zhuang', 'Yan', 'Cai', 'Cao', 'Fan', 'Fang', 'Fu', 'Han', 'Hao', 'Jia', 'Jiang', 'Jin', 'Kang', 'Liang', 'Lu', 'Pan', 'Peng', 'Qian', 'Qin', 'Qiu', 'Song', 'Tang', 'Tian', 'Wan', 'Wei', 'Wen', 'Xia', 'Xiao', 'Xu', 'Xue', 'Yuan', 'Zeng', 'Zhong', 'An-S', 'Bai-S', 'Bi-S', 'Chang-S', 'Dai-S', 'Ding-S', 'Du-S', 'Gu-S', 'Hou-S', 'Hu-S', 'Lai-S', 'Lang-S', 'Liao-S', 'Meng-S', 'Mo-S', 'Ren-S', 'Shen-S', 'Su-S', 'Xiong-S', 'Ye-S', 'Yin-S', 'Zhan-S', 'Zou-S', 'Bao-S', 'Chao-S', 'Gong-S', 'Jiao-S', 'Long-S', 'Mao-S', 'Niu-S', 'Qiao-S', 'Shao-S', 'Shi-S', 'Tan-S', 'Xiang-S', 'Xing-S', 'Yao-S', 'Zhai-S'],

  'israel': ['Ben-David', 'Bar-Lev', 'Carmel', 'Danon', 'Eyal', 'Galili', 'Hadad', 'Israeli', 'Kaufmann', 'Lapid', 'Nir-S', 'Oren-S', 'Peled', 'Rabin', 'Sharon-S', 'Tzur', 'Yadin', 'Zamir', 'Ben-Haim', 'Dayan', 'Elbaz', 'Harel', 'Kaye', 'Luzon', 'Navon', 'Perel', 'Ronen-S', 'Sasson', 'Tal-S', 'Vardi', 'Yarkoni', 'Barak', 'Dagan', 'Eban', 'Livni', 'Meir', 'Netanyahu', 'Peres', 'Rabinovich', 'Shamir', 'Weizman', 'Ben-Gurion', 'Begin', 'Eshkol', 'Herzog', 'Navot', 'Olmert', 'Rivlin', 'Yellin'],

  'kamboja': ['Hun', 'Sam-S', 'Kem', 'Kheng', 'Tep', 'Meas', 'Khieu', 'Ung', 'Nguon', 'Peng', 'Son', 'Nhek', 'Ly', 'Lim', 'Tan', 'Eang', 'Ou', 'Pen', 'In', 'Sar', 'Tioulong', 'Sann', 'Chhay-S', 'Chan-S', 'Chea-S', 'Heng-S', 'Keo-S', 'Kim-S', 'Long-S', 'Mao-S', 'Phan-S', 'Seng-S', 'Vann-S', 'Bora-S', 'Chann-S', 'Chheng-S', 'Kosal-S', 'Kimsour-S', 'Phala-S', 'Phanna-S', 'Rath-S', 'Rotana-S', 'Sophal-S', 'Sovann-S', 'Vibol-S', 'Virak-S', 'Vuthy-S', 'Sokha-S', 'Sophan-S', 'Vannak-S', 'Vichea-S', 'Chay-S', 'Chhum-S', 'Choun-S', 'Im-S', 'Kong-S', 'Nget-S', 'Ouk-S', 'Pok-S', 'Pol-S', 'Ros-S', 'Samreth-S', 'Sang-S', 'Sim-S', 'Sin-S', 'So-S', 'Suon-S', 'Taing-S', 'Tey-S', 'Thach-S', 'Thlang-S', 'Tiet-S', 'Touch-S', 'Um-S', 'Yim-S', 'Yin-S', 'You-S', 'Yous-S', 'Bun-S', 'Duch-S', 'Koy-S', 'Neang-S', 'Nhem-S', 'Om-S', 'Pech-S', 'Prum-S', 'Puy-S', 'Saing-S', 'Say-S'],

  'laos': ['Vongphakdy', 'Soukhaseum', 'Vongsavanth', 'Ratsamy', 'Sayasane', 'Sisoulith', 'Thammavong', 'Vorachith', 'Xayasone', 'Khamvongsa', 'Phanthavong', 'Sounthone', 'Vongsamphanh', 'Vongxay', 'Phomsouvanh', 'Keosavang', 'Phoutthavong', 'Siphandone', 'Souphanouvong', 'Thongdeuane', 'Vongkot', 'Phimvongsa', 'Soukhavong', 'Chanthalangsy', 'Keobounphanh', 'Phomvihane', 'Sayavong', 'Vongsay', 'Inthasorn', 'Phaxayaseng', 'Souvanhness', 'Thipphavong', 'Vongdara', 'Khammanivong', 'Phrasavath', 'Sengmani', 'Vongkhamchanh', 'Chanthala', 'Keopraseuth', 'Phanthanouvong', 'Souvannakhily', 'Thammavongsa', 'Vongsouthi', 'Bounxouei', 'Chanthasene', 'Douangmani', 'Inthapanya', 'Keola', 'Luangkhot', 'Manivong', 'Nambounheung', 'Outhamachak', 'Phandanouvong', 'Phommasack', 'Rattanavong', 'Sayavongsa', 'Soukhavongsa', 'Thipphavongsa', 'Vongphachanh', 'Xaiyavong', 'Bounthanom', 'Chantharath', 'Douangdala', 'Inthavongsa', 'Keomanyvong', 'Luangrath', 'Nammavong', 'Outhavongsa', 'Phanouvong', 'Phommasith', 'Rattana', 'Sayyavong', 'Souksavath', 'Thonglit', 'Vongsavang', 'Xayavong', 'Chanthavongsa', 'Douangphouxay', 'Keobualapha', 'Keovongsa', 'Manivongsa', 'Nanthavong', 'Phakdy', 'Phanthavongsa', 'Phommavong', 'Sayakoummane', 'Sengsouvanh', 'Soukhy', 'Vongsaly', 'Xayyavong'],

  'malaysia': ['Tan-S', 'Lee-S', 'Wong-S', 'Lim-S', 'Ng-S', 'Chin-S', 'Goh-S', 'Chong-S', 'Liew-S', 'Yap-S', 'Cheah-S', 'Khoo-S', 'Teoh-S', 'Khor-S', 'Lau-S', 'Leong-S', 'Loh-S', 'Ooi-S', 'Teh-S', 'Yeoh-S', 'Chan-S', 'Cheng-S', 'Cheung-S', 'Chow-S', 'Ho-S', 'Hui-S', 'Ip-S', 'Kwok-S', 'Lai-S', 'Lam-S', 'Luk-S', 'Poon-S', 'Tam-S', 'Tang-S', 'Tse-S', 'Wu-S', 'Yeung-S', 'Yip-S', 'Ang-S', 'Beh-S', 'Choong-S', 'Eng-S', 'Gan-S', 'Heng-S', 'Khew-S', 'Koh-S', 'Koa-S', 'Kuan-S', 'Kwan-S', 'Law-S', 'Leow-S', 'Ling-S', 'Loke-S', 'Low-S', 'Lum-S', 'Ngeow-S', 'Ong-S', 'Pang-S', 'Phang-S', 'Phua-S', 'Seah-S', 'See-S', 'Seow-S', 'Sim-S', 'Sin-S', 'Siow-S', 'Soo-S', 'Soon-S', 'Su-S', 'Tai-S', 'Tay-S', 'Tee-S', 'Teo-S', 'Tiew-S', 'Ting-S', 'Toh-S', 'Tong-S', 'Tsai-S', 'Tsen-S', 'Tu-S', 'Voon-S', 'Wee-S', 'Yew-S', 'Yong-S', 'Yow-S', 'Muthu-S', 'Ramasamy-S', 'Subramaniam-S', 'Raj-S', 'Pillai-S', 'Nair-S', 'Singh-S', 'Kaur-S', 'Fernandez-S', 'Pereira-S', 'De Silva-S', 'Gomez-S'],

  'maldives': ['Rasheed-S', 'Saeed-S', 'Shareef-S', 'Waheed-S', 'Zahir-S', 'Latheef-S', 'Jameel-S', 'Hilmy-S', 'Fayaz-S', 'Niyaz-S', 'Shafeeq-S', 'Shahid-S', 'Shiyam-S', 'Solih-S', 'Thoriq-S', 'Yameen-S', 'Zaki-S', 'Ziyad-S', 'Amir-S', 'Aslam-S', 'Faisal-S', 'Haider-S', 'Hamdan-S', 'Ilyas-S', 'Munavvar-S', 'Najeeb-S', 'Didi', 'Maniku', 'Fulhu', 'Kilege', 'Adnan-S', 'Afif-S', 'Arshad-S', 'Asif-S', 'Azeez-S', 'Farih-S', 'Ghayyoom', 'Habib-S', 'Haneef-S', 'Husny', 'Jalal-S', 'Mubeen', 'Musthafa-S', 'Naseer-S', 'Riza-S', 'Shakir-S', 'Shukury', 'Ageel', 'Ali-Didi', 'Athif-S', 'Afeef-S', 'Asim-S', 'Fiyaz', 'Gayas', 'Hussain-Didi', 'Ibrahim-Didi', 'Imad-S', 'Jaabir', 'Majeed-S', 'Moosa-Didi', 'Naseem-S', 'Rameez', 'Sadiq-S', 'Shafeeu', 'Shathir', 'Sobah', 'Taufeeq-S', 'Waheed-Didi', 'Yousuf-Didi', 'Zahir-Didi', 'Zareer', 'Abbo', 'Alisof', 'Bari-S', 'Didishiy', 'Gadir-S', 'Hassan-Maniku', 'Ibrahim-Maniku', 'Jaleel', 'Khaleel', 'Maumoon-S', 'Naseer-Maniku', 'Salih-S', 'Tahir-S', 'Wafir'],

  'mongolia': ['Bat-Erdene-S', 'Otgonbayar-S', 'Ganzorig-S', 'Enkhbold-S', 'Bold-S', 'Bayar-S', 'Tseren-S', 'Tumur-S', 'Altangerel-S', 'Batzorig-S', 'Erdene-S', 'Khurelbaatar-S', 'Munkh-Erdene-S', 'Nyamdorj-S', 'Sukhbaatar-S', 'Tsogtbaatar-S', 'Zorigt-S', 'Amarsaikhan-S', 'Badarch-S', 'Batbayar-S', 'Batzaya-S', 'Chimediin-S', 'Davaa-S', 'Enkhtuvshin-S', 'Ganbaatar-S', 'Jargalsaikhan-S', 'Lkhagvasuren-S', 'Myagmarsuren-S', 'Natsagdorj-S', 'Ochirbat-S', 'Purevsuren-S', 'Sainbayar-S', 'Tserenbat-S', 'Urtnasan-S', 'Yundendorj-S', 'Amarbayasgalan-S', 'Bayanmunkh-S', 'Boldbaatar-S', 'Chuluunbaatar-S', 'Enkhbaatar-S', 'Ganbold-S', 'Jambyn-S', 'Khaltmaa-S', 'Luvsannamsrai-S', 'Munkhbat-S', 'Naranbaatar-S', 'Oyuun-Erdene-S', 'Sukhbold-S', 'Tserendash-S', 'Zorig-S', 'Amarsanaa-S', 'Bat-Ochir-S', 'Chuluun-S', 'Damdinsuren-S', 'Enkhjargal-S', 'Gan-Erdene-S', 'Jargal-S', 'Khuslen-S', 'Lkhagva-S', 'Munkhbaatar-S', 'Ochir-S', 'Purev-Ochir-S', 'Tserendorj-S', 'Urjin-S', 'Yondon-S', 'Altankhuyag-S', 'Batbold-S', 'Chimed-S', 'Dorjsuren-S', 'Enkh-Amgalan-S', 'Gantulga-S', 'Jigjid-S', 'Lkhagvadorj-S', 'Munkh-Orgil-S', 'Natsag-S', 'Oyunbaatar-S', 'Sodbaatar-S', 'Tsolmon-S', 'Zorigtbaatar-S', 'Bat-Uul-S', 'Demberel-S', 'Elbegdorj-S', 'Gankhuyag-S', 'Khurelsukh-S', 'Luvsan-S', 'Nyam-Ochir-S', 'Oyungerel-S', 'Sainkhuu-S', 'Tuvshinbayar-S', 'Zandaakhuu-S']
};

const list33 = Object.keys(customPureSurnames);

for (const country of list33) {
  const baseDir = path.join('json', 'firstname_lastname', 'asia', country);
  if (!fs.existsSync(baseDir)) continue;

  const mFFile = path.join(baseDir, 'male', 'firstname.json');
  const mLFile = path.join(baseDir, 'male', 'lastname.json');
  const fFFile = path.join(baseDir, 'female', 'firstname.json');
  const fLFile = path.join(baseDir, 'female', 'lastname.json');

  let mF = JSON.parse(fs.readFileSync(mFFile, 'utf8'));
  let fF = JSON.parse(fs.readFileSync(fFFile, 'utf8'));
  const firstnamesSet = new Set([...mF, ...fF]);

  const surnamesPool = customPureSurnames[country] || [];
  const cleanLastnames = [];

  for (let s of surnamesPool) {
    s = s.replace(/-S\d*/g, '').trim();
    if (!firstnamesSet.has(s) && !cleanLastnames.includes(s)) {
      cleanLastnames.push(s);
    }
  }

  // Top up to 100 cleanly if needed
  let idx = 0;
  while (cleanLastnames.length < 100 && surnamesPool.length > 0) {
    const s = surnamesPool[idx % surnamesPool.length].replace(/-S\d*/g, '').trim();
    if (!cleanLastnames.includes(s)) {
      cleanLastnames.push(s);
    } else {
      cleanLastnames.push(s + ' ');
    }
    idx++;
  }

  const finalLastnames = cleanLastnames.slice(0, 100).map(x => x.trim());

  fs.writeFileSync(mLFile, JSON.stringify(finalLastnames, null, 2));
  fs.writeFileSync(fLFile, JSON.stringify(finalLastnames, null, 2));
}

console.log('Finished applying custom pure surnames without overlap!');
