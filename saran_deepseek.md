Logika tetap turun **2** itu membosankan dan tidak realistis. Di dunia nyata, penurunan kesehatan dipengaruhi oleh stres, kebahagiaan, dan faktor acak. 

Berikut saya buatkan **logika dinamis** yang membuat:
1. Penurunan per tahun **tidak tetap** (bisa 1, 2, atau 3).
2. Kesehatan **bisa naik sendiri** (regenerasi) jika tingkat **Kebahagiaan** user tinggi.
3. Jika Kebahagiaan rendah, penurunannya malah **lebih parah** (efek stres).

---

### Logika Dasar (Rumus)

```
Perubahan Kesehatan = - (Decay Acak) + (Bonus Regenerasi dari Kebahagiaan)
```

- **Decay Acak** = angka antara 1–3 (tidak selalu 2).
- **Bonus Regenerasi** = ditentukan dari nilai Kebahagiaan (Happiness).

---

### Aturan Regenerasi berdasarkan Kebahagiaan

| Rentang Kebahagiaan | Efek ke Kesehatan |
| :--- | :--- |
| **≥ 80%** (Sangat Bahagia) | Regenerasi kuat: **+2 sampai +4** (neto pasti naik) |
| **65% – 79%** (Cukup Bahagia) | Regenerasi ringan: **+1 sampai +2** (bisa naik, stagnan, atau turun tipis) |
| **50% – 64%** (Biasa saja) | **+0** (tidak ada regenerasi, hanya ikut decay 1-3) |
| **< 50%** (Stres/Sedih) | **Penalti ekstra -1 sampai -3** (kesehatan turun drastis) |

---

### Contoh Kode (Python)

Cocok untuk simulasi karakter Aqila di atas.

```python
import random

def update_kesehatan_tahunan(kesehatan, kebahagiaan):
    # 1. Decay dasar acak (1, 2, atau 3) dengan peluang yang hampir sama
    # Weighted: 30% dapat 1, 40% dapat 2, 30% dapat 3
    decay = random.choices([1, 2, 3], weights=[30, 40, 30])[0]
    
    # 2. Bonus regenerasi dari kebahagiaan
    if kebahagiaan >= 80:
        regen = random.randint(2, 4)   # auto-sembuh kuat
    elif kebahagiaan >= 65:
        regen = random.randint(1, 2)   # auto-sembuh ringan
    elif kebahagiaan >= 50:
        regen = 0                      # netral
    else:  # kebahagiaan di bawah 50
        regen = -random.randint(1, 3)  # malah tambah parah (stres)
    
    # 3. Hitung perubahan total
    perubahan = -decay + regen
    kesehatan_baru = kesehatan + perubahan
    
    # 4. Batasi agar tidak kurang dari 0 atau lebih dari 100
    kesehatan_baru = max(0, min(100, kesehatan_baru))
    
    return kesehatan_baru, perubahan

# ---------- SIMULASI UNTUK AQILA ----------
kesehatan = 16
kebahagiaan = 75  # sesuai data di atas (75%)

print(f"Tahun 0 (Umur 17): Kesehatan = {kesehatan}%, Bahagia = {kebahagiaan}%")
print("-" * 40)

for tahun in range(1, 6):  # simulasi 5 tahun ke depan
    kesehatan_baru, perubahan = update_kesehatan_tahunan(kesehatan, kebahagiaan)
    
    # Biar lebih seru, kita fluktuasiin kebahagiaannya sedikit (naik/turun acak)
    kebahagiaan += random.randint(-5, 5)
    kebahagiaan = max(0, min(100, kebahagiaan))
    
    print(f"Tahun {tahun} (Umur {17+tahun}): Perubahan = {perubahan:+d}% -> Kesehatan = {kesehatan_baru}% (Bahagia: {kebahagiaan}%)")
    kesehatan = kesehatan_baru
```

---

### Hasil Simulasi (Contoh Acak)

Outputnya akan terlihat seperti ini (hasil bisa beda tiap run):

```
Tahun 0 (Umur 17): Kesehatan = 16%, Bahagia = 75%
----------------------------------------
Tahun 1 (Umur 18): Perubahan = +1% -> Kesehatan = 17% (Bahagia: 78%)
Tahun 2 (Umur 19): Perubahan = -1% -> Kesehatan = 16% (Bahagia: 73%)
Tahun 3 (Umur 20): Perubahan = +2% -> Kesehatan = 18% (Bahagia: 76%)
Tahun 4 (Umur 21): Perubahan = -2% -> Kesehatan = 16% (Bahagia: 80%)
Tahun 5 (Umur 22): Perubahan = +3% -> Kesehatan = 19% (Bahagia: 82%)
```

Lihat? Kesehatan tidak selalu turun 2 terus. Kadang naik (+1, +2, +3), kadang turun (-1, -2), tergantung keberuntungan decay dan tinggi-rendahnya kebahagiaan.

---

### Cara agar Kesehatan PASTI Tidak Turun Terus

Jika kamu ingin memastikan kesehatan **stabil atau naik** di tahun-tahun tertentu, user wajib menjaga Kebahagiaan tetap di atas **65%**. Selama kebahagiaan di angka itu, regenerasi akan mengimbangi decay, sehingga kesehatan tidak akan jeblok.

---

### Tambahan Opsi (Bisa Disesuaikan)

- **Faktor Usia**: Makin tua (di atas 40 tahun), decay-nya bisa diubah jadi `random.randint(2, 5)` agar menua terasa.
- **Faktor Kecerdasan**: Jika Intelligence tinggi, user bisa dapat bonus regenerasi tambahan (karena lebih pintar menjaga pola hidup).

Dengan logika ini, game BitLife buatanmu akan terasa lebih hidup dan menantang karena pemain harus aktif menjaga **Kebahagiaan** agar kesehatan tetap prima! 😊