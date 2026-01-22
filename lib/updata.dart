class siswa {
  final String id, nama, nis, fotoProfile;

  siswa({
    required this.id,
    required this.nama,
    required this.nis,
    required this.fotoProfile,
  });

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'nama': nama,
      'nis': nis,
      'fotoProfile': fotoProfile,
      'status': ''
    };
  }
}

  final List<siswa> daftarSiswaRPL = [
  siswa(id: '1', nama: 'ADITYA PRASETYO WIBOWO', nis: '17792', fotoProfile: ''),
  siswa(id: '2', nama: 'AHMAD PRIANDOKO', nis: '17793', fotoProfile: ''),
  siswa(id: '3', nama: 'ANGGI ANDIKA', nis: '17794', fotoProfile: ''),
  siswa(id: '4', nama: 'ANJAS MARCELINO YUDHISTIRA', nis: '17795', fotoProfile: ''),
  siswa(id: '5', nama: 'ARRASYD NANDA FAIRUZ', nis: '17796', fotoProfile: ''),
  siswa(id: '6', nama: 'ARYA SATRIA WICAKSONO', nis: '17797', fotoProfile: ''),
  siswa(id: '7', nama: 'AZIZAN HANIF YUSRON', nis: '17798', fotoProfile: ''),
  siswa(id: '8', nama: 'BIMA REVAN SAPUTRA', nis: '17799', fotoProfile: ''),
  siswa(id: '9', nama: 'CHRISTOPHORUS PASCHALIS TANGGUH SATRIA NUGRAHA', nis: '17800', fotoProfile: ''),
  siswa(id: '10', nama: 'DAFFA NUR DZAKY', nis: '17801', fotoProfile: ''),
  siswa(id: '11', nama: 'DANI ARSYAD RAZAK', nis: '17802', fotoProfile: ''),
  siswa(id: '12', nama: 'DIRYA ASKA GHANI WIBOWO', nis: '17803', fotoProfile: ''),
  siswa(id: '13', nama: "ESA NUR'UDZRI YUNAN ARIFIANTO", nis: '17804', fotoProfile: ''),
  siswa(id: '14', nama: 'FADHILAH MARELE SAPUTRO', nis: '17805', fotoProfile: ''),
  siswa(id: '15', nama: 'FAIZ BARAKA PUTRA', nis: '17806', fotoProfile: ''),
  siswa(id: '16', nama: 'FANDY MARVELLINO', nis: '17807', fotoProfile: 'images/fotoProfile.jpg'),
  siswa(id: '17', nama: 'FERNANDA DENIA EKA SAPUTRA', nis: '17808', fotoProfile: ''),
  siswa(id: '18', nama: 'GANGGAS YOGASWARA', nis: '17809', fotoProfile: ''),
  siswa(id: '19', nama: 'GENTA NILAM PRANA', nis: '17810', fotoProfile: ''),
  siswa(id: '20', nama: 'HANAN FAIRUUZ MUSYAFFA', nis: '17811', fotoProfile: ''),
  siswa(id: '21', nama: 'MAHENDI FAREL AL FARAUQ', nis: '17812', fotoProfile: ''),
  siswa(id: '22', nama: 'MAHIRSYA BHANU ADYATMA', nis: '17813', fotoProfile: ''),
  siswa(id: '23', nama: 'MUHAMMAD AZFA FIKRONIY', nis: '17814', fotoProfile: ''),
  siswa(id: '24', nama: 'MUHAMMAD DANIS ARJUN', nis: '17815', fotoProfile: ''),
  siswa(id: '25', nama: 'MUHAMMAD NAYAKA DAFA ABYAN', nis: '17816', fotoProfile: ''),
  siswa(id: '26', nama: 'MUHYIYUDIN AFIF LITHFIANSYAH', nis: '17817', fotoProfile: ''),
  siswa(id: '27', nama: 'N RUPAKA MATAHARI', nis: '17818', fotoProfile: ''),
  siswa(id: '28', nama: 'REFAND GRACIAS NATANAEL LUMBAN TOBING', nis: '17819', fotoProfile: ''),
  siswa(id: '29', nama: 'REIFAN PUTRA PRATAMA', nis: '17820', fotoProfile: ''),
  siswa(id: '30', nama: 'REZKY ADITYA', nis: '17821', fotoProfile: ''),
  siswa(id: '31', nama: 'SHAQUILE HAFIDS AMADA', nis: '17822', fotoProfile: ''),
  siswa(id: '32', nama: 'TIMOTHY HUGO MANIHURUK', nis: '17823', fotoProfile: ''),
  siswa(id: '33', nama: 'UZZI KURNIANTORO', nis: '17824', fotoProfile: ''),
  siswa(id: '34', nama: 'VIRDAN DEVANANTO', nis: '17825', fotoProfile: ''),
  siswa(id: '35', nama: 'ZAQI ALFIANSYAH', nis: '17826', fotoProfile: ''),
  siswa(id: '36', nama: 'ZHAFRAN RADITA DHIYAULHAQ', nis: '17827', fotoProfile: ''),
];