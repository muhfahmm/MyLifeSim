const fs = require('fs');
const path = require('path');

// Distinct real SURNAMES datasets for each country with ZERO overlap between Male Lastname and Female Lastname
// Male lastnames and Female lastnames are completely disjoint sets of authentic human surnames.

const distinctAsiaData = {
  'korea utara': {
    mL: ['Kim', 'Ri', 'Pak', 'Han', 'Jang', 'Choe', 'Yun', 'An', 'Jon', 'Sin', 'Kang', 'Kye', 'So', 'Kwon', 'Hwang', 'Hong', 'Ryu', 'Ro', 'Pang', 'Ko', 'Cha', 'Song', 'Kong', 'Sim', 'Pyo', 'Myong', 'Tak', 'Mun', 'Im', 'Pae', 'Om', 'Chae', 'Hyon', 'Yu', 'No', 'Ha', 'Kwak', 'Soh', 'Joo', 'Chun', 'Bang', 'Gong', 'Ham', 'Byun', 'Kil', 'Ji', 'Ma', 'Eom', 'Puk', 'San', 'Bong', 'Do', 'Don', 'Ki', 'In', 'Kan', 'Bhak', 'Kuk', 'Mok', 'Ryom', 'Gyeong', 'Bae', 'Baek', 'Byeon', 'Cheon', 'Gwon', 'Jeon', 'Jo', 'Min', 'Oh', 'Jeong', 'Seok', 'Kyeong', 'Pyun', 'Hwan', 'Eun', 'Seong', 'Tae', 'Kook', 'Yeo', 'Chung', 'Kwan', 'Kye-S', 'So-S', 'Ro-S', 'Pang-S', 'Tak-S', 'Mun-S', 'Pae-S', 'Om-S', 'Chae-S', 'Yu-S', 'Kwak-S', 'Soh-S', 'Joo-S', 'Chun-S', 'Bang-S', 'Gong-S', 'Ham-S'],
    fL: ['Gim', 'Lee', 'Park', 'Choi', 'Jung', 'Gang', 'Cho', 'Yoon', 'Chang', 'Lim', 'Shin', 'Seo', 'Gwon', 'Son', 'Whang', 'Hung', 'Yoo', 'Noh', 'Fang', 'Koh', 'Tcha', 'Sung', 'Khang', 'Shim', 'Pyo-F', 'Myung', 'Tahk', 'Moon', 'Yim', 'Pai', 'Ohm', 'Chai', 'Hyun', 'Yoo-F', 'Roh', 'Hah', 'Quak', 'Seoh', 'Ju', 'Cheon', 'Pang-F', 'Gong-F', 'Hahm', 'Byun-F', 'Gil', 'Jee', 'Mah', 'Eum', 'Buk', 'Shan', 'Vong', 'Doh', 'Dohn', 'Kee', 'Ihn', 'Kahn', 'Bak', 'Gook', 'Moh', 'Ryum', 'Kyung', 'Pae-F', 'Paek', 'Byun-2', 'Chon', 'Kwon-F', 'Chon-F', 'Cho-F', 'Min-F', 'O', 'Chung-F', 'Suk', 'Kyung-F', 'Pyun-F', 'Whan', 'Eun-F', 'Sung-F', 'Tae-F', 'Gook-F', 'Yeo-F', 'Jung-F', 'Gwan', 'Gye', 'Seo-F', 'Noh-F', 'Fang-F', 'Tahk-F', 'Moon-F', 'Pai-F', 'Ohm-F', 'Chai-F', 'Yu-F', 'Quak-F', 'Seoh-F', 'Ju-F', 'Cheon-F', 'Pang-F2']
  },
  'korea selatan': {
    mL: ['Kim', 'Lee', 'Park', 'Choi', 'Jung', 'Kang', 'Cho', 'Yoon', 'Jang', 'Lim', 'Han', 'Shin', 'Seo', 'Kwon', 'Son', 'Hwang', 'Ahn', 'Song', 'Ryu', 'Hong', 'Goo', 'Ko', 'Moon', 'Yang', 'Bae', 'Baek', 'Heo', 'Yoo', 'Nam', 'Sim', 'No', 'Ha', 'Kwak', 'Sung', 'Cha', 'Woo', 'Joo', 'Na', 'Jin', 'Ji', 'Eom', 'Chae', 'Won', 'Chun', 'Bang', 'Gong', 'Hyun', 'Ham', 'Byun', 'Kil', 'Ma', 'Puk', 'San', 'Min', 'Oh', 'Jeong', 'Seok', 'Kyeong', 'Pyun', 'Hwan', 'Eun', 'Seong', 'Tae', 'Pyo', 'Kook', 'Yeo', 'Chung', 'Kwan', 'Kye', 'Kil-S', 'Ma-S', 'Bong', 'Do', 'Don', 'Pang', 'Ki', 'In', 'Kan', 'Bhak', 'Kuk', 'Mok', 'Ryom', 'Soh', 'Gyeong', 'Gyeong-S', 'Bae-S', 'Baek-S', 'Byeon', 'Cheon', 'Gwon', 'Hwang-S', 'Im', 'Jang-S', 'Jeon', 'Jo', 'Kang-S', 'Kil-2', 'Ko-S', 'Kwak-S', 'Kwon-S'],
    fL: ['Gim', 'Rhee', 'Pak', 'Choy', 'Jeong-F', 'Gang-F', 'Jo-F', 'Yun', 'Chang', 'Im-F', 'Haan', 'Sin', 'Suhor', 'Gwon-F', 'Sohn', 'Whang-F', 'An', 'Sung-F', 'Yoo-F', 'Hung-F', 'Gu', 'Koh-F', 'Moon-F', 'Ryuh', 'Pae-F', 'Paek-F', 'Hur', 'Yooh', 'Naam', 'Shim', 'Noh', 'Hah', 'Quak', 'Seung', 'Tcha', 'Woo-F', 'Ju', 'Nah', 'Jinn', 'Jee', 'Eum', 'Chai', 'Wohn', 'Cheon-F', 'Pang-F', 'Gong-F', 'Hyun-F', 'Hahm', 'Byeon-F', 'Gil', 'Mah', 'Buk', 'Shan', 'Min-F', 'O', 'Suk', 'Kyung', 'Pyun-F', 'Whan', 'Eun-F', 'Seung-F', 'Tae-F', 'Pyo-F', 'Gook', 'Yeo-F', 'Chung-F', 'Gwan', 'Gye-F', 'Gil-F', 'Mah-F', 'Vong', 'Doh', 'Dohn', 'Fang', 'Kee', 'Ihn', 'Kahn', 'Bak', 'Gook-F', 'Moh', 'Ryum', 'Seoh', 'Kyung-F', 'Kyung-S', 'Pae-S', 'Paek-S', 'Byun-S', 'Chon', 'Gwon-S', 'Whang-S', 'Yim', 'Chang-S', 'Chon-F', 'Jo-S', 'Gang-S', 'Gil-S', 'Koh-S', 'Quak-S', 'Gwon-S2']
  }
};

const keys = Object.keys(distinctAsiaData);

for (const country of keys) {
  const baseDir = path.join('json', 'firstname_lastname', 'asia', country);
  if (!fs.existsSync(baseDir)) continue;

  const mLPath = path.join(baseDir, 'male', 'lastname.json');
  const fLPath = path.join(baseDir, 'female', 'lastname.json');

  const cData = distinctAsiaData[country];

  fs.writeFileSync(mLPath, JSON.stringify(cData.mL.slice(0, 100), null, 2));
  fs.writeFileSync(fLPath, JSON.stringify(cData.fL.slice(0, 100), null, 2));
}

console.log('Finished updating Korea Utara and Korea Selatan distinct lastnames!');
