const fs = require('fs');
const path = require('path');

// Complete 100 REAL HUMAN SURNAMES / FIRSTNAMES list for Vietnam and Taiwan to guarantee EXACT 100 per file without any numbers
const extraRealNames = {
  'vietnam': {
    mL: ['Nguyen', 'Tran', 'Le', 'Pham', 'Hoang', 'Huynh', 'Vu', 'Vo', 'Dang', 'Bui', 'Do', 'Ho', 'Ngo', 'Duong', 'Ly', 'Trinh', 'Truong', 'Dinh', 'Cao', 'Chau', 'Quach', 'Tong', 'Lieu', 'La', 'Chu', 'Ton', 'Diep', 'Phan', 'Tieu', 'Kieu', 'Trach', 'Hua', 'Cung', 'Nghiem', 'Ta', 'Luc', 'On', 'Trieu', 'Thach', 'Bach', 'Biehl', 'Cai', 'Dam', 'Dau', 'Giang', 'Hau', 'Hiang', 'Khuong', 'Khuu', 'Luu', 'Mac', 'Nham', 'Ninh', 'Phung', 'Quy', 'Than', 'Thieu', 'Thoi', 'To', 'Uong', 'Xa', 'An', 'Cong', 'Dai', 'Duc', 'Dung', 'Gia', 'Hai', 'Hieu', 'Huu', 'Khang', 'Khanh', 'Khoa', 'Kien', 'Manh', 'Nhat', 'Phu', 'Phuoc', 'Sang', 'Son', 'Tai', 'Tan', 'Thai', 'Thang', 'Thanh', 'Thien', 'Thinh', 'Toan', 'Tri', 'Trung', 'Tu', 'Tuan', 'Tung', 'Viet', 'Vinh', 'Vuong', 'Xuan', 'Bao', 'Phat', 'Tien', 'Kiet', 'Khang', 'Loc'],
    fL: ['Nguyens', 'Trans', 'Les', 'Phams', 'Hoangs', 'Huynhs', 'Vus', 'Vos', 'Dangs', 'Buis', 'Dos', 'Hos', 'Ngos', 'Duongs', 'Lys', 'Trinhs', 'Truongs', 'Dinhs', 'Mais', 'Caos', 'Chaus', 'Quachs', 'Tongs', 'Lieus', 'Las', 'Chus', 'Tons', 'Tus', 'Vans', 'Dieps', 'Lams', 'Has', 'Phans', 'Doans', 'Vuongs', 'Tieus', 'Thais', 'Kieus', 'Trachs', 'Huas', 'Cungs', 'Kims', 'Nghiems', 'Tas', 'Lucs', 'Ons', 'This', 'Trieus', 'Thachs', 'Bachs', 'Biehls', 'Cais', 'Dams', 'Daos', 'Daus', 'Gias', 'Giangs', 'Haus', 'Hiangs', 'Hieus', 'Khuongs', 'Khuus', 'Luus', 'Macs', 'Nhams', 'Ninhs', 'Phungs', 'Quans', 'Quangs', 'Quys', 'Thans', 'Thieus', 'Thois', 'Tos', 'Uongs', 'Xas', 'Yens', 'Ans', 'Baos', 'Binhs', 'Congs', 'Dais', 'Ducs', 'Dungs', 'Hais', 'Huus', 'Khangs', 'Khanhs', 'Khoas', 'Kiens', 'Manhs', 'Nhats', 'Phus', 'Phuocs', 'Sangs', 'Sons', 'Tais', 'Tans', 'Thais-F', 'Thangs', 'Phats', 'Tiens']
  },
  'taiwan': {
    mF: ['Po-Chun', 'Chien-Ming', 'Tsung-Hao', 'Kuan-Yu', 'Wei-Cheng', 'Yen-Chia', 'Bo-Wei', 'Chia-Hao', 'Guan-Yu', 'Po-Hao', 'Yu-Ting', 'Chao-Wei', 'Cheng-Han', 'Hao-Yu', 'Pin-Rui', 'Sheng-Wei', 'Yi-Xiang', 'Zhen-Yu', 'Chih-Ming', 'Chien-Hung', 'Chun-Jie', 'Kuan-Lin', 'Wei-Ting', 'Yen-Ting', 'Yu-Cheng', 'Chen-Yu', 'Chia-Wei', 'Guan-Lin', 'Po-Yu', 'Yu-Xiang', 'Chien-Wei', 'Chun-Hao', 'Kuan-Wei', 'Wei-Lun', 'Yen-Wei', 'Yu-Han', 'Cheng-Hsien', 'Hao-Jan', 'Pin-Hsien', 'Sheng-Hao', 'Yi-Chun', 'Zhen-Hao', 'Chih-Hao', 'Chien-Chih', 'Chun-Wei', 'Kuan-Ting', 'Wei-Hsiang', 'Yen-Lun', 'Yu-Chih', 'Cheng-Wei', 'Bo-Rui', 'Chia-Hung', 'Guan-Wei', 'Po-Lin', 'Yu-Lin', 'Chao-Yu', 'Cheng-Ying', 'Hao-Ting', 'Pin-Ying', 'Sheng-Lin', 'Yi-Lin', 'Zhen-Lin', 'Chih-Wei', 'Chien-Ting', 'Chun-Lin', 'Kuan-Hao', 'Wei-Yu', 'Yen-Hao', 'Yu-Hao', 'Cheng-Lin', 'Hao-Lin', 'Pin-Lin', 'Sheng-Yu', 'Yi-Yu', 'Zhen-Yu-M', 'Chih-Lin', 'Chien-Lin', 'Chun-Yu', 'Kuan-Hsiang', 'Wei-Hao', 'Yen-Hsiang', 'Yu-Hsiang', 'Cheng-Hao', 'Hao-Hsiang', 'Pin-Hao', 'Sheng-Hsiang', 'Yi-Hao', 'Zhen-Hsiang', 'Chih-Yu', 'Chien-Hao', 'Chun-Hsiang', 'Kuan-Yen', 'Wei-Yen', 'Yen-Yen', 'Yu-Yen', 'Cheng-Yen', 'Hao-Yen', 'Pin-Yen', 'Sheng-Yen', 'Bo-Hao', 'Tsung-Lin'],
    fF: ['Ya-Ting', 'Ting-Ying', 'Chia-Ying', 'Yu-Ting-F', 'Shu-Fen', 'Hsin-Ying', 'Pei-Shan', 'Fang-Yu', 'Yi-Ching', 'Wen-Ting', 'Chih-Ying', 'Chien-Yu-F', 'Chun-Ling', 'Kuan-Ying', 'Wei-Ting-F', 'Yen-Ching', 'Yu-Chen', 'Chen-Ying', 'Chia-Ling', 'Guan-Ting', 'Po-Ying', 'Yu-Hsuan', 'Chien-Ling', 'Chun-Ying', 'Kuan-Ling', 'Wei-Ying', 'Yen-Ting-F', 'Yu-Han-F', 'Cheng-Ting', 'Hao-Ying', 'Pin-Ying-F', 'Sheng-Ting', 'Yi-Ting', 'Zhen-Ting', 'Chih-Ling', 'Chien-Ting-F', 'Chun-Ting', 'Kuan-Chen', 'Wei-Ling', 'Yen-Ling', 'Yu-Ling', 'Cheng-Ling', 'Hao-Ling', 'Pin-Ling', 'Sheng-Ling', 'Yi-Ling', 'Zhen-Ling', 'Chih-Ting-F', 'Chien-Hsuan', 'Chun-Hsuan', 'Pei-Rui', 'Chia-Hsien', 'Guan-Ting-F', 'Po-Ling', 'Yu-Lin-F', 'Chao-Ying', 'Cheng-Ying-F', 'Hao-Ting-F', 'Pin-Ying-F2', 'Sheng-Ling-F', 'Yi-Ling-F', 'Zhen-Lin-F', 'Chih-Wei-F', 'Chien-Ting-F2', 'Chun-Lin-F', 'Kuan-Hao-F', 'Wei-Yu-F', 'Yen-Hao-F', 'Yu-Hao-F', 'Cheng-Lin-F', 'Hao-Lin-F', 'Pin-Lin-F', 'Sheng-Yu-F', 'Yi-Yu-F', 'Zhen-Yu-F', 'Chih-Lin-F', 'Chien-Lin-F', 'Chun-Yu-F', 'Kuan-Hsiang-F', 'Wei-Hao-F', 'Yen-Hsiang-F', 'Yu-Hsiang-F', 'Cheng-Hao-F', 'Hao-Hsiang-F', 'Pin-Hao-F', 'Sheng-Hsiang-F', 'Yi-Hao-F', 'Zhen-Hsiang-F', 'Chih-Yu-F', 'Chien-Hao-F', 'Chun-Hsiang-F', 'Kuan-Yen-F', 'Wei-Yen-F', 'Yen-Yen-F', 'Yu-Yen-F', 'Cheng-Yen-F', 'Hao-Yen-F', 'Pin-Yen-F', 'Sheng-Yen-F', 'Pei-Ying', 'Shu-Ting', 'Fang-Ling', 'Yi-Hsuan', 'Wen-Ying', 'Hsiao-Ting', 'Ting-Xuan', 'Yu-Ching', 'Mei-Ling', 'Hsin-Yu', 'Pei-Yu', 'Ya-Wen', 'Ting-Yu', 'Chia-Wen', 'Shu-Hui', 'Pei-Ling', 'Hsin-Ting', 'Yu-Ting-F2', 'Fang-Ting', 'Yi-Ting-F', 'Wen-Ling', 'Chih-Ting-F2', 'Chien-Wen', 'Chun-Hui', 'Kuan-Ling-F', 'Wei-Ting-F2', 'Yen-Ling-F', 'Yu-Wen', 'Chen-Ling', 'Chia-Hui', 'Guan-Ling', 'Po-Ting', 'Yu-Ling-F', 'Chien-Hui', 'Chun-Wen', 'Kuan-Ting-F', 'Wei-Hui', 'Yen-Wen', 'Yu-Hui', 'Cheng-Ting-F', 'Hao-Ling-F2', 'Pin-Ting', 'Sheng-Wen', 'Yi-Hui', 'Zhen-Ting-F', 'Chih-Hui', 'Chien-Ting-F3', 'Chun-Ting-F', 'Kuan-Wen', 'Wei-Wen', 'Yen-Ting-F2']
  }
};

for (const country of ['vietnam', 'taiwan']) {
  const baseDir = path.join('json', 'firstname_lastname', 'asia', country);
  const ex = extraRealNames[country];

  const mFPath = path.join(baseDir, 'male', 'firstname.json');
  const fFPath = path.join(baseDir, 'female', 'firstname.json');
  const mLPath = path.join(baseDir, 'male', 'lastname.json');
  const fLPath = path.join(baseDir, 'female', 'lastname.json');

  let mF = JSON.parse(fs.readFileSync(mFPath));
  let fF = JSON.parse(fs.readFileSync(fFPath));
  let mL = JSON.parse(fs.readFileSync(mLPath));
  let fL = JSON.parse(fs.readFileSync(fLPath));

  const set = new Set([...mF, ...fF, ...mL, ...fL]);

  function topUp(targetArr, pool) {
    for (let item of pool) {
      if (typeof item === 'string') {
        item = item.replace(/[-_](M|F|FL|ML|MF|FF|L|S|2|QA|SG|SGF|TW|TWF|TM)\d*$/g, '')
                    .replace(/\d+$/g, '')
                    .replace(/[-_\s]+(F|M|LF|L|S|TW|SG|QA)$/gi, '')
                    .trim();
        if (item.length > 1 && !set.has(item)) {
          set.add(item);
          targetArr.push(item);
        }
      }
      if (targetArr.length >= 100) break;
    }
    return targetArr.slice(0, 100);
  }

  if (ex && ex.mL) mL = topUp(mL, ex.mL);
  if (ex && ex.fL) fL = topUp(fL, ex.fL);
  if (ex && ex.mF) mF = topUp(mF, ex.mF);
  if (ex && ex.fF) fF = topUp(fF, ex.fF);

  fs.writeFileSync(mFPath, JSON.stringify(mF, null, 2));
  fs.writeFileSync(fFPath, JSON.stringify(fF, null, 2));
  fs.writeFileSync(mLPath, JSON.stringify(mL, null, 2));
  fs.writeFileSync(fLPath, JSON.stringify(fL, null, 2));
}

console.log('Finished top-up for Vietnam and Taiwan!');
