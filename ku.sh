#sudo apt-get update
#sudo apt-get install jq -y
#sudo apt-get upgrade -y

mkdir -p cache

#infoBerkala
curl -Ss --location --request POST 'ppid.kemendagri.go.id/api/front/dokumen/search' \
--header 'Content-Type: application/json' \
--data-raw '{
    "search":"",
    "category":1,
    "area":"pemda",
    "kabkota":68,
    "type":0,
    "opr":0,
    "page":1
}' | jq '.data.results.last_page' > cache/jml_infoBerkala.txt
#sleep 10
cat cache/jml_infoBerkala.txt | sed 's/^/Jumlah Info Berkala : /'
#sleep 10

#InfoSementara
curl -Ss --location --request POST 'ppid.kemendagri.go.id/api/front/dokumen/search' \
--header 'Content-Type: application/json' \
--data-raw '{
    "search":"",
    "category":2,
    "area":"pemda",
    "kabkota":68,
    "type":0,
    "opr":0,
    "page":1
}' | jq '.data.results.last_page' > cache/jml_infoSertamerta.txt
#sleep 10
cat cache/jml_infoSertamerta.txt | sed 's/^/Jumlah Info Serta Merta : /'
#sleep 10


#infoSetiapsaat
curl -Ss --location --request POST 'ppid.kemendagri.go.id/api/front/dokumen/search' \
--header 'Content-Type: application/json' \
--data-raw '{
    "search":"",
    "category":3,
    "area":"pemda",
    "kabkota":68,
    "type":0,
    "opr":0,
    "page":1
}' | jq '.data.results.last_page' > cache/jml_infoSetiapsaat.txt
cat cache/jml_infoSetiapsaat.txt | sed 's/^/Jumlah Info Setiap saat : /'
#sleep 10

#GenerateInfoberkala
mkdir -p cache/infoberkala
GenerateInfoberkala(){
crinfoBerkala=$(cat cache/jml_infoBerkala.txt)
    for i in `seq -w 1 $crinfoBerkala`
do
 echo "curl -Ss --location --request POST 'ppid.kemendagri.go.id/api/front/dokumen/search' --header 'Content-Type: application/json' --data-raw '{\"search\":\"\",\"category\":1,\"area\":\"pemda\",\"kabkota\":68,\"type\": 0,\"opr\": 0,\"page\":$i}' > cache/infoberkala/page_$i.json" 
done
}
echo "Generate Info Berkala"
#AutoReportInformasiBerkala
GenerateInfoberkala | sed 's/":0/":/g' | sed -e '0~55 s/$/\necho "sleep dulu yah"\nsleep 120\necho "Mulai lagi"/g;' | bash
cat cache/infoberkala/*.json | jq -s 'flatten' > cache/final_infoBerkala.json
mkdir -p cache/fin_infoBerkala
cat cache/final_infoBerkala.json | jq -r '[.[].data.results.data[]]' | jq -c '[try .[] | {judul: .judul, deskripsi: .deskripsi, kode: .kode, dokumen_kategori: .dokumen_kategori.name, opd: .operasional.nama, reg_opd: .operasional.id, created_at: .created_at, jenis_informasi:.dokumen_jenis.name, link: ("http://ppid.bekasikota.go.id/front/dokumen/detail/"+(.kode))}]' > cache/fin_infoBerkala/fin_infoBerkala.json

cat cache/fin_infoBerkala/fin_infoBerkala.json | jq -r '.[].reg_opd' | sort | uniq | sed 's/^/mkdir -p data\//' | bash

cat cache/fin_infoBerkala/fin_infoBerkala.json | jq -r '.[].reg_opd' | sort | uniq > cache/ListSkpdBerkala.txt
cat cache/fin_infoBerkala/fin_infoBerkala.json | jq -r '.[].reg_opd' | sort | uniq | sed "s/^/cat cache\/fin_infoBerkala\/fin_infoBerkala.json | jq -r '\[.\[\] | select\(.reg_opd | contains\('/; s/$/'\)\)\]\' > data/" > cache/CommandListSkpdBerkala.txt
paste -d "/" cache/CommandListSkpdBerkala.txt cache/ListSkpdBerkala.txt  | sed 's/$/\/berkala/' | bash
echo "sleep Info Berkala"
sleep 120
echo "Generate Info Sementara"
###########
## INFO SERTA MERTA

mkdir -p cache/infoSertamerta
Generate_InfoSertamerta(){
cr_InfoSertamerta=$(cat cache/jml_infoSertamerta.txt)
    for i in `seq -w 1 $cr_InfoSertamerta`
do
 echo "curl -Ss --location --request POST 'ppid.kemendagri.go.id/api/front/dokumen/search' --header 'Content-Type: application/json' --data-raw '{\"search\":\"\",\"category\":2,\"area\":\"pemda\",\"kabkota\":68,\"type\": 0,\"opr\": 0,\"page\":$i}' > cache/infosertamerta/page_$i.json" 
done
}

#AutoReport_InfoSertamerta
Generate_InfoSertamerta | sed 's/":0/":/g' | sed -e '0~55 s/$/\necho "sleep dulu yah"\nsleep 120\necho "Mulai lagi"/g;' | bash
cat cache/infosertamerta/*.json | jq -s 'flatten' > cache/final_infosertamerta.json
mkdir -p cache/fin_infosertamerta
cat cache/final_infosertamerta.json | jq -r '[.[].data.results.data[]]' | jq -c '[try .[] | {judul: .judul, deskripsi: .deskripsi, kode: .kode, dokumen_kategori: .dokumen_kategori.name, opd: .operasional.nama, reg_opd: .operasional.id, created_at: .created_at, jenis_informasi:.dokumen_jenis.name, link: ("http://ppid.bekasikota.go.id/front/dokumen/detail/"+(.kode))}]' > cache/fin_infosertamerta/fin_infosertamerta.json

cat cache/fin_infosertamerta/fin_infosertamerta.json | jq -r '.[].reg_opd' | sort | uniq | sed 's/^/mkdir -p data\//' | bash

cat cache/fin_infosertamerta/fin_infosertamerta.json | jq -r '.[].reg_opd' | sort | uniq > cache/ListSkpdSertaMerta.txt
cat cache/fin_infosertamerta/fin_infosertamerta.json | jq -r '.[].reg_opd' | sort | uniq | sed "s/^/cat cache\/fin_infosertamerta\/fin_infosertamerta.json | jq -r '\[.\[\] | select\(.reg_opd | contains\('/; s/$/'\)\)\]\' > data/" > cache/CommandListSkpdSertamerta.txt
paste -d "/" cache/CommandListSkpdSertamerta.txt cache/ListSkpdSertaMerta.txt| sed 's/$/\/sertamerta/' | bash
echo "sleep Info sementara"
sleep 120
echo "mulai Info Setiap Saat"

####
# Generate Informasi Setiap Saat
####
mkdir -p cache/infoSetiapsaat
Generate_InfoSeriapSaat(){
cr_infoSetiapsaat=$(cat cache/jml_infoSetiapsaat.txt)
    for i in `seq -w 1 $cr_infoSetiapsaat`
do
 echo "curl -Ss --location --request POST 'ppid.kemendagri.go.id/api/front/dokumen/search' --header 'Content-Type: application/json' --data-raw '{\"search\":\"\",\"category\":3,\"area\":\"pemda\",\"kabkota\":68,\"type\": 0,\"opr\": 0,\"page\":$i}' > cache/infoSetiapsaat/page_$i.json" 
done
}

#AutoReport_infoSetiapsaat
Generate_InfoSeriapSaat | sed 's/":0/":/g' | sed -e '0~55 s/$/\necho "sleep dulu yah"\nsleep 120\necho "Mulai lagi"/g;' | bash
cat cache/infoSetiapsaat/*.json | jq -s 'flatten' > cache/final_infoSetiapsaat.json
mkdir -p cache/fin_infoSetiapsaat
cat cache/final_infoSetiapsaat.json | jq -r '[.[].data.results.data[]]' | jq -c '[try .[] | {judul: .judul, deskripsi: .deskripsi, kode: .kode, dokumen_kategori: .dokumen_kategori.name, opd: .operasional.nama, reg_opd: .operasional.id, created_at: .created_at, jenis_informasi:.dokumen_jenis.name, link: ("http://ppid.bekasikota.go.id/front/dokumen/detail/"+(.kode))}]' > cache/fin_infoSetiapsaat/fin_infoSetiapsaat.json

cat cache/fin_infoSetiapsaat/fin_infoSetiapsaat.json | jq -r '.[].reg_opd' | sort | uniq | sed 's/^/mkdir -p data\//' | bash

cat cache/fin_infoSetiapsaat/fin_infoSetiapsaat.json | jq -r '.[].reg_opd' | sort | uniq > cache/ListSkpdfin_infoSetiapsaat.txt
cat cache/fin_infoSetiapsaat/fin_infoSetiapsaat.json | jq -r '.[].reg_opd' | sort | uniq | sed "s/^/cat cache\/fin_infoSetiapsaat\/fin_infoSetiapsaat.json | jq -r '\[.\[\] | select\(.reg_opd | contains\('/; s/$/'\)\)\]\' > data/" > cache/CommandListSkpdinfoSetiapsaat.txt
paste -d "/" cache/CommandListSkpdinfoSetiapsaat.txt cache/ListSkpdfin_infoSetiapsaat.txt | sed 's/$/\/setiapsaat/' | bash
echo "sleep Info Setiap Saat"
#sleep 120
echo "mulai generate report all"
##GENERATE DATA LIST OPD
cat data/*/* | jq -s 'flatten' > cache/opd_list.json
cat cache/opd_list.json | jq '[try .[] | {path: ("data/"+(.reg_opd|tostring)+"/index"),reg_opd: .reg_opd, opd: .opd}]|unique' > opd_data.json

ls data/ > cache/AvailOPD.txt
cat cache/AvailOPD.txt | sed "s/^/cat data\//; s/$/\/* | jq -s 'flatten' > data/" >  cache/MergeAvailOPD.txt
paste -d "/" cache/MergeAvailOPD.txt cache/AvailOPD.txt | sed 's/$/\/index/' | bash
#ls data/*/*_* | sed 's/^/rm /' | bash
echo "selesai"
sleep 5
rm ku.sh
echo "menutup program"
sleep 10
rm -rf cache/*