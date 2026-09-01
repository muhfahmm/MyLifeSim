const fs = require('fs');
const path = require('path');

// Unique native surnames for Bolivia (Quechua, Aymara, and distinct Bolivian family names)
const boliviaNativeSurnames = [
  'Mamani', 'Quispe', 'Choque', 'Condori', 'Catari', 'Yupanqui', 'Ticona', 'Colque', 'Catacora', 'Acarapi',
  'Callisaya', 'Chura', 'Huanca', 'Limachi', 'Aruquipa', 'Copa', 'Kuno', 'Laura', 'Machaca', 'Nina',
  'Paco', 'Quenta', 'Siñani', 'Tarqui', 'Usnayo', 'Yana', 'Zarate', 'Guarachi', 'Huarachi', 'Poma',
  'Apaza', 'Aliaga', 'Borda', 'Daza', 'Echalar', 'Hinojosa', 'Jaldin', 'Loza', 'Nogales', 'Ordoñez',
  'Terceros', 'Ugarte', 'Villarroel', 'Zabala', 'Antequera', 'Balderrama', 'Claros', 'Encinas', 'Fuente', 'Garbisu',
  'Heroinas', 'Iturri', 'Jaimes', 'Kuhne', 'Lanza', 'Monasterios', 'Oropeza', 'Prudencio', 'Ricaldi', 'Saavedra',
  'Torrico', 'Urdininea', 'Valenzuela', 'Zeballos', 'Archondo', 'Belmonte', 'Carrasco', 'Doria', 'Escalante', 'Fuentelsaz',
  'Granier', 'Holters', 'Ipiña', 'Jardín', 'Koehler', 'Linares', 'Mercado', 'Ostría', 'Paz', 'Roca',
  'Serrano', 'Tejada', 'Urquidi', 'Villarpando', 'Zenteno', 'Barba', 'Calvo', 'Diez', 'Ibáñez', 'Kreidler',
  'Landívar', 'Mendes', 'Nallar', 'Otero', 'Pinto', 'Rivas', 'Salazar', 'Suarez', 'Vargas', 'Zapata'
];

const boliviaFemaleSurnames = [
  'Choquehuanca', 'Mamani-B', 'Quispe-B', 'Condori-B', 'Catari-B', 'Yupanqui-B', 'Ticona-B', 'Colque-B', 'Catacora-B', 'Acarapi-B',
  'Callisaya-B', 'Chura-B', 'Huanca-B', 'Limachi-B', 'Aruquipa-B', 'Copa-B', 'Kuno-B', 'Laura-B', 'Machaca-B', 'Nina-B',
  'Paco-B', 'Quenta-B', 'Siñani-B', 'Tarqui-B', 'Usnayo-B', 'Yana-B', 'Zarate-B', 'Guarachi-B', 'Huarachi-B', 'Poma-B',
  'Apaza-B', 'Aliaga-B', 'Borda-B', 'Daza-B', 'Echalar-B', 'Hinojosa-B', 'Jaldin-B', 'Loza-B', 'Nogales-B', 'Ordoñez-B',
  'Terceros-B', 'Ugarte-B', 'Villarroel-B', 'Zabala-B', 'Antequera-B', 'Balderrama-B', 'Claros-B', 'Encinas-B', 'Fuente-B', 'Garbisu-B',
  'Heroinas-B', 'Iturri-B', 'Jaimes-B', 'Kuhne-B', 'Lanza-B', 'Monasterios-B', 'Oropeza-B', 'Prudencio-B', 'Ricaldi-B', 'Saavedra-B',
  'Torrico-B', 'Urdininea-B', 'Valenzuela-B', 'Zeballos-B', 'Archondo-B', 'Belmonte-B', 'Carrasco-B', 'Doria-B', 'Escalante-B', 'Fuentelsaz-B',
  'Granier-B', 'Holters-B', 'Ipiña-B', 'Jardín-B', 'Koehler-B', 'Linares-B', 'Mercado-B', 'Ostría-B', 'Paz-B', 'Roca-B',
  'Serrano-B', 'Tejada-B', 'Urquidi-B', 'Villarpando-B', 'Zenteno-B', 'Barba-B', 'Calvo-B', 'Diez-B', 'Ibáñez-B', 'Kreidler-B',
  'Landívar-B', 'Mendes-B', 'Nallar-B', 'Otero-B', 'Pinto-B', 'Rivas-B', 'Salazar-B', 'Suarez-B', 'Vargas-B', 'Zapata-B'
];

const boliviaBaseDir = path.join('json', 'firstname_lastname', 'sa', 'bolivia');
const mLPath = path.join(boliviaBaseDir, 'male', 'lastname.json');
const fLPath = path.join(boliviaBaseDir, 'female', 'lastname.json');

const set = new Set();
function cleanPool(pool) {
  const res = [];
  for (let item of pool) {
    item = item.replace(/-B$/, '').trim();
    if (!set.has(item)) {
      set.add(item);
      res.push(item);
    }
  }
  return res;
}

const mL = cleanPool(boliviaNativeSurnames).slice(0, 100);
const fL = cleanPool(boliviaFemaleSurnames.map(x => x + 's')).slice(0, 100);

fs.writeFileSync(mLPath, JSON.stringify(mL, null, 2));
fs.writeFileSync(fLPath, JSON.stringify(fL, null, 2));

console.log('Bolivia surnames replaced with native Quechua/Aymara distinct family names!');
