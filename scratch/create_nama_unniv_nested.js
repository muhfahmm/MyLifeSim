const fs = require('fs');
const path = require('path');

const baseKotaDir = 'c:/utama/project/project-sendiri/bitlife/json/nama_kota';
const baseUnivDir = 'c:/utama/project/project-sendiri/bitlife/json/nama_unniv';

if (!fs.existsSync(baseUnivDir)) {
  fs.mkdirSync(baseUnivDir, { recursive: true });
}

// Map database 10 universitas NEGERI dan 10 universitas SWASTA per negara
const univDB = {
  // --- AFRIKA ---
  "afrika selatan": {
    "negeri": ["Universitas Cape Town", "Universitas Witwatersrand", "Universitas Stellenbosch", "Universitas Pretoria", "Universitas Johannesburg", "Universitas KwaZulu-Natal", "Universitas Rhodes", "Universitas North-West", "Universitas Western Cape", "Universitas Teknologi Tshwane"],
    "swasta": ["Universitas Monash South Africa", "Kolej Universitas St Augustine", "Universitas Manajemen Southern Africa", "Institut Manajemen Henley", "Universitas Eduvos Cape Town", "Kolej Universitas IIE MSA", "Institut Regent Business School", "Kolej Boston City", "Kolej Universitas AFDA", "Institut Akuntansi Chartall"]
  },
  "aljazair": {
    "negeri": ["Universitas Sains dan Teknologi Houari Boumediene", "Universitas Algiers", "Universitas Constantine 1", "Universitas Oran 1", "Universitas Setif 1", "Universitas Tlemcen", "Universitas Bejaia", "Universitas Batna 1", "Universitas Annaba", "Universitas Biskra"],
    "swasta": ["Sekolah Tinggi Bisnis Algiers (MDBA)", "Universitas Internasional Algiers", "Institut Manajemen Bisnis Oran", "Sekolah Bisnis Informatika Constantine", "Institut Teknologi Terapan Annaba", "Universitas Politeknik Swasta Algiers", "Institut Manajemen Pariwisata Tlemcen", "Sekolah Bisnis Internasional Setif", "Institut Informatika Terapan Bejaia", "Universitas Ekonomi Swasta Batna"]
  },
  "angola": {
    "negeri": ["Universitas Agostinho Neto", "Universitas Mandume ya Ndemufayo", "Universitas Kimpa Vita", "Universitas Lueji A'Nkonde", "Universitas Katyavala Bwila", "Universitas Cuito Cuanavale", "Universitas 11 de Novembro", "Universitas Rainha Njinga a Mbandi", "Institut Politeknik Luanda", "Institut Ilmu Pendidikan Namibe"],
    "swasta": ["Universitas Katolik Angola", "Universitas Jean Piaget Angola", "Universitas Metodis Angola", "Universitas Gregório Semedo", "Universitas Belas", "Universitas Independen Angola", "Universitas Teknik Angola", "Universitas Óscar Ribas", "Universitas Utanga Luanda", "Institut Tinggi Bisnis Angola"]
  },
  "benin": {
    "negeri": ["Universitas Abomey-Calavi", "Universitas Parakou", "Universitas Nasional Sains Teknik Alakada", "Universitas Kétou", "Universitas Pertanian Porto-Novo", "Institut Teknologi Lokossa", "Universitas Ilmu Kesehatan Cotonou", "Institut Statistik Abomey", "Universitas Matematika Dangbo", "Sekolah Keguruan Porto-Novo"],
    "swasta": ["Universitas Katolik Afrika Barat", "Sekolah Tinggi Manajemen Cotonou", "Universitas GDI Benin", "Universitas Afrika Benin", "Universitas Pigier Benin", "Universitas ESM Benin", "Universitas Politeknik Internasional Benin", "Universitas Houdegbe North American", "Universitas Haute École de Commerce Cotonou", "Universitas IRGIB Africa"]
  },
  "botswana": {
    "negeri": ["Universitas Botswana", "Universitas Sains dan Teknologi Botswana (BIUST)", "Universitas Pertanian Botswana", "Kolej Teknologi Gaborone", "Kolej Keguruan Tlokweng", "Kolej Riset Kesehatan Botswana", "Kolej Akuntansi Botswana", "Kolej Pertanian Sebele", "Institut Pendidikan Francistown", "Kolej Teknik Lobatse"],
    "swasta": ["Kolej Universitas Botho", "Kolej Universitas Ba Isago", "Universitas Limkokwing Gaborone", "Universitas Manajemen Southern Africa Gaborone", "Institut Manajemen Publik Eswatini-Botswana", "Kolej Bisnis Gaborone", "Kolej Sains Kesehatan BUC", "Institut Teknologi Terapan Botho", "Sekolah Tinggi Pariwisata Maun", "Kolej Informatika Francistown"]
  },
  "burkina faso": {
    "negeri": ["Universitas Joseph Ki-Zerbo", "Universitas Nazi Boni", "Universitas Norbert Zongo", "Universitas Thomas Sankara", "Universitas Ouahigouya", "Universitas Fada N'Gourma", "Universitas Dédougou", "Universitas Kaya", "Universitas Gaoua", "Universitas Tenkodogo"],
    "swasta": ["Universitas Saint Thomas d'Aquin", "Universitas Aube Nouvelle", "Universitas Catholique de l'Afrique de l'Ouest", "Universitas Libre du Burkina", "Institut Sains Komputer Ouagadougou", "Universitas Bisnis Internasional Ouagadougou", "Institut Manajemen Sankara", "Universitas Sains Kesehatan Ouagadougou", "Sekolah Tinggi Komunikasi Burkina", "Institut Politeknik Aube"]
  },
  "burundi": {
    "negeri": ["Universitas Burundi", "Institut Keguruan Bujumbura", "Institut Kesehatan Masyarakat Bujumbura", "Universitas Pertanian Gitega", "Institut Sains Terapan Bujumbura", "Institut Statistik Burundi", "Universitas Teknik Gitega", "Kolej Militer Bujumbura", "Institut Administrasi Negara Burundi", "Sekolah Tinggi Hukum Bujumbura"],
    "swasta": ["Universitas Hope Africa", "Universitas Ngozi", "Universitas Light of Bujumbura", "Universitas Lake Tanganyika", "Universitas Martin Luther King", "Universitas Internasional Bujumbura", "Universitas Kebijaksanaan Burundi", "Universitas Katolik Bujumbura", "Universitas Grands Lacs", "Universitas Magesi Bujumbura"]
  },
  "chad": {
    "negeri": ["Universitas N'Djamena", "Universitas Adam Barka Abéché", "Universitas Doba", "Universitas Moundou", "Universitas Sarh", "Universitas Ati", "Universitas Mongo", "Sekolah Tinggi Teknik N'Djamena", "Institut Sains Komputer N'Djamena", "Universitas Sains Terapan Chad"],
    "swasta": ["Universitas HEC-Tchad", "Universitas Emi Koussi N'Djamena", "Institut Manajemen Bisnis N'Djamena", "Universitas Katolik Chad", "Institut Politeknik Swasta N'Djamena", "Universitas Sains Kesehatan Moundou", "Universitas Komunikasi Abéché", "Sekolah Bisnis Internasional Sarh", "Institut Pertanian Swasta Doba", "Universitas Informatika Chad"]
  },
  "djibouti": {
    "negeri": ["Universitas Djibouti", "Institut Teknologi Djibouti", "Kolej Kedokteran Djibouti", "Universitas Sains dan Ekonomi Djibouti", "Institut Administrasi Publik Djibouti", "Universitas Seni dan Bahasa Djibouti", "Sekolah Tinggi Maritim Djibouti", "Universitas Manajemen Djibouti", "Institut Keguruan Nasional Djibouti", "Universitas Riset Telekomunikasi Djibouti"],
    "swasta": ["Universitas Internasional Djibouti", "Institut Bisnis Swasta Djibouti", "Sekolah Tinggi Sains Informasi Djibouti", "Kolej Manajemen Red Sea", "Institut Teknologi Terapan Djibouti", "Kolej Sains Kesehatan Swasta Djibouti", "Institut Perdagangan Internasional Djibouti", "Universitas Bahasa dan Bisnis Djibouti", "Kolej Pariwisata Horn of Africa", "Institut Komputer Djibouti"]
  },
  "eritrea": {
    "negeri": ["Universitas Asmara", "Institut Teknologi Eritrea (Mai Nefhi)", "Kolej Bisnis dan Ekonomi Halhale", "Kolej Sains Kelautan Massawa", "Kolej Pertanian Hamelmalo", "Kolej Kedokteran Orotta", "Kolej Seni dan Ilmu Sosial Adi Keih", "Institut Kedokteran Asmara", "Kolej Teknik Asmara", "Institut Sains Terapan Asmara"],
    "swasta": ["Kolej Swasta Teknologi Asmara", "Institut Bisnis Internasional Eritrea", "Kolej Manajemen Red Sea Asmara", "Institut Bahasa Asmara", "Kolej Sains Komputer Terapan Massawa", "Institut Pariwisata Keren", "Sekolah Bisnis Halhale Swasta", "Kolej Kesehatan Masyarakat Asmara", "Institut Informatika Terapan Asmara", "Kolej Pertanian Swasta Hamelmalo"]
  },
  "eswatini": {
    "negeri": ["Universitas Eswatini", "Kolej Pertanian Eswatini", "Kolej Keguruan William Pitcher", "Kolej Teknologi Mbabane", "Kolej Manzini", "Institut Manajemen Publik Eswatini", "Kolej Sains Kesehatan Mbabane", "Institut Pendidikan Matsapha", "Kolej Teknik Piggs Peak", "Kolej Industri Nhlangano"],
    "swasta": ["Universitas Kristen Eswatini", "Universitas Teknologi Limkokwing Mbabane", "Kolej Keperawatan Nazarene", "Universitas Manajemen Southern Africa", "Institut Informatika Swasta Mbabane", "Kolej Bisnis Manzini", "Sekolah Tinggi Sains Terapan Eswatini", "Institut Komunikasi Mbabane", "Kolej Pariwisata Ezulwini", "Institut Akuntansi Eswatini"]
  },
  "ethiopia": {
    "negeri": ["Universitas Addis Ababa", "Universitas Jimma", "Universitas Gondar", "Universitas Bahir Dar", "Universitas Mekelle", "Universitas Hawassa", "Universitas Arba Minch", "Universitas Haramaya", "Universitas Dilla", "Universitas Wolaita Sodo"],
    "swasta": ["Universitas Unity Addis Ababa", "Universitas St. Mary Addis Ababa", "Universitas Rift Valley", "Universitas Admas", "Universitas CPU College", "Universitas CPU Business", "Universitas New Generation", "Universitas Alpha College", "Universitas MicroLink Information Technology", "Universitas Gage College"]
  },
  "gabon": {
    "negeri": ["Universitas Omar Bongo", "Universitas Sains dan Teknologi Masuku", "Universitas Kesehatan Gabon", "Institut Politeknik Libreville", "Institut Sains Informatika Gabon", "Universitas Pertanian Oyem", "Sekolah Keguruan Libreville", "Institut Kehutanan Port-Gentil", "Universitas Teknik Franceville", "Institut Kelautan Libreville"],
    "swasta": ["Universitas Internasional Libreville", "Institut Manajemen Gabon", "Universitas Franco-Gabonaise", "Universitas Bisnis Gabon", "Institut Teknologi Terapan Libreville", "Sekolah Bisnis Internasional Gabon", "Universitas Sains Kesehatan Swasta Libreville", "Institut Pariwisata Port-Gentil", "Universitas Informatika Gabon", "Kolej Manajemen Masuku"]
  },
  "gambia": {
    "negeri": ["Universitas Gambia", "Kolej Komunitas Gambia", "Institut Pelatihan Teknis Gambia (GPTI)", "Kolej Keguruan Gambia", "Institut Riset Kesehatan Gambia", "Kolej Pertanian Brikama", "Institut Publik Banjul", "Sekolah Keperawatan Banjul", "Institut Manajemen Komputer Gambia", "Kolej Maritim Banjul"],
    "swasta": ["Universitas Internasional American Gambia", "Kolej Manajemen Banjul", "Institut Jurnalisme Gambia", "Universitas Sains Teknologi Gambia", "Universitas Bisnis Serrekunda", "Institut Teknologi Terapan Gambia", "Sekolah Bisnis Internasional Banjul", "Kolej Kesehatan Swasta Serrekunda", "Institut Pariwisata Gambia", "Universitas Informatika West Africa"]
  },
  "ghana": {
    "negeri": ["Universitas Ghana (Legon)", "Universitas Sains dan Teknologi Kwame Nkrumah (KNUST)", "Universitas Cape Coast", "Universitas Pendidikan Winneba", "Universitas Studi Pembangunan (UDS)", "Universitas Pertambangan Tarkwa", "Universitas Kesehatan Ho", "Universitas Teknik Kumasi", "Universitas Teknik Accra", "Universitas Energi Sunyani"],
    "swasta": ["Universitas Ashesi", "Universitas Central Ghana", "Universitas Ghana Communication Technology", "Universitas Valley View", "Universitas Pentecost", "Universitas Academic City", "Universitas Regent Ghana", "Universitas Lancaster Ghana", "Universitas Wisconsin International Ghana", "Universitas Methodist Ghana"]
  },
  "guinea bissau": {
    "negeri": ["Universitas Amílcar Cabral", "Institut Teknologi Bissau", "Universitas Kedokteran Bissau", "Kolej Keguruan Bissau", "Institut Ekonomi Guinea Bissau", "Universitas Pertanian Bafatá", "Sekolah Perikanan Bissau", "Institut Kehutanan Cacheu", "Institut Hukum Bissau", "Kolej Sains Terapan Gabú"],
    "swasta": ["Universitas Colinas de Boé", "Universitas Jean Piaget Bissau", "Universitas Katolik Guinea Bissau", "Institut Manajemen Bisnis Bissau", "Sekolah Bisnis Internasional Bissau", "Universitas Informatika Terapan Bissau", "Institut Sains Kesehatan Swasta Bissau", "Kolej Teknologi Informasi Bissau", "Universitas Bahasa dan Komunikasi Bissau", "Institut Pariwisata Bissau"]
  },
  "guinea": {
    "negeri": ["Universitas Gamal Abdel Nasser Conakry", "Universitas Lansana Conté Sonfonia", "Universitas Julius Nyerere Kankan", "Universitas Labé", "Universitas Kindia", "Universitas N'Zérékoré", "Institut Politeknik Conakry", "Institut Kedokteran Conakry", "Universitas Pertanian Faranah", "Institut Pertambangan Boké"],
    "swasta": ["Universitas Kofi Annan Conakry", "Universitas Nongo Conakry", "Universitas Katolik Guinea", "Universitas Mercure International Conakry", "Universitas Mahatma Gandhi Conakry", "Universitas N'Zérékoré Swasta", "Institut Manajemen Bisnis Conakry", "Universitas Sains Terapan Guinea", "Sekolah Bisnis Internasional Conakry", "Universitas Komunikasi Guinea"]
  },
  "kenya": {
    "negeri": ["Universitas Nairobi", "Universitas Kenyatta", "Universitas Pertanian dan Teknologi Jomo Kenyatta (JKUAT)", "Universitas Moi", "Universitas Egerton", "Universitas Maseno", "Universitas Teknik Kenya", "Universitas Dedan Kimathi", "Universitas Eldoret", "Universitas Machakos"],
    "swasta": ["Universitas Strathmore", "Universitas Internasional Afrika Serikat (USIU)", "Universitas Baraton", "Universitas Daystar", "Universitas Mount Kenya", "Universitas Katolik Afrika Timur (CUEA)", "Universitas Kabarak", "Universitas St. Paul", "Universitas KCA", "Universitas Africa Nazarene"]
  },
  "komoro": {
    "negeri": ["Universitas Komoro", "Institut Teknologi Moroni", "Kolej Pertanian Komoro", "Institut Keguruan Komoro", "Kolej Kesehatan Komoro", "Institut Studi Islam Komoro", "Universitas Maritim Mutsamudu", "Kolej Ilmu Sosial Fomboni", "Institut Kelautan Anjouan", "Kolej Sains Terapan Mohéli"],
    "swasta": ["Universitas Sains Terapan Moroni", "Universitas Bisnis Mitsamiouli", "Institut Manajemen Swasta Moroni", "Sekolah Bisnis Internasional Komoro", "Universitas Informatika Terapan Moroni", "Kolej Pariwisata Anjouan", "Institut Sains Kesehatan Swasta Moroni", "Universitas Bahasa Komoro", "Kolej Komunikasi Mitsamiouli", "Institut Keuangan Moroni"]
  },
  "kongo": {
    "negeri": ["Universitas Marien Ngouabi", "Universitas Denis Sassou Nguesso", "Institut Teknologi Brazzaville", "Universitas Pertanian Pointe-Noire", "Institut Komunikasi Kongo", "Universitas Sains Terapan Dolisie", "Sekolah Keguruan Brazzaville", "Institut Kehutanan Ouesso", "Universitas Kelautan Pointe-Noire", "Institut Statistik Brazzaville"],
    "swasta": ["Universitas Libre Brazzaville", "Universitas Katolik kongo", "Universitas Manajemen Brazzaville", "Universitas Bisnis Pointe-Noire", "Institut Politeknik Swasta Brazzaville", "Universitas Informatika Terapan Pointe-Noire", "Sekolah Bisnis Internasional Kongo", "Institut Sains Kesehatan Swasta Brazzaville", "Universitas Teknologi Swasta Dolisie", "Kolej Manajemen Pointe-Noire"]
  },
  "lesotho": {
    "negeri": ["Universitas Nasional Lesotho", "Kolej Pertanian Lesotho", "Kolej Pendidikan Maluti", "Kolej Keperawatan Scott", "Kolej Teknologi Lerotholi", "Institut Manajemen Publik Lesotho", "Sekolah Keperawatan Maseru", "Institut Pendidikan Maseru", "Kolej Vokasi Roma", "Institut Teknik Mohale's Hoek"],
    "swasta": ["Universitas Teknologi Limkokwing Maseru", "Institut Manajemen Maseru", "Universitas Katolik Maseru", "Universitas Bisnis Lesotho", "Institut Studi Pembangunan Maseru", "Sekolah Bisnis Swasta Maseru", "Kolej Sains Kesehatan Swasta Lesotho", "Universitas Informatika Terapan Maseru", "Institut Akuntansi Lesotho", "Kolej Komunikasi Lesotho"]
  },
  "liberia": {
    "negeri": ["Universitas Liberia", "Universitas Tubman", "Kolej Komunitas Bassa", "Kolej Komunitas Booker Washington", "Kolej Komunitas Nimba", "Kolej Komunitas Sinoe", "Kolej Komunitas Grand Gedeh", "Kolej Komunitas Lofa", "Kolej Komunitas Bong", "Institut Pelatihan Teknis Monrovia"],
    "swasta": ["Universitas Cuttington", "Universitas Stella Maris", "Universitas African Methodist Episcopal (AME)", "Universitas United Methodist (UMU)", "Universitas Adventist West Africa", "Universitas Smythe Institute", "Universitas African Methodist Episcopal Zion", "Universitas Starz College", "Universitas Barshell University", "Universitas Blue Crest College"]
  },
  "libya": {
    "negeri": ["Universitas Tripoli", "Universitas Benghazi", "Universitas Sebha", "Universitas Misurata", "Universitas Sirte", "Universitas Omar Al-Mukhtar", "Universitas Zawiya", "Universitas Gharyan", "Universitas Tobruk", "Universitas Asmarya"],
    "swasta": ["Universitas Libya Internasional Medical (LIMU)", "Universitas Al-Raqi Benghazi", "Universitas Tripoli Swasta", "Institut Manajemen Bisnis Tripoli", "Universitas Sains Terapan Benghazi", "Universitas Teknologi Informasi Tripoli", "Sekolah Bisnis Internasional Misurata", "Institut Kedokteran Swasta Benghazi", "Universitas Informatika Libya", "Kolej Teknik Swasta Tripoli"]
  },
  "madagaskar": {
    "negeri": ["Universitas Antananarivo", "Universitas Toamasina", "Universitas Mahajanga", "Universitas Fianarantsoa", "Universitas Toliara", "Universitas Antsiranana", "Institut Teknologi Antananarivo", "Institut Pertanian Antananarivo", "Sekolah Keguruan Antananarivo", "Institut Perikanan Toliara"],
    "swasta": ["Universitas Katolik Madagaskar", "Institut Sains Terapan Antananarivo", "Universitas ISPM Antananarivo", "Universitas ACEEM Antananarivo", "Institut Manajemen Madagascar", "Universitas CNTEMAD", "Universitas Infocentre Antananarivo", "Sekolah Bisnis Internasional Toamasina", "Universitas Politeknik Swasta Antananarivo", "Institut Informatika Terapan Mahajanga"]
  },
  "malawi": {
    "negeri": ["Universitas Malawi", "Universitas Pertanian Lilongwe (LUANAR)", "Universitas Sains dan Teknologi Malawi (MUST)", "Universitas Mzuzu", "Kolej Keperawatan Kamuzu", "Kolej Politeknik Blantyre", "Institut Pendidikan Domasi", "Kolej Kedokteran Blantyre", "Kolej Pertanian Natural Resources", "Institut Manajemen Malawi"],
    "swasta": ["Universitas Katolik Malawi", "Universitas Adventist Malawi", "Universitas Solusi Malawi", "Universitas Pentecostal Malawi", "Universitas Nkhoma", "Universitas Eksplorasi Blantyre", "Universitas DMI-St. John Malawi", "Universitas Management Studies Blantyre", "Universitas Share World Open", "Kolej Bisnis Lilongwe"]
  },
  "mali": {
    "negeri": ["Universitas Bamako", "Universitas Sains Teknik Bamako", "Universitas Ségou", "Institut Politeknik Bamako", "Universitas Hukum Bamako", "Institut Kedokteran Mali", "Sekolah Keguruan Bamako", "Universitas Pertanian Katibougou", "Institut Statistik Bamako", "Universitas Sains Terapan Sikasso"],
    "swasta": ["Universitas Sango", "Universitas Katolik Mali", "Universitas Manajemen Bamako", "Universitas Bisnis Sikasso", "Universitas HEC-Mali", "Institut Bisnis Internasional Bamako", "Universitas Technolab-ISTA", "Universitas SUP'IMAM Bamako", "Institut Informatika Terapan Bamako", "Universitas Komunikasi Mali"]
  },
  "maroko": {
    "negeri": ["Universitas Mohammed V Rabat", "Universitas Cadi Ayyad Marrakech", "Universitas Hassan II Casablanca", "Universitas Sidi Mohamed Ben Abdellah Fez", "Universitas Ibn Tofail Kenitra", "Universitas Abdelmalek Essaâdi Tetouan", "Universitas Ibn Zohr Agadir", "Universitas Moulay Ismail Meknes", "Universitas Chouaib Doukkali El Jadida", "Universitas Sultan Moulay Slimane Beni Mellal"],
    "swasta": ["Universitas Al Akhawayn Ifrane", "Universitas Mohammed VI Sains Kesehatan", "Universitas Internasional Rabat (UIR)", "Universitas Internasional Casablanca", "Universitas Mundiapolis Casablanca", "Universitas Politeknik Mohammed VI", "Universitas Universiapolis Agadir", "Sekolah Manajemen HEM Casablanca", "Universitas Euromed Fez", "Institut Bisnis ESCA Casablanca"]
  },
  "mauritania": {
    "negeri": ["Universitas Nouakchott Al Aasriya", "Universitas Sains Teknologi Nouakchott", "Universitas Islam Nouakchott", "Institut Politeknik Nouakchott", "Sekolah Tinggi Tambang Mauritania", "Universitas Kedokteran Nouakchott", "Institut Keguruan Mauritania", "Universitas Maritim Nouadhibou", "Universitas Sains Terapan Rosso", "Institut Kehutanan Atar"],
    "swasta": ["Institut Manajemen Nouakchott", "Universitas Libanaise Nouakchott", "Universitas SUP MGT Nouakchott", "Sekolah Bisnis Internasional Mauritania", "Institut Informatika Terapan Nouakchott", "Universitas Sains Kesehatan Swasta Nouakchott", "Kolej Bisnis Nouadhibou", "Institut Komunikasi Nouakchott", "Universitas Bahasa Terapan Nouakchott", "Institut Keuangan Mauritania"]
  },
  "mauritius": {
    "negeri": ["Universitas Mauritius", "Universitas Teknologi Mauritius", "Universitas Sains Kesehatan Mauritius", "Universitas Terbuka Mauritius", "Institut Pendidikan Mauritius", "Institut Maritim Mauritius", "Kolej Politeknik Mauritius", "Institut Keuangan Mauritius", "Sekolah Keguruan Reduit", "Institut Riset Gula Mauritius"],
    "swasta": ["Universitas Curtin Mauritius", "Universitas Middlesex Mauritius", "Universitas Pantas Port Louis", "Kolej Manajemen Mauritius", "Universitas Charles Telfair", "Universitas Amity Mauritius", "Universitas Rushmore Business School", "Universitas Vatel Mauritius", "Universitas SUPINFO Mauritius", "Institut Bisnis EIILM Mauritius"]
  },
  "mesir": {
    "negeri": ["Universitas Kairo", "Universitas Ain Shams", "Universitas Alexandria", "Universitas Mansoura", "Universitas Al-Azhar", "Universitas Assiut", "Universitas Zagazig", "Universitas Helwan", "Universitas Suez Canal", "Universitas Tanta"],
    "swasta": ["Universitas Amerika di Kairo (AUC)", "Universitas Jerman di Kairo (GUC)", "Universitas Inggris di Mesir (BUE)", "Universitas Sains dan Teknologi Misr (MUST)", "Universitas Internasional Mesir (MIU)", "Universitas Modern Sciences & Arts (MSA)", "Universitas Future Egypt", "Universitas Badr Kairo", "Universitas Heliopolis", "Universitas Nile Giza"]
  },
  "mozambik": {
    "negeri": ["Universitas Eduardo Mondlane", "Universitas Pedagogis Mozambik", "Universitas Lúrio", "Universitas Zambeze", "Universitas Rovuma", "Universitas Púnguè", "Universitas Licungo", "Institut Kedokteran Maputo", "Institut Politeknik Tete", "Sekolah Keguruan Nampula"],
    "swasta": ["Universitas Katolik Mozambik", "Universitas São Tomás Mozambik", "Universitas Politeknik Maputo", "Universitas Teknik Mozambik", "Institut Internasional Mozambik", "Universitas Sains Kesehatan Maputo", "Universitas Wutivi Maputo", "Universitas ISCTEM Maputo", "Universitas Mussa Bin Bique", "Universitas Kebanggaan Beira"]
  },
  "namibia": {
    "negeri": ["Universitas Namibia (UNAM)", "Universitas Sains dan Teknologi Namibia (NUST)", "Kolej Pendidikan Windhoek", "Kolej Keperawatan Namibia", "Institut Maritim Namibia", "Universitas Pertanian Neudamm", "Kolej Vokasi Windhoek", "Institut Akuntansi Namibia", "Sekolah Tinggi Teknik Ongwediva", "Institut Kehutanan Ogongo"],
    "swasta": ["Universitas Manajemen Namibia (IUM)", "Universitas Teknologi Swakopmund", "Institut Bisnis Swasta Windhoek", "Sekolah Bisnis Internasional Namibia", "Universitas Informatika Terapan Windhoek", "Kolej Sains Kesehatan Swasta Namibia", "Institut Keuangan Windhoek", "Universitas Komunikasi Namibia", "Kolej Pariwisata Walvis Bay", "Institut Manajemen Publik Namibia"]
  },
  "niger": {
    "negeri": ["Universitas Abdou Moumouni Niamey", "Universitas Zinder", "Universitas Maradi", "Universitas Tahoua", "Universitas Agadez", "Universitas Diffa", "Universitas Dosso", "Universitas Tillabéri", "Institut Teknologi Niamey", "Sekolah Tambang Niamey"],
    "swasta": ["Universitas Islam Niger", "Universitas Swasta Niamey", "Institut Sains Manajemen Niamey", "Sekolah Bisnis Internasional Niger", "Universitas Informatika Terapan Niamey", "Institut Politeknik Swasta Zinder", "Universitas Sains Kesehatan Swasta Maradi", "Kolej Bisnis Tahoua", "Institut Komunikasi Niger", "Universitas Teknologi Terapan Niamey"]
  },
  "nigeria": {
    "negeri": ["Universitas Ibadan", "Universitas Lagos (UNILAG)", "Universitas Ahmadu Bello Zaria", "Universitas Obafemi Awolowo (OAU)", "Universitas Nigeria Nsukka", "Universitas Ilorin", "Universitas Benin", "Universitas Pertanian Abeokuta", "Universitas Teknologi Federal Akure", "Universitas Pertambangan Owerri"],
    "swasta": ["Universitas Covenant", "Universitas Babcock", "Universitas Afe Babalola", "Universitas Bowen", "Universitas Pan-Atlantic", "Universitas Nile Nigeria", "Universitas American University of Nigeria", "Universitas Redeemer's", "Universitas Bells Technology", "Universitas Lead City"]
  },
  "pantai gading": {
    "negeri": ["Universitas Félix Houphouët-Boigny", "Universitas Nangui Abrogoua", "Universitas Alassane Ouattara", "Universitas Jean Lorougnon Guédé", "Universitas Peleforo Gon Coulibaly", "Institut Politeknik Félix Houphouët-Boigny", "Universitas Man", "Universitas San Pedro", "Universitas Korhogo", "Institut Sains Komputer Abidjan"],
    "swasta": ["Universitas Katolik Afrika Barat", "Universitas Internasional Abidjan", "Universitas Sains Manajemen Abidjan", "Universitas Formatech Abidjan", "Universitas Pigier Pantai Gading", "Universitas HEC-Abidjan", "Universitas Atlantic Abidjan", "Universitas Sup'Elite Abidjan", "Institut Informatika Terapan Abidjan", "Universitas Teknologi Swasta Yamoussoukro"]
  },
  "republik afrika tengah": {
    "negeri": ["Universitas Bangui", "Institut Teknologi Bangui", "Universitas Sains Terapan Bangui", "Institut Pertanian Bangui", "Kolej Kesehatan Bangui", "Institut Keguruan Bangui", "Sekolah Hukum Bangui", "Institut Kehutanan Bouar", "Kolej Militer Bangui", "Institut Statistik Bangui"],
    "swasta": ["Universitas Euromed Bangui", "Universitas Katolik Bangui", "Universitas Bisnis Bangui", "Universitas Komunikasi Afrika Tengah", "Institut Manajemen Swasta Bangui", "Sekolah Bisnis Internasional Bangui", "Universitas Informatika Terapan Bangui", "Kolej Sains Kesehatan Swasta Bangui", "Institut Teknologi Terapan Bangui", "Universitas Bahasa Terapan Bangui"]
  },
  "republik demokratik kongo": {
    "negeri": ["Universitas Kinshasa (UNIKIN)", "Universitas Lubumbashi (UNILU)", "Universitas Kisangani (UNIKIS)", "Universitas Pedagogis Nasional Kinshasa", "Universitas Kikwit", "Universitas Mbandaka", "Universitas Kananga", "Institut Politeknik Kinshasa", "Institut Kedokteran Lubumbashi", "Sekolah Tambang Kolwezi"],
    "swasta": ["Universitas Katolik Kongo", "Universitas Kongo Goma", "Universitas Bukavu", "Universitas Protestan Kongo", "Universitas Teknik Kinshasa", "Universitas Bel-Air Lubumbashi", "Universitas Kebangkitan Kinshasa", "Universitas Supérieur d'Informatique Kinshasa", "Universitas William Booth Kinshasa", "Universitas Cepromad Kinshasa"]
  },
  "republik sudan": {
    "negeri": ["Universitas Khartoum", "Universitas Sains dan Teknologi Sudan", "Universitas Al-Jazeera", "Universitas Nil", "Universitas Omdurman Islamic", "Universitas Kordofan", "Universitas Kassala", "Universitas Dongola", "Universitas Red Sea", "Universitas Nyala"],
    "swasta": ["Universitas Afrika Internasional", "Universitas Ribat Nasional", "Universitas Future Sudan", "Universitas Ahfad untuk Wanita", "Universitas Bayan Sains Teknologi", "Universitas Ibn Sina Khartoum", "Universitas Al-Machtal Khartoum", "Universitas Kedokteran Swasta Khartoum", "Universitas Sains Terapan Omdurman", "Universitas Bisnis Khartoum"]
  },
  "republik tanzania": {
    "negeri": ["Universitas Dar es Salaam", "Universitas Pertanian Sokoine", "Universitas Muhimbili Sains Kesehatan", "Universitas Dodoma", "Universitas Terbuka Tanzania", "Universitas Mzumbe", "Universitas Sains Teknologi Mbeya", "Universitas State Zanzibar", "Universitas Sains Kesehatan Nelson Mandela", "Universitas Pertambangan Shinyanga"],
    "swasta": ["Universitas Kristen Saint Augustine", "Universitas Katolik Ruaha", "Universitas Tumaini Makumira", "Universitas Hubert Kairuki Memorial", "Universitas St. John Tanzania", "Universitas Muslim Morogoro", "Universitas Zanzibar", "Universitas Teofilo Kisanji", "Universitas Mount Meru", "Universitas International Medical & Technological"]
  },
  "republik uganda": {
    "negeri": ["Universitas Makerere", "Universitas Sains Teknologi Mbarara", "Universitas Kyambogo", "Universitas Gulu", "Universitas Busitema", "Universitas Kabale", "Universitas Lira", "Universitas Muni", "Universitas Soroti", "Institut Politeknik Kyambogo"],
    "swasta": ["Universitas Islam Uganda (IUIU)", "Universitas Uganda Christian (UCU)", "Universitas Kampala International (KIU)", "Universitas Ndejje", "Universitas Uganda Martyrs", "Universitas Nkumba", "Universitas Victoria Kampala", "Universitas International University of East Africa", "Universitas Bugema", "Universitas Cavendish Uganda"]
  },
  "republik zambia": {
    "negeri": ["Universitas Zambia (UNZA)", "Universitas Copperbelt", "Universitas Mulungushi", "Universitas Levy Mwanawasa", "Universitas Kapasa Makasa", "Universitas Mukuba", "Universitas Kwame Nkrumah Kabwe", "Kolej Pendidikan Kitwe", "Institut Teknik Ndola", "Kolej Pertanian Natural Resources"],
    "swasta": ["Universitas Zambia Open", "Universitas Cavendish Zambia", "Universitas Texila International Zambia", "Universitas Rusangu", "Universitas DMI-St. Eugene", "Universitas sains Teknologi Lusaka", "Universitas Lusaka (UNILUS)", "Universitas Information and Communications University", "Universitas ZCAS University", "Universitas Victoria Falls University"]
  },
  "republik zimbabwe": {
    "negeri": ["Universitas Zimbabwe", "Universitas Sains Teknologi National (NUST)", "Universitas Midlands State", "Universitas Great Zimbabwe", "Universitas Chinhoyi Technology", "Universitas Bindura Science", "Universitas Lupane State", "Universitas Harare Institute of Technology", "Universitas Manicaland Applied Sciences", "Universitas Gwanda State"],
    "swasta": ["Universitas Africa Mutare", "Universitas Catholic Zimbabwe", "Universitas Women Africa", "Universitas Solusi Solusi Bulawayo", "Universitas Reformed Church Masvingo", "Universitas Arrupe Jesuit Harare", "Universitas International Open Zimbabwe", "Universitas Bisnis Harare", "Institut Teknologi Terapan Bulawayo", "Universitas Sains Kesehatan Swasta Harare"]
  },
  "rwanda": {
    "negeri": ["Universitas Rwanda", "Institut Politeknik IPRC Kigali", "Institut Politeknik IPRC Musanze", "Institut Politeknik IPRC Huye", "Institut Politeknik IPRC Karongi", "Institut Politeknik IPRC Tumba", "Sekolah Keguruan Kigali", "Institut Kedokteran Butare", "Kolej Pertanian Nyagatare", "Institut Statistik Kigali"],
    "swasta": ["Universitas Global Health Equity", "Universitas Carnegie Mellon Rwanda", "Universitas Adventist Central Africa", "Universitas Lay Adventists Kigali (UNILAK)", "Universitas Rwanda Tourism and Business", "Universitas Kigali", "Universitas Protestant Institute Butare", "Universitas Ines Ruhengeri", "Universitas East African Kigali", "Universitas Mount Kenya Rwanda"]
  },
  "sao tome dan principe": {
    "negeri": ["Universitas São Tomé dan Príncipe", "Institut Teknologi São Tomé", "Kolej Keguruan São Tomé", "Institut Sains Terapan São Tomé", "Sekolah Kedokteran São Tomé", "Institut Pertanian Santo António", "Kolej Maritim São Tomé", "Institut Hukum São Tomé", "Institut Kehutanan Príncipe", "Kolej Statistik São Tomé"],
    "swasta": ["Universitas Sains Kesehatan São Tomé", "Institut Manajemen São Tomé", "Kolej Pertanian São Tomé", "Universitas Maritim São Tomé", "Institut Ilmu Sosial São Tomé", "Universitas Bisnis Santo António", "Kolej Komunikasi São Tomé", "Institut Informatika Swasta São Tomé", "Sekolah Bisnis Internasional São Tomé", "Universitas Bahasa Terapan São Tomé"]
  },
  "senegal": {
    "negeri": ["Universitas Cheikh Anta Diop Dakar", "Universitas Gaston Berger Saint-Louis", "Universitas Assane Seck Ziguinchor", "Universitas Alioune Diop Bambey", "Universitas Thies", "Universitas Sine Saloum Fatick", "Universitas Virtual Senegal", "Universitas Amadou Mahtar Mbow", "Institut Politeknik Dakar", "Sekolah Keguruan Dakar"],
    "swasta": ["Universitas Dakar Bourguiba", "Universitas Amadou Hampate Ba", "Universitas Supelec Dakar", "Universitas BEM Management School Dakar", "Universitas IAM Dakar", "Universitas ISM Dakar", "Universitas Sahel Dakar", "Universitas Euromed Dakar", "Institut Supérieur de Management Dakar", "Universitas Sup'Info Dakar"]
  },
  "seychelles": {
    "negeri": ["Universitas Seychelles", "Institut Teknologi Seychelles", "Institut Manajemen Seychelles", "Kolej Pariwisata Seychelles", "Institut Maritim Seychelles", "Institut Pertanian Seychelles", "Kolej Pendidikan Victoria", "Institut Seni Seychelles", "Sekolah Keperawatan Victoria", "Institut Kelautan Praslin"],
    "swasta": ["Universitas Sains Kesehatan Seychelles", "Universitas Bisnis Praslin", "Institut Bisnis Swasta Victoria", "Sekolah Bisnis Internasional Seychelles", "Universitas Informatika Terapan Victoria", "Kolej Sains Terapan Seychelles", "Institut Komunikasi Praslin", "Universitas Bahasa Swasta Victoria", "Kolej Keuangan Seychelles", "Institut Teknologi Informasi Praslin"]
  },
  "sierra leone": {
    "negeri": ["Universitas Sierra Leone (Fourah Bay College)", "Universitas Njala", "Universitas sains Teknologi Ernest Bai Koroma", "Universitas Milton Margai", "Universitas Eastern Kenema", "College of Medicine and Allied Health Sciences (COMAHS)", "Institut Pelatihan Teknis Freetown", "Kolej Keguruan Freetown", "Institut Pertanian Njala", "Kolej Perikanan Tombo"],
    "swasta": ["Universitas Makeni (UNIMAK)", "Institut Manajemen Freetown", "Universitas Kedokteran Sierra Leone", "Universitas Bisnis Bo", "Universitas Limkokwing Freetown", "Universitas United Methodist Freetown", "Institut Informatika Terapan Freetown", "Sekolah Bisnis Swasta Bo", "Universitas Komunikasi Sierra Leone", "Institut Keuangan Freetown"]
  },
  "somalia": {
    "negeri": ["Universitas Nasional Somalia", "Universitas Hargeisa", "Universitas Puntland State", "Universitas Kismayo", "Universitas Galkayo", "Universitas Burao", "Universitas Bosaso State", "Institut Teknologi Mogadishu", "Universitas Pertanian Afgooye", "Sekolah Keguruan Mogadishu"],
    "swasta": ["Universitas Mogadishu", "Universitas SIMAD", "Universitas Amoud", "Universitas Benadir", "Universitas East Africa", "Universitas Nugaal", "Universitas Plaza Mogadishu", "Universitas Jamhuriya", "Universitas Somali International", "Universitas Capital Mogadishu"]
  },
  "sudan selatan": {
    "negeri": ["Universitas Juba", "Universitas Upper Nile", "Universitas Bahr El Ghazal", "Universitas Rumbek", "Universitas Dr. John Garang Memorial", "Institut Politeknik Juba", "Sekolah Keperawatan Juba", "Institut Keguruan Wau", "Kolej Pertanian Malakal", "Institut Kehutanan Yambio"],
    "swasta": ["Universitas Catholic South Sudan", "Universitas Star University Juba", "Universitas Staff Juba", "Universitas Sains Terapan Juba", "Universitas Bisnis Malakal", "Institut Manajemen Swasta Juba", "Sekolah Bisnis Internasional Juba", "Universitas Informatika Terapan Juba", "Kolej Sains Kesehatan Swasta Juba", "Universitas Komunikasi South Sudan"]
  },
  "tanjung verde": {
    "negeri": ["Universitas Tanjung Verde", "Institut Sains Terapan Praia", "Kolej Maritim Mindelo", "Institut Keguruan Praia", "Sekolah Kedokteran Praia", "Institut Pertanian São Jorge", "Kolej Teknik Mindelo", "Institut Statistik Praia", "Sekolah Perikanan Mindelo", "Institut Kehutanan Santo Antão"],
    "swasta": ["Universitas Jean Piaget Tanjung Verde", "Universitas Mindelo", "Universitas Santiago", "Universitas Sains Kesehatan Tanjung Verde", "Kolej Manajemen Mindelo", "Institut Bisnis Swasta Praia", "Sekolah Bisnis Internasional Mindelo", "Universitas Informatika Terapan Praia", "Kolej Komunikasi Mindelo", "Institut Keuangan Praia"]
  },
  "togo": {
    "negeri": ["Universitas Lomé", "Universitas Kara", "Institut Teknologi Lomé", "Universitas Sains Terapan Lomé", "Sekolah Keguruan Atakpamé", "Institut Pertanian Kpalimé", "Institut Kedokteran Lomé", "Sekolah Teknik Lomé", "Institut Kehutanan Tsevié", "Institut Statistik Lomé"],
    "swasta": ["Universitas Katolik Afrika Barat Togo", "Institut Sains Manajemen Lomé", "Universitas Formatech Lomé", "Universitas Bisnis Togo", "Universitas Komunikasi Lomé", "Universitas IAEC Togo", "Universitas ESGIS Lomé", "Universitas Defitech Lomé", "Universitas CAMS Lomé", "Institut Politeknik Swasta Lomé"]
  },
  "tunisia": {
    "negeri": ["Universitas Tunis El Manar", "Universitas Carthage", "Universitas Sfax", "Universitas Sousse", "Universitas Monastir", "Universitas Tunis", "Universitas Manouba", "Universitas Gabès", "Universitas Ez-Zitouna", "Universitas Jendouba"],
    "swasta": ["Universitas Libanaise Tunis", "Universitas Central Tunis", "Universitas Université Libre de Tunis (ULT)", "Universitas ESPRIT Tunis", "Universitas South Mediterranean (MSB)", "Universitas Polytechnique Sousse", "Universitas Université Internationale de Tunis", "Universitas MIT Tunis", "Universitas SESAME Tunis", "Universitas Ibn Khaldoun Tunis"]
  },

  // --- ASIA ---
  "afganistan": {
    "negeri": ["Universitas Kabul", "Universitas Nangarhar", "Universitas Herat", "Universitas Balkh", "Universitas Kandahar", "Universitas Politeknik Kabul", "Universitas Kedokteran Kabul", "Universitas Al-Beroni", "Universitas Khost", "Universitas Bamiyan"],
    "swasta": ["Universitas Kardan", "Universitas Kateb", "Universitas Bakhtar", "Universitas Dunya", "Universitas Gawharshad", "Universitas Rana Kabul", "Universitas Karwan", "Universitas Tabesh", "Universitas Maryam", "Universitas Jahan"]
  },
  "arab saudi": {
    "negeri": ["Universitas Raja Saud", "Universitas Sains dan Teknologi Raja Abdullah (KAUST)", "Universitas Raja Fahd Minyak & Mineral", "Universitas Raja Abdulaziz", "Universitas Umm Al-Qura", "Universitas Putri Nora bint Abdul Rahman", "Universitas Imam Abdulrahman bin Faisal", "Universitas Raja Khalid", "Universitas Qassim", "Universitas Taibah"],
    "swasta": ["Universitas Prince Sultan", "Universitas Alfaisal", "Universitas Dar Al-Hekma", "Universitas Effat", "Universitas Al Yamamah", "Universitas Prince Mohammad bin Fahd", "Universitas Batterjee Medical College", "Universitas Ibn Sina National College", "Universitas Al-Maarefa", "Universitas Riyadh Elm"]
  },
  "armenia": {
    "negeri": ["Universitas Negeri Yerevan", "Universitas Politeknik Armenia", "Universitas Medis Negeri Yerevan", "Universitas Ekonomi Negeri Armenia", "Universitas Bahasa Negeri Yerevan", "Universitas Pedagogis Negeri Armenia", "Universitas Pertanian Negeri Armenia", "Universitas Arsitektur Yerevan", "Universitas Negeri Shirak", "Universitas Negeri Vanadzor"],
    "swasta": ["Universitas Amerika Armenia (AUA)", "Universitas Katolik Eurasia Yerevan", "Universitas Prancis di Armenia (UFAR)", "Universitas Internasional Haybusak", "Universitas Kedokteran Swasta Yerevan", "Universitas Bisnis Northern Armenia", "Universitas Gladzor Yerevan", "Universitas Imastaser Anania Shirakatsi", "Universitas Mkhitar Gosh", "Universitas Urartu Yerevan"]
  },
  "azerbaijan": {
    "negeri": ["Universitas Negeri Baku", "Universitas Minyak dan Industri Azerbaijan", "Universitas Teknik Azerbaijan", "Universitas Kedokteran Azerbaijan", "Universitas Ekonomi Negeri Azerbaijan", "Universitas Bahasa Azerbaijan", "Universitas Pedagogis Azerbaijan", "Universitas Arsitektur dan Konstruksi Azerbaijan", "Universitas Negeri Ganja", "Universitas Negeri Sumqayit"],
    "swasta": ["Universitas ADA Baku", "Universitas Khazar", "Universitas Barat Caspian", "Universitas Baku Eurasian", "Universitas Bisnis Azerbaijan", "Universitas Odlar Yurdu", "Universitas Azerbaijan Baku", "Universitas Arsitektur Swasta Baku", "Institut Sains Terapan Khazar", "Universitas Teknologi Terapan Baku"]
  },
  "bahrain": {
    "negeri": ["Universitas Bahrain", "Universitas Kerajaan Manama", "Universitas Publik Politeknik Bahrain", "Institut Pendidikan Riffa", "Kolej Sains Kesehatan Manama", "Institut Keuangan Bahrain", "Kolej Keguruan Manama", "Institut Maritim Bahrain", "Sekolah Teknik Bahrain", "Institut Riset Minyak Bahrain"],
    "swasta": ["Universitas Medis Bahrain (RCSI)", "Universitas Terbuka Arab Bahrain", "Universitas Teraplikasi Bahrain", "Universitas Ahlia", "Universitas Teknologi Bahrain", "Universitas Kingdom Bahrain", "Universitas Gulf Bahrain", "Universitas Royal University for Women", "Universitas British University of Bahrain", "Universitas Vatel Bahrain"]
  },
  "bangladesh": {
    "negeri": ["Universitas Dhaka", "Universitas Rekayasa dan Teknologi Bangladesh (BUET)", "Universitas Rajshahi", "Universitas Chittagong", "Universitas Jahangirnagar", "Universitas Pertanian Bangladesh", "Universitas Shahjalal Science and Technology", "Universitas Khulna", "Universitas Jagannath", "Universitas Barisal"],
    "swasta": ["Universitas BRAC", "Universitas North South", "Universitas Independent Bangladesh", "Universitas East West", "Universitas Ahsanullah", "Universitas American International Bangladesh", "Universitas United International", "Universitas Daffodil International", "Universitas Southeast Dhaka", "Universitas Stamford Bangladesh"]
  },
  "bhutan": {
    "negeri": ["Universitas Kerajaan Bhutan", "Universitas Sains Kesehatan Khesar Gyalpo", "Kolej Sains Sherubtse", "Kolej Sains dan Teknologi Gaeddu", "Kolej Teknik Jirung", "Kolej Keguruan Paro", "Kolej Bahasa dan Kebudayaan Trongsa", "Kolej Pertanian Punakha", "Kolej Sumber Daya Alam Lobesa", "Institut Samtse"],
    "swasta": ["Institut Manajemen Bhutan", "Kolej Kedokteran Thimphu", "Kolej Bisnis Swasta Thimphu", "Sekolah Bisnis Internasional Paro", "Universitas Informatika Terapan Thimphu", "Institut Sains Kesehatan Swasta Bhutan", "Kolej Pariwisata Punakha", "Institut Komunikasi Thimphu", "Universitas Bahasa Swasta Paro", "Kolej Keuangan Thimphu"]
  },
  "brunei": {
    "negeri": ["Universitas Brunei Darussalam (UBD)", "Universitas Teknologi Brunei (UTB)", "Universitas Islam Sultan Sharif Ali (UNISSA)", "Kolej Universiti Perguruan Ugama Seri Begawan", "Institut Teknologi Brunei", "Kolej Keperawatan Bandar Seri Begawan", "Kolej Perdagangan Brunei", "Institut Sains Terapan Bandar Seri Begawan", "Sekolah Teknik Jefri Bolkiah", "Institut Pendidikan Teknik Brunei"],
    "swasta": ["Kolej Penerbangan Brunei", "Institut Manajemen Bandar Seri Begawan", "Institut Bisnis Laksamana", "Kolej International Graduate Studies (KIGS)", "Institut Sains Kesehatan Swasta Brunei", "Kolej Informatika Terapan Brunei", "Sekolah Bisnis Internasional Brunei", "Institut Pariwisata Bandar Seri Begawan", "Kolej Keuangan Swasta Brunei", "Institut Komunikasi Brunei"]
  },
  "china": {
    "negeri": ["Universitas Tsinghua", "Universitas Peking", "Universitas Zhejiang", "Universitas Shanghai Jiao Tong", "Universitas Fudan", "Universitas Sains dan Teknologi China (USTC)", "Universitas Nanjing", "Universitas Wuhan", "Universitas Sun Yat-sen", "Universitas Harbin Institute of Technology"],
    "swasta": ["Universitas Ningbo Nottingham", "Universitas Xi'an Jiaotong-Liverpool", "Universitas Duke Kunshan", "Universitas Wenzhou-Kean", "Universitas HKUST Guangzhou", "Universitas CUHK Shenzhen", "Universitas NYU Shanghai", "Universitas Guangdong Technion", "Universitas Beijing Normal-HKBU UIC", "Universitas Westlake Hangzhou"]
  },
  "filipina": {
    "negeri": ["Universitas Filipina (UP Diliman)", "Universitas Teknik Filipina", "Universitas Negeri Mindanao", "Universitas Negeri Polytechnic Filipina", "Universitas Negeri West Visayas", "Universitas Negeri Central Luzon", "Universitas Negeri Leyte", "Universitas Negeri Batangas", "Universitas Negeri Bulacan", "Universitas Negeri Cagayan"],
    "swasta": ["Universitas Ateneo de Manila", "Universitas De La Salle", "Universitas Santo Tomas", "Universitas Mapúa", "Universitas Negeri Siliman", "Universitas San Carlos", "Universitas Far Eastern", "Universitas Adamson", "Universitas UE Manila", "Universitas Centro Escolar"]
  },
  "georgia": {
    "negeri": ["Universitas Negeri Tbilisi Ivane Javakhishvili", "Universitas Negeri Ilia", "Universitas Teknik Georgia", "Universitas Medis Negeri Tbilisi", "Universitas Negeri Batumi", "Universitas Negeri Akaki Tsereteli Kutaisi", "Universitas Negeri Samtskhe-Javakheti", "Universitas Negeri Gori", "Universitas Negeri Telavi", "Universitas Negeri Zugdidi"],
    "swasta": ["Universitas Bebas Tbilisi", "Universitas Laut Hitam Internasional", "Universitas Georgia", "Universitas Kaukasus", "Universitas Grigol Robakidze", "Universitas Laut Hitam Batumi", "Universitas GIPA Tbilisi", "Universitas SEU Georgia", "Universitas Alterbridge Tbilisi", "Universitas bisnis Tbilisi"]
  },
  "hong kong": {
    "negeri": ["Universitas Hong Kong (HKU)", "Universitas Sains dan Teknologi Hong Kong (HKUST)", "Universitas Chinese Hong Kong (CUHK)", "Universitas Politeknik Hong Kong (PolyU)", "Universitas City Hong Kong (CityU)", "Universitas Baptist Hong Kong", "Universitas Lingnan", "Universitas Pendidikan Hong Kong", "Universitas Metropolitan Hong Kong", "Kolej Kedokteran Hong Kong"],
    "swasta": ["Universitas Shue Yan Hong Kong", "Universitas Hang Seng Hong Kong", "Kolej Tung Wah", "Kolej Teknologi Caritas", "Kolej Chu Hai", "Kolej Manajemen HKU SPACE", "Kolej Komunitas HKU", "Kolej Keperawatan Grantham", "Institut Pendidikan Tinggi Centennial", "Kolej Sains Kesehatan Hong Kong"]
  },
  "india": {
    "negeri": ["Institut Teknologi India (IIT Bombay)", "Institut Sains India (IISc Bangalore)", "IIT Delhi", "IIT Madras", "Universitas Delhi", "Universitas Jawaharlal Nehru (JNU)", "Universitas Banaras Hindu (BHU)", "IIT Kharagpur", "Universitas Hyderabad", "IIT Kanpur"],
    "swasta": ["Universitas BITS Pilani", "Universitas Manipal", "Universitas VIT Vellore", "Universitas Amity", "Universitas SRM Chennai", "Universitas Thapar", "Universitas OP Jindal Global", "Universitas Ashoka", "Universitas Kalinga (KIIT)", "Universitas Shiv Nadar"]
  },
  "indonesia": {
    "negeri": ["Universitas Indonesia (UI)", "Institut Teknologi Bandung (ITB)", "Universitas Gadjah Mada (UGM)", "Institut Pertanian Bogor (IPB)", "Universitas Airlangga (UNAIR)", "Universitas Diponegoro (UNDIP)", "Universitas Padjadjaran (UNPAD)", "Universitas Brawijaya (UB)", "Universitas Sepuluh Nopember (ITS)", "Universitas Hasanuddin (UNHAS)"],
    "swasta": ["Universitas Telkom", "Universitas Bina Nusantara (Binus)", "Universitas Muhammadiyah Yogyakarta (UMY)", "Universitas Katolik Indonesia Atma Jaya", "Universitas Islam Indonesia (UII)", "Universitas Pelita Harapan (UPH)", "Universitas Trisakti", "Universitas Tarumanagara (Untar)", "Universitas Muhammadiyah Surakarta (UMS)", "Universitas Petra Surabaya"]
  },
  "irak": {
    "negeri": ["Universitas Baghdad", "Universitas Mustansiriyah", "Universitas Mosul", "Universitas Basrah", "Universitas Kufa", "Universitas Teknologi Baghdad", "Universitas Sulaimani", "Universitas Erbil Polytechnic", "Universitas Salahaddin Erbil", "Universitas Anbar"],
    "swasta": ["Universitas Amerika Irak Sulaimani (AUIS)", "Universitas Cihan Erbil", "Universitas Komar Sains Teknologi", "Universitas Ishik Erbil", "Universitas Tigris Baghdad", "Universitas Al-Turath Baghdad", "Universitas Al-Mansour Baghdad", "Universitas Al-Maarif Ramadi", "Universitas Al-Rafidain Baghdad", "Universitas Bayan Erbil"]
  },
  "iran": {
    "negeri": ["Universitas Teknologi Sharif", "Universitas Teheran", "Universitas Teknologi Amirkabir", "Universitas Sains dan Teknologi Iran", "Universitas Tarbiat Modares", "Universitas Teknologi Isfahan", "Universitas Shiraz", "Universitas Ferdowsi Mashhad", "Universitas Ilmu Kedokteran Teheran", "Universitas Khajeh Nasir Toosi"],
    "swasta": ["Universitas Azad Islam Teheran", "Universitas Sains Terapan Iran Swasta", "Universitas Khatam Teheran", "Universitas Ershad Damavand", "Universitas Safahan Isfahan", "Universitas Souore Teheran", "Universitas Sadraad Shiraz", "Universitas Tabaran Mashhad", "Universitas Khayyām Mashhad", "Universitas Sobh-e Sadeq Isfahan"]
  },
  "israel": {
    "negeri": ["Universitas Hebrew Yerusalem", "Technion - Institut Teknologi Israel", "Universitas Tel Aviv", "Universitas Ben-Gurion", "Universitas Bar-Ilan", "Universitas Haifa", "Institut Sains Weizmann", "Universitas Open Israel", "Universitas Ariel", "Kolej Kedokteran Haifa"],
    "swasta": ["Universitas Reichman (IDC Herzliya)", "Kolej Rekayasa Afeka Tel Aviv", "Kolej Manajemen Academic Studies Rishon LeZion", "Kolej Akademik Tel Aviv-Yaffo", "Kolej Rekayasa Shenkar", "Kolej Akademik Ono", "Kolej Akademik Ruppin", "Kolej Rekayasa Sami Shamoon", "Kolej Akademik Hadassah", "Kolej Rekayasa ORT Braude"]
  },
  "jepang": {
    "negeri": ["Universitas Tokyo", "Universitas Kyoto", "Universitas Osaka", "Universitas Tohoku", "Universitas Nagoya", "Institut Teknologi Tokyo (Tokyo Tech)", "Universitas Kyushu", "Universitas Hokkaido", "Universitas Tsukuba", "Universitas Hiroshima"],
    "swasta": ["Universitas Waseda", "Universitas Keio", "Universitas Sophia Tokyo", "Universitas Meiji", "Universitas Doshisha Kyoto", "Universitas Ritsumeikan", "Universitas Chuo Tokyo", "Universitas Rikkyo", "Universitas Hosei", "Universitas Kansai"]
  },
  "kamboja": {
    "negeri": ["Universitas Royal Phnom Penh", "Universitas Teknologi Kamboja", "Universitas Sains Kesehatan Kamboja", "Universitas Pertanian Royal Kamboja", "Universitas Manajemen Kamboja", "Universitas Chea Sim Kamchaymear", "Universitas Svay Rieng", "Universitas Meanchey", "Universitas Battambang", "Sekolah Keguruan Phnom Penh"],
    "swasta": ["Universitas Norton Phnom Penh", "Universitas International Kamboja", "Universitas Paññāsāstra Kamboja", "Universitas Pannasastra Battambang", "Universitas Build Bright Kamboja", "Universitas Kirirom Institute of Technology", "Universitas Zaman Phnom Penh", "Universitas Western Phnom Penh", "Universitas Beltei International", "Universitas Phnom Penh International"]
  },
  "kamerun": {
    "negeri": ["Universitas Yaoundé I", "Universitas Douala", "Universitas Dschang", "Universitas Buea", "Universitas Ngaoundéré", "Universitas Bamenda", "Universitas Maroua", "Universitas Ebolowa", "Universitas Bertoua", "Universitas Garoua"],
    "swasta": ["Universitas Katolik Afrika Tengah Yaoundé", "Universitas Sains dan Teknologi Douala", "Universitas Biaka Institute Buea", "Universitas PKFokam Institute of Excellence", "Universitas Saint Jerome Douala", "Universitas Montagne Bangangté", "Universitas SIANTOU Yaoundé", "Universitas Taniform Bamenda", "Universitas ICT University Yaoundé", "Universitas International Douala"]
  },
  "kazakhstan": {
    "negeri": ["Universitas Nasional Al-Farabi Kazakh", "Universitas Nazarbayev", "Universitas Teknik Nasional Satbayev", "Universitas Nasional L.N. Gumilyov Eurasian", "Universitas Kedokteran Astana", "Universitas Pertanian Kazakh", "Universitas Hubungan Internasional Kazakh", "Universitas Karaganda", "Universitas Pedagogis Abai", "Universitas Teknologi Almaty"],
    "swasta": ["Universitas KIMEP Almaty", "Universitas Suleyman Demirel", "Universitas Bisnis AlmaU Almaty", "Universitas Kazakh-American Free", "Universitas Internasional Information Technologies (IITU)", "Universitas Turan Almaty", "Universitas KAZGUU Astana", "Universitas Ekonomi Narxoz", "Universitas KAEU Ust-Kamenogorsk", "Universitas Kainar Almaty"]
  },
  "kirgizstan": {
    "negeri": ["Universitas Nasional Kirgiz Jusup Balasagyn", "Universitas Teknik Kirgiz Razzakov", "Universitas Kedokteran Kirgiz", "Universitas Slavik Kirgiz-Rusia", "Universitas Jalal-Abad", "Universitas Osh State", "Universitas Pedagogis Arabaev", "Universitas Pertanian Skryabin", "Universitas Naryn State", "Universitas Issyk-Kul State"],
    "swasta": ["Universitas Manas Kirgiz-Turki", "Universitas Amerika Asia Tengah (AUCA)", "Universitas International Kirgizstan", "Universitas Ala-Too International", "Universitas Adam Bishkek", "Universitas Salymbekov Bishkek", "Universitas Keperawatan International Bishkek", "Universitas Bisnis Bishkek", "Universitas Kedokteran Asian Medical Institute", "Universitas Toktomamatov Jalal-Abad"]
  },
  "korea selatan": {
    "negeri": ["Universitas Nasional Seoul (SNU)", "KAIST (Institut Sains dan Teknologi Korea)", "POSTECH (Sains & Teknologi Pohang)", "Universitas Nasional Pusan", "Universitas Nasional Kyungpook", "Universitas Nasional Chonnam", "Universitas Nasional Chungnam", "Universitas Gwangju Institute of Science (GIST)", "Universitas UNIST Ulsan", "Universitas DGIST Daegu"],
    "swasta": ["Universitas Korea", "Universitas Yonsei", "Universitas Sungkyunkwan (SKKU)", "Universitas Hanyang", "Universitas Kyung Hee", "Universitas Ewha Womans", "Universitas Sogang", "Universitas Chung-Ang", "Universitas Hankuk University of Foreign Studies", "Universitas Sejong"]
  },
  "korea utara": {
    "negeri": ["Universitas Kim Il-sung", "Universitas Teknologi Kim Chaek", "Universitas Kedokteran Pyongyang", "Universitas Pertanian Sariwon", "Universitas Hubungan Luar Negeri Pyongyang", "Universitas Keguruan Pyongyang", "Universitas Seni Pyongyang", "Universitas Olahraga Pyongyang", "Universitas Sains Pyongsong", "Universitas Industri Hamhung"],
    "swasta": ["Universitas Sains dan Teknologi Pyongyang (PUST)", "Institut Sains Terapan Pyongyang Swasta", "Kolej Teknik Internasional Pyongyang", "Institut Manajemen Bisnis Rason", "Sekolah Bahasa Internasional Pyongyang", "Kolej Informatika Terapan PUST", "Institut Kedokteran Internasional Pyongyang", "Universitas Pertanian Terapan PUST", "Institut Keuangan Swasta Rason", "Kolej Komunikasi Terapan Pyongyang"]
  },
  "kuwait": {
    "negeri": ["Universitas Kuwait", "Universitas Publik Organisasi Pendidikan Kuwait (PAAET)", "Kolej Sains Kesehatan Kuwait", "Institut Riset Sains Kuwait (KISR)", "Kolej Teknologi Kuwait", "Institut Keuangan Kuwait", "Sekolah Keguruan Kuwait", "Kolej Keperawatan Kuwait", "Institut Maritim Kuwait", "Kolej Teknik Terapan Kuwait"],
    "swasta": ["Universitas Sains dan Teknologi Gulf Kuwait", "Universitas Amerika Kuwait", "Universitas Teknik Kuwait", "Universitas Australia di Kuwait", "Universitas Internasional Kuwait", "Kolej Kedokteran Kuwait (RCSI)", "Universitas American International Kuwait", "Universitas Al-Bayan Kuwait", "Universitas Maastricht School of Management Kuwait", "Kolej Hukum Kuwait"]
  },
  "laos": {
    "negeri": ["Universitas Nasional Laos (NUOL)", "Universitas Souphanouvong Luang Prabang", "Universitas Champasak", "Universitas Sains Kesehatan Vientiane", "Universitas Savannakhet", "Kolej Politeknik Vientiane", "Institut Pertanian Nabong", "Kolej Keguruan Luang Prabang", "Kolej Teknik Pakse", "Institut Pendidikan Luang Namtha"],
    "swasta": ["Institut Bisnis Vientiane", "Universitas Teknologi Pakse", "Universitas Rattana Vientiane", "Universitas Sengsavanh Vientiane", "Kolej Lao-American Vientiane", "Institut Komputer ComCenter Vientiane", "Sekolah Bisnis Internasional Luang Prabang", "Universitas Bahasa Terapan Vientiane", "Institut Sains Kesehatan Swasta Vientiane", "Kolej Pariwisata Champasak"]
  },
  "lebanon": {
    "negeri": ["Universitas Lebanon", "Institut Politeknik Lebanon Tripoli", "Kolej Keguruan Beirut", "Institut Sains Terapan Saida", "Sekolah Pertanian Bekaa", "Institut Kedokteran Beirut", "Kolej Seni Tripoli", "Institut Kelautan Tyre", "Sekolah Hukum Beirut", "Institut Statistik Lebanon"],
    "swasta": ["Universitas Amerika Beirut (AUB)", "Universitas Saint-Joseph Beirut", "Universitas Amerika Lebanon (LAU)", "Universitas Balamand", "Universitas Holy Spirit Kaslik", "Universitas Beirut Arab", "Universitas Notre Dame Louaize", "Universitas Sains dan Teknologi Lebanon", "Universitas Antonine", "Universitas Phoenicia"]
  },
  "makau": {
    "negeri": ["Universitas Makau", "Institut Politeknik Makau", "Institut Studi Pariwisata Makau", "Kolej Keperawatan Makau", "Institut Sains Terapan Makau", "Sekolah Keguruan Makau", "Institut Keuangan Makau", "Sekolah Seni Makau", "Institut Maritim Makau", "Kolej Administrasi Publik Makau"],
    "swasta": ["Universitas Sains dan Teknologi Makau (MUST)", "Universitas Kota Makau", "Universitas Saint Joseph Makau", "Kolej Keperawatan Kiang Wu", "Institut Eropa Makau", "Universitas Manajemen Makau", "Sekolah Bisnis Internasional Makau", "Universitas Informatika Terapan Makau", "Institut Sains Kesehatan Swasta Makau", "Kolej Keuangan Swasta Makau"]
  },
  "malaysia": {
    "negeri": ["Universitas Malaya (UM)", "Universitas Sains Malaysia (USM)", "Universitas Putra Malaysia (UPM)", "Universitas Kebangsaan Malaysia (UKM)", "Universitas Teknologi Malaysia (UTM)", "Universitas Utara Malaysia (UUM)", "Universitas Islam Internasional Malaysia (IIUM)", "Universitas Malaysia Sarawak (UNIMAS)", "Universitas Malaysia Sabah (UMS)", "Universitas Pendidikan Sultan Idris (UPSI)"],
    "swasta": ["Universitas Teknologi PETRONAS (UTP)", "Universitas Taylor's", "Universitas UCSI", "Universitas Sunway", "Universitas Multimedia (MMU)", "Universitas Monash Malaysia", "Universitas Nottingham Malaysia", "Universitas Curtin Malaysia", "Universitas Heriot-Watt Malaysia", "Universitas Xiamen Malaysia"]
  },
  "maldives": {
    "negeri": ["Universitas Nasional Maldives (MNU)", "Universitas Islamic Maldives", "Institut Sains Kesehatan Maldives", "Sekolah Keguruan Male", "Institut Teknologi Male", "Kolej Maritim Male", "Institut Perikanan Maldives", "Sekolah Keperawatan Male", "Institut Keuangan Male", "Kolej Seni Male"],
    "swasta": ["Kolej Villa Male", "Kolej MAPS Male", "Kolej Clique Male", "Kolej Cyryx Male", "Kolej Avid Male", "Universitas Bisnis Male", "Sekolah Bisnis Internasional Maldives", "Universitas Informatika Terapan Male", "Institut Pariwisata Maldives", "Kolej Keuangan Swasta Male"]
  },
  "mongolia": {
    "negeri": ["Universitas Nasional Mongolia", "Universitas Sains dan Teknologi Mongolia", "Universitas Ilmu Hayati Mongolia", "Universitas Ilmu Medis Mongolia", "Universitas Pendidikan Negeri Mongolia", "Universitas Pertanian Darkhan", "Sekolah Keguruan Ulaanbaatar", "Institut Teknik Erdenet", "Universitas Olahraga Ulaanbaatar", "Sekolah Hukum Mongolia"],
    "swasta": ["Universitas Humaniora Ulaanbaatar", "Universitas International Ulaanbaatar", "Universitas Mandakh Ulaanbaatar", "Universitas Otgontenger", "Universitas Ider", "Universitas Raffles Ulaanbaatar", "Universitas City Ulaanbaatar", "Universitas Global Leadership", "Universitas Mon-Altius", "Universitas Ulaanbaatar Erdem"]
  },
  "myanmar": {
    "negeri": ["Universitas Yangon", "Universitas Mandalay", "Universitas Teknologi Yangon", "Universitas Kedokteran 1 Yangon", "Universitas Ekonomi Yangon", "Universitas Studi Asing Yangon", "Universitas Kedokteran 2 Yangon", "Universitas Yezin Agricultural", "Universitas Computer Studies Yangon", "Universitas Dagon"],
    "swasta": ["Universitas STI Myanmar", "Universitas Victoria Yangon", "Universitas Strategy First Mandalay", "Universitas National Management Degree College", "Universitas PSI Myanmar", "Universitas Gusto College Yangon", "Universitas Crown Education Yangon", "Universitas Imperial World College", "Universitas Myanmar Imperial University", "Universitas Apex Degree College"]
  },
  "nepal": {
    "negeri": ["Universitas Tribhuvan Kathmandu", "Universitas Pokhara", "Universitas Purbanchal", "Universitas Pertanian dan Kehutanan Nepal", "Universitas Nepal Sanskrit", "Universitas Mid-Western Surkhet", "Universitas Far-Western Mahendranagar", "Universitas Open Nepal", "Universitas Lumbini Buddhist", "Institut Kedokteran BP Koirala Dharan"],
    "swasta": ["Universitas Kathmandu", "Universitas Gandaki Pokhara", "Kolej Kedokteran Manipal Pokhara", "Kolej Kedokteran Kathmandu", "Kolej Teknik Nepal", "Kolej Manajemen Apex Kathmandu", "Kolej Bisnis Quest Pokhara", "Kolej Teknologi Islington Kathmandu", "Kolej Internasional Lord Buddha", "Kolej Keperawatan Nepal"]
  },
  "oman": {
    "negeri": ["Universitas Sultan Qaboos", "Universitas Teknologi dan Sains Terapan Oman", "Universitas Sains Kesehatan Muscat", "Kolej Militer Musandam", "Institut Keuangan Muscat", "Sekolah Keguruan Nizwa", "Kolej Maritim Sohar", "Institut Kedokteran Muscat", "Sekolah Teknik Salalah", "Institut Statistik Oman"],
    "swasta": ["Universitas Dhofar", "Universitas Sohar", "Universitas Nizwa", "Universitas Muscat", "Universitas Al Sharqiyah", "Universitas Buraimi", "Universitas German Technology Oman", "Universitas Mazoon Muscat", "Universitas Gulf College Muscat", "Universitas Majan Muscat"]
  },
  "pakistan": {
    "negeri": ["Universitas Quaid-i-Azam Islamabad", "Universitas Sains dan Teknologi Nasional (NUST) Islamabad", "Universitas Punjab Lahore", "Universitas COMSATS Islamabad", "Universitas Teknik & Teknologi Lahore", "Universitas Karatsyi", "Universitas Pertanian Faisalabad", "Universitas Peshawar", "Universitas Kedokteran Dow Karatsyi", "Universitas Sindh Jamshoro"],
    "swasta": ["Universitas Lahore (LUMS)", "Universitas Aga Khan", "Universitas Riphah International", "Universitas FAST NUCES", "Universitas Bahria Islamabad", "Universitas Beaconhouse National", "Universitas Capital Science & Technology", "Universitas Superior Lahore", "Universitas Foundation Islamabad", "Universitas IQRA Karatsyi"]
  },
  "palestina": {
    "negeri": ["Universitas Nasional An-Najah Nablus", "Universitas Al-Quds Yerusalem", "Universitas Politeknik Palestina Hebron", "Universitas Kadoorie Tulkarm", "Universitas Al-Aqsa Gaza", "Institut Teknologi Gaza", "Kolej Keguruan Ramallah", "Institut Kedokteran Nablus", "Sekolah Hukum Hebron", "Institut Sains Terapan Jenin"],
    "swasta": ["Universitas Birzeit", "Universitas Islam Gaza", "Universitas Al-Azhar Gaza", "Universitas Bethlehem", "Universitas Hebron", "Universitas Arab Amerika Jenin", "Universitas Gaza Swasta", "Kolej Bisnis Palestine Ramallah", "Universitas Keperawatan Gaza", "Institut Sains Terapan Gaza"]
  },
  "qatar": {
    "negeri": ["Universitas Qatar", "Universitas Hamad Bin Khalifa", "Universitas Pertahanan Qatar", "Institut Riset Lingkungan Qatar", "Kolej Sains Kesehatan Doha", "Sekolah Teknik Qatar", "Institut Keuangan Doha", "Kolej Keperawatan Qatar", "Institut Maritim Doha", "Sekolah Keguruan Qatar"],
    "swasta": ["Universitas Weill Cornell Qatar", "Universitas Texas A&M Qatar", "Universitas Carnegie Mellon Qatar", "Universitas Georgetown Qatar", "Universitas Northwestern Qatar", "Universitas Virginia Commonwealth Qatar", "Universitas HEC Paris Qatar", "Universitas Stenden Qatar", "Universitas Calgary Qatar", "Universitas University of Aberdeen Qatar"]
  },
  "republik timor leste": {
    "negeri": ["Universitas Nasional Timor Lorosa'e (UNTL)", "Institut Politeknik Hera", "Kolej Pendidikan Baucau", "Institut Kedokteran Dili", "Kolej Pertanian Maliana", "Institut Perikanan Liquiçá", "Sekolah Keguruan Dili", "Institut Sains Terapan Hera", "Sekolah Hukum Dili", "Institut Kehutanan Ermera"],
    "swasta": ["Universitas Dili (UNDIL)", "Universitas Katolik Timor (UCT)", "Universitas Oriental Timor Lorosa'e (UNITAL)", "Universitas Dili Institute of Technology (DIT)", "Universitas Perdamaian Dili (UNPAZ)", "Universitas Cristã Dili", "Kolej Kedokteran Dili Swasta", "Institut Bisnis Dili (IOB)", "Universitas Teknologi Terapan Dili", "Institut Manajemen Canossa"]
  },
  "singapura": {
    "negeri": ["Universitas Nasional Singapura (NUS)", "Universitas Teknologi Nanyang (NTU)", "Universitas Manajemen Singapura (SMU)", "Universitas Sains dan Desain Singapura (SUTD)", "Universitas Ilmu Sosial Singapura (SUSS)", "Institut Teknologi Singapura (SIT)", "Universitas Pertunjukan Yong Siew Toh", "Kolej Kedokteran Duke-NUS", "Politeknik Singapura (SP)", "Politeknik Ngee Ann"],
    "swasta": ["Universitas Teknologi SIM", "Universitas INSEAD Singapura", "Universitas Curtin Singapura", "Universitas James Cook Singapura", "Universitas Management Development Institute of Singapore (MDIS)", "Universitas PSB Academy Singapura", "Universitas Kaplan Singapura", "Universitas RAFFLES Design Institute", "Universitas Amity Global Institute Singapore", "Universitas Dimensions International College"]
  },
  "siprus": {
    "negeri": ["Universitas Siprus", "Universitas Teknologi Siprus", "Universitas Terbuka Siprus", "Kolej Kedokteran Nicosia", "Institut Teknologi Limassol", "Sekolah Keguruan Nicosia", "Institut Maritim Larnaca", "Sekolah Seni Nicosia", "Institut Keuangan Siprus", "Kolej Sains Terapan Paphos"],
    "swasta": ["Universitas Nicosia", "Universitas European Siprus", "Universitas Frederick", "Universitas Neapolis Pafos", "Universitas Eastern Mediterranean", "Universitas Near East Lefkoşa", "Universitas Girne American", "Universitas Cyprus International", "Universitas Final International", "Universitas Cyprus Health and Social Sciences"]
  },
  "sri lanka": {
    "negeri": ["Universitas Colombo", "Universitas Peradeniya", "Universitas Moratuwa", "Universitas Sri Jayewardenepura", "Universitas Kelaniya", "Universitas Ruhuna", "Universitas Jaffna", "Universitas Open Sri Lanka", "Universitas Eastern Sri Lanka", "Universitas Rajarata"],
    "swasta": ["Institut Teknologi Informasi Sri Lanka (SLIIT)", "Universitas NSBM Green Colombo", "Universitas CINEC Maritime", "Universitas Horizon College Colombo", "Universitas KIU Sri Lanka", "Universitas Saegis Colombo", "Universitas Management Corporation Campus", "Universitas Sri Lanka Institute of Nanotechnology", "Universitas Gateway Graduate College", "Universitas APIIT Sri Lanka"]
  },
  "suriah": {
    "negeri": ["Universitas Damaskus", "Universitas Aleppo", "Universitas Tishreen Latakia", "Universitas Al-Baath Homs", "Universitas Al-Furat Deir ez-Zor", "Universitas Syrian Virtual", "Universitas Tartous", "Universitas Hama", "Institut Teknologi Damaskus", "Sekolah Keguruan Aleppo"],
    "swasta": ["Universitas Arab International Damaskus", "Universitas Kalamoon", "Universitas Hawash International", "Universitas International University for Science and Technology", "Universitas Al-Jazeera Deir ez-Zor", "Universitas Al-Wadi International", "Universitas Al-Andalus Medical Sciences", "Universitas Yarmouk Private", "Universitas Al-Rasheed Private", "Universitas Al-Shahba Aleppo"]
  },
  "taiwan": {
    "negeri": ["Universitas Nasional Taiwan (NTU)", "Universitas Tsing Hua Nasional (NTHU)", "Universitas Yang Ming Chiao Tung (NYCU)", "Universitas Cheng Kung Nasional (NCKU)", "Universitas Taiwan Tech (NTUST)", "Universitas Sun Yat-sen Nasional", "Universitas Central Nasional", "Universitas Normal Taiwan Nasional (NTNU)", "Universitas Taipei Tech (NTUT)", "Universitas National Taipei"],
    "swasta": ["Universitas Catholique Fu Jen", "Universitas Tunghai Taichung", "Universitas Tamkang New Taipei", "Universitas Chung Yuan Christian", "Universitas Feng Chia Taichung", "Universitas Taipei Medical", "Universitas Kaohsiung Medical", "Universitas China Medical Taichung", "Universitas Soochow Taipei", "Universitas Chang Gung"]
  },
  "tajikistan": {
    "negeri": ["Universitas Nasional Tajikistan Dushanbe", "Universitas Teknik Tajikistan", "Universitas Medis Negeri Tajikistan", "Universitas Pedagogis Tajikistan", "Universitas Pertanian Tajikistan", "Universitas Khujand State", "Universitas Teknologi Dushanbe", "Universitas Perdagangan Tajikistan", "Universitas Kulyab State", "Universitas Khorog State"],
    "swasta": ["Universitas Slavik Rusia-Tajikistan", "Universitas International Dushanbe", "Universitas Bisnis Tajikistan", "Sekolah Bisnis Internasional Dushanbe", "Universitas Informatika Terapan Dushanbe", "Institut Sains Kesehatan Swasta Khujand", "Kolej Keuangan Dushanbe", "Universitas Bahasa Terapan Dushanbe", "Institut Komunikasi Tajikistan", "Kolej Sains Terapan Dushanbe"]
  },
  "thailand": {
    "negeri": ["Universitas Chulalongkorn", "Universitas Mahidol", "Universitas Chiang Mai", "Universitas Kasetsart", "Universitas Thammasat", "Universitas Khon Kaen", "Universitas Prince of Songkla", "Universitas Teknologi Thonburi (KMUTT)", "Universitas King Mongkut Ladkrabang", "Universitas Srinakharinwirot"],
    "swasta": ["Universitas Bangkok", "Universitas Rangsit", "Universitas Assumption (ABAC)", "Universitas Kamnoetvidya Science Academy", "Universitas Thai Chamber of Commerce (UTCC)", "Universitas Sripatum", "Universitas Payap Chiang Mai", "Universitas Stamford International", "Universitas Huachiew Chalermprakiet", "Universitas Kasem Bundit"]
  },
  "turki": {
    "negeri": ["Universitas Teknik Timur Tengah (METU)", "Universitas Boğaziçi", "Universitas Istanbul", "Universitas Teknik Istanbul (İTÜ)", "Universitas Hacettepe", "Universitas Ankara", "Universitas Ege", "Universitas Dokuz Eylül", "Universitas Marmara", "Universitas Gazi"],
    "swasta": ["Universitas Koç", "Universitas Bilkent", "Universitas Sabancı", "Universitas Çankaya", "Universitas Başkent", "Universitas Yeditepe", "Universitas TOBB ETÜ", "Universitas Bahçeşehir", "Universitas Özyeğin", "Universitas Bilgi Istanbul"]
  },
  "turkmenistan": {
    "negeri": ["Universitas Negeri Turkmenistan Magtymguly", "Universitas Minyak dan Gas Turkmenistan", "Universitas Teknologi Turkmenistan Oguz Han", "Universitas Pertanian Turkmenistan", "Universitas Medis Negeri Turkmenistan", "Universitas Teknik Turkmenistan", "Universitas Ekonomi dan Manajemen Turkmenistan", "Universitas Pedagogis Turkmenistan Seyitnazar Seydi", "Universitas Hubungan Internasional Ashgabat", "Universitas Arsitektur Ashgabat"],
    "swasta": ["Universitas Terapan Swasta Ashgabat", "Institut Bisnis Internasional Ashgabat", "Sekolah Tinggi Komunikasi Ashgabat", "Institut Sains Terapan Turkmen", "Kolej Keuangan Swasta Ashgabat", "Universitas Informatika Terapan Ashgabat", "Institut Sains Kesehatan Swasta Ashgabat", "Kolej Perdagangan Turkmenabat", "Institut Teknologi Terapan Mary", "Universitas Bahasa Terapan Ashgabat"]
  },
  "uni emirat arab": {
    "negeri": ["Universitas Uni Emirat Arab (UAEU)", "Universitas Zayed", "Universitas Higher Colleges of Technology (HCT)", "Universitas Sorbonne Abu Dhabi", "Universitas Pertahanan Nasional UAE", "Kolej Sains Kesehatan Sharjah", "Institut Kedokteran Abu Dhabi", "Sekolah Teknik Ras Al Khaimah", "Institut Keuangan Dubai", "Sekolah Keguruan UAE"],
    "swasta": ["Universitas Khalifa Abu Dhabi", "Universitas Amerika Sharjah (AUS)", "Universitas Sharjah", "Universitas Amerika Dubai (AUD)", "Universitas NYU Abu Dhabi", "Universitas Abu Dhabi", "Universitas Ajman", "Universitas Wollongong di Dubai", "Universitas Birmingham Dubai", "Universitas Heriot-Watt Dubai"]
  },
  "uzbekistan": {
    "negeri": ["Universitas Nasional Uzbekistan Mirzo Ulugbek", "Universitas Teknik Negeri Tashkent", "Universitas Teknologi Informasi Tashkent", "Universitas Ekonomi Negeri Tashkent", "Universitas Kedokteran Tashkent", "Universitas Pedagogis Tashkent", "Universitas Samarkand State", "Universitas Urgench State", "Universitas Bukhara State", "Universitas Fergana State"],
    "swasta": ["Universitas Inha Tashkent", "Universitas Westminster International Tashkent", "Universitas Akfa Tashkent", "Universitas Webster Tashkent", "Universitas Management and Technology Tashkent", "Universitas Bucheon Tashkent", "Universitas Yeungnam Tashkent", "Universitas Singapore Institute of Management Tashkent", "Universitas Amity Tashkent", "Universitas Sharda Tashkent"]
  },
  "vietnam": {
    "negeri": ["Universitas Nasional Vietnam Hanoi (VNU)", "Universitas Sains dan Teknologi Hanoi (HUST)", "Universitas Nasional Vietnam Ho Chi Minh City", "Universitas Kedokteran Hanoi", "Universitas Ekonomi Ho Chi Minh City", "Universitas Can Tho", "Universitas Danang", "Universitas Hue", "Universitas Perdagangan Luar Negeri Hanoi (FTU)", "Universitas Pedagogy Hanoi"],
    "swasta": ["Universitas Ton Duc Thang", "Universitas Duy Tan", "Universitas RMIT Vietnam", "Universitas VinUniversity", "Universitas FPT Hanoi", "Universitas Van Lang Ho Chi Minh", "Universitas Nguyen Tat Thanh", "Universitas Hoa Sen", "Universitas Phenikaa Hanoi", "Universitas Hong Bang International"]
  },
  "yaman": {
    "negeri": ["Universitas Sana'a", "Universitas Aden", "Universitas Taiz", "Universitas Hodeidah", "Universitas Ibb", "Universitas Hadramout", "Universitas Dhamar", "Universitas Al-Baydha", "Universitas Amran", "Universitas Sa'ada"],
    "swasta": ["Universitas Sains dan Teknologi Yaman", "Universitas Al-Ahgaff Mukalla", "Universitas Queen Arwa Sana'a", "Universitas Lebanese International Sana'a", "Universitas National Taiz", "Universitas Al-Nasser Sana'a", "Universitas Future Sana'a", "Universitas University of Modern Sciences Sana'a", "Universitas Al-Saeed Taiz", "Universitas International University of Technology Sana'a"]
  },
  "yordania": {
    "negeri": ["Universitas Yordania Amman", "Universitas Sains dan Teknologi Yordania (JUST)", "Universitas Yarmouk Irbid", "Universitas Hashemite Zarqa", "Universitas Al-Balqa Applied", "Universitas Mutah", "Universitas Al-Hussein Bin Talal", "Universitas Tafila Technical", "Universitas Mut'ah Karak", "Sekolah Teknik Amman"],
    "swasta": ["Universitas German Jordanian", "Universitas Princess Sumaya Technology", "Universitas Philadelphia Yordania", "Universitas Applied Science Private Amman", "Universitas Al-Ahliyya Amman", "Universitas Middle East Amman", "Universitas Isra Amman", "Universitas Petra Amman", "Universitas Zarqa Private", "Universitas Irbid National"]
  },

  // --- EROPA ---
  "albania": {
    "negeri": ["Universitas Tirana", "Universitas Politeknik Tirana", "Universitas Pertanian Tirana", "Universitas Medis Tirana", "Universitas Aleksandër Xhuvani Elbasan", "Universitas Luigj Gurakuqi Shkodër", "Universitas Fan Noli Korçë", "Universitas Ismail Qemali Vlorë", "Universitas Aleksandër Moisiu Durrës", "Universitas Eqrem Çabej Gjirokastër"],
    "swasta": ["Universitas Epoka Tirana", "Universitas Luarasi Tirana", "Universitas New York Tirana", "Universitas Katolik Our Lady of Good Counsel", "Universitas Canadian Institute of Technology Tirana", "Universitas Polis Tirana", "Universitas Marin Barleti Tirana", "Universitas Tirana Business University", "Universitas Aldent Tirana", "Universitas Bedër Tirana"]
  },
  "andorra": {
    "negeri": ["Universitas Andorra", "Institut Sains Terapan Andorra", "Sekolah Keperawatan Andorra", "Institut Keguruan Andorra", "Sekolah Hukum Andorra", "Institut Maritim Andorra", "Sekolah Teknik Andorra", "Institut Keuangan Andorra", "Sekolah Seni Andorra", "Institut Statistik Andorra"],
    "swasta": ["Universitas Internasional Andorra", "Kolej Kedokteran Andorra", "Kolej Bisnis Andorra", "Universitas Terbuka Andorra", "Institut Pariwisata Andorra", "Institut Teknologi Andorra", "Kolej Pendidikan Andorra", "Sekolah Bisnis Internasional Andorra", "Universitas Informatika Terapan Andorra", "Kolej Komunikasi Andorra"]
  },
  "austria": {
    "negeri": ["Universitas Wina", "Universitas Teknologi Wina (TU Wien)", "Universitas Kedokteran Wina", "Universitas Innsbruck", "Universitas Graz", "Universitas Sains Ekonomi Wina (WU)", "Universitas Johannes Kepler Linz", "Universitas Klagenfurt", "Universitas Salzburg", "Universitas BOKU Wina"],
    "swasta": ["Universitas Webster Wina", "Universitas Modul Wina", "Universitas Sigmund Freud Wina", "Universitas CEU Wina", "Universitas Musik Swasta Musik und Kunst Wina", "Universitas Paracelsus Medical Salzburg", "Universitas UMIT TIROL Hall in Tirol", "Universitas Seeburg Castle Salzburg", "Universitas Anton Bruckner Linz", "Universitas Jam Music Lab Wina"]
  },
  "belanda": {
    "negeri": ["Universitas TU Delft", "Universitas Amsterdam (UvA)", "Universitas Wageningen", "Universitas Leiden", "Universitas Utrecht", "Universitas Erasmus Rotterdam", "Universitas Vrije Amsterdam (VU)", "Universitas Eindhoven Technology (TU/e)", "Universitas Groningen", "Universitas Maastricht"],
    "swasta": ["Universitas Nyenrode Business", "Universitas Tias Nimbas Business", "Universitas Webster Leiden", "Universitas Hotel School The Hague", "Universitas Breda Applied Sciences", "Universitas Wittenborg Applied Sciences", "Universitas Saxion Applied Sciences", "Universitas Fontys Applied Sciences", "Universitas HAN Applied Sciences", "Universitas Inholland Applied Sciences"]
  },
  "belarus": {
    "negeri": ["Universitas Negeri Belarusia (BSU) Minsk", "Universitas Informatika dan Radioelektronika Belarusia (BSUIR)", "Universitas Teknik Nasional Belarusia (BNTU)", "Universitas Kedokteran Negeri Belarusia", "Universitas Ekonomi Negeri Belarusia", "Universitas Pedagogis Negeri Belarusia", "Universitas Grodno Yanka Kupala", "Universitas Vitebsk State", "Universitas Brest State", "Universitas Gomel State"],
    "swasta": ["Universitas EHU Minsk-Vilnius", "Universitas BIP Institute of Law Minsk", "Universitas International Mitso Minsk", "Universitas Institute of Modern Knowledge Minsk", "Universitas Minsk Innovation University", "Institut Manajemen Bisnis Minsk", "Universitas Informatika Terapan Minsk", "Sekolah Bisnis Internasional BSUIR", "Kolej Keuangan Swasta Minsk", "Universitas Komunikasi Terapan Minsk"]
  },
  "belgia": {
    "negeri": ["Universitas KU Leuven", "Universitas Ghent", "Universitas Catholique de Louvain (UCLouvain)", "Universitas Libre de Bruxelles (ULB)", "Universitas Vrije Brussel (VUB)", "Universitas Antwerp", "Universitas Liège", "Universitas Hasselt", "Universitas Mons", "Universitas Namur"],
    "swasta": ["Universitas Vlerick Business School", "Universitas United Business Institutes Brussels", "Universitas Boston University Brussels", "Universitas Vesalius College Brussels", "Universitas Brussels School of Governance", "Universitas Antwerp Management School", "Universitas Solvay Brussels School", "Universitas ICHEC Brussels Management School", "Universitas BBI Luxembourg-Brussels", "Universitas European University Brussels"]
  },
  "bosnia dan hercegovina": {
    "negeri": ["Universitas Sarajevo", "Universitas Banja Luka", "Universitas Mostar", "Universitas Tuzla", "Universitas Zenica", "Universitas Bihać", "Universitas Džemal Bijedić Mostar", "Universitas East Sarajevo", "Sekolah Keguruan Sarajevo", "Institut Teknik Banja Luka"],
    "swasta": ["Universitas International Sarajevo", "Universitas Sarajevo School of Science and Technology", "Universitas Aperion Banja Luka", "Universitas American University in Bosnia", "Universitas Slobomir P Banja Luka", "Universitas Bijeljina Swasta", "Universitas Victoria Mostar", "Universitas International Burch Sarajevo", "Universitas Kallos Tuzla", "Universitas Synergy Bijeljina"]
  },
  "bulgaria": {
    "negeri": ["Universitas Sofia St. Kliment Ohridski", "Universitas Teknik Sofia", "Universitas Medis Sofia", "Universitas Ekonomi Nasional dan Dunia Sofia", "Universitas Plovdiv Paisii Hilendarski", "Universitas Medis Plovdiv", "Universitas Varna Economics", "Universitas Thracian Stara Zagora", "Universitas South-West Blagoevgrad", "Universitas Ruse Angel Kanchev"],
    "swasta": ["Universitas Amerika di Bulgaria (AUBG)", "Universitas New Bulgarian Sofia", "Universitas Varna Free", "Universitas Burgas Free", "Universitas International University College Dobrich", "Universitas European Higher School of Economics Plovdiv", "Universitas High School of Insurance Sofia", "Universitas Telecommunications Sofia", "Universitas Theater Arts Sofia", "Universitas Kedokteran Swasta Varna"]
  },
  "ceko": {
    "negeri": ["Universitas Charles Praha", "Universitas Teknik Ceko di Praha (ČVUT)", "Universitas Masaryk Brno", "Universitas Teknologi Brno (VUT)", "Universitas Kimia dan Teknologi Praha (VŠCHT)", "Universitas Palacký Olomouc", "Universitas Ekonomi Praha (VŠE)", "Universitas Pertanian Ceko Praha (ČZU)", "Universitas Ostrava", "Universitas Pardubice"],
    "swasta": ["Universitas New York in Prague (UNYP)", "Universitas Anglo-American Prague", "Universitas Praha School of Creative Communication", "Universitas Metropolitní Praha", "Universitas Jan Amos Komenský Praha", "Universitas Finance and Administration Praha (VŠFS)", "Universitas Ambis Praha", "Universitas College of Business Prague", "Universitas Škoda Auto University Mladá Boleslav", "Universitas Architectural Institute in Prague (ARCHIP)"]
  },
  "denmark": {
    "negeri": ["Universitas Kopenhagen", "Universitas Teknik Denmark (DTU)", "Universitas Aarhus", "Universitas Aalborg", "Universitas Syddansk (Southern Denmark)", "Universitas Bisnis Kopenhagen (CBS)", "Universitas Roskilde", "Universitas IT Kopenhagen", "Kolej Universitas Kopenhagen", "Universitas VIA University College Aarhus"],
    "swasta": ["Universitas Kaospilot Aarhus", "Universitas Kopenhagen Design School Swasta", "Universitas Niels Brock Copenhagen Business", "Institut Bisnis Internasional Kopenhagen", "Universitas Informatika Terapan Kopenhagen", "Sekolah Seni Media Kopenhagen", "Kolej Musik Swasta Jutland", "Institut Kedokteran Swasta Aarhus", "Universitas Komunikasi Terapan Kopenhagen", "Kolej Keuangan Terapan Denmark"]
  },
  "estonia": {
    "negeri": ["Universitas Tartu", "Universitas Teknologi Tallinn (TalTech)", "Universitas Tallinn", "Universitas Ilmu Hayati Estonia Tartu", "Universitas Seni Estonia Tallinn", "Universitas Musik dan Teater Estonia", "Kolej Penerbangan Estonia", "Kolej Ilmu Kesehatan Tallinn", "Universitas IT College Tallinn", "Kolej Keperawatan Tartu"],
    "swasta": ["Universitas Estonian Business School (EBS)", "Universitas Entrepreneurship Mainor", "Kolej Bisnis Euroacademy Tallinn", "Institut Informatika Swasta Tallinn", "Sekolah Bisnis Internasional Tartu", "Universitas Sains Terapan Swasta Tallinn", "Kolej Komunikasi Terapan Tallinn", "Institut Keuangan Swasta Tallinn", "Universitas Bahasa Terapan Tallinn", "Kolej Seni Media Swasta Tallinn"]
  },
  "finlandia": {
    "negeri": ["Universitas Helsinki", "Universitas Aalto", "Universitas Tampere", "Universitas Turku", "Universitas Oulu", "Universitas Jyväskylä", "Universitas Finlandia Timur (UEF)", "Universitas LUT Lappeenranta", "Universitas Åbo Akademi", "Universitas Vaasa"],
    "swasta": ["Universitas Metropolia Applied Sciences", "Universitas Haaga-Helia Applied Sciences", "Universitas HAMK Applied Sciences", "Universitas Laurea Applied Sciences", "Universitas LAB Applied Sciences", "Universitas JAMK Applied Sciences", "Universitas SAVONIA Applied Sciences", "Universitas SAMK Applied Sciences", "Universitas XAMK Applied Sciences", "Universitas LAPLAND Applied Sciences"]
  },
  "gibraltar": {
    "negeri": ["Universitas Gibraltar", "Institut Kesehatan Gibraltar", "Institut Keuangan Gibraltar", "Kolej Pendidikan Gibraltar", "Institut Maritim Gibraltar", "Sekolah Teknik Gibraltar", "Institut Sains Terapan Gibraltar", "Sekolah Keperawatan Gibraltar", "Institut Statistik Gibraltar", "Kolej Kelautan Gibraltar"],
    "swasta": ["Kolej Maritim Gibraltar Swasta", "Kolej Bisnis Gibraltar", "Kolej Hukum Gibraltar", "Institut Pariwisata Gibraltar", "Kolej Komunikasi Gibraltar", "Sekolah Bisnis Internasional Gibraltar", "Universitas Informatika Terapan Gibraltar", "Institut Sains Kesehatan Swasta Gibraltar", "Kolej Teknologi Terapan Gibraltar", "Universitas Bahasa Terapan Gibraltar"]
  },
  "hungaria": {
    "negeri": ["Universitas Eötvös Loránd (ELTE) Budapest", "Universitas Teknologi dan Ekonomi Budapest (BME)", "Universitas Szeged", "Universitas Debrecen", "Universitas Pécs", "Universitas Semmelweis Kedokteran Budapest", "Universitas Corvinus Budapest", "Universitas Szent István Gödöllő", "Universitas Miskolc", "Universitas Pannon Veszprém"],
    "swasta": ["Universitas METU Metropolitan Budapest", "Universitas Katolik Pázmány Péter", "Universitas Reformasi Károli Gáspár", "Universitas Central European (CEU) Budapest", "Universitas IBS International Business School Budapest", "Universitas Wekerle Business Budapest", "Universitas Kodolányi János Székesfehérvár", "Universitas Milton Friedman Budapest", "Universitas McDaniel College Budapest", "Universitas Andrássy Budapest"]
  },
  "inggris": {
    "negeri": ["Universitas Oxford", "Universitas Cambridge", "Imperial College London", "University College London (UCL)", "London School of Economics (LSE)", "Universitas Edinburgh", "Universitas Manchester", "King's College London", "Universitas Warwick", "Universitas Bristol"],
    "swasta": ["Universitas Buckingham", "Universitas BPP London", "Universitas Law London", "Universitas Regent's London", "Universitas Northeastern London (NCH)", "Universitas Arden Coventry", "Universitas Richmond American London", "Universitas London Interdisciplinary School", "Universitas Hult International Business School London", "Universitas European Business School London"]
  },
  "irlandia": {
    "negeri": ["Trinity College Dublin (TCD)", "University College Dublin (UCD)", "Universitas Nasional Irlandia Galway (University of Galway)", "University College Cork (UCC)", "Universitas Dublin City (DCU)", "Universitas Limerick", "Universitas Teknologi Dublin (TU Dublin)", "Universitas Teknologi Munster", "Universitas Teknologi Maynooth", "Universitas Teknologi Atlantic"],
    "swasta": ["Universitas Griffith College Dublin", "Universitas National College of Ireland (NCI)", "Universitas Dublin Business School (DBS)", "Universitas ICD Business School Dublin", "Universitas Independent Colleges Dublin", "Universitas American College Dublin", "Universitas Dorset College Dublin", "Universitas IBAT College Dublin", "Universitas Portobello College Dublin", "Universitas St. Patrick's Pontifical Maynooth"]
  },
  "islandia": {
    "negeri": ["Universitas Islandia Reykjavík", "Universitas Akureyri", "Universitas Pertanian Islandia Hvanneyri", "Kolej Universitas Hólar", "Institut Sains Kedokteran Reykjavík", "Sekolah Teknik Reykjavík", "Kolej Keperawatan Akureyri", "Institut Keguruan Reykjavík", "Sekolah Seni Reykjavík", "Institut Statistik Islandia"],
    "swasta": ["Universitas Reykjavík", "Universitas Bifröst", "Universitas Seni Islandia Reykjavík", "Kolej Teknologi Islandia Swasta", "Universitas Maritim Reykjavík", "Institut Bisnis Internasional Reykjavík", "Universitas Informatika Terapan Reykjavík", "Kolej Sains Kesehatan Swasta Islandia", "Institut Komunikasi Terapan Reykjavík", "Kolej Keuangan Swasta Reykjavík"]
  },
  "italia": {
    "negeri": ["Universitas Bologna", "Universitas Sapienza Roma", "Politecnico di Milano", "Universitas Padova", "Universitas Statale di Milano", "Politecnico di Torino", "Universitas Pisa", "Universitas Florence", "Universitas Naples Federico II", "Universitas Milano-Bicocca"],
    "swasta": ["Universitas Bocconi Milano", "Universitas Katolik Sacro Cuore Milano", "Universitas LUISS Guido Carli Roma", "Universitas Vita-Salute San Raffaele Milano", "Universitas LUMSA Roma", "Universitas IULM Milano", "Universitas NABA Nuova Accademia di Belle Arti", "Universitas Istituto Marangoni Milano", "Universitas Humanitas Milano", "Universitas Cattolica del Sacro Cuore Roma"]
  },
  "jerman": {
    "negeri": ["Universitas Ludwig Maximilian Munich (LMU)", "Universitas Teknik Munich (TUM)", "Universitas Heidelberg", "Universitas Humboldt Berlin", "Universitas Free Berlin", "Universitas RWTH Aachen", "Universitas KIT Karlsruhe", "Universitas Tubingen", "Universitas Freiburg", "Universitas Bonn"],
    "swasta": ["Universitas Frankfurt School of Finance & Management", "Universitas WHU – Otto Beisheim School of Management", "Universitas ESMT Berlin", "Universitas Constructor Bremen (Jacobs)", "Universitas EBS Business Wiesbaden", "Universitas GISMA Business School", "Universitas SRH Berlin University of Applied Sciences", "Universitas International University (IU)", "Universitas EU Business School Munich", "Universitas Kühne Logistics University Hamburg"]
  },
  "kepulauan faroe": {
    "negeri": ["Universitas Kepulauan Faroe (Fróðskaparsetur Føroya)", "Institut Laut Faroe Tórshavn", "Kolej Keperawatan Faroe", "Institut Teknologi Tórshavn", "Kolej Perdagangan Faroe", "Institut Pendidikan Tórshavn", "Kolej Seni Faroe", "Institut Sains Terapan Faroe", "Sekolah Teknik Klaksvík", "Institut Kedokteran Tórshavn"],
    "swasta": ["Kolej Maritim Tórshavn Swasta", "Institut Bisnis Klaksvík", "Sekolah Bisnis Internasional Faroe", "Universitas Informatika Terapan Tórshavn", "Kolej Sains Kesehatan Swasta Faroe", "Institut Komunikasi Tórshavn", "Kolej Keuangan Swasta Faroe", "Universitas Bahasa Terapan Faroe", "Institut Pariwisata Klaksvík", "Kolej Komputer Terapan Faroe"]
  },
  "kosovo": {
    "negeri": ["Universitas Pristina Hasan Prishtina", "Universitas Prizren Ukshin Hoti", "Universitas Peja Haxhi Zeka", "Universitas Mitrovica Isa Boletini", "Universitas Gjilan Kadri Zeka", "Universitas Ferizaj Applied Sciences", "Institut Teknik Pristina", "Sekolah Kedokteran Pristina", "Kolej Keguruan Prizren", "Institut Pertanian Peja"],
    "swasta": ["Universitas UBT Pristina", "Universitas AAB Pristina", "Universitas Riinvest Pristina", "Universitas American University in Kosovo (RIT)", "Universitas Universum Pristina", "Universitas Fama Pristina", "Universitas Iliria Pristina", "Universitas Kolegji Pjetër Budi", "Universitas Biznesi Pristina", "Universitas Tempulli Pristina"]
  },
  "kroasia": {
    "negeri": ["Universitas Zagreb", "Universitas Split", "Universitas Rijeka", "Universitas Osijek Josip Juraj Strossmayer", "Universitas Zadar", "Universitas Pula Juraj Dobrila", "Universitas Dubrovnik", "Universitas Sjever Varaždin", "Politeknik Zagreb", "Politeknik Rijeka"],
    "swasta": ["Universitas Katolik Kroasia Zagreb", "Universitas ZŠEM Zagreb School of Economics", "Universitas RIT Croatia Dubrovnik", "Universitas Libertas International Zagreb", "Universitas VERN' Zagreb", "Universitas Edward Bernays Zagreb", "Universitas Algebra University College Zagreb", "Universitas Effectus Zagreb", "Universitas Aspira Split", "Universitas Baltazar Zaprešić"]
  },
  "latvia": {
    "negeri": ["Universitas Latvia Riga", "Universitas Teknik Riga (RTU)", "Universitas Riga Stradiņš (RSU)", "Universitas Ilmu Hayati Latvia Jelgava", "Universitas Daugavpils", "Universitas Liepāja", "Universitas Ventspils University College", "Universitas Akademi Seni Latvia", "Universitas Akademi Musik Latvia", "Universitas Akademi Olahraga Latvia"],
    "swasta": ["Universitas Transportasi dan Telekomunikasi Riga (TSI)", "Universitas RISEBA Riga", "Universitas Turība Riga", "Universitas Stockholm School of Economics in Riga (SSE Riga)", "Universitas ISMA Riga", "Universitas EKA University of Applied Sciences Riga", "Universitas Baltic International Academy Riga", "Universitas RPIVA Riga", "Universitas Lutera Riga", "Universitas Law College Riga"]
  },
  "liechtenstein": {
    "negeri": ["Universitas Liechtenstein Vaduz", "Institut Teknologi Liechtenstein", "Kolej Bisnis Vaduz", "Institut Sains Terapan Liechtenstein", "Kolej Keuangan Vaduz", "Institut Kedokteran Liechtenstein", "Sekolah Keguruan Liechtenstein", "Institut Statistik Vaduz", "Kolej Seni Liechtenstein", "Institut Hukum Vaduz"],
    "swasta": ["Universitas Khusus Swasta Kepangeranan Liechtenstein (UFL)", "Kolej Hukum Vaduz Swasta", "Institut Komunikasi Liechtenstein", "Kolej Seni Vaduz", "Sekolah Bisnis Internasional Liechtenstein", "Universitas Informatika Terapan Vaduz", "Institut Sains Kesehatan Swasta Liechtenstein", "Kolej Keuangan Swasta Vaduz", "Universitas Bahasa Terapan Liechtenstein", "Institut Teknologi Terapan Vaduz"]
  },
  "lithuania": {
    "negeri": ["Universitas Vilnius", "Universitas Teknologi Kaunas (KTU)", "Universitas Vytautas Magnus Kaunas", "Universitas Teknik Vilnius Gediminas (VILNIUS TECH)", "Universitas Sains Kesehatan Lithuania Kaunas", "Universitas Klaipėda", "Universitas Šiauliai", "Universitas Mykolas Romeris Vilnius", "Universitas Olahraga Lithuania Kaunas", "Universitas Akademi Musik Lithuania"],
    "swasta": ["Universitas LCC International Klaipėda", "Universitas ISM University of Management Vilnius", "Universitas Kazimieras Simonavičius Vilnius", "Universitas EHU Vilnius (Universitas Humaniora)", "Universitas Vilniaus Kolegija Swasta", "Universitas Kauno Kolegija Swasta", "Universitas SMK University of Applied Sciences Vilnius", "Universitas Northern Lithuania College", "Universitas Graičiūnas School of Management", "Universitas Kolping College Kaunas"]
  },
  "luksemburg": {
    "negeri": ["Universitas Luksemburg", "Institut Teknologi Luksemburg", "Kolej Keuangan Luksemburg", "Institut Kedokteran Luksemburg", "Sekolah Keguruan Luksemburg", "Institut Statistik Luksemburg", "Sekolah Hukum Luksemburg", "Institut Sains Terapan Luksemburg", "Sekolah Seni Luksemburg", "Kolej Maritim Luksemburg"],
    "swasta": ["Universitas Internasional Lunex", "Universitas Bisnis Luksemburg (LBS)", "Universitas Sains Terapan Luksemburg Swasta", "Kolej Eropa Luksemburg", "Institut Komunikasi Luksemburg", "Kolej Manajemen Esch-sur-Alzette", "Sekolah Bisnis Internasional Luksemburg", "Universitas Informatika Terapan Luksemburg", "Institut Sains Kesehatan Swasta Luksemburg", "Kolej Keuangan Swasta Luksemburg"]
  },
  "makedonia utara": {
    "negeri": ["Universitas St. Cyril dan Methodius Skopje", "Universitas Goce Delčev Štip", "Universitas St. Kliment Ohridski Bitola", "Universitas Tetovo", "Universitas Sains Komputer Ohrid", "Universitas Mother Teresa Skopje", "Institut Politeknik Skopje", "Sekolah Kedokteran Bitola", "Kolej Keguruan Štip", "Institut Pertanian Strumica"],
    "swasta": ["Universitas SEEU Tetovo", "Universitas American College Skopje (UACS)", "Universitas FON Skopje", "Universitas International Balkan Skopje (IBU)", "Universitas EURO College Kumanovo", "Universitas MIT Skopje", "Universitas International University of Struga", "Universitas Vision International Gostivar", "Universitas Slavik Sveti Nikole", "Universitas New York Skopje"]
  },
  "malta": {
    "negeri": ["Universitas Malta Msida", "Institut Seni Akuntansi Teknologi Malta (MCAST)", "Kolej Pariwisata Malta (ITH)", "Sekolah Kedokteran Malta", "Institut Maritim Malta", "Sekolah Keguruan Valletta", "Institut Sains Terapan Malta", "Sekolah Keperawatan Msida", "Institut Keuangan Malta", "Institut Statistik Malta"],
    "swasta": ["Universitas Amerika Malta", "Universitas Sains Kesehatan Malta Swasta", "Kolej Bisnis Valletta", "Institut Teknologi Informasi Malta Swasta", "Kolej Pendidikan Malta Swasta", "Universitas Manajemen Sliema", "Sekolah Bisnis Internasional Malta", "Universitas Informatika Terapan Malta", "Institut Komunikasi Terapan Malta", "Kolej Keuangan Swasta Malta"]
  },
  "moldova": {
    "negeri": ["Universitas Negeri Moldova Chișinău", "Universitas Teknik Moldova Chișinău", "Universitas Medis dan Farmasi Negeri Nicolae Testemițanu", "Universitas Studi Ekonomi Moldova (ASEM)", "Universitas Pedagogis Negeri Ion Creangă", "Universitas Agraris Negeri Moldova", "Universitas Bălți Alecu Russo", "Universitas Cahul Bogdan Petriceicu Hasdeu", "Universitas Comrat State", "Universitas Taraclia State"],
    "swasta": ["Universitas Free International Moldova (ULIM)", "Universitas Persada Komrat", "Universitas Studi Eropa Moldova (USEM)", "Universitas Kemanusiaan Moldova", "Universitas Politeknik Swasta Chișinău", "Universitas Bisnis Internasional Chișinău", "Universitas Informatika Terapan Moldova", "Institut Sains Kesehatan Swasta Chișinău", "Kolej Keuangan Swasta Chișinău", "Universitas Komunikasi Terapan Moldova"]
  },
  "monako": {
    "negeri": ["Institut Teknologi Monako", "Kolej Kedokteran Monako", "Institut Maritim Monako", "Institut Pariwisata Monako", "Sekolah Keguruan Monte Carlo", "Institut Keuangan Monako", "Sekolah Seni Monako", "Institut Sains Terapan Monako", "Sekolah Keperawatan Monako", "Institut Statistik Monako"],
    "swasta": ["Universitas Internasional Monako (IUM)", "Kolej Bisnis Monte Carlo", "Kolej Keuangan Monako Swasta", "Institut Sains Terapan Monako Swasta", "Kolej Komunikasi Monako", "Institut Seni Monte Carlo Swasta", "Sekolah Bisnis Internasional Monako", "Universitas Informatika Terapan Monako", "Institut Sains Kesehatan Swasta Monako", "Kolej Keuangan Swasta Monte Carlo"]
  },
  "montenegro": {
    "negeri": ["Universitas Montenegro Podgorica", "Institut Laut Kotor", "Kolej Bisnis Podgorica", "Institut Teknologi Cetinje", "Universitas Sains Terapan Nikšić", "Sekolah Kedokteran Podgorica", "Institut Keguruan Bijelo Polje", "Sekolah Teknik Bar", "Institut Pertanian Podgorica", "Sekolah Hukum Kotor"],
    "swasta": ["Universitas Donja Gorica UDG Podgorica", "Universitas Mediterania Podgorica", "Universitas Adriatic Bar", "Universitas Politeknik Podgorica Swasta", "Kolej Pariwisata Budva Swasta", "Sekolah Bisnis Internasional Podgorica", "Universitas Informatika Terapan Podgorica", "Institut Sains Kesehatan Swasta Montenegro", "Kolej Keuangan Swasta Podgorica", "Universitas Komunikasi Terapan Bar"]
  },
  "norwegia": {
    "negeri": ["Universitas Oslo", "Universitas Sains dan Teknologi Norwegia (NTNU) Trondheim", "Universitas Bergen", "Universitas UiT Arctic Norway Tromsø", "Universitas Sains Hayati Norwegia (NMBU) Ås", "Universitas Stavanger", "Universitas Agder Kristiansand", "Universitas OsloMet", "Universitas Nord Bodø", "Universitas Keuangan Norwegia NHH Bergen"],
    "swasta": ["Universitas Bisnis BI Norwegian Oslo", "Universitas Kristiania University College Oslo", "Universitas VID Specialized Oslo", "Universitas Ansgar University College Kristiansand", "Universitas NLA University College Bergen", "Universitas Queen Maud University College Trondheim", "Universitas MF Norwegian School of Theology Oslo", "Universitas Atlantis Medical College Oslo", "Universitas Steiner University College Oslo", "Universitas Norwegian School of Information Technology (NITH)"]
  },
  "polandia": {
    "negeri": ["Universitas Jagiellonian Krakow", "Universitas Warsawa", "Universitas Teknologi Warsawa (PW)", "Universitas AGH Sains dan Teknologi Krakow", "Universitas Adam Mickiewicz Poznań", "Universitas Teknologi Wrocław (PWr)", "Universitas Kedokteran Gdańsk", "Universitas Kedokteran Warsawa", "Universitas Wrocław", "Universitas Łódź"],
    "swasta": ["Universitas SWPS Humaniora Warsawa", "Universitas Kozminski Warsawa", "Universitas Lazarski Warsawa", "Universitas Vistula Warsawa", "Universitas Polish-Japanese Academy of Information Technology", "Universitas WSB Merito Poznań", "Universitas Wyższa Szkoła Bankowa Wrocław", "Universitas Collegium Civitas Warsawa", "Universitas Upper Silesian Katowice", "Universitas Katolik Lublin (KUL)"]
  },
  "portugal": {
    "negeri": ["Universitas Lisbon", "Universitas Porto", "Universitas Coimbra", "Universitas NOVA Lisbon", "Universitas Aveiro", "Universitas Minho Braga", "Universitas Algarve Faro", "Institut Politeknik Porto", "Universitas Beira Interior Covilhã", "Universitas Évora"],
    "swasta": ["Universitas Katolik Portugis", "Universitas Fernando Pessoa Porto", "Universitas Lusófona Lisbon", "Universitas Autonoma de Lisboa", "Universitas Portucalense Porto", "Universitas Atlântica Lisbon", "Universitas Europeia Lisbon", "Universitas ISMAI Maia", "Universitas Camilo Castelo Branco", "Universitas Instituto Superior de Psicologia Aplicada (ISPA)"]
  },
  "prancis": {
    "negeri": ["Universitas PSL Paris", "Universitas Sorbonne Paris", "Institut Politeknik Paris", "Universitas Paris-Saclay", "Universitas Paris Cité", "Universitas École Polytechnique", "Universitas Grenoble Alpes", "Universitas Aix-Marseille", "Universitas Bordeaux", "Universitas Lyon 1 Claude Bernard"],
    "swasta": ["Universitas HEC Paris", "Universitas INSEAD Fontainebleau", "Universitas ESSEC Business School", "Universitas ESCP Business School", "Universitas Katolik de Lille", "Universitas Katolik de Paris", "Universitas EDHEC Business School", "Universitas emlyon business school", "Universitas SKEMA Business School", "Universitas Katolik de Lyon"]
  },
  "republik rumania": {
    "negeri": ["Universitas Babeș-Bolyai Cluj-Napoka", "Universitas Bukares", "Universitas Politehnica Bukares", "Universitas Alexandru Ioan Cuza Iași", "Universitas Kedokteran Carol Davila Bukares", "Universitas Vest Timișoara", "Universitas Teknik Cluj-Napoka", "Universitas Transilvania Brașov", "Universitas Kedokteran Iuliu Hațieganu Cluj", "Universitas Studi Ekonomi Bukares (ASE)"],
    "swasta": ["Universitas Titu Maiorescu Bukares", "Universitas Nicolae Titulescu Bukares", "Universitas Spiru Haret Bukares", "Universitas Româno-Americană Bukares", "Universitas Danubius Galați", "Universitas Dimitrie Cantemir Bukares", "Universitas Vasile Goldiș Arad", "Universitas Andrei Șaguna Constanța", "Universitas George Bacovia Bacău", "Universitas Bogdan Vodă Cluj-Napoca"]
  },
  "republik serbia": {
    "negeri": ["Universitas Beograd", "Universitas Novi Sad", "Universitas Niš", "Universitas Kragujevac", "Universitas Seni Beograd", "Universitas Novi Pazar State", "Universitas Pertahanan Beograd", "Institut Teknik Beograd", "Sekolah Kedokteran Novi Sad", "Institut Pertanian Čačak"],
    "swasta": ["Universitas Singidunum Beograd", "Universitas Educons Sremska Kamenica", "Universitas Megatrend Beograd", "Universitas Union Beograd", "Universitas Metropolitan Beograd", "Universitas Alfa BK Beograd", "Universitas Akademija Umetnosti Novi Sad", "Universitas Privredna Akademija Novi Sad", "Universitas Singidunum Niš", "Universitas ITS Beograd"]
  },
  "rusia": {
    "negeri": ["Universitas Negeri Moskow Lomonosov (MSU)", "Universitas Negeri Saint Petersburg (SPbSU)", "Universitas HSE Moskow", "Universitas Riset Nuklir MEPhI Moskow", "Universitas Fisika dan Teknologi Moskow (MIPT)", "Universitas Sains dan Teknologi MISIS Moskow", "Universitas Bauman Moscow State Technical", "Universitas Novosibirsk State", "Universitas Tomsk State", "Universitas ITMO Saint Petersburg"],
    "swasta": ["Universitas Synergia Moskow", "Universitas Humaniora Islam Moskow", "Universitas Akademia Sosial Moskow Swasta", "Universitas Institut Bisnis dan Desain Moskow", "Universitas Moskow Witte", "Universitas Keuangan dan Hukum Moskow (MFUA)", "Universitas Internasional Moskow Swasta", "Universitas Togliatti Academy of Management", "Universitas Saint Petersburg University of Management", "Universitas Institute of International Economic Relations Moskow"]
  },
  "san marino": {
    "negeri": ["Universitas San Marino", "Institut Teknologi San Marino", "Kolej Kedokteran San Marino", "Institut Sains Terapan San Marino", "Sekolah Keguruan San Marino", "Institut Keuangan San Marino", "Sekolah Hukum San Marino", "Institut Maritim San Marino", "Sekolah Seni San Marino", "Institut Statistik San Marino"],
    "swasta": ["Kolej Bisnis San Marino", "Institut Keuangan San Marino Swasta", "Kolej Pendidikan San Marino Swasta", "Institut Komunikasi San Marino", "Kolej Seni San Marino Swasta", "Institut Maritim San Marino Swasta", "Sekolah Bisnis Internasional San Marino", "Universitas Informatika Terapan San Marino", "Institut Sains Kesehatan Swasta San Marino", "Kolej Keuangan Swasta San Marino"]
  },
  "slovenia": {
    "negeri": ["Universitas Ljubljana", "Universitas Maribor", "Universitas Primorska Koper", "Universitas Nova Gorica", "Institut Politeknik Ljubljana", "Sekolah Kedokteran Maribor", "Sekolah Keguruan Koper", "Institut Sains Terapan Celje", "Sekolah Pertanian Kranj", "Institut Statistik Ljubljana"],
    "swasta": ["Universitas Novo Mesto", "Universitas Katolik Ljubljana", "Kolej Teknologi Ljubljana Swasta", "Institut Bisnis Maribor Swasta", "Universitas Teraplikasi Celje Swasta", "Kolej Pariwisata Portorož Swasta", "Universitas IEDC-Bled School of Management", "Universitas Alma Mater Europaea Maribor", "Universitas GEA College Ljubljana", "Universitas B2 College Ljubljana"]
  },
  "slowakia": {
    "negeri": ["Universitas Comenius Bratislava", "Universitas Teknologi Slowakia Bratislava (STU)", "Universitas Pavol Jozef Šafárik Košice", "Universitas Teknik Košice (TUKE)", "Universitas Matej Bel Banská Bystrica", "Universitas Žilina", "Universitas Pertanian Slowakia Nitra", "Universitas Kedokteran Slowakia Bratislava", "Universitas Prešov", "Universitas Trnava"],
    "swasta": ["Universitas Katolik Ružomberok", "Universitas Pan-European Bratislava", "Universitas Central European Skalica", "Universitas Danubius Sládkovičovo", "Universitas International School of Management Prešov", "Universitas School of Management Trenčín (CityU)", "Universitas St. Elizabeth University of Health Bratislava", "Universitas Security Management Košice", "Universitas College of DTI Dubnica", "Universitas Business School Bratislava"]
  },
  "spanyol": {
    "negeri": ["Universitas Barcelona (UB)", "Universitas Autònoma de Barcelona (UAB)", "Universitas Complutense Madrid (UCM)", "Universitas Autónoma de Madrid (UAM)", "Universitas Pompeu Fabra Barcelona", "Universitas Politeknik Catalonia (UPC)", "Universitas Valencia", "Universitas Granada", "Universitas Politeknik Madrid (UPM)", "Universitas Sevilla"],
    "swasta": ["Universitas Navarra", "Universitas IE Madrid", "Universitas Ramon Llull Barcelona (ESADE)", "Universitas Deusto Bilbao", "Universitas Universidad Pontificia Comillas Madrid", "Universitas European University of Valencia", "Universitas CEU San Pablo Madrid", "Universitas Alfonso X el Sabio Madrid", "Universitas Universidad Nebrija Madrid", "Universitas UCAM Murcia"]
  },
  "swedia": {
    "negeri": ["Universitas Karolinska Institute Stockholm", "Universitas Lund", "Universitas Uppsala", "Universitas Stockholms", "Universitas Teknologi Chalmers Gothenburg", "Universitas KTH Royal Institute of Technology Stockholm", "Universitas Gothenburg", "Universitas Linköping", "Universitas Umeå Swedia", "Universitas SLAU Swedish Agricultural"],
    "swasta": ["Universitas Jönköping (Swasta)", "Universitas Stockholm School of Economics (SSE)", "Universitas Chalmers University of Technology Swasta", "Universitas Sophiahemmet University College Stockholm", "Universitas Red Cross University College Stockholm", "Universitas Marie Cederschiöld University Stockholm", "Universitas Beckmans College of Design Stockholm", "Universitas KMH Royal College of Music Stockholm", "Universitas Stockholm University of the Arts", "Universitas Ericastiftelsen University College Stockholm"]
  },
  "swiss": {
    "negeri": ["Universitas ETH Zurich", "Universitas EPFL Lausanne", "Universitas Zurich", "Universitas Geneva", "Universitas Basel", "Universitas Bern", "Universitas Lausanne", "Universitas Svizzera Italiana Lugano", "Universitas St. Gallen (HSG)", "Universitas Fribourg"],
    "swasta": ["Universitas International Institute for Management Development (IMD) Lausanne", "Universitas Webster Geneva", "Universitas EU Business School Geneva", "Universitas Franklin University Switzerland Lugano", "Universitas Les Roches International School Crans-Montana", "Universitas Glion Institute of Higher Education", "Universitas Geneva Business School", "Universitas UBIS Geneva", "Universitas Montreux Business School", "Universitas Swiss Hotel Management School Caux"]
  },
  "ukraina": {
    "negeri": ["Universitas Nasional Taras Shevchenko Kairo Kyiv", "Institut Politeknik Igor Sikorsky Kyiv (KPI)", "Universitas Nasional V. N. Karazin Kharkiv", "Universitas Politeknik Lviv", "Universitas Kedokteran Bogomolets Kyiv", "Universitas Kedokteran Kharkiv", "Universitas Lviv Ivan Franko", "Universitas Nasional Sumy", "Universitas Teknik Dnipro", "Universitas Odesa I. I. Mechnikov"],
    "swasta": ["Universitas Katolik Ukraina Lviv (UCU)", "Universitas Kyiv School of Economics (KSE)", "Universitas Alfred Nobel Dnipro", "Universitas International Humanitarian Odesa", "Universitas Interregional Academy of Personnel Management (MAUP) Kyiv", "Universitas European University Kyiv", "Universitas Kyiv University of Market Relations", "Universitas Dnipro University of Technology Swasta", "Universitas Kharkiv University of Humanities", "Universitas Odesa Law Academy Swasta"]
  },
  "vatikan": {
    "negeri": ["Universitas Pontifikal Gregorian Roma", "Universitas Pontifikal St. Thomas Aquinas (Angelicum)", "Universitas Pontifikal Lateran", "Universitas Pontifikal Urbaniana", "Universitas Pontifikal Salesian", "Universitas Pontifikal Holy Cross", "Universitas Pontifikal Antonianum", "Institut Kedokteran Vatikan", "Institut Studi Alkitab Pontifikal", "Institut Arkeologi Kristen Pontifikal"],
    "swasta": ["Institut Teologi Vatikan Swasta", "Kolej Filsafat Vatikan Swasta", "Institut Musik Gereja Vatikan", "Kolej Liturgi Pontifikal Vatikan", "Institut Hukum Kanonik Vatikan Swasta", "Sekolah Alkitab Katolik Vatikan", "Institut Komunikasi Vatikan Swasta", "Kolej Sejarah Gereja Vatikan", "Institut Sains Terapan Vatikan Swasta", "Kolej Bahasa Latin Vatikan Swasta"]
  },
  "yunani": {
    "negeri": ["Universitas Nasional Kapodistrian Athena", "Universitas Teknik Nasional Athena (NTUA)", "Universitas Aristotle Thessaloniki", "Universitas Crete", "Universitas Patras", "Universitas Ekonomi dan Bisnis Athena (AUEB)", "Universitas Ioannina", "Universitas Thessaly", "Universitas Democritus Thrace", "Universitas Aegean"],
    "swasta": ["Universitas Deree – The American College of Greece", "Universitas CITY College University of York Europe Campus Thessaloniki", "Universitas New York College Athens", "Universitas Mediterranean College Athens", "Universitas Metropolitan College Athens", "Universitas BCA College Athens", "Universitas Alpine Center Athens", "Universitas Athens Metropolitan College Thessaloniki", "Universitas AAS College Thessaloniki", "Universitas DEI College Thessaloniki"]
  },

  // --- NA (NORTH AMERICA) ---
  "amerika serikat": {
    "negeri": ["Universitas California Berkeley (UC Berkeley)", "Universitas California Los Angeles (UCLA)", "Universitas Michigan Ann Arbor", "Universitas Virginia", "Universitas North Carolina Chapel Hill", "Universitas Florida", "Universitas Washington Seattle", "Universitas Texas Austin", "Universitas Wisconsin-Madison", "Universitas Illinois Urbana-Champaign"],
    "swasta": ["Universitas Harvard", "Universitas Stanford", "Massachusetts Institute of Technology (MIT)", "Universitas Princeton", "Universitas Columbia", "Universitas Yale", "Universitas Chicago", "Universitas Pennsylvania (Penn)", "Universitas Cornell", "Universitas Johns Hopkins"]
  },
  "antigua dan barbuda": {
    "negeri": ["Universitas West Indies Five Islands", "Kolej Negeri Antigua", "Institut Teknologi St. John's", "Kolej Keperawatan Antigua", "Institut Maritim Barbuda", "Kolej Pendidikan Antigua", "Sekolah Kedokteran St. John's", "Institut Pertanian Antigua", "Sekolah Keuangan Antigua", "Institut Statistik Antigua"],
    "swasta": ["Universitas Ilmu Kesehatan Antigua (UHSA)", "Universitas American University of Antigua (AUA)", "Universitas Bisnis Antigua Swasta", "Institut Pariwisata Antigua Swasta", "Kolej Sains Kesehatan Swasta Antigua", "Sekolah Bisnis Internasional Antigua", "Universitas Informatika Terapan Antigua", "Kolej Keuangan Swasta Antigua", "Institut Komunikasi Terapan Antigua", "Universitas Bahasa Terapan Antigua"]
  },
  "bahama": {
    "negeri": ["Universitas Bahama Nassau", "Universitas West Indies Bahama", "Kolej Komunitas Bahama", "Institut Teknologi Nassau", "Kolej Maritim Bahama", "Institut Keguruan Bahama", "Kolej Keperawatan Nassau", "Institut Pertanian Bahama", "Sekolah Keuangan Nassau", "Institut Statistik Bahama"],
    "swasta": ["Universitas Sains Kesehatan Freeport", "Universitas Bisnis Freeport Swasta", "Institut Pariwisata Bahama Swasta", "Sekolah Bisnis Internasional Nassau", "Universitas Informatika Terapan Bahama", "Kolej Sains Kesehatan Swasta Bahama", "Institut Komunikasi Terapan Nassau", "Kolej Keuangan Swasta Freeport", "Universitas Bahasa Terapan Bahama", "Institut Teknologi Terapan Freeport"]
  },
  "barbados": {
    "negeri": ["Universitas West Indies Cave Hill Barbados", "Kolej Komunitas Errol Barrow", "Kolej Keperawatan Barbados", "Institut Teknologi Bridgetown", "Institut Keguruan Bridgetown", "Kolej Maritim Barbados", "Institut Pertanian Barbados", "Sekolah Keuangan Bridgetown", "Institut Statistik Barbados", "Sekolah Teknik Bridgetown"],
    "swasta": ["Universitas Kedokteran Ross Bridgetown", "Universitas Bisnis Barbados Swasta", "Institut Sains Terapan Barbados Swasta", "Kolej Pariwisata Bridgetown Swasta", "Sekolah Bisnis Internasional Barbados", "Universitas Informatika Terapan Bridgetown", "Kolej Sains Kesehatan Swasta Barbados", "Institut Komunikasi Terapan Bridgetown", "Kolej Keuangan Swasta Barbados", "Universitas Bahasa Terapan Bridgetown"]
  },
  "belize": {
    "negeri": ["Universitas Belize Belmopan", "Kolej Komunitas St. John's Belize City", "Kolej Corozal Junior", "Institut Teknologi Belize", "Kolej Keperawatan Belize", "Institut Pertanian Cayo", "Sekolah Keguruan Belmopan", "Institut Maritim Belize", "Sekolah Keuangan Belize City", "Institut Statistik Belize"],
    "swasta": ["Universitas Galen San Ignacio", "Universitas Central America Health Sciences", "Kolej Sacred Heart San Ignacio", "Universitas Bisnis Belmopan Swasta", "Sekolah Bisnis Internasional Belize", "Universitas Informatika Terapan Belize City", "Kolej Sains Kesehatan Swasta Belmopan", "Institut Komunikasi Terapan Cayo", "Kolej Keuangan Swasta San Ignacio", "Universitas Bahasa Terapan Belize"]
  },
  "bermuda": {
    "negeri": ["Kolej Bermuda Hamilton", "Institut Maritim Bermuda", "Institut Teknologi Hamilton", "Sekolah Keperawatan Bermuda", "Institut Keguruan Hamilton", "Sekolah Keuangan Bermuda", "Institut Statistik Hamilton", "Sekolah Teknik Hamilton", "Institut Kelautan Bermuda", "Kolej Pariwisata Hamilton"],
    "swasta": ["Universitas Sains Kesehatan Bermuda Swasta", "Kolej Keuangan Bermuda Swasta", "Universitas Bisnis Hamilton Swasta", "Institut Pariwisata Bermuda Swasta", "Kolej Pendidikan Bermuda Swasta", "Institut Sains Terapan Bermuda Swasta", "Sekolah Bisnis Internasional Hamilton", "Universitas Informatika Terapan Bermuda", "Institut Komunikasi Terapan Hamilton", "Kolej Sains Kesehatan Swasta Hamilton"]
  },
  "costa rica": {
    "negeri": ["Universitas Costa Rica (UCR) San José", "Universitas Nasional Costa Rica (UNA) Heredia", "Institut Teknologi Costa Rica (TEC) Cartago", "Universitas UNED Costa Rica (Terbuka)", "Universitas UTN Costa Rica (Teknik)", "Institut Kedokteran San José", "Sekolah Keguruan Heredia", "Institut Pertanian Cartago", "Sekolah Hukum San José", "Institut Statistik Costa Rica"],
    "swasta": ["Universitas ULACIT San José", "Universitas Latina de Costa Rica", "Universitas Veritas San José", "Universitas EARTH Limón", "Universitas Kedokteran UCIMED", "Universitas Katolik Costa Rica", "Universitas International de las Américas", "Universitas San Judas Tadeo", "Universitas Hispanoamericana San José", "Universitas Fidelitas San José"]
  },
  "curacao": {
    "negeri": ["Universitas Curaçao Willemstad", "Kolej Komunitas Curaçao", "Institut Teknologi Willemstad", "Sekolah Keperawatan Willemstad", "Institut Keguruan Curaçao", "Sekolah Keuangan Willemstad", "Institut Maritim Curaçao", "Sekolah Teknik Willemstad", "Institut Statistik Curaçao", "Sekolah Hukum Willemstad"],
    "swasta": ["Universitas Sains Kesehatan St. Martinus Willemstad", "Universitas Caribbean Medical University", "Kolej Maritim Curaçao Swasta", "Universitas Bisnis Willemstad Swasta", "Institut Pariwisata Curaçao Swasta", "Sekolah Bisnis Internasional Willemstad", "Universitas Informatika Terapan Curaçao", "Kolej Sains Kesehatan Swasta Willemstad", "Institut Komunikasi Terapan Curaçao", "Kolej Keuangan Swasta Willemstad"]
  },
  "dominika": {
    "negeri": ["Kolej Komunitas State College Roseau", "Institut Teknologi Roseau", "Kolej Keperawatan Dominika", "Institut Keguruan Roseau", "Institut Maritim Dominika", "Institut Pertanian Dominika", "Sekolah Keuangan Roseau", "Institut Statistik Dominika", "Sekolah Teknik Roseau", "Institut Kelautan Roseau"],
    "swasta": ["Universitas Sains Kesehatan All Saints Roseau", "Universitas International University for Graduate Studies", "Universitas Bisnis Roseau Swasta", "Kolej Pendidikan Roseau Swasta", "Kolej Pariwisata Roseau Swasta", "Sekolah Bisnis Internasional Dominika", "Universitas Informatika Terapan Roseau", "Kolej Sains Kesehatan Swasta Dominika", "Institut Komunikasi Terapan Roseau", "Kolej Keuangan Swasta Roseau"]
  },
  "el salvador": {
    "negeri": ["Universitas El Salvador (UES) San Salvador", "Institut Teknologi ITCA-FEPADE Santa Tecla", "Sekolah Pertanian ENA San Salvador", "Sekolah Kedokteran San Salvador", "Institut Keguruan San Salvador", "Sekolah Teknik Santa Ana", "Institut Keuangan San Salvador", "Sekolah Hukum San Salvador", "Institut Statistik El Salvador", "Sekolah Seni San Salvador"],
    "swasta": ["Universitas Centroamericana José Simeón Cañas (UCA)", "Universitas Francisco Gaviria", "Universitas Don Bosco San Salvador", "Universitas Tecnológica de El Salvador (UTEC)", "Universitas Dr. José Matías Delgado", "Universitas Evangelica de El Salvador", "Universitas Salvadoreña Alberto Masferrer", "Universitas Katolik El Salvador", "Universitas Pedagógica de El Salvador", "Universitas Modular Abierta San Salvador"]
  },
  "greenland": {
    "negeri": ["Universitas Greenland (Ilisimatusarfik) Nuuk", "Institut Politeknik Greenland Nuuk", "Kolej Keperawatan Nuuk", "Institut Keguruan Nuuk", "Kolej Maritim Greenland", "Institut Tambang Sisimiut", "Sekolah Keuangan Nuuk", "Institut Statistik Nuuk", "Sekolah Seni Nuuk", "Institut Kelautan Nuuk"],
    "swasta": ["Institut Komunikasi Nuuk Swasta", "Kolej Bisnis Nuuk Swasta", "Institut Sains Terapan Nuuk Swasta", "Kolej Seni Greenland Swasta", "Sekolah Bisnis Internasional Greenland", "Universitas Informatika Terapan Nuuk", "Institut Sains Kesehatan Swasta Nuuk", "Kolej Keuangan Swasta Sisimiut", "Universitas Bahasa Terapan Greenland", "Institut Teknologi Terapan Nuuk"]
  },
  "grenada": {
    "negeri": ["Kolej Komunitas T.A. Marryshow St. George's", "Institut Teknologi Grenada", "Kolej Keperawatan Grenada", "Institut Keguruan St. George's", "Institut Maritim Grenada", "Institut Pertanian Grenada", "Sekolah Keuangan St. George's", "Institut Statistik Grenada", "Sekolah Teknik St. George's", "Institut Kelautan Grenada"],
    "swasta": ["Universitas St. George's (SGU) Grenada", "Universitas Bisnis St. George's Swasta", "Kolej Pariwisata St. George's Swasta", "Institut Sains Terapan Grenada Swasta", "Sekolah Bisnis Internasional Grenada", "Universitas Informatika Terapan St. George's", "Kolej Sains Kesehatan Swasta Grenada", "Institut Komunikasi Terapan St. George's", "Kolej Keuangan Swasta Grenada", "Universitas Bahasa Terapan Grenada"]
  },
  "guatemala": {
    "negeri": ["Universitas de San Carlos de Guatemala (USAC)", "Institut Politeknik Guatemala City", "Sekolah Pertanian USAC Quetzaltenango", "Sekolah Kedokteran Guatemala City", "Institut Keguruan USAC", "Sekolah Hukum Guatemala City", "Institut Keuangan USAC", "Sekolah Teknik Quetzaltenango", "Institut Statistik Guatemala", "Sekolah Seni USAC"],
    "swasta": ["Universitas Francisco Marroquín (UFM)", "Universitas del Valle de Guatemala (UVG)", "Universitas Rafael Landívar", "Universitas Mariano Gálvez de Guatemala", "Universitas Galileo Guatemala City", "Universitas Istmo Guatemala", "Universitas Panamericana Guatemala", "Universitas Mesoamericana Quetzaltenango", "Universitas San Pablo de Guatemala", "Universitas Da Vinci de Guatemala"]
  },
  "haiti": {
    "negeri": ["Universitas Negeri Haiti (UEH) Port-au-Prince", "Universitas Publique du Nord Cap-Haïtien", "Universitas Publique du Sud Les Cayes", "Universitas Publique de Artibonite Gonaïves", "Institut Politeknik Port-au-Prince", "Sekolah Kedokteran UEH", "Institut Keguruan Port-au-Prince", "Sekolah Agronomi UEH", "Institut Keuangan Port-au-Prince", "Sekolah Hukum Cap-Haïtien"],
    "swasta": ["Universitas Quisqueya Port-au-Prince", "Universitas Notre Dame d'Haïti", "Universitas Caraïbe Port-au-Prince", "Universitas Lumière Port-au-Prince", "Universitas Episcopale d'Haïti", "Universitas INUKA Port-au-Prince", "Universitas GOC Port-au-Prince", "Universitas Quisqueya Cap-Haïtien", "Universitas Franco-Haïtienne", "Universitas Anacaona Léogâne"]
  },
  "honduras": {
    "negeri": ["Universitas Nasional Otonom Honduras (UNAH) Tegucigalpa", "Universitas Pedagogica Nacional Francisco Morazan", "Universitas Nacional de Agricultura Catacamas", "Universitas Nacional de Ciencias Forestales Siguatepeque", "Sekolah Kedokteran UNAH Tegucigalpa", "Institut Teknik Tegucigalpa", "Sekolah Hukum UNAH San Pedro Sula", "Institut Keuangan Tegucigalpa", "Sekolah Pertanian Catacamas", "Institut Statistik Honduras"],
    "swasta": ["Universitas Tecnológica Centroamericana (UNITEC)", "Universitas Zamorano Pertanian", "Universitas Católica de Honduras", "Universitas Tecnológica de Honduras (UTH)", "Universitas de San Pedro Sula", "Universitas Politécnica de Honduras", "Universitas Metropolitana de Honduras", "Universitas Jose Cecilio del Valle", "Universitas CEUTEC Tegucigalpa", "Universitas San Lorenzo Honduras"]
  },
  "jamaika": {
    "negeri": ["Universitas West Indies Mona Jamaica", "Universitas Teknologi Jamaika (UTech) Kingston", "Kolej Komunitas Excelsior Kingston", "Universitas Mico College Kingston", "Kolej Pertanian CASE Port Antonio", "Universitas Caribbean Maritime Kingston", "Kolej Keguruan Shortwood", "Universitas Edna Manley College Kingston", "Kolej Keperawatan Kingston", "Institut Keuangan Kingston"],
    "swasta": ["Universitas Northern Caribbean Mandeville", "Universitas Teknologi Karibia Kingston Swasta", "Universitas International University of the Caribbean", "Universitas Management Institute of Jamaica", "Universitas B&B University College Kingston", "Sekolah Bisnis Internasional Jamaica", "Universitas Informatika Terapan Kingston", "Kolej Sains Kesehatan Swasta Mandeville", "Institut Komunikasi Terapan Kingston", "Kolej Keuangan Swasta Jamaica"]
  },
  "kanada": {
    "negeri": ["Universitas Toronto", "Universitas British Columbia (UBC)", "Universitas McGill Montreal", "Universitas Alberta Edmonton", "Universitas Waterloo", "Universitas Western London Ontario", "Universitas Montreal", "Universitas Calgary", "Universitas McMaster Hamilton", "Universitas Ottawa"],
    "swasta": ["Universitas Quest British Columbia", "Universitas Trinity Western Langley", "Universitas Concordia Edmonton", "Universitas Redeemer Ontario", "Universitas Crandall New Brunswick", "Universitas Tyndale Toronto", "Universitas Yorkville Toronto", "Universitas Canada West Vancouver", "Universitas King's University Edmonton", "Universitas St. Stephen's New Brunswick"]
  },
  "kuba": {
    "negeri": ["Universitas Havana", "Universitas Teknologi Havana (CUJAE)", "Universitas Central de Las Villas Santa Clara", "Universitas Santiago de Cuba", "Universitas Sains Kedokteran Havana", "Universitas Holguín", "Universitas Pinar del Río", "Universitas Camagüey", "Universitas Cienfuegos", "Universitas Matanzas"],
    "swasta": ["Institut Sains Terapan Havana Swasta", "Kolej Informatika Terapan Havana", "Institut Kedokteran Internasional Havana", "Sekolah Bisnis Swasta Havana", "Kolej Bahasa Terapan Havana", "Institut Teknologi Informasi Santiago", "Sekolah Seni Swasta Havana", "Kolej Keuangan Terapan Cuba", "Institut Komunikasi Terapan Havana", "Universitas Olahraga Swasta Havana"]
  },
  "meksiko": {
    "negeri": ["Universitas Nasional Otonom Meksiko (UNAM)", "Institut Politeknik Nasional (IPN) Mexico City", "Universitas Autónoma Metropolitana (UAM)", "Universitas de Guadalajara (UDG)", "Universitas Autónoma de Nuevo León (UANL)", "Universitas Autónoma de San Luis Potosí", "Universitas Autónoma de Sinaloa", "Universitas Autónoma de Yucatán", "Universitas Autónoma del Estado de México", "Universitas Autónoma de Puebla (BUAP)"],
    "swasta": ["Technológico de Monterrey (ITESM)", "Universitas Iberoamericana Mexico City", "Universitas de las Américas Puebla (UDLAP)", "Universitas Anáhuac Mexico", "Universitas ITESO Guadalajara", "Universitas Universidad Panamericana Mexico City", "Universitas Universidad La Salle Mexico City", "Universitas Universidad de Monterrey (UDEM)", "Universitas Universidad Tecnológica de México (UNITEC)", "Universitas UVM Mexico"]
  },
  "nikaragua": {
    "negeri": ["Universitas Nasional Otonom Nikaragua (UNAN) Managua", "Universitas Nasional Teknik (UNI) Managua", "Universitas Nasional Pertanian (UNA) Managua", "Universitas UNAN León", "Institut Politeknik Managua", "Sekolah Kedokteran UNAN", "Institut Keguruan Managua", "Sekolah Hukum UNAN", "Institut Keuangan Managua", "Sekolah Teknik León"],
    "swasta": ["Universitas Centroamericana (UCA) Managua", "Universitas Católica Redemptoris Mater", "Universitas Politécnica de Nicaragua (UPOLI)", "Universitas American College Managua", "Universitas de Ciencias Comerciales", "Universitas Keiser Nicaragua", "Universitas Thomas More Managua", "Universitas Iberoamericana de Ciencia y Tecnología", "Universitas Central de Nicaragua", "Universitas de Managua"]
  },
  "panama": {
    "negeri": ["Universitas de Panamá (UP) Panama City", "Universitas Tecnológica de Panamá (UTP)", "Universitas Marítima Internacional de Panamá", "Universitas Specialized of the Americas (UDELAS)", "Universitas Autónoma de Chiriquí (UNACHI)", "Institut Kedokteran UP Panama City", "Sekolah Keguruan Panama City", "Institut Pertanian David", "Sekolah Hukum UP", "Institut Keuangan Panama City"],
    "swasta": ["Universitas Católica Santa María La Antigua (USMA)", "Universitas Latina de Panamá", "Universitas del Istmo Panama City", "Universitas Interamericana de Panamá", "Universitas Metropolitan of Education (UMECIT)", "Universitas Ganexa Panama City", "Universitas Florida State University Panama", "Universitas Columbus University Panama", "Universitas Universidad Alta Dirección", "Universitas Quality Leadership University"]
  },
  "puerto rico": {
    "negeri": ["Universitas Puerto Rico (UPR Mayagüez)", "Universitas Puerto Rico Rio Piedras", "Universitas Ciencias Médicas UPR San Juan", "Universitas Puerto Rico Ponce", "Universitas Puerto Rico Arecibo", "Universitas Puerto Rico Humacao", "Universitas Puerto Rico Aguadilla", "Universitas Puerto Rico Utuado", "Universitas Puerto Rico Bayamón", "Universitas Puerto Rico Carolina"],
    "swasta": ["Universitas Interamericana de Puerto Rico", "Universitas Pontificia Universidad Católica de Puerto Rico", "Universitas Ana G. Méndez San Juan", "Universitas Politecnica de Puerto Rico", "Universitas Sagrado Corazón San Juan", "Universitas Carlos Albizu San Juan", "Universitas Central del Caribe Bayamón", "Universitas San Juan Bautista School of Medicine", "Universitas EDP University of Puerto Rico", "Universitas Dewey University San Juan"]
  },
  "republik dominika": {
    "negeri": ["Universitas Autónoma de Santo Domingo (UASD)", "Universitas UASD Santiago", "Universitas UASD San Francisco", "Universitas UASD Barahona", "Institut Teknik UASD", "Sekolah Kedokteran UASD", "Institut Keguruan Santo Domingo", "Sekolah Hukum UASD", "Institut Pertanian San Cristóbal", "Institut Keuangan Santo Domingo"],
    "swasta": ["Universitas Instituto Tecnológico de Santo Domingo (INTEC)", "Universitas Pontificia Universidad Católica Madre y Maestra (PUCMM)", "Universitas Iberoamericana (UNIBE) Santo Domingo", "Universitas Pedro Henríquez Ureña (UNPHU)", "Universitas APEC Santo Domingo", "Universitas Católica Santo Domingo (UCSD)", "Universitas Tecnológica de Santiago (UTESA)", "Universitas del Caribe (UNICARIBE)", "Universitas Central del Este (UCE)", "Universitas Católica Nordestana"]
  },
  "saint kitts dan nevis": {
    "negeri": ["Kolej Komunitas Clarence Fitzroy Bryant", "Institut Teknologi Basseterre", "Kolej Keperawatan St. Kitts", "Institut Maritim Nevis", "Kolej Pendidikan Charlestown", "Institut Pertanian St. Kitts", "Sekolah Keuangan Basseterre", "Institut Statistik St. Kitts", "Sekolah Teknik Charlestown", "Institut Kelautan Nevis"],
    "swasta": ["Universitas Sains Kedokteran Ross Basseterre", "Universitas Umhs St. Kitts", "Universitas Windsor University School of Medicine", "Universitas Bisnis Basseterre Swasta", "Institut Pariwisata St. Kitts Swasta", "Sekolah Bisnis Internasional St. Kitts", "Universitas Informatika Terapan Basseterre", "Kolej Sains Kesehatan Swasta Nevis", "Institut Komunikasi Terapan Basseterre", "Kolej Keuangan Swasta St. Kitts"]
  },
  "saint lucia": {
    "negeri": ["Kolej Komunitas Sir Arthur Lewis Castries", "Institut Teknologi Castries", "Kolej Keperawatan St. Lucia", "Institut Maritim Vieux Fort", "Kolej Pendidikan Castries", "Institut Pertanian Soufrière", "Sekolah Keuangan Castries", "Institut Statistik St. Lucia", "Sekolah Teknik Castries", "Institut Kelautan Vieux Fort"],
    "swasta": ["Universitas Sains Kedokteran Spartan Vieux Fort", "Universitas International American University College of Medicine", "Universitas Destiny University School of Medicine", "Universitas Bisnis Castries Swasta", "Institut Pariwisata St. Lucia Swasta", "Sekolah Bisnis Internasional St. Lucia", "Universitas Informatika Terapan Castries", "Kolej Sains Kesehatan Swasta Vieux Fort", "Institut Komunikasi Terapan Castries", "Kolej Keuangan Swasta St. Lucia"]
  },
  "saint vincent dan grenadine": {
    "negeri": ["Kolej Komunitas St. Vincent Kingstown", "Institut Teknologi Kingstown", "Kolej Keperawatan St. Vincent", "Institut Maritim Grenadines", "Kolej Pendidikan Kingstown", "Institut Pertanian Georgetown", "Sekolah Keuangan Kingstown", "Institut Statistik St. Vincent", "Sekolah Teknik Kingstown", "Institut Kelautan Bequia"],
    "swasta": ["Universitas Sains Kedokteran Trinity Kingstown", "Universitas Saint James School of Medicine", "Universitas All Saints University College of Medicine", "Universitas Bisnis Kingstown Swasta", "Institut Pariwisata St. Vincent Swasta", "Sekolah Bisnis Internasional St. Vincent", "Universitas Informatika Terapan Kingstown", "Kolej Sains Kesehatan Swasta Grenadines", "Institut Komunikasi Terapan Kingstown", "Kolej Keuangan Swasta St. Vincent"]
  },
  "trinidad dan tobago": {
    "negeri": ["Universitas West Indies St. Augustine Trinidad", "Universitas Trinidad dan Tobago (UTT) Arima", "Kolej Sains Teknologi COSTAATT Port of Spain", "Institut Teknologi Port of Spain", "Kolej Keperawatan Trinidad", "Institut Maritim Chaguaramas", "Kolej Pendidikan Port of Spain", "Institut Pertanian Centeno", "Sekolah Keuangan San Fernando", "Institut Statistik Trinidad"],
    "swasta": ["Universitas Perintisan Karibia (USC) Maracas", "Universitas Bisnis San Fernando Swasta", "Institut Pariwisata Tobago Swasta", "Sekolah Bisnis Internasional Trinidad", "Universitas Informatika Terapan Port of Spain", "Kolej Sains Kesehatan Swasta Tobago", "Institut Komunikasi Terapan Trinidad", "Kolej Keuangan Swasta San Fernando", "Universitas Bahasa Terapan Trinidad", "Institut Teknologi Terapan Tobago"]
  },

  // --- OCEANIA ---
  "australia": {
    "negeri": ["Universitas Melbourne", "Universitas Sydney", "Universitas Nasional Australia (ANU) Canberra", "Universitas New South Wales (UNSW) Sydney", "Universitas Queensland (UQ) Brisbane", "Universitas Monash Melbourne", "Universitas Western Australia (UWA) Perth", "Universitas Adelaide", "Universitas Teknologi Sydney (UTS)", "Universitas RMIT Melbourne"],
    "swasta": ["Universitas Bond Gold Coast", "Universitas Torrens Australia", "Universitas Katolik Australia (ACU)", "Universitas Notre Dame Australia Fremantle", "Universitas Avondale Cooranbong", "Universitas International College of Management Sydney (ICMS)", "Universitas Kaplan Higher Education Australia", "Universitas Marcus Oldham College Geelong", "Universitas SAE Institute Australia", "Universitas Box Hill Institute Melbourne"]
  },
  "fiji": {
    "negeri": ["Universitas South Pacific (USP) Suva", "Universitas Nasional Fiji (FNU) Suva", "Kolej Keperawatan Fiji Suva", "Institut Teknologi Suva", "Kolej Pertanian Koronivia", "Institut Maritim Fiji", "Kolej Pendidikan Nadi", "Sekolah Kedokteran Suva", "Institut Keuangan Suva", "Sekolah Teknik Lautoka"],
    "swasta": ["Universitas Fiji Lautoka", "Universitas Bisnis Suva Swasta", "Institut Pariwisata Denarau Swasta", "Sekolah Bisnis Internasional Fiji", "Universitas Informatika Terapan Suva", "Kolej Sains Kesehatan Swasta Nadi", "Institut Komunikasi Terapan Suva", "Kolej Keuangan Swasta Lautoka", "Universitas Bahasa Terapan Fiji", "Institut Teknologi Terapan Suva"]
  },
  "guam": {
    "negeri": ["Universitas Guam Mangilao", "Kolej Komunitas Guam Mangilao", "Institut Teknologi Hagåtña", "Kolej Keperawatan Guam", "Institut Maritim Guam", "Kolej Pendidikan Mangilao", "Sekolah Keuangan Hagåtña", "Institut Statistik Guam", "Sekolah Teknik Mangilao", "Institut Kelautan Guam"],
    "swasta": ["Universitas Bisnis Hagåtña Swasta", "Institut Pariwisata Guam Swasta", "Kolej Sains Terapan Guam Swasta", "Institut Keuangan Hagåtña Swasta", "Sekolah Bisnis Internasional Guam", "Universitas Informatika Terapan Mangilao", "Kolej Sains Kesehatan Swasta Guam", "Institut Komunikasi Terapan Hagåtña", "Universitas Bahasa Terapan Guam", "Kolej Teknologi Terapan Mangilao"]
  },
  "kiribati": {
    "negeri": ["Universitas South Pacific Kampus Kiribati Tarawa", "Kolej Maritim Kiribati Tarawa", "Institut Teknologi Tarawa", "Kolej Keguruan Tarawa", "Kolej Keperawatan Kiribati", "Kolej Pertanian Tarawa", "Institut Perikanan Betio", "Sekolah Keuangan Tarawa", "Institut Statistik Kiribati", "Sekolah Teknik Betio"],
    "swasta": ["Institut Bisnis Tarawa Swasta", "Institut Sains Terapan Tarawa Swasta", "Kolej Komunikasi Tarawa Swasta", "Sekolah Bisnis Internasional Kiribati", "Universitas Informatika Terapan Tarawa", "Kolej Sains Kesehatan Swasta Betio", "Institut Keuangan Swasta Tarawa", "Universitas Bahasa Terapan Kiribati", "Kolej Teknologi Terapan Tarawa", "Institut Pariwisata Betio Swasta"]
  },
  "marshall": {
    "negeri": ["Kolej Kepulauan Marshall Majuro", "Universitas South Pacific Kampus Marshall Majuro", "Institut Teknologi Majuro", "Kolej Keperawatan Majuro", "Institut Maritim Majuro", "Kolej Pendidikan Majuro", "Institut Perikanan Ebeye", "Sekolah Keuangan Majuro", "Institut Statistik Marshall", "Sekolah Teknik Majuro"],
    "swasta": ["Universitas Bisnis Majuro Swasta", "Kolej Sains Terapan Majuro Swasta", "Institut Komunikasi Majuro Swasta", "Sekolah Bisnis Internasional Marshall", "Universitas Informatika Terapan Majuro", "Kolej Sains Kesehatan Swasta Majuro", "Institut Keuangan Swasta Majuro", "Universitas Bahasa Terapan Marshall", "Kolej Teknologi Terapan Ebeye", "Institut Pariwisata Majuro Swasta"]
  },
  "mikronesia": {
    "negeri": ["Kolej Mikronesia (COM-FSM) Pohnpei", "Universitas South Pacific Kampus Pohnpei", "Institut Teknologi Palikir", "Kolej Keperawatan Chuuk", "Institut Maritim Kosrae", "Kolej Pendidikan Pohnpei", "Institut Perikanan FSM", "Sekolah Keuangan Palikir", "Institut Statistik Mikronesia", "Sekolah Teknik Yap"],
    "swasta": ["Universitas Bisnis Yap Swasta", "Kolej Sains Terapan Palikir Swasta", "Institut Komunikasi Weno Swasta", "Sekolah Bisnis Internasional FSM", "Universitas Informatika Terapan Pohnpei", "Kolej Sains Kesehatan Swasta Chuuk", "Institut Keuangan Swasta Palikir", "Universitas Bahasa Terapan Mikronesia", "Kolej Teknologi Terapan Kosrae", "Institut Pariwisata Pohnpei Swasta"]
  },
  "nauru": {
    "negeri": ["Universitas South Pacific Kampus Nauru Yaren", "Institut Teknologi Nauru", "Kolej Keperawatan Nauru", "Kolej Pendidikan Nauru", "Institut Maritim Nauru", "Kolej Pertanian Nauru", "Sekolah Keuangan Yaren", "Institut Statistik Nauru", "Sekolah Teknik Yaren", "Institut Kelautan Nauru"],
    "swasta": ["Institut Bisnis Yaren Swasta", "Kolej Sains Terapan Yaren Swasta", "Institut Komunikasi Nauru Swasta", "Institut Keuangan Yaren Swasta", "Sekolah Bisnis Internasional Nauru", "Universitas Informatika Terapan Yaren", "Kolej Sains Kesehatan Swasta Nauru", "Universitas Bahasa Terapan Nauru", "Kolej Teknologi Terapan Yaren", "Institut Pariwisata Nauru Swasta"]
  },
  "palau": {
    "negeri": ["Kolej Komunitas Palau Koror", "Universitas South Pacific Kampus Palau Koror", "Institut Teknologi Koror", "Kolej Keperawatan Palau", "Institut Maritim Palau", "Kolej Pendidikan Koror", "Institut Perikanan Airai", "Sekolah Keuangan Koror", "Institut Statistik Palau", "Sekolah Teknik Koror"],
    "swasta": ["Universitas Bisnis Koror Swasta", "Institut Pariwisata Palau Swasta", "Kolej Sains Terapan Koror Swasta", "Sekolah Bisnis Internasional Palau", "Universitas Informatika Terapan Koror", "Kolej Sains Kesehatan Swasta Airai", "Institut Komunikasi Terapan Koror", "Kolej Keuangan Swasta Palau", "Universitas Bahasa Terapan Palau", "Institut Teknologi Terapan Koror Swasta"]
  },
  "papua nugini": {
    "negeri": ["Universitas Papua Nugini (UPNG) Port Moresby", "Universitas Teknologi Papua Nugini (UNITECH) Lae", "Universitas Goroka", "Kolej Pertanian Vudal Rabaul", "Institut Teknologi Lae", "Kolej Keperawatan Port Moresby", "Institut Maritim Madang", "Sekolah Kedokteran Port Moresby", "Institut Keuangan Lae", "Sekolah Teknik Goroka"],
    "swasta": ["Universitas Divine Word Madang", "Universitas Adventist Pacific Port Moresby", "Universitas Bisnis Kokopo Swasta", "Sekolah Bisnis Internasional PNG", "Universitas Informatika Terapan Port Moresby", "Kolej Sains Kesehatan Swasta Lae", "Institut Komunikasi Terapan Madang", "Kolej Keuangan Swasta Port Moresby", "Universitas Bahasa Terapan PNG", "Institut Teknologi Terapan Kokopo"]
  },
  "samoa amerika": {
    "negeri": ["Kolej Komunitas Samoa Amerika (ASCC) Pago Pago", "Institut Teknologi Pago Pago", "Kolej Keperawatan Samoa Amerika", "Institut Maritim Utulei", "Kolej Pendidikan Pago Pago", "Institut Perikanan Tafuna", "Sekolah Keuangan Pago Pago", "Institut Statistik Samoa Amerika", "Sekolah Teknik Pago Pago", "Institut Kelautan Utulei"],
    "swasta": ["Universitas Bisnis Pago Pago Swasta", "Kolej Sains Terapan Pago Pago Swasta", "Institut Komunikasi Utulei Swasta", "Kolej Pariwisata Pago Pago Swasta", "Sekolah Bisnis Internasional Samoa Amerika", "Universitas Informatika Terapan Pago Pago", "Kolej Sains Kesehatan Swasta Tafuna", "Institut Keuangan Swasta Utulei", "Universitas Bahasa Terapan Samoa Amerika", "Kolej Teknologi Terapan Pago Pago Swasta"]
  },
  "samoa": {
    "negeri": ["Universitas Nasional Samoa (NUS) Apia", "Universitas South Pacific Kampus Alafua Apia", "Institut Teknologi Apia", "Kolej Keperawatan Samoa", "Institut Maritim Samoa", "Kolej Pendidikan Apia", "Institut Pertanian Alafua", "Sekolah Keuangan Apia", "Institut Statistik Samoa", "Sekolah Teknik Apia"],
    "swasta": ["Universitas Bisnis Apia Swasta", "Kolej Pariwisata Samoa Swasta", "Institut Sains Terapan Apia Swasta", "Sekolah Bisnis Internasional Samoa", "Universitas Informatika Terapan Apia", "Kolej Sains Kesehatan Swasta Alafua", "Institut Komunikasi Terapan Apia", "Kolej Keuangan Swasta Samoa", "Universitas Bahasa Terapan Samoa", "Institut Teknologi Terapan Apia Swasta"]
  },
  "selandia baru": {
    "negeri": ["Universitas Auckland", "Universitas Otago Dunedin", "Universitas Victoria Wellington", "Universitas Canterbury Christchurch", "Universitas Massey Palmerston North", "Universitas Waikato Hamilton", "Universitas Teknologi Auckland (AUT)", "Universitas Lincoln Christchurch", "Institut Teknologi WelTec Wellington", "Institut Teknologi Ara Christchurch"],
    "swasta": ["Universitas IPU New Zealand Palmerston North", "Universitas Media Design School Auckland", "Universitas Pacific International Hotel Management School (PIHMS)", "Universitas SAE Institute Auckland", "Universitas Yoobee College of Creative Innovation Auckland", "Universitas Whitecliffe College of Arts Auckland", "Universitas New Zealand Tertiary College Auckland", "Universitas AIS Auckland Institute of Studies", "Universitas Crown Institute of Studies Auckland", "Universitas Le Cordon Bleu New Zealand Wellington"]
  },
  "tahiti": {
    "negeri": ["Universitas Polinesia Prancis (UPF) Papeete", "Institut Politeknik Tahiti Papeete", "Kolej Keperawatan Papeete", "Institut Maritim Tahiti", "Kolej Pendidikan Papeete", "Institut Pertanian Moorea", "Sekolah Keuangan Papeete", "Institut Statistik Tahiti", "Sekolah Teknik Faaa", "Institut Kelautan Tahiti"],
    "swasta": ["Kolej Bisnis Papeete Swasta", "Institut Pariwisata Tahiti Swasta", "Institut Sains Terapan Faaa Swasta", "Kolej Komunikasi Papeete Swasta", "Sekolah Bisnis Internasional Tahiti", "Universitas Informatika Terapan Papeete", "Kolej Sains Kesehatan Swasta Tahiti", "Institut Keuangan Swasta Papeete", "Universitas Bahasa Terapan Polinesia", "Kolej Teknologi Terapan Faaa Swasta"]
  },
  "tonga": {
    "negeri": ["Universitas South Pacific Kampus Tonga Nuku'alofa", "Universitas Tonga Nuku'alofa", "Institut Teknologi Nuku'alofa", "Kolej Keperawatan Tonga", "Institut Maritim Tonga", "Kolej Pendidikan Nuku'alofa", "Institut Pertanian Tonga", "Sekolah Keuangan Nuku'alofa", "Institut Statistik Tonga", "Sekolah Teknik Nuku'alofa"],
    "swasta": ["Universitas Bisnis Nuku'alofa Swasta", "Kolej Pariwisata Nuku'alofa Swasta", "Institut Sains Terapan Nuku'alofa Swasta", "Sekolah Bisnis Internasional Tonga", "Universitas Informatika Terapan Nuku'alofa", "Kolej Sains Kesehatan Swasta Tonga", "Institut Komunikasi Terapan Nuku'alofa", "Kolej Keuangan Swasta Nuku'alofa", "Universitas Bahasa Terapan Tonga", "Institut Teknologi Terapan Nuku'alofa Swasta"]
  },
  "tuvalu": {
    "negeri": ["Universitas South Pacific Kampus Tuvalu Funafuti", "Institut Pelatihan Maritim Tuvalu Funafuti", "Institut Teknologi Funafuti", "Kolej Keperawatan Tuvalu", "Kolej Pendidikan Funafuti", "Institut Perikanan Tuvalu", "Kolej Pertanian Funafuti", "Sekolah Keuangan Funafuti", "Institut Statistik Tuvalu", "Sekolah Teknik Funafuti"],
    "swasta": ["Universitas Bisnis Funafuti Swasta", "Kolej Sains Terapan Funafuti Swasta", "Institut Komunikasi Funafuti Swasta", "Sekolah Bisnis Internasional Tuvalu", "Universitas Informatika Terapan Funafuti", "Kolej Sains Kesehatan Swasta Tuvalu", "Institut Keuangan Swasta Funafuti", "Universitas Bahasa Terapan Tuvalu", "Kolej Teknologi Terapan Funafuti Swasta", "Institut Pariwisata Funafuti Swasta"]
  },
  "vanuatu": {
    "negeri": ["Universitas South Pacific Kampus Emalus Port Vila", "Universitas Nasional Vanuatu Port Vila", "Institut Teknologi Vanuatu Port Vila", "Kolej Keperawatan Vanuatu", "Institut Maritim Vanuatu", "Kolej Pendidikan Port Vila", "Institut Pertanian Luganville", "Sekolah Keuangan Port Vila", "Institut Statistik Vanuatu", "Sekolah Teknik Port Vila"],
    "swasta": ["Universitas Bisnis Port Vila Swasta", "Kolej Pariwisata Vanuatu Swasta", "Institut Sains Terapan Port Vila Swasta", "Sekolah Bisnis Internasional Vanuatu", "Universitas Informatika Terapan Port Vila", "Kolej Sains Kesehatan Swasta Luganville", "Institut Komunikasi Terapan Port Vila", "Kolej Keuangan Swasta Vanuatu", "Universitas Bahasa Terapan Vanuatu", "Institut Teknologi Terapan Port Vila Swasta"]
  },

  // --- SA (SOUTH AMERICA) ---
  "argentina": {
    "negeri": ["Universitas Buenos Aires (UBA)", "Universitas La Plata (UNLP)", "Universitas Nasional Córdoba (UNC)", "Universitas Nasional Rosario (UNR)", "Universitas Teknologi Nasional (UTN)", "Universitas Nasional Cuyo", "Universitas Nasional Mar del Plata", "Universitas Nasional Quilmes", "Universitas Nasional General San Martín", "Universitas Nasional Sur"],
    "swasta": ["Universitas Torcuato Di Tella", "Universitas Austral Buenos Aires", "Universitas San Andrés", "Universitas Katolik Argentina (UCA)", "Universitas Belgrano", "Universitas Palermo Buenos Aires", "Universitas ITBA (Teknologi Buenos Aires)", "Universitas UADE Buenos Aires", "Universitas Universidad del Salvador", "Universitas CEMA (UCEMA)"]
  },
  "bolivia": {
    "negeri": ["Universitas Mayor de San Andrés (UMSA) La Paz", "Universitas Mayor de San Simón (UMSS) Cochabamba", "Universitas Autónoma Gabriel René Moreno (UAGRM) Santa Cruz", "Universitas Mayor Real y Pontificia de San Francisco Xavier Sucre", "Universitas Técnica de Oruro (UTO)", "Universitas Autónoma Tomás Frías Potosí", "Universitas Autónoma del Beni José Ballivián", "Universitas Amazónica de Pando", "Universitas Pública de El Alto (UPEA)", "Universitas Autónoma Juan Misael Saracho Tarija"],
    "swasta": ["Universitas Católica Boliviana San Pablo", "Universitas Privada Boliviana (UPB)", "Universitas del Valle (UNIVALLE)", "Universitas Salesiana de Bolivia", "Universitas Nur Santa Cruz", "Universitas Privada de Santa Cruz de la Sierra (UPSA)", "Universitas Privada Franz Tamayo (UNIFRANZ)", "Universitas UTEPSA Santa Cruz", "Universitas UDABOL Santa Cruz", "Universitas Loyola La Paz"]
  },
  "brazil": {
    "negeri": ["Universitas São Paulo (USP)", "Universitas Negeri Campinas (UNICAMP)", "Universitas Federal Rio de Janeiro (UFRJ)", "Universitas Federal Minas Gerais (UFMG)", "Universitas Federal Rio Grande do Sul (UFRGS)", "Universitas Federal Santa Catarina (UFSC)", "Universitas Estadual Paulista (UNESP)", "Universitas Federal São Paulo (UNIFESP)", "Universitas Federal Brasilia (UnB)", "Universitas Federal Paraná (UFPR)"],
    "swasta": ["Universitas Katolik Pontifikal Rio de Janeiro (PUC-Rio)", "Universitas Katolik Pontifikal Rio Grande do Sul (PUCRS)", "Universitas Katolik Pontifikal São Paulo (PUC-SP)", "Universitas Katolik Pontifikal Paraná (PUCPR)", "Universitas FGV (Fundação Getulio Vargas)", "Universitas Insper São Paulo", "Universitas Mackenzies São Paulo", "Universitas UNISINOS Rio Grande do Sul", "Universitas UNIFOR Fortaleza", "Universitas Universidade Veiga de Almeida"]
  },
  "chile": {
    "negeri": ["Universitas Chile Santiago", "Universitas Concepción", "Universitas Técnico Federico Santa María Valparaíso", "Universitas Santiago de Chile (USACH)", "Universitas Austral de Chile Valdivia", "Universitas Valparaíso", "Universitas Talca", "Universitas Frontera Temuco", "Universitas Bío-Bío", "Universitas Tarapacá Arica"],
    "swasta": ["Universitas Pontificia Universidad Católica de Chile (UC) Santiago", "Universitas Adolfo Ibáñez", "Universitas Diego Portales", "Universitas de los Andes Chile", "Universitas Universidad del Desarrollo (UDD)", "Universitas Andrés Bello (UNAB)", "Universitas Universidad Mayor", "Universitas Universidad Finis Terrae", "Universitas Universidad San Sebastián", "Universitas Universidad Santo Tomás"]
  },
  "ekuador": {
    "negeri": ["Universitas Escuela Superior Politécnica del Litoral (ESPOL) Guayaquil", "Universitas Central del Ecuador Quito", "Universitas Cuenca", "Universitas Escuela Politécnica Nacional (EPN) Quito", "Universitas Técnica de Ambato", "Universitas Estatal de Guayaquil", "Universitas Técnica del Norte Ibarra", "Universitas Nacional de Loja", "Universitas Estatal de Milagro", "Universitas Estatal Península de Santa Elena"],
    "swasta": ["Universitas San Francisco de Quito (USFQ)", "Universitas Pontificia Universidad Católica del Ecuador (PUCE) Quito", "Universitas Espíritu Santo (UEES) Guayaquil", "Universitas Técnica Particular de Loja (UTPL)", "Universitas de las Américas (UDLA) Quito", "Universitas Azuay Cuenca", "Universitas UTE Quito", "Universitas Internacional del Ecuador (UIDE)", "Universitas Universidad de Guayaquil Swasta", "Universitas Católica de Santiago de Guayaquil"]
  },
  "guiana prancis": {
    "negeri": ["Universitas Guiana Cayenne", "Institut Politeknik Cayenne", "Sekolah Keperawatan Cayenne", "Institut Maritim Kourou", "Institut Teknologi Kourou", "Sekolah Keguruan Cayenne", "Institut Pertanian Saint-Laurent-du-Maroni", "Sekolah Keuangan Cayenne", "Institut Statistik Guiana", "Sekolah Teknik Cayenne"],
    "swasta": ["Kolej Keperawatan Cayenne Swasta", "Kolej Bisnis Cayenne Swasta", "Kolej Pendidikan Cayenne Swasta", "Institut Sains Terapan Cayenne Swasta", "Institut Komunikasi Cayenne Swasta", "Sekolah Bisnis Internasional Guiana", "Universitas Informatika Terapan Cayenne", "Kolej Sains Kesehatan Swasta Kourou", "Institut Keuangan Swasta Cayenne", "Universitas Bahasa Terapan Guiana"]
  },
  "guyana": {
    "negeri": ["Universitas Guyana Georgetown", "Institut Pelatihan Teknis Guyana", "Kolej Keperawatan Georgetown", "Institut Maritim Guyana", "Kolej Pendidikan Georgetown", "Institut Pertanian Mon Repos", "Sekolah Keuangan Georgetown", "Institut Statistik Guyana", "Sekolah Teknik Berbice", "Institut Kelautan Essequibo"],
    "swasta": ["Universitas Kedokteran Texila International Georgetown", "Universitas Kedokteran American International Georgetown", "Kolej Komunitas Critchlow Labour Georgetown", "Universitas Bisnis Georgetown Swasta", "Sekolah Bisnis Internasional Guyana", "Universitas Informatika Terapan Georgetown", "Kolej Sains Kesehatan Swasta Berbice", "Institut Komunikasi Terapan Georgetown", "Kolej Keuangan Swasta Guyana", "Universitas Bahasa Terapan Georgetown"]
  },
  "kolombia": {
    "negeri": ["Universitas Nacional de Colombia Bogotá", "Universitas Antioquia Medellín", "Universitas del Valle Cali", "Universitas Industrial de Santander (UIS) Bucaramanga", "Universitas Caldas Manizales", "Universitas Pedagógica y Tecnológica de Colombia", "Universitas Cauca Popayán", "Universitas Technological of Pereira", "Universitas Cartagena", "Universitas Nariño Pasto"],
    "swasta": ["Universitas de los Andes Bogotá", "Universitas Pontificia Universidad Javeriana Bogotá", "Universitas EAFIT Medellín", "Universitas del Norte Barranquilla", "Universitas Rosario Bogotá", "Universitas Sabana Chía", "Universitas CES Medellín", "Universitas Universidad Externado de Colombia", "Universitas Pontificia Bolivariana Medellín", "Universitas Universidad ICESI Cali"]
  },
  "paraguay": {
    "negeri": ["Universitas Nacional de Asunción (UNA)", "Universitas Nacional de Itapúa Encarnación", "Universitas Nacional de Este Ciudad del Este", "Universitas Politécnica Taiwán-Paraguay", "Universitas Nacional de Concepción", "Universitas Nacional de Caaguazú", "Universitas Nacional de Canindeyú", "Institut Kedokteran UNA Asunción", "Sekolah Keguruan Asunción", "Institut Pertanian Villarrica"],
    "swasta": ["Universitas Católica Nuestra Señora de la Asunción (UCA)", "Universitas Autónoma de Asunción (UAA)", "Universitas Americana Asunción", "Universitas del Norte Asunción", "Universitas San Carlos Asunción", "Universitas Columbia del Paraguay", "Universitas Tecnológica Intercontinental (UTIC)", "Universitas Universidad Politécnica del Artístico", "Universitas Universidad de la Integración de las Américas", "Universitas Universidad del Pacífico Asunción"]
  },
  "peru": {
    "negeri": ["Universitas Nacional Mayor de San Marcos (UNMSM) Lima", "Universitas Nacional de Ingeniería (UNI) Lima", "Universitas Nacional Agraria La Molina", "Universitas San Agustín de Arequipa (UNSA)", "Universitas National de San Antonio Abad del Cusco", "Universitas Nacional Trujillo", "Universitas Nacional del Altiplano Puno", "Universitas Nacional de Piura", "Universitas Nacional Hermilio Valdizán Huánuco", "Universitas Nacional Centro del Perú Huancayo"],
    "swasta": ["Universitas Pontificia Universidad Católica del Perú (PUCP) Lima", "Universitas Peruana Cayetano Heredia (UPCH) Lima", "Universitas de Lima", "Universitas del Pacífico Lima", "Universitas Peruana de Ciencias Aplicadas (UPC)", "Universitas Universidad de Piura", "Universitas Universidad San Ignacio de Loyola (USIL)", "Universitas Universidad de San Martín de Porres (USMP)", "Universitas Universidad ESAN Lima", "Universitas Universidad Científica del Sur"]
  },
  "suriname": {
    "negeri": ["Universitas Anton de Kom Suriname (ADEKUS) Paramaribo", "Institut Politeknik Paramaribo", "Kolej Keperawatan Suriname", "Institut Maritim Suriname", "Kolej Pendidikan Paramaribo", "Institut Pertanian Suriname", "Sekolah Keuangan Paramaribo", "Institut Statistik Suriname", "Sekolah Teknik Nickerie", "Institut Kelautan Paramaribo"],
    "swasta": ["Universitas Kedokteran FHR Paramaribo", "Universitas Bisnis Paramaribo Swasta", "Institut Sains Terapan Suriname Swasta", "Institut Komunikasi Paramaribo Swasta", "Sekolah Bisnis Internasional Suriname", "Universitas Informatika Terapan Paramaribo", "Kolej Sains Kesehatan Swasta Suriname", "Institut Keuangan Swasta Paramaribo", "Universitas Bahasa Terapan Suriname", "Kolej Teknologi Terapan Nickerie Swasta"]
  },
  "uruguay": {
    "negeri": ["Universitas de la República (UdelaR) Montevideo", "Universitas Tecnológica del Uruguay (UTEC)", "Institut Politeknik Montevideo", "Kolej Keperawatan Montevideo", "Institut Keguruan Montevideo", "Sekolah Kedokteran UdelaR", "Institut Pertanian Salto", "Sekolah Keuangan Montevideo", "Institut Statistik Uruguay", "Sekolah Teknik Rocha"],
    "swasta": ["Universitas ORT Uruguay Montevideo", "Universitas Católica del Uruguay (UCU) Montevideo", "Universitas Montevideo (UM)", "Universitas de la Empresa (UDE) Montevideo", "Universitas Bisnis Maldonado Swasta", "Institut Sains Terapan Salto Swasta", "Sekolah Bisnis Internasional Uruguay", "Universitas Informatika Terapan Montevideo", "Kolej Sains Kesehatan Swasta Montevideo", "Institut Komunikasi Terapan Montevideo"]
  },
  "venezuela": {
    "negeri": ["Universitas Central de Venezuela (UCV) Caracas", "Universitas Simón Bolívar (USB) Caracas", "Universitas de Los Andes (ULA) Mérida", "Universitas del Zulia (LUZ) Maracaibo", "Universitas de Carabobo (UC) Valencia", "Universitas de Oriente (UDO) Cumaná", "Universitas Lisandro Alvarado (UCLA) Barquisimeto", "Universitas Nacional Experimental Francisco de Miranda", "Universitas Pedagógica Experimental Libertador", "Universitas Nacional Experimental de los Llanos Ezequiel Zamora"],
    "swasta": ["Universitas Católica Andrés Bello (UCAB) Caracas", "Universitas Metropolitana (UNIMET) Caracas", "Universitas Rafael Urdaneta Maracaibo", "Universitas Universidad José Antonio Páez Valencia", "Universitas Universidad Monteávila Caracas", "Universitas Universidad Alejandro de Humboldt Caracas", "Universitas Universidad Yacambú Barquisimeto", "Universitas Universidad Santa María Caracas", "Universitas Universidad Nororiental Gran Mariscal de Ayacucho", "Universitas Universidad Tecnológica del Centro Guacara"]
  }
};

// Baca semua benua dari nama_kota
const continents = fs.readdirSync(baseKotaDir);
let totalCountriesProcessed = 0;
let totalFilesCreated = 0;

continents.forEach(continent => {
  const kotaContinentDir = path.join(baseKotaDir, continent);
  const univContinentDir = path.join(baseUnivDir, continent);

  if (fs.statSync(kotaContinentDir).isDirectory()) {
    if (!fs.existsSync(univContinentDir)) {
      fs.mkdirSync(univContinentDir, { recursive: true });
    }

    const countryFiles = fs.readdirSync(kotaContinentDir).filter(f => f.endsWith('.json'));

    countryFiles.forEach(cFile => {
      const countryName = cFile.replace('.json', '');
      const dataCountry = univDB[countryName];

      if (!dataCountry || !dataCountry.negeri || !dataCountry.swasta) {
        console.error('[ERROR] Country ' + countryName + ' in continent ' + continent + ' missing state/private university data!');
        process.exit(1);
      }

      if (dataCountry.negeri.length < 10 || dataCountry.swasta.length < 10) {
        console.error('[ERROR] Country ' + countryName + ' in continent ' + continent + ' has less than 10 state/private universities!');
        process.exit(1);
      }

      // Buat folder bernama negara di dalam folder benua
      const countryFolderPath = path.join(univContinentDir, countryName);
      if (!fs.existsSync(countryFolderPath)) {
        fs.mkdirSync(countryFolderPath, { recursive: true });
      }

      // Tulis 2 file JSON: unniv_negeri.json & unniv_swasta.json
      const negeriPath = path.join(countryFolderPath, 'unniv_negeri.json');
      const swastaPath = path.join(countryFolderPath, 'unniv_swasta.json');

      fs.writeFileSync(negeriPath, JSON.stringify(dataCountry.negeri.slice(0, 10), null, 2), 'utf-8');
      fs.writeFileSync(swastaPath, JSON.stringify(dataCountry.swasta.slice(0, 10), null, 2), 'utf-8');

      totalCountriesProcessed++;
      totalFilesCreated += 2;
    });
  }
});

console.log('[SUCCESS] Successfully created ' + totalCountriesProcessed + ' country folders and ' + totalFilesCreated + ' university JSON files across all 6 continent folders under json/nama_unniv!');
